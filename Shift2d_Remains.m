% === % =========================================== % === %
% === % Initialization of coordinate and grid shift % === %
% === % =========================================== % === %
clc; clear;
digits;
disp('K, case 1');

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 100 * 10^3; % 2 * pi * 100 kHz
% J_0           = 300000;
J_0           = 1500;
% V_0           = 89; 

% paras: 
rho           = [ 1, 4600 ]';
epsilon_r_pre = [ 1,    1 ]';
sigma         = [ 0,    0 ]';
epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );
mu_prime      = [ 1,    1 ]';
mu_db_prime   = [ 0,    0 ]';
% mu_db_prime   = [ 0,    0.62 ]';
mu_r          = mu_prime - i * mu_db_prime;

% There 'must' be a grid point at the origin.
loadParas_Mag;
% paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;

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

% unvalid SegMed is set to 0
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable(m, n, ell) == uint8(2)
        SegMed(m, n, ell, :, :) = uint8(2);

        x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
        x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

        y_idx_near = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
        y_idx_far  = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);

        z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
        z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

        if ell == z_idx_up
            SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if ell == z_idx_down
            SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if m   == x_idx_left
            SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if m   == x_idx_rght
            SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if n   == y_idx_far
            SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if n   == y_idx_near
            SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
    end
end

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

% % === % ======================== % === %
% % === % MedTetTable Construction % === %
% % === % ======================== % === % 

% trim for SegMed: unvalid set to 0
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 0 );
    end
end

tic;
disp('Time for constructing the MedTetTable');
MedTetTable = sparse(0, N_v);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntMedTetTable = sparse(48, N_v);
    PntMedTetTable = getPntMedTetTable( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' );
    MedTetTable = vertcat(MedTetTable, PntMedTetTable(validTet, :));
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(MedTetTable, 1) ~= validNum
    error('check the construction');
end

% % === % ==================== % === %
% % === % Filling of EdgeTable % === %
% % === % ==================== % === %

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
            = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable );
    end
end

% B_k       = zeros(N_e, 1);
% edgeTable = false(size(B_k));
% M_K1  = sparse(N_e, N_e);
% M_KEV = sparse(N_e, N_v);
% M_KVE = sparse(N_v, N_e);
% edgeScript;

% % === % =============================== % === %
% % === % Constructing The Directed Graph % === %
% % === % =============================== % === %

