% clc; clear;
% digits;

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
% mu_db_prime   = [ 0,  0.6 ]';
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

% tmpParas = [ w_y, w_x, w_z ];
% shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, tmpParas, dx, dy, dz );

% % figure(1);
% % hold on;
% % plotGridLineXZ( shiftedCoordinateXYZ, uint64(0.01 / dy + w_y / (2 * dy) + 1) );
% % plotGridLineYZ( shiftedCoordinateXYZ, uint64(0.02 / dx + w_x / (2 * dx) + 1) );

% % sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
% % B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
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

% % old putOnCurrent.m function
% % % start from here: check the correctness of the above SegMed.
% % % The currently putOnCurrent.m has a zigzag boundary
% % n_far  =   ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% % n_near = - ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% % CurrentTable = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
% % % SegMedXZ = squeeze( SegMed(:, int64( (y_idx_max + 1) / 2 ), :, :, :) );
% % % mediumXZ = squeeze( mediumTable(:, int64( (y_idx_max + 1) / 2 ), :) );
% % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% %     if n >= n_near && n <= n_far && mediumTable(m, n, ell) == 11
% %         [ SegMed(m, n, ell, :, :), CurrentTable(m, n, ell, :, :, :) ] ...
% %             = putOnCurrent(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, J_0 );
% %     end
% % end

% % the above process update the medium value and construct the shiftedCoordinateXYZ

% x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
% N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

% Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
% tic;
% Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% toc;
% save('FEM_A.mat', 'Vertex_Crdnt', 'SegMed');
% % load('FEM_A.mat');
% % load('FEM_fullwave.mat');

% % ========== % ========== % ========== % ========== % ========== % ========== %

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
%         % check the validity of this assignment
%         SheetPntsTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
%             = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable );
%     end
% end

% % flag = '000';
% % load('Case0317.mat');
% % clearvars sparseS B_phi;
% % sparseS = cell( N_v, 1 );
% % B_phi = zeros(N_v, 1);
% B_k = zeros(N_e, 1);
% sparseK1 = cell( N_e, 1 );
% sparseKEV = cell( N_e, 1 );
% sparseKVE = cell( 1, N_e );

% tic;
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% % for vIdx = x_max_vertex * y_max_vertex * 1: 1: x_max_vertex * y_max_vertex * 14
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     % if m_v == 3 && n_v == 3 && ell_v == 2
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

%     if m_v >= 2 && n_v >= 2 && ell_v >= 2 
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
%     % end
% end
% toc;
% % % save('TMP0411.mat');
% sparseGVV = cell(1, N_v);

% % G_VV and SPAI method in sparse matrix form.
% disp('The filling time of G_VV: ');
% tic;
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     % if vIdx == 716

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

%     % end
% end
% toc;

% % save('preGVV.mat');
% Tol = 0.4;
% sparseG_VV_inv = cell(1, N_v);
% disp('The calculation time of SAI: ');
% tic;
% sparseG_VV_inv = getSAI_sparse(sparseGVV, N_v, Tol);
% toc;
% % G_VV = zeros(N_v);
% % G_VV = recoverMatrix( sparseGVV, N_v );

