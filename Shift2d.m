% % === % ========================================= % === %
% % === % Construction of coordinate and grid shift % === %
% % === % ========================================= % === %

% clc; clear;
% digits;
% disp('K, case 1');

% Mu_0          = 4 * pi * 10^(-7);
% Epsilon_0     = 10^(-9) / (36 * pi);
% Omega_0       = 2 * pi * 100 * 10^3; % 2 * pi * 100 kHz
% % J_0           = 300000;
% J_0           = 1500;
% % V_0           = 89; 

% % paras: 
% rho           = [ 1, 4600 ]';
% epsilon_r_pre = [ 1,    1 ]';
% sigma         = [ 0,    0 ]';
% epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );
% mu_prime      = [ 1,    1 ]';
% mu_db_prime   = [ 0,    0 ]';
% % mu_db_prime   = [ 0,    0.62 ]';
% mu_r          = mu_prime - i * mu_db_prime;

% % There 'must' be a grid point at the origin.
% loadParas_Mag;
% % paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

% x_idx_max = w_x / dx + 1;
% y_idx_max = w_y / dy + 1;
% z_idx_max = w_z / dz + 1;

% GridShiftTableXZ = cell( y_idx_max, 1);
% % GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.
% mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% % medium1            : 1 
% % magnetic particle  : 2
% % % conductor        : 3
% % current sheet bndry: 11

% for y = - w_y / 2: dy: w_y / 2
%     paras2dXZ_Mag = genParas2dXZ_Mag( y, Paras_Mag );
%     y_idx = y / dy + w_y / (2 * dy) + 1;
%     sample_valid = paras2dXZ_Mag(12);
%     if sample_valid
%         mediumTable(:, int64(y_idx), :) = getRoughMed_Mag( mediumTable(:, int64(y_idx), :), paras2dXZ_Mag );
%     end
%     [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all_Mag( paras2dXZ_Mag, mediumTable(:, int64(y_idx), :) );
% end

% % re-organize the GridShiftTable
% GridShiftTable = cell( w_x / dx + 1, w_y / dy + 1, w_z / dz + 1 );
% for y_idx = 1: 1: w_y / dy + 1
%     tmp_table = GridShiftTableXZ{ y_idx };
%     for x_idx = 1: 1: w_x / dx + 1
%         for z_idx = 1: 1: w_z / dz + 1
%             GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
%         end
%     end
% end
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% % xy_grid_table format: [ x_coordonate, y_coordonate, difference ]

% shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, [ w_y, w_x, w_z ], dx, dy, dz );

% % unvalid SegMed is set to 0
% SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if mediumTable(m, n, ell) == uint8(2)
%         SegMed(m, n, ell, :, :) = uint8(2);

%         x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
%         x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

%         y_idx_near = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
%         y_idx_far  = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);

%         z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
%         z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

%         if ell == z_idx_up
%             SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if ell == z_idx_down
%             SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if m   == x_idx_left
%             SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if m   == x_idx_rght
%             SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if n   == y_idx_far
%             SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if n   == y_idx_near
%             SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%     end
% end

% x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
% N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

% Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
% tic;
% disp('Calculation of vertex coordinate');
% Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% toc;

% % === % ======================== % === %
% % === % MedTetTable Construction % === %
% % === % ======================== % === % 

% % trim for SegMed: unvalid set to 0
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if ell == z_idx_max
%         SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
%     if ell == 1
%         SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
%     if m   == 1
%         SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
%     if m   == x_idx_max
%         SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
%     if n   == y_idx_max
%         SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
%     if n   == 1
%         SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 0 );
%     end
% end

% tic;
% disp('Time for constructing the MedTetTable');
% MedTetTable = sparse(0, N_v);
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;

%     PntMedTetTable = sparse(48, N_v);
%     PntMedTetTable = getPntMedTetTable( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     validTet = find( squeeze( SegMed(m, n, ell, :, :) )' );
%     MedTetTable = vertcat(MedTetTable, PntMedTetTable(validTet, :));
% end
% toc;

% validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
%                 + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;
% if size(MedTetTable, 1) ~= validNum
%     error('check the construction');
% end

% % % === % ==================== % === %
% % % === % Filling of EdgeTable % === %
% % % === % ==================== % === %

% % thin current sheet: need to trim the near end and the far end
% SheetPntsTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
% n_far  =   ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% n_near = - ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if n >= n_near && n <= n_far && mediumTable(m, n, ell) == 11
%         m_v = 2 * m - 1;
%         n_v = 2 * n - 1;
%         ell_v = 2 * ell - 1;
%         SheetPntsTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
%             = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable );
%     end
% end

% % === % =============================== % === %
% % === % Constructing The Directed Graph % === %
% % === % =============================== % === %

% B_k       = zeros(N_e, 1);
% starts = [];
% ends = [];
% vals = [];
% borderFlag = false(1, 6);
% disp('Constructing the directed graph');
% % the validity of the input must be gurantee !!!
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
%     if strcmp(flag, '000') && ~mod(ell_v, 2)
%         [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
%     end
% end
% G = sparse(starts, ends, vals, N_v, N_v);
% toc;
% [ P1, P2 ] = find(G);
% l_G = length(find(G));

% % undirected graph
% uG = G + G';

% edgeChecker = false(l_G, 1);
% tic; 
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% for lGidx = 1: 1: l_G
%     eIdx = full( G(P1(lGidx), P2(lGidx)) );
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
%     K1_6 = sparse(1, N_e); 
%     Kev_4 = sparse(1, N_v);
%     Kve_4 = sparse(N_v, 1);
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
%                 [ K1_6, Kev_4, Kve_4, B_k_Pnt ] = fillK( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
%                     G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
%                     SheetPntsTable( P1(lGidx) ), SheetPntsTable( P2(lGidx) ), SheetPntsTable( Candi(itr) ), SheetPntsTable( Candi(TetFinder) ), ...
%                     lGidx, K1_6, Kev_4, Kve_4, B_k_Pnt, J_0, MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
%             end
%         end
%     end
%     if isempty(K1_6)
%         disp('K1: empty');
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

% checker = find(edgeChecker);
% save('checker.mat', 'checker');

% % === % ========================== % === %
% % === % GVV matrix and its inverse % === %
% % === % ========================== % === %

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

Tol = 0.2;
GVV_test;
% load( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv' );
% M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );

% === % ========================= % === %
% === % Matrices product to get K % === %
% === % ========================= % === %

disp('The calculation time of matrix product: ');
tic;
M_three = M_KEV * M_sparseGVV_inv_spai * M_KVE;
toc;

M_K = sparse(N_e, N_e);
M_K = M_K1 - M_three;
% M_K = - M_three;

% === % ============================ % === %
% === % Sparse Normalization Process % === %
% === % ============================ % === %

tic;
disp('Time for normalization');
sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
nrmlM_K = sptmp * M_K;
B_k = sptmp * B_k;
toc;

% % === % ============================================================ % === %
% % === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% % === % ============================================================ % === %

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(B_k));
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

% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;