% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %

clc; clear;
digits;
disp('K, case 1, Regular Tet');

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 100 * 10^3; % 2 * pi * 100 kHz
J_0           = 1500;

% paras: 
rho           = [ 1, 4600 ]';
epsilon_r_pre = [ 1,    1 ]';
sigma         = [ 0,    0 ]';
epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );
mu_prime      = [ 1,    1 ]';
mu_db_prime   = [ 0,    0 ]';
% mu_db_prime   = [ 0,    0.62 ]';
mu_r          = mu_prime - i * mu_db_prime;

loadParas_Mag;
% paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];
x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;
x_idx_max_prm = x_idx_max - 1;
y_idx_max_prm = y_idx_max - 1;
z_idx_max_prm = z_idx_max - 1;
x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;

GridShiftTableXZ = cell( y_idx_max, 1);
% GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.
mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% medium1            : 1 
% magnetic particle  : 2
% % conductor        : 3
% current sheet bndry: 11

for y = - w_y / 2: dy: w_y / 2
    paras2dXZ_Mag = genParas2dXZ_Mag( y, Paras_Mag );
    y_idx = y / dy + w_y / (2 * dy) + 1;
    sample_valid = paras2dXZ_Mag(12);
    if sample_valid
        mediumTable(:, int64(y_idx), :) = getRoughMed_Mag( mediumTable(:, int64(y_idx), :), paras2dXZ_Mag );
    end
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all_Mag( paras2dXZ_Mag, mediumTable(:, int64(y_idx), :) );
end

% re-organize the GridShiftTable
GridShiftTable = cell( w_x / dx + 1, w_y / dy + 1, w_z / dz + 1 );
for y_idx = 1: 1: w_y / dy + 1
    tmp_table = GridShiftTableXZ{ y_idx };
    for x_idx = 1: 1: w_x / dx + 1
        for z_idx = 1: 1: w_z / dz + 1
            GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
        end
    end
end

shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, [ w_y, w_x, w_z ], dx, dy, dz );

% temporarily apply the shifted-grid; Need to implemet the un-shifted version.
Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
tic;
disp('Calculation of vertex coordinate');
Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
toc;

N_v = x_max_vertex * y_max_vertex * z_max_vertex;
N_v_r = 4 * x_idx_max_prm * y_idx_max_prm * z_idx_max_prm ...
    + 2 * (x_idx_max_prm * y_idx_max_prm + y_idx_max_prm * z_idx_max_prm + x_idx_max_prm * z_idx_max_prm) ...
    + x_idx_max_prm + y_idx_max_prm + z_idx_max_prm + 1;
N_e_r = 28 * x_idx_max_prm * y_idx_max_prm * z_idx_max_prm ...
    + 6 * (x_idx_max_prm * y_idx_max_prm + y_idx_max_prm * z_idx_max_prm + x_idx_max_prm * z_idx_max_prm) ...
    + x_idx_max_prm + y_idx_max_prm + z_idx_max_prm;

% N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

% === % ======================== % === %
% === % MedTetTable Construction % === %
% === % ======================== % === % 

tic;
disp('Time for constructing the MedTetTable');
SegMedReg = ones(x_idx_max_prm, y_idx_max_prm, z_idx_max_prm, 24);
MedTetTable = sparse(0, N_v_r);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    corner_flag = getCornerFlag(m, n, ell, x_idx_max, y_idx_max, z_idx_max);
    if ~my_F(corner_flag(2, :), 1)
        PntMedTetTable = sparse(24, N_v);
        % implement the getPntMedTetTable_Reg.m function: manually input for a cube.
        PntMedTetTable = getPntMedTetTable_Reg( squeeze(SegMedReg(m - 1, n - 1, ell - 1, :)), N_v_r, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
        MedTetTable = vertcat(MedTetTable, PntMedTetTable);
    end
end
toc;

TetNum = x_idx_max_prm * y_idx_max_prm * z_idx_max_prm * 24;
if size(MedTetTable, 1) ~= TetNum
    error('check the construction');
end

% validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
%                 + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;
% if size(MedTetTable, 1) ~= validNum
%     error('check the construction');
% end

% === % ==================== % === %
% === % Filling of EdgeTable % === %
% === % ==================== % === %

% thin current sheet: need to trim the near end and the far end
SheetPntsTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
n_far  =   ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
n_near = - ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n >= n_near && n <= n_far && mediumTable(m, n, ell) == 11
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        SheetPntsTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
            = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, ...
                SheetPntsTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) );
    end
end

% === % =============================== % === %
% === % Constructing The Directed Graph % === %
% === % =============================== % === %

