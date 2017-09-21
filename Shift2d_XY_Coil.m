% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %
clc; clear;
digits;
disp('MQS, 1.2 MHz: ');
Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 1.2 * 10^6; % 2 * pi * 1.2 MHz
J_0           = 1500;

% paras: 
%               air, bolus, mucle
rho           = 1;
epsilon_r_pre = 1;
sigma         = 0;
epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );
mu_prime      = 1;
mu_db_prime   = 0;
mu_r          = mu_prime - i * mu_db_prime;

% There 'must' be a grid point at the origin.
loadParas_Mag_XYCoil;
% paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;

GridShiftTableXY = cell( z_idx_max, 1);
% GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.
% Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]
mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% air                : 1 
% current sheet bndry: 11

% no shifting 
GridShiftTable = cell( w_x / dx + 1, w_y / dy + 1, w_z / dz + 1 );
shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, [ w_y, w_x, w_z ], dx, dy, dz );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');
byndCD = 30;
% trim for SegMed: unvalid set to 30
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
end

% === % ======================================================== % === %
% === % Vertex_Crdnt Construction and calculate basic parameters % === %
% === % ======================================================== % === % 
x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
N_v = x_max_vertex * y_max_vertex * z_max_vertex;
N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
    + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
    + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
tic;
disp('Calculation of vertex coordinate');
Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
toc;

% === % ======================== % === %
% === % MedTetTable Construction % === %
% === % ======================== % === % 
tic;
disp('Getting MedTetTableCell: ');
MedTetTableCell  = cell(0, 1);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntMedTetTableCell  = cell(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );
    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
    MedTetTableCell  = vertcat(MedTetTableCell, PntMedTetTableCell(validTet));
end
toc;
validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;
if size(MedTetTableCell, 1) ~= validNum
    error('check the construction');
end
MedTetTable = sparse(validNum, N_v);
tic;
disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
MedTetTable = mySparse2MatlabSparse( MedTetTableCell, validNum, N_v, 'Row' );
toc;

% % === % ========================= % === %
% % === % Filling of SheetPntsTable % === %
% % === % ========================= % === %
Vrtx_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
% computational domain boundary is set to 2
n_far  = y_idx_max - 1;
n_near = 2;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    if my_F(borderFlag, 1)
        Vrtx_bndry(m_v, n_v, ell_v) = 2;
    end
end

% endowment of current sheet.
% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %
% Vrtx_bndry: v-location of current sheet and computational domain 
Vrtx_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
%  2: computational domain boundary
n_far  = y_idx_max - 1;
n_near = 2;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    if my_F(borderFlag, 1)
        Vrtx_bndry(m_v, n_v, ell_v) = 2;
    end
end

% update the Vrtx_bndry for oblique current sheet.
SheetY_0 = 0;
% 1: sheetPoints boundary
m_v_0 = 2 * ( 0 / dx + w_x / (2 * dx) + 1 ) - 1;
n_v_0 = 2 * ( 0 / dx + w_y / (2 * dy) + 1 ) - 1;
ell_v_0 = 2 * ( 0 / dx + w_z / (2 * dz) + 1 ) - 1;

% vertical version
% to-do: feed in the Vertical coil Vrtx_bndry.
half_size = 1;
Vrtx_bndry(m_v_0 - half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 + half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 + half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size, ell_v_0     ) = 7;

Vrtx_bndry(m_v_0    , n_v_0 - 1, ell_v_0    ) = 3;
Vrtx_bndry(m_v_0    , n_v_0 - 1, ell_v_0 - 1) = 3;
Vrtx_bndry(m_v_0 + 1, n_v_0    , ell_v_0    ) = 4;
Vrtx_bndry(m_v_0 + 1, n_v_0    , ell_v_0 - 1) = 4;
Vrtx_bndry(m_v_0    , n_v_0 + 1, ell_v_0    ) = 5;
Vrtx_bndry(m_v_0    , n_v_0 + 1, ell_v_0 - 1) = 5;
Vrtx_bndry(m_v_0 - 1, n_v_0    , ell_v_0    ) = 6;
Vrtx_bndry(m_v_0 - 1, n_v_0    , ell_v_0 - 1) = 6;
% % oblique version
% half_size = 3;
% Vrtx_bndry(m_v_0 - half_size - 1, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 1;
% Vrtx_bndry(m_v_0 - half_size    , n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 1;
% Vrtx_bndry(m_v_0 + half_size    , n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 1;
% Vrtx_bndry(m_v_0 + half_size + 1, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 1;
% Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size + 1, ell_v_0     ) = 1;
% Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size    , ell_v_0 - 1 ) = 1;
% Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size    , ell_v_0 - 1 ) = 1;
% Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size - 1, ell_v_0     ) = 1;
% Vrtx_bndry(m_v_0 + half_size + 1, n_v_0 + half_size + 1, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 + half_size + 1, n_v_0 - half_size - 1, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 - half_size - 1, n_v_0 - half_size - 1, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 - half_size - 1, n_v_0 + half_size + 1, ell_v_0) = 1;

