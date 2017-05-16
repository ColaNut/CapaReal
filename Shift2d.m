% === % =========================================== % === %
% === % Initialization of coordinate and grid shift % === %
% === % =========================================== % === %
clc; clear;
digits;

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
% === % ======== % === %
% === % Modified % === %
% === % ======== % === %
mu_db_prime   = [ 0,    0 ]';
% === % ============ % === %
% === % Modified End % === %
% === % ============ % === %
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

% the above process update the medium value and construct the shiftedCoordinateXYZ
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

% === % =================== % === %
% === % Filling of Matrices % === %
% === % =================== % === %

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
        % check the validity of this assignment
        SheetPntsTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
            = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable );
    end
end

B_k       = zeros(N_e, 1);
% sparseK1  = cell( N_e, 1 );
% sparseKEV = cell( N_e, 1 );
% sparseKVE = cell( 1, N_e );
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
%                 B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     % three surfaces
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     % three lines
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
%         sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
% end
% toc;

% % GVV matrix
% sparseGVV = cell(1, N_v);
% disp('The filling time of G_VV: ');
% tic;
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     GVV_SideFlag = false(1, 6);
%     GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%     if isempty( find( GVV_SideFlag ) )
%         sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
%                                             z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
%     else
%         sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
% end
% toc;

% % === % =================== % === %
% % === % Calculation of SPAI % === %
% % === % =================== % === %

% % Refer to GVV_test.m

% Tol = 0.1;
% load( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv' );

% % === % ========================= % === %
% % === % Matrices product to get K % === %
% % === % ========================= % === %

% M_three = sparse(N_e, N_e);
% M_KEV      = mySparse2MatlabSparse( sparseKEV, N_e, N_v, 'Row' );
% M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
% % M_G_VV_inv = mySparse2MatlabSparse( sparseG_VV_inv, N_v, N_v, 'Col' );
% M_KVE      = mySparse2MatlabSparse( sparseKVE, N_v, N_e, 'Col' );

% disp('The calculation time of matrix product: ');
% tic;
% M_three = M_KEV * M_sparseGVV_inv_spai * M_KVE;
% toc;

% % disp('Transforming from M_three to m_three in the first 100 rows: ');
% % tic;
% % TMP_m_three = cell( N_e, 1 );
% % TMP_m_three = Msparse2msparse(M_three, 100);
% % toc;
% % save('TMP_m_three.mat', 'TMP_m_three', 'sparseK1', 'sparseKEV', 'sparseGVV', 'sparseGVV_inv', 'sparseKVE' );

% M_K = sparse(N_e, N_e);
% M_K1 = mySparse2MatlabSparse( sparseK1, N_e, N_e, 'Row' );
% M_K = M_K1 - M_three;

% sparseK = cell(N_e, 1);
% disp('Transforming from M_K to sparseK : ');
% tic;
% sparseK = Msparse2msparse(M_K);
% toc;

% % boundary condition on \Gamma for K
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     % the three top-right-far faces
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == z_max_vertex
%         [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 2}, ...
%             sparseK{7 * ( vIdx_prm - 1 ) + 4} ] = fillTop_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v == x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK{7 * ( vIdx_prm - 1 ) + 2}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
%             sparseK{7 * ( vIdx_prm - 1 ) + 5} ] = fillRght_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
%             sparseK{7 * ( vIdx_prm - 1 ) + 6} ] = fillFar_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     % the three near-left-bottom faces
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fillNear_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fillLeft_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fillBttm_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     % three lines
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
%         sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fillLine1_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v == 1 && n_v == 1 && ell_v >= 2  && ell_v <= z_max_vertex
%         sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fillLine2_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ...
%             = fillLine3_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
% end

y_n = 0;
arndNum = length( find(SheetPntsTable(:, int64(w_y / (2 * dy) + 1), :) == 1) );
for v_idx = 1: 1: x_max_vertex * z_max_vertex
    [ m_v, ell_v ] = getML(v_idx, x_max_vertex);
    if SheetPntsTable(m_v, int64(w_y / (2 * dy) + 1), ell_v) == 1;
        y_n = length( find( SheetPntsTable(m_v, :, ell_v) == 1 ) );
        break
    end