starts = [];
ends = [];
vals = [];
borderFlag = false(1, 6);
disp('Constructing the directed graph');
% the validity of the input must be gurantee !!!
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = getCornerFlag(m, n, ell, x_idx_max, y_idx_max, z_idx_max);
    % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    if ~my_F(corner_flag(2, :), 1)
        [ starts, ends, vals ] = fillGraph_Reg( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
    end
end
G = sparse(starts, ends, vals, N_v_r, N_v_r);
toc;
[ P1, P2 ] = find(G);
l_G = length(find(G));

% undirected graph
uG = G + G';

% B_k   = zeros(N_e_r, 1);
% M_K1  = sparse(N_e_r, N_e_r);
% M_KEV = sparse(N_e_r, N_v_r);
% M_KVE = sparse(N_v_r, N_e_r);

% TEX = 'Regular';
% edgeChecker = false(l_G, 1);
% tic; 
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% for lGidx = 1: 1: l_G
%     eIdx = full( G(P1(lGidx), P2(lGidx)) );
%     if eIdx == 22469
%         ;
%     end
%     Candi = [];
%     % get candidate points
%     P1_cand = uG(P1(lGidx), :);
%     P2_cand = uG(P2(lGidx), :);
%     P1_nz = find(P1_cand);
%     P2_nz = find(P2_cand);
%     for CandiFinder = 1: 1: length(P1_nz)
%         if find(P2_nz == P1_nz(CandiFinder))
%             Candi = horzcat(Candi, P1_nz(CandiFinder));
%         end
%     end
%     % get adjacent tetrahdron
%     K1_6 = sparse(1, N_e_r); 
%     Kev_4 = sparse(1, N_v_r);
%     Kve_4 = sparse(N_v_r, 1);
%     B_k_Pnt = 0;
%     for TetFinder = 1: 1: length(Candi) - 1
%         for itr = TetFinder + 1: length(Candi)
%             if uG( Candi(TetFinder), Candi(itr) )
%                 % linked to become a tetrahedron
%                 v1234 = [ P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder) ];
%                 tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
%                 if length(tetRow) ~= 1
%                     error('check te construction of MedTetTable');
%                 end
%                 MedVal = MedTetTable( tetRow, v1234(1) );
%                 % P1 pointed to P2 may be used as a self-checker
%                 [ K1_6, Kev_4, Kve_4, B_k_Pnt ] = fillK( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
%                     G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
%                     SheetPntsTable( r2v( P1(lGidx) ) ), SheetPntsTable( r2v( P2(lGidx) ) ), SheetPntsTable( r2v( Candi(itr) ) ), SheetPntsTable( r2v( Candi(TetFinder) ) ), ...
%                     lGidx, K1_6, Kev_4, Kve_4, B_k_Pnt, J_0, MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, 'Regular' );
%             end
%         end
%     end
%     if isempty(K1_6)
%         disp('K1: empty');
%         if strcmp(TEX, 'Regular')
%             [ m_v, n_v, ell_v, edgeNum ] = eIdx2rIdx(eIdx, x_idx_max, y_idx_max, z_idx_max);
%             [ m_v, n_v, ell_v, edgeNum ]
%         end
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [ m_v, n_v, ell_v, edgeNum ]
%         break
%     end
%     if isnan(K1_6) | isinf(K1_6)
%         disp('K1: NaN or Inf');
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [ m_v, n_v, ell_v, edgeNum ]
%         break
%     end
%     if isempty(Kev_4)
%         disp('Kev: empty');
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [ m_v, n_v, ell_v, edgeNum ]
%         break
%     end
%     if isnan(Kev_4) | isinf(Kev_4)
%         disp('Kev: NaN or Inf');
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [ m_v, n_v, ell_v, edgeNum ]
%         break
%     end
%     if edgeChecker(eIdx) == true
%         lGidx
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [ m_v, n_v, ell_v, edgeNum ]
%         error('check')
%     end

%     edgeChecker(eIdx) = true;
%     M_K1(eIdx, :)  = M_K1(eIdx, :)  + K1_6;
%     M_KEV(eIdx, :) = M_KEV(eIdx, :) + Kev_4;
%     M_KVE(:, eIdx) = M_KVE(:, eIdx) + Kve_4;
%     B_k(eIdx) = B_k(eIdx) + B_k_Pnt;
% end
% toc;

% % === % ========================== % === %
% % === % GVV matrix and its inverse % === %
% % === % ========================== % === %

% % start from here: debug for GVV
% M_sparseGVV = sparse(N_v_r, N_v_r);
% disp('The filling time of G_VV: ');
% tic;
% for rIdx = 1: 1: N_v_r
%     GVV_row = sparse(1, N_v_r);
%     CandiTet = find( MedTetTable(:, rIdx));
%     for itr = 1: 1: length(CandiTet)
%         % v is un-ordered vertices; while p is ordered vertices.
%         v1234 = find( MedTetTable( CandiTet(itr), : ) );
%         if length(v1234) ~= 4
%             error('check');
%         end
%         p1234 = horzcat( v1234(find(v1234 == rIdx)), v1234(find(v1234 ~= rIdx)));
%         GVV_row(p1234) = GVV_row(p1234) + fillGVV(p1234, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt);
%     end
%     M_sparseGVV(rIdx, :) = M_sparseGVV(rIdx, :) + GVV_row;
% end
% toc;

% % % check empty rows in M_sparseGVV
% sparseGVV = cell(1, N_v);
% sparseGVV = Msparse2msparse(M_sparseGVV, 'Col');

% TEX = 'Regular';
% CaseTEX = 'Case1';
% GVV_test; % a script
% Tol = 0.2;
% load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

% % === % ========================= % === %
% % === % Matrices product to get K % === %
% % === % ========================= % === %

% disp('The calculation time of matrix product: ');
% tic;
% M_three = M_KEV * M_sparseGVV_inv_spai * M_KVE;
% toc;

% M_K = sparse(N_e_r, N_e_r);
% M_K = M_K1 - M_three;

% % === % ============================ % === %
% % === % Sparse Normalization Process % === %
% % === % ============================ % === %

% tic;
% disp('Time for normalization');
% sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e_r, N_e_r );
% nrmlM_K = sptmp * M_K;
% B_k = sptmp * B_k;
% toc;

% % === % ============================================================ % === %
% % === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% % === % ============================================================ % === %

% tol = 1e-6;
% ext_itr_num = 10;
% int_itr_num = 50;

% bar_x_my_gmres = zeros(size(B_k));
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\B_k;
% toc;
% % tic;
% % disp('The gmres solutin of Ax = B: ');
% % bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
% % toc;

% % save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

% AFigsScript;

% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % toc;