% === % =============================== % === %
% === % Constructing The Directed Graph % === %
% === % =============================== % === %
starts = [];
ends = [];
vals = [];
borderFlag = false(1, 6);
disp('Constructing the directed graph');
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    if strcmp(flag, '000') && ~mod(ell_v, 2)
        [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
    end
end
G = sparse(ends, starts, vals, N_v, N_v);
toc;
[ P2, P1 ] = find(G);
l_G = length(find(G));
% undirected graph
uG = G + G';

[ P2, P1, Vals ] = find(G);
[ Vals, idxSet ] = sort(Vals);
P1 = P1(idxSet);
P2 = P2(idxSet);
l_G = length(P1);

% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %
% to-do
% update the following function
B_k = zeros(N_e, 1);
m_K1 = cell(N_e, 1);
% m_K2 = cell(N_e, 1);
% m_KEV = cell(N_e, 1);
% m_KVE = cell(1, N_e);
edgeChecker = false(l_G, 1);
tic; 
disp('The filling time of K_1, K_2, K_EV, K_VE and B: ');
parfor eIdx = 1: 1: l_G
    % eIdx = full( G(P2(lGidx), P1(lGidx)) );
    Candi = [];
    % get candidate points
    P1_cand = uG(:, P1(eIdx));
    P2_cand = uG(:, P2(eIdx));
    P1_nz = find(P1_cand);
    P2_nz = find(P2_cand);
    for CandiFinder = 1: 1: length(P1_nz)
        if find(P2_nz == P1_nz(CandiFinder))
            Candi = horzcat(Candi, P1_nz(CandiFinder));
        end
    end
    % get adjacent tetrahdron
    K1_6 = zeros(1, N_e); 
    % K2_6 = zeros(1, N_e); 
    % Kev_4 = zeros(1, N_v);
    % Kve_4 = zeros(N_v, 1);
    B_k_Pnt = 0;
    cFlag = false;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                MedFinder = MedTetTableCell{ tetRow };
                MedVal = MedFinder(5);
                K1_6 = fillK1_FW_currentsheet( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                    G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry, J_0, ...
                    K1_6, B_k_Pnt, zeros(1, 3), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt )
                B_k_Pnt = fillBk_Esphgs_Vrtcl( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                        G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry, J_0, ...
                        B_k_Pnt, zeros(1, 3), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
                % [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW_currentsheet( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                %     G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry, J_0, ...
                %     K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt, [0, 0, 0], MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
                
            end
        end
    end

    if isempty(K1_6) 
        disp('K1, K2 or KEV: empty');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if isnan(K1_6) 
        disp('K1 or K2: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if edgeChecker(eIdx) == true
        % lGidx
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        error('check')
    end

    edgeChecker(eIdx) = true;
    
    m_K1{eIdx} = Mrow2myRow(K1_6);
    % m_K2{eIdx}  = Mrow2myRow(K2_6);
    % m_KEV{eIdx} = Mrow2myRow(Kev_4);
    % m_KVE{eIdx} = Mrow2myRow(Kve_4')';
    B_k(eIdx) = B_k_Pnt;
end
toc;

% === % ========================= % === %
% === % Matrices product to get K % === %
% === % ========================= % === %
M_K = sparse(N_e, N_e);
M_K1 = sparse(N_e, N_e);
% M_K2 = sparse(N_e, N_e);
% M_KEV = sparse(N_e, N_v);
% M_KVE = sparse(N_v, N_e);
tic;
disp('Transfroming M_K1, M_K2, M_KEV and M_KVE')
M_K1 = mySparse2MatlabSparse( m_K1, N_e, N_e, 'Row' );
% M_K2 = mySparse2MatlabSparse( m_K2, N_e, N_e, 'Row' );
% M_KEV = mySparse2MatlabSparse( m_KEV, N_e, N_v, 'Row' );
% M_KVE = mySparse2MatlabSparse( m_KVE, N_v, N_e, 'Col' );
toc;
% M_K = M_K1 - M_KEV * M_sparseGVV_inv_spai * M_KVE;
M_K = M_K1; 
% M_K = M_K1 - Epsilon_0 * Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% === % ============================ % === %
% === % Sparse Normalization Process % === %
% === % ============================ % === %

tic;
disp('Time for normalization');
sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
nrmlM_K = sptmp * M_K;
nrmlB_k = sptmp * B_k;
toc;

% === % ============================================================ % === %
% === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% === % ============================================================ % === %

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(nrmlB_k));
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\nrmlB_k;
% toc;
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-1) );
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
toc;

% maybe to-do
AFigsScript_CoilXY;
return;