% % clc; clear;
% % load('0430.mat');
% % product to get K
% sparseK = cell( N_e, 1 );
% % the product of K_EV, G_VV_inv and K_VE
% disp('The calculation time of matrix product: ');
% % start from here: implment the getProduct function.
% % get MidMat2
% tic;
% MidMat2 = cell(N_e, 1);
% MidMat2 = getProduct2( sparseKEV, sparseG_VV_inv, N_v );
% toc;
% % get MidMat3
% tic;
% MidMat3 = cell(N_e, 1);
% MidMat3 = getProduct2( MidMat2, sparseKVE, N_v );
% toc;
% combine K1 and MidMat3
clc; clear;
load('0501.mat');
% tic;
% NrmlRow_K1 = zeros(1, N_e);
% NrmlRow_MidMat3 = zeros(1, N_e);
% for e_idx = 1: 1: N_e
%     % tic;
%     NrmlRow_K1 = sparse2NrmlVec( sparseK1{ e_idx }', N_e )';
%     NrmlRow_MidMat3 = sparse2NrmlVec( MidMat3{ e_idx }', N_e )';
%     sparseK{ e_idx } = Nrml2Sparse( NrmlRow_K1 - NrmlRow_MidMat3 );
%     % if e_idx == 100
%     %     disp('100 unit time');
%     %     toc;
%     % end
% end
% toc;
sparseK = sparseK1;

for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% for vIdx = x_max_vertex * y_max_vertex * 13: 1: x_max_vertex * y_max_vertex * 14
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    % the three top-right-far faces
    if m_v >= 2 && n_v >= 2 && ell_v == z_max_vertex
        [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 2}, ...
            sparseK{7 * ( vIdx_prm - 1 ) + 4} ] = fillTop_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == x_max_vertex && n_v >= 2 && ell_v >= 2
        [ sparseK{7 * ( vIdx_prm - 1 ) + 2}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
            sparseK{7 * ( vIdx_prm - 1 ) + 5} ] = fillRght_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v >= 2 && n_v == y_max_vertex && ell_v >= 2
        [ sparseK{7 * ( vIdx_prm - 1 ) + 1}, sparseK{7 * ( vIdx_prm - 1 ) + 3}, ...
            sparseK{7 * ( vIdx_prm - 1 ) + 6} ] = fillFar_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

    % the three near-left-bottom faces
    if m_v >= 2 && n_v == 1 && ell_v >= 2
        [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillNear_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v >= 2 && ell_v >= 2
        [ sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillLeft_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v >= 2 && n_v >= 2 && ell_v == 1
        [ sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillBttm_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

    % three lines
    if m_v >= 2 && n_v == 1 && ell_v == 1
        sparseK{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine1_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v == 1 && ell_v >= 2
        sparseK{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine2_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v >= 2 && ell_v == 1
        sparseK{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine3_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

end

% % update the idx on the three face, three lines and one point stored in the first several part of sparseK1.

% % save('beforeElctrd_S2.mat', 'sparseS');
% % load('beforeElctrd_S2.mat');
% % save('TMP0407.mat');

% % clc; clear;
% % load('Case0319.mat');
% % put on electrodes
% % [ sparseS, B_phi ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
% %                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );
% % sparseS = PutOnDwnElctrd( sparseS, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
% %                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% % [ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_c, dx, dz );
% % % Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
% % % Ztable = [ x1, int_grid_z, x2, int_grid_z ];
% % UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );

% % [ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max );
% % [ sparseA, B ] = DwnElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz );
% % load('TMP0410.mat');

% % % check empty rows
% counter = 0;
% for idx = 1: 1: N_e
%     if isempty( sparseK( idx ) )
%         counter = counter + 1;
%         [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [m, n, ell]
%     end
% end
% counter

% % load('TMP0410.mat');
% % check NaN
% % for idx = 1: 1: N_e
% %     tmp_vector = sparseGVV{ idx };
% %     lgth = length(tmp_vector);
% %     for idx2 = 1: 1: lgth
% %         if isnan( tmp_vector(idx2) )
% %             [idx, idx2]
% %         end
% %     end
% % end

% load('TMP0410.mat');
% Normalize each rows
for idx = 1: 1: N_e
    tmp_vector = sparseK{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    sparseK{ idx } = tmp_vector;
    B_k( idx ) = B_k( idx ) ./ MAX_row_value;
end

tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

tic;
Matlab_sparse = mySparse2MatlabSparse( sparseK, N_e );
toc;
bar_x_my_gmres = zeros(size(B_k));
tic;
[ L, U ] = ilu( Matlab_sparse, struct('type', 'ilutp', 'droptol', 1e-4) );
toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num, L, U );
% toc;
% save('0501K1.mat');
% save('First.mat');

% save( strcat(fname, CaseName, '.mat') );
% save('Case0423.mat');
% load('Case0321_S2.mat');
% save('TMP0418.mat');
% AFigsScript;

% ADstrbtn;
% PhiDstrbtn;

% CurrentEst;

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x = A \ B;
% toc;

% save('FirstTest.mat');
% PhiDstrbtn;
% FigsScript;

% count = 0;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     if A( idx, : ) == zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         count = count + 1;
%     end
% end
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]