starts = [];
ends = [];
vals = [];
borderFlag = false(1, 6);
disp('Constructing the directed graph');
% the validity of the input must be gurantee !!!
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    if strcmp(flag, '000') && ~mod(ell_v, 2)
        [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
    end
end
G = sparse(starts, ends, vals, N_v, N_v);
toc;
[ P1, P2 ] = find(G);
l_G = length(find(G));

% undirected graph
uG = G + G';

edgeChecker = false(l_G, 1);
tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
for lGidx = 1: 1: l_G
    eIdx = full( G(P1(lGidx), P2(lGidx)) );
    Candi = [];
    % get candidate points
    P1_cand = uG(P1(lGidx), :);
    P2_cand = uG(P2(lGidx), :);
    P1_nz = find(P1_cand);
    P2_nz = find(P2_cand);
    for CandiFinder = 1: 1: length(P1_nz)
        if find(P2_nz == P1_nz(CandiFinder))
            Candi = horzcat(Candi, P1_nz(CandiFinder));
        end
    end
    % get adjacent tetrahdron
    K1_6 = sparse(1, N_e); 
    Kev_4 = sparse(1, N_v);
    Kve_4 = sparse(N_v, 1);
    B_k_Pnt = 0;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                MedVal = MedTetTable( tetRow, v1234(1) );
                [ K1_6, Kev_4, Kve_4, B_k_Pnt ] = fillK( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
                    G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
                    SheetPntsTable( P1(lGidx) ), SheetPntsTable( P2(lGidx) ), SheetPntsTable( Candi(itr) ), SheetPntsTable( Candi(TetFinder) ), ...
                    lGidx, K1_6, Kev_4, Kve_4, B_k_Pnt, J_0, MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
            end
        end
    end
    if isempty(K1_6)
        disp('K1: empty');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        break
    end
    if isnan(K1_6) | isinf(K1_6)
        disp('K1: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        break
    end
    if isempty(Kev_4)
        disp('Kev: empty');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        break
    end
    if isnan(Kev_4) | isinf(Kev_4)
        disp('Kev: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        break
    end
    if edgeChecker(eIdx) == true
        lGidx
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        error('check')
    end

    edgeChecker(eIdx) = true;
    M_K1(eIdx, :)  = M_K1(eIdx, :)  + K1_6;
    M_KEV(eIdx, :) = M_KEV(eIdx, :) + Kev_4;
    M_KVE(:, eIdx) = M_KVE(:, eIdx) + Kve_4;
    B_k(eIdx) = B_k(eIdx) + B_k_Pnt;
end
toc;

checker = find(edgeChecker);
save('checker.mat', 'checker');

% === % ============== % === %
% === % Old Manual Way % === %
% === % ============== % === %

% toc;
% tic;
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

%     auxiSegMed = ones(6, 8, 'uint8');
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     corner_flag = false(2, 6);
%     % first row: prime coordinate
%     % second row: original coordinate
%     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     % 1: up; 2: left; 3: down; 4: righ; 5: far; 6: near
%     % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
%     % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
%     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );

%     % volume
%     switch flag
%         case { '111', '000' }
%             fc = str2func('fillNrml_K_Type1');
%         case { '100', '011' }
%             fc = str2func('fillNrml_K_Type2');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '101', '010' }
%             fc = str2func('fillNrml_K_Type3');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '110', '001' }
%             fc = str2func('fillNrml_K_Type4');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         otherwise
%             error('check');
%     end
%     % volume
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{7 * ( vIdx_prm - 1 ) + 1}, sparseK1{7 * ( vIdx_prm - 1 ) + 2}, sparseK1{7 * ( vIdx_prm - 1 ) + 3}, ...
%             sparseK1{7 * ( vIdx_prm - 1 ) + 4}, sparseK1{7 * ( vIdx_prm - 1 ) + 5}, sparseK1{7 * ( vIdx_prm - 1 ) + 6}, ...
%             sparseK1{7 * ( vIdx_prm - 1 ) + 7}, sparseKEV{7 * ( vIdx_prm - 1 ) + 1}, sparseKEV{7 * ( vIdx_prm - 1 ) + 2}, ...
%             sparseKEV{7 * ( vIdx_prm - 1 ) + 3}, sparseKEV{7 * ( vIdx_prm - 1 ) + 4}, sparseKEV{7 * ( vIdx_prm - 1 ) + 5}, ...
%             sparseKEV{7 * ( vIdx_prm - 1 ) + 6}, sparseKEV{7 * ( vIdx_prm - 1 ) + 7}, sparseKVE{7 * ( vIdx_prm - 1 ) + 1}, ...
%             sparseKVE{7 * ( vIdx_prm - 1 ) + 2}, sparseKVE{7 * ( vIdx_prm - 1 ) + 3}, sparseKVE{7 * ( vIdx_prm - 1 ) + 4}, ...
%             sparseKVE{7 * ( vIdx_prm - 1 ) + 5}, sparseKVE{7 * ( vIdx_prm - 1 ) + 6}, sparseKVE{7 * ( vIdx_prm - 1 ) + 7}, B_k ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                 Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                 B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     % three surfaces
%     elseif m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     elseif m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     elseif m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     % three lines
%     elseif m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     elseif m_v == 1 && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     elseif m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
%     else
%         [m_v, n_v, ell_v]
%     end
% end
% toc;

% % === % ========== % === %
% % === % GVV matrix % === %
% % === % ========== % === %

sparseGVV = cell(1, N_v);
disp('The filling time of G_VV: ');
tic;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    GVV_SideFlag = false(1, 6);
    GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
    if isempty( find( GVV_SideFlag ) )
        sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                                            z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
    else
        sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    end
end
toc;

% % % === % =================== % === %
% % % === % Calculation of SPAI % === %
% % % === % =================== % === %

% Refer to GVV_test.m
Tol = 0.2;
% GVV_test;
load( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv' );

% % % === % ===================== % === %
% % % === % Check Valid my_sparse % === %
% % % === % ===================== % === %

% if ~( checkRow(sparseK1) && checkRow(sparseKEV) && checkCol(sparseGVV_inv) && checkCol(sparseKVE) )
%     error('check');
% end

% % === % =================================== % === %
% % === % Transform from mySparse to M_sparse % === %
% % === % =================================== % === %

% M_K1 = mySparse2MatlabSparse( sparseK1, N_e, N_e, 'Row' );
% M_three = sparse(N_e, N_e);
% M_KEV      = mySparse2MatlabSparse( sparseKEV, N_e, N_v, 'Row' );
M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
% M_KVE      = mySparse2MatlabSparse( sparseKVE, N_v, N_e, 'Col' );

% % % === % ========================== % === %
% % % === % Test For Invalid Filled-in % === %
% % % === % ========================== % === %

% % x_max_vertex_prm = x_max_vertex - 1;
% % y_max_vertex_prm = y_max_vertex - 1;
% % z_max_vertex_prm = z_max_vertex - 1;

% % % 8 possible mask points 
% % MaskIdx_prm = x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm / 2 + x_max_vertex_prm * y_max_vertex_prm / 2 + x_max_vertex_prm / 2;
% % Middle_eIdx = 7 * ( x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm / 2 + x_max_vertex_prm * y_max_vertex_prm / 2 + x_max_vertex_prm / 2 ) + 1;
% % MaskIdxes = [ vIdx2eIdx(MaskIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 vIdx2eIdx(MaskIdx_prm, 7, x_max_vertex, y_max_vertex, z_max_vertex), ...
% %                 Middle_eIdx ];

% % % M_check = sparse(N_e, 8);
% % % for itr = 1: 1: 8
% % %     M_check(:, itr) = M_K1(:, MaskIdxes(itr));
% % % end

% % % for exItr = 1: 1: 8
% % %     tmpCheck = find(M_check(:, exItr));
% % %     for itr = 1: 1: length( tmpCheck )
% % %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(tmpCheck(itr), x_max_vertex, y_max_vertex, z_max_vertex)
% % %     end
% % % end

% % % check for vertex:
% % MiddleV_idx = int64( x_max_vertex * y_max_vertex * z_max_vertex / 2);
% % [ m_v, n_v, ell_v ] = getMNL(MiddleV_idx, x_max_vertex, y_max_vertex, z_max_vertex)
% % M_checkV = sparse(N_e, 1);
% % M_checkV = M_KEV(:, MiddleV_idx);

% % ValidPnts = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );


% % % === % ========================= % === %
% % % === % Matrices product to get K % === %
% % % === % ========================= % === %

disp('The calculation time of matrix product: ');
tic;
M_three = M_KEV * M_sparseGVV_inv_spai * M_KVE;
toc;

% % disp('Transforming from M_three to m_three in the first 100 rows: ');
% % tic;
% % TMP_m_three = cell( N_e, 1 );
% % TMP_m_three = Msparse2msparse(M_three, 100);
% % toc;
% % save('TMP_m_three.mat', 'TMP_m_three', 'sparseK1', 'sparseKEV', 'sparseGVV', 'sparseGVV_inv', 'sparseKVE' );

M_K = sparse(N_e, N_e);
M_K = M_K1 - M_three;
% M_K = - M_three;

% % sparseK = cell(N_e, 1);
% % disp('Transforming from M_K to sparseK : ');
% % tic;
% % sparseK = Msparse2msparse(M_K);
% % toc;
% % sparseK = sparseK1;

% % % === % ===================================== % === %
% % % === % Recover the original rows in sparseK1 % === %
% % % === % ===================================== % === %

% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     if edgeTable(vIdx)
% %         sparseK{ vIdx } = sparseK1_keep{ vIdx };
% %     end
% % end

% % % boundary condition on \Gamma for K
% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     % the three top-right-far faces
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == z_max_vertex
% %         [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 2}, ...
% %             sparseK{7 * ( vIdx_prm - 1 ) + 4} ] = fillTop_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v == x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
% %         [ sparseK{7 * ( vIdx_prm - 1 ) + 2}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
% %             sparseK{7 * ( vIdx_prm - 1 ) + 5} ] = fillRght_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v == y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
% %         [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
% %             sparseK{7 * ( vIdx_prm - 1 ) + 6} ] = fillFar_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     % the three near-left-bottom faces
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
% %         [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
% %             = fillNear_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
% %         [ sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
% %             = fillLeft_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
% %         [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
% %             sparseK{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
% %             = fillBttm_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     % three lines
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
% %         sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ...
% %             = fillLine1_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v == 1 && n_v == 1 && ell_v >= 2  && ell_v <= z_max_vertex
% %         sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ...
% %             = fillLine2_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% %     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
% %         sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ...
% %             = fillLine3_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% % end

% % save('UnNormalized.mat', 'sparseK', 'B_k');

% % === % =================================================== % === %
% % === % Imposed cboundary conditions on current sheet Ver.1 % === %
% % === % =================================================== % === %

% % y_n = 0;
% % arndNum = length( find(SheetPntsTable(:, int64(w_y / (2 * dy) + 1), :) == 1) );
% % for v_idx = 1: 1: x_max_vertex * z_max_vertex
% %     [ m_v, ell_v ] = getML(v_idx, x_max_vertex);
% %     if SheetPntsTable(m_v, int64(w_y / (2 * dy) + 1), ell_v) == 1;
% %         y_n = length( find( SheetPntsTable(m_v, :, ell_v) == 1 ) );
% %         break
% %     end
% % end
% % EdgeTable = false(N_e, 2); % first row for filled in; second row for prohibition look-up table
% % EdgeTable(:, 2) = logical(B_k);
% % sparseAug     =  cell( 3 * arndNum * 2 * (y_n - 1), 1 );
% % CurrentIdxSet =  cell(     arndNum * 2 * (y_n - 1), 1 );
% % AugBk         = zeros( 3 * arndNum * 2 * (y_n - 1), 1 );

% % % boundary condition on current sheet 
% % counter = int64(0);
% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

% %     if m_v == 9 && n_v == 9 && ell_v == 13
% %         ;
% %     end
% %     auxiSegMed = ones(6, 8, 'uint8');
% %     corner_flag = false(2, 6);
% %     flag = getMNL_flag(m_v, n_v, ell_v);
% %     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %     % volume
% %     switch flag
% %         case { '111', '000' }
% %             fc = str2func('fillNrml_K_Type1');
% %             tpflag = 'type1';
% %         case { '100', '011' }
% %             fc = str2func('fillNrml_K_Type2');
% %             tpflag = 'type2';
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         case { '101', '010' }
% %             fc = str2func('fillNrml_K_Type3');
% %             tpflag = 'type3';
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         case { '110', '001' }
% %             fc = str2func('fillNrml_K_Type4');
% %             tpflag = 'type4';
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         otherwise
% %             error('check');
% %     end

% %     TiltType = '';
% %     EdgeRx = [0, 0];
% %     if n_v >= 2 && SheetPntsTable(m_v, n_v, ell_v) == 1 && SheetPntsTable(m_v, n_v - 1, ell_v) == 1
% %         counter = counter + 1;
% %         if Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
% %             % II-quadrant 
% %             quadtantNum = 2;
% %             tpflag = strcat(tpflag, '-II');
% %             if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
% %                 TiltType = 'Horizental';
% %                 % EdgeRx = [2, 4];
% %             elseif SheetPntsTable(m_v - 1, n_v, ell_v - 1) == 1
% %                 TiltType = 'Oblique';
% %                 % EdgeRx = [2, 7];
% %             elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
% %                 TiltType = 'Vertical';
% %                 % EdgeRx = [2, 5];
% %             end
% %         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
% %             % I-quadrant 
% %             quadtantNum = 1;
% %             tpflag = strcat(tpflag, '-I');
% %             if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
% %                 TiltType = 'Horizental';
% %                 % EdgeRx = [2, 4];
% %             elseif SheetPntsTable(m_v - 1, n_v, ell_v + 1) == 1
% %                 TiltType = 'Oblique';
% %                 % EdgeRx = [2, 7];
% %             elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
% %                 TiltType = 'Vertical';
% %                 % EdgeRx = [2, 5];
% %             end
% %         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
% %             % IV-quadrant 
% %             quadtantNum = 4;
% %             tpflag = strcat(tpflag, '-IV');
% %             if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
% %                 TiltType = 'Horizental';
% %                 % EdgeRx = [2, 4];
% %             elseif SheetPntsTable(m_v + 1, n_v, ell_v + 1) == 1
% %                 TiltType = 'Oblique';
% %                 % EdgeRx = [2, 7];
% %             elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
% %                 TiltType = 'Vertical';
% %                 % EdgeRx = [2, 5];
% %             end
% %         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
% %             % III-quadrant 
% %             quadtantNum = 3;
% %             tpflag = strcat(tpflag, '-III');
% %             if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
% %                 TiltType = 'Horizental';
% %                 % EdgeRx = [2, 4];
% %             elseif SheetPntsTable(m_v + 1, n_v, ell_v - 1) == 1
% %                 TiltType = 'Oblique';
% %                 % EdgeRx = [2, 7];
% %             elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
% %                 TiltType = 'Vertical';
% %                 % EdgeRx = [2, 5];
% %             end
% %         end
% %         [ sparseAug{6 * ( counter - 1 ) + 1}, sparseAug{6 * ( counter - 1 ) + 2}, sparseAug{6 * ( counter - 1 ) + 3}, ...
% %             CurrentIdxSet{ 2 * (counter - 1) + 1 }, ...
% %             sparseAug{6 * ( counter - 1 ) + 4}, sparseAug{6 * ( counter - 1 ) + 5}, sparseAug{6 * ( counter - 1 ) + 6}, ...
% %             CurrentIdxSet{ 2 * (counter - 1) + 2 }, ...
% %             AugBk(6 * ( counter - 1 ) + 1), AugBk(6 * ( counter - 1 ) + 2), AugBk(6 * ( counter - 1 ) + 3), ...
% %             AugBk(6 * ( counter - 1 ) + 4), AugBk(6 * ( counter - 1 ) + 5), AugBk(6 * ( counter - 1 ) + 6) ] ...
% %         = fc( m_v, n_v, ell_v, flag, ...
% %             Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
% %             B_k, SheetPntsTable, J_0, corner_flag, TiltType, quadtantNum, SegMed );

% %         % replace the sparseK matrix
% %         lastFlag = false;
% %         if SheetPntsTable(m_v, n_v + 1, ell_v) == 0
% %             lastFlag = true;
% %         end
% %         AuxiIdx = zeros(6, 1);
% %         [ AuxiIdx, EdgeTable ] = getAuxiIdx(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, tpflag, TiltType, lastFlag, ...
% %                         EdgeTable, CurrentIdxSet{ 2 * (counter - 1) + 1 }, CurrentIdxSet{ 2 * (counter - 1) + 2 });
% %         sparseK{ AuxiIdx(1) } = sparseAug{ 6 * (counter - 1) + 1 };
% %         sparseK{ AuxiIdx(2) } = sparseAug{ 6 * (counter - 1) + 2 };
% %         sparseK{ AuxiIdx(3) } = sparseAug{ 6 * (counter - 1) + 3 };
% %         sparseK{ AuxiIdx(4) } = sparseAug{ 6 * (counter - 1) + 4 };
% %         sparseK{ AuxiIdx(5) } = sparseAug{ 6 * (counter - 1) + 5 };
% %         sparseK{ AuxiIdx(6) } = sparseAug{ 6 * (counter - 1) + 6 };
% %         B_k( AuxiIdx(1) ) = AugBk( 6 * (counter - 1) + 1 );
% %         B_k( AuxiIdx(2) ) = AugBk( 6 * (counter - 1) + 2 );
% %         B_k( AuxiIdx(3) ) = AugBk( 6 * (counter - 1) + 3 );
% %         B_k( AuxiIdx(4) ) = AugBk( 6 * (counter - 1) + 4 );
% %         B_k( AuxiIdx(5) ) = AugBk( 6 * (counter - 1) + 5 );
% %         B_k( AuxiIdx(6) ) = AugBk( 6 * (counter - 1) + 6 );
% %     end
% % end

% % count = 0;
% % for idx = 1: 1: 3 * arndNum * 2 * (y_n - 1)
% %     if isempty(sparseAug{ idx })
% %         count = count + 1;
% %     end
% % end
% % count

% % for idx = 1: 1: arndNum  * (y_n - 1)
% %     if AugBk( 3 * ( idx - 1 ) + 3 ) == 0
% %         idx
% %     end
% % end

% % === % =================================================== % === %
% % === % Imposed cboundary conditions on current sheet Ver.2 % === %
% % === % =================================================== % === %

% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

% %     auxiSegMed = ones(6, 8, 'uint8');
% %     flag = getMNL_flag(m_v, n_v, ell_v);
% %     corner_flag = false(2, 6);
% %     % first row: prime coordinate
% %     % second row: original coordinate
% %     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
% %     % 1: up; 2: left; 3: down; 4: righ; 5: far; 6: near
% %     % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
% %     % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
% %     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );

% %     % volume
% %     switch flag
% %         case { '111', '000' }
% %             fc = str2func('fillNrml_K_Type1');
% %         case { '100', '011' }
% %             fc = str2func('fillNrml_K_Type2');
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         case { '101', '010' }
% %             fc = str2func('fillNrml_K_Type3');
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         case { '110', '001' }
% %             fc = str2func('fillNrml_K_Type4');
% %             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %         otherwise
% %             error('check');
% %     end
% %     % volume
% %     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
% %         sparseK1( 7 * ( vIdx_prm - 1 ) + 1: 7 * ( vIdx_prm - 1 ) + 7 ) ...
% %             = fc( m_v, n_v, ell_v, flag, ...
% %                 Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
% %                 B_k, SheetPntsTable, J_0, corner_flag, ...
% %                 sparseK1( 7 * ( vIdx_prm - 1 ) + 1: 7 * ( vIdx_prm - 1 ) + 7 ) );
% %     end
% % end
% % % === % ============================ % === %
% % % === % Sparse Normalization Process % === %
% % % === % ============================ % === %
% tic;
% disp('Time for saving');
% save('0604.mat', 'B_k', 'M_K1', 'M_KEV', 'M_sparseGVV_inv_spai', 'M_KVE');
% toc;
% % % Normalize each rows
tic;
disp('Time for normalization');
sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
nrmlM_K = sptmp * M_K;
B_k = sptmp * B_k;
toc;
% % disp('Normalization');
% % tic;
% % for idx = 1: 1: N_e
% %     % non-zero index: nz_idx
% %     nz_idx = find(M_K(idx, :));
% %     MAX_row_value = full( max( abs(M_K(idx, nz_idx)) ) );
% %     M_K(idx, nz_idx) = M_K(idx, nz_idx) / MAX_row_value;
% %     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% % end
% % toc;

% % save('NormalizedNBC_K1.mat', 'sparseK', 'B_k');

% % % === % ================ % === %
% % % === % Check empty rows % === %
% % % === % ================ % === %

% % for eIdx = 1: 1: N_e
% %     if isempty(sparseK{ eIdx })
% %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex)
% %     end
% % end

% % === % =============================== % === %
% % === % my_sparse Normalization Process % === %
% % === % =============================== % === %

% % for idx = 1: 1: N_e
% %     tmp_vector = sparseK{ idx };
% %     num = uint64(size(tmp_vector, 2)) / 2;
% %     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
% %     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
% %     sparseK{ idx } = tmp_vector;
% %     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% % end

% % === % =========================== % === %
% % === % LU preconditioner and GMRES % === %
% % === % =========================== % === %

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
tic; 
disp('Computational time for solving Ax = b: ')
bar_x_my_gmres = nrmlM_K\B_k;
toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
% toc;

% % save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

AFigsScript;

% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % toc;

% % % % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% % % xy_grid_table format: [ x_coordonate, y_coordonate, difference ]