end
sparseAug =  cell( 3 * arndNum * 2 * (y_n - 1), 1 );
AugBk     = zeros( 3 * arndNum * 2 * (y_n - 1), 1 );

% boundary condition on current sheet 
counter = int64(0);
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    auxiSegMed = ones(6, 8, 'uint8');
    corner_flag = false(2, 6);
    flag = getMNL_flag(m_v, n_v, ell_v);
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
    % volume
    switch flag
        case { '111', '000' }
            fc = str2func('fillNrml_K_Type1');
        case { '100', '011' }
            fc = str2func('fillNrml_K_Type2');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '101', '010' }
            fc = str2func('fillNrml_K_Type3');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '110', '001' }
            fc = str2func('fillNrml_K_Type4');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        otherwise
            error('check');
    end
    
    TiltType = '';
    EdgeRx = [0, 0];
    if n_v >= 2 && SheetPntsTable(m_v, n_v, ell_v) == 1 && SheetPntsTable(m_v, n_v - 1, ell_v) == 1
        counter = counter + 1;
        if Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
            % II-quadrant 
            quadtantNum = 2;
            if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v - 1, n_v, ell_v - 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
            % I-quadrant 
            quadtantNum = 1;
            if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v - 1, n_v, ell_v + 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
            % IV-quadrant 
            quadtantNum = 4;
            if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v + 1, n_v, ell_v + 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        end
        end
        [ sparseAug{6 * ( counter - 1 ) + 1}, sparseAug{6 * ( counter - 1 ) + 2}, sparseAug{6 * ( counter - 1 ) + 3}, ...
            sparseAug{6 * ( counter - 1 ) + 4}, sparseAug{6 * ( counter - 1 ) + 5}, sparseAug{6 * ( counter - 1 ) + 6}, ...
            AugBk(6 * ( counter - 1 ) + 1), AugBk(6 * ( counter - 1 ) + 2), AugBk(6 * ( counter - 1 ) + 3), ...
            AugBk(6 * ( counter - 1 ) + 4), AugBk(6 * ( counter - 1 ) + 5), AugBk(6 * ( counter - 1 ) + 6) ] ...
        = fc( m_v, n_v, ell_v, flag, ...
            Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
            B_k, SheetPntsTable, J_0, corner_flag, TiltType, quadtantNum, SegMed );
    end
end

count = 0;
for idx = 1: 1: 3 * arndNum  * (y_n - 1)
    if isempty(sparseAug{ idx })
        count = count + 1;
    end
end
count
% % === % ============================ % === %
% % === % Sparse Normalization Process % === %
% % === % ============================ % === %

% % Normalize each rows
% disp('Normalization');
% tic;
% for idx = 1: 1: N_e
%     % non-zero index: nz_idx
%     nz_idx = find(M_K(idx, :));
%     MAX_row_value = full( max( abs(M_K(idx, nz_idx)) ) );
%     M_K(idx, nz_idx) = M_K(idx, nz_idx) / MAX_row_value;
%     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% end
% toc;

% save('Normalized.mat', 'M_K', 'B_k');

% % === % ================ % === %
% % === % Check empty rows % === %
% % === % ================ % === %

% for eIdx = 1: 1: N_e
%     if isempty(sparseK{ eIdx })
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex)
%     end
% end

% === % ========================= % === %
% === % Old Normalization Process % === %
% === % ========================= % === %

% for idx = 1: 1: N_e
%     tmp_vector = sparseK{ idx };
%     num = uint64(size(tmp_vector, 2)) / 2;
%     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
%     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
%     sparseK{ idx } = tmp_vector;
%     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% end

% === % =========================== % === %
% === % LU preconditioner and GMRES % === %
% === % =========================== % === %

% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 20;

% bar_x_my_gmres = zeros(size(B_k));
% nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;

% save('Case0511_1e2.mat', 'bar_x_my_gmres');

% AFigsScript;

% % % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% % xy_grid_table format: [ x_coordonate, y_coordonate, difference ]