% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0115Bolus1cm';
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');

% function BxB = TestFc
%     BxB = zeros(1, 3);
% end
% plotMap( paras2dXZ, dx, dz );
% plotRibXZ(Ribs, SSBone, dx, dz);
% plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
% axis equal;
% [Tet32Value(5, 3), Tet32Value(6, 4);
% Tet32Value(6, 3), Tet32Value(7, 4);
% Tet32Value(7, 3), Tet32Value(8, 4);
% Tet32Value(4, 3), Tet32Value(5, 4);
% Tet32Value(8, 3), Tet32Value(1, 4);
% Tet32Value(3, 3), Tet32Value(4, 4);
% Tet32Value(2, 3), Tet32Value(3, 4);
% Tet32Value(1, 3), Tet32Value(2, 4)]

% load('bar_x_my_gmresA.mat');
% load('GVV_test.mat');
% AFigsScript;

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% plot H distribution in the XZ plane
saveas(figure(12), fullfile(fname, 'H_YZ'), 'fig');
saveas(figure(12), fullfile(fname, 'H_YZ'), 'jpg');

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% counter = 0;
% mnell_table = zeros(1, 3);
% collectBPhi = 0;
% for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     if B_phi( idx ) ~= 0
%         collectBPhi = vertcat(collectBPhi, B_phi(idx));
%         counter = counter + 1;
%         [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
%         mnell_table = vertcat(mnell_table, [m, n, ell]);
%     end
% end
% clc; clear;
% load('First.mat');
% load('Case0504.mat', 'sparseK1', 'MidMat3', 'N_e');
% sparseK = cell( N_e, 1 );
% tic;
% NrmlRow_K1 = zeros(1, N_e);
% NrmlRow_MidMat3 = zeros(1, N_e);
% for e_idx = 1: 1: N_e
%     NrmlRow_K1 = sparse2NrmlVec( sparseK1{ e_idx }', N_e )';
%     NrmlRow_MidMat3 = sparse2NrmlVec( MidMat3{ e_idx }', N_e )';
%     sparseK{ e_idx } = Nrml2Sparse( NrmlRow_K1 - NrmlRow_MidMat3 );
% end
% toc;

% tic;
% M_KEV = mySparse2MatlabSparse( sparseKEV(1: 100), 100, N_v, 'Row' );
% M_KVE = mySparse2MatlabSparse( sparseKVE(1: 100), N_v, 100, 'Col' );
% toc;
% disp('Calculation time of matrix product in 100^2 unit');
% tic;
% Test_product = M_KEV * G_VV_inv * M_KVE;
% toc;

% % check NaN
% disp('KEV nan and infty check');
% for idx = 1: 1: N_e
%     tmp_vector = sparseKEV{ idx };
%     lgth = length(tmp_vector);
%     for idx2 = 1: 1: lgth
%         if isnan( tmp_vector(idx2) )
%             [idx, idx2]
%         elseif isinf( tmp_vector(idx2) )
%             [idx, idx2]
%         end
%     end
% end
% load('Case0504_LU_1e2.mat', 'B_k', 'sparseK1', 'sparseKEV', 'sparseKVE');
% lgthArr = zeros(1, N_v);
% for idx = 1: 1: N_v 
%     lgthArr(idx) = length(sparseGVV{ idx });
% end
% cond2 = cond(full(M_sparseGVV * M_GVV_inv), 2);
% f_norm = norm(M_sparseGVV * M_GVV_inv - sparseId, 'fro');
% disp( strcat( 'For genuine inverse of GVV, the 2-condition number is ', num2str(cond2) ) );
% disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );


% % === % ==================== % === %
% % === % An abandomed process % === %
% % === % ==================== % === %

% disp('Time converting from M to m sparse');
% tic;
% m_three = cell( N_e, 1 );
% m_three = Msparse2msparse(M_three);
% toc;


% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% load('GVV_test.mat');

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %
% clc; clear;
% load('GVV_test.mat');
% load('TMP_m_three.mat', 'TMP_m_three', 'sparseK1', 'sparseKEV', 'sparseGVV', 'sparseGVV_inv', 'sparseKVE' );
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);
% TMP_M_three = cell(99, 1);

% for idx = 1: 1: 99
%     TMP_M_three{ idx } = mySparse2MatlabSparse( TMP_m_three( idx ), 1, N_e, 'Row' );
% end

% MidMat2 = getProduct2( sparseKEV( 42 ), sparseGVV_inv );
% TMP_MidMat2 = cell(1, 1);
% TMP_MidMat2{ 1 } = mySparse2MatlabSparse( MidMat2( 1 ), 1, N_v, 'Row' );

% MidMat3 = getProduct2( MidMat2( 1 ), sparseKVE );
% TMP_MidMat3 = cell(1, 1);
% TMP_MidMat3{ 1 } = mySparse2MatlabSparse( MidMat3( 1 ), 1, N_e, 'Row' );

% TMP_KEV = cell(7, 1);
% for idx = 1: 1: 7
%     TMP_KEV{ idx } = mySparse2MatlabSparse( sparseKEV( 5159 + idx ), 1, N_v, 'Row' );
% end

% TMP_GVVinv = cell(1, N_v);
% for idx = 1: 1: N_v
%     TMP_GVVinv{ idx } = mySparse2MatlabSparse( sparseGVV_inv( idx ), N_v, 1, 'Col' );
% end

% TMP_KVE = cell(1, N_v);
% for idx = 1: 1: N_v
%     TMP_KVE{ idx } = mySparse2MatlabSparse( sparseKVE( idx ), N_v, 1, 'Col' );
% end

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %
% % Normalize each rows
% disp('Normalization');
% tic;
% for idx = 1: 1: 100
%     % non-zero index: nz_idx
%     nz_idx = find(M_K(idx, :));
%     MAX_row_value = full( max( abs(M_K(idx, nz_idx)) ) );
%     M_K(idx, nz_idx) = M_K(idx, nz_idx) / MAX_row_value;
%     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% end
% toc;

% % % === % ========================= % === %
% % % === % Old Normalization Process % === %
% % % === % ========================= % === %

% % for idx = 1: 1: N_e
% %     tmp_vector = sparseK{ idx };
% %     num = uint64(size(tmp_vector, 2)) / 2;
% %     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
% %     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
% %     sparseK{ idx } = tmp_vector;
% %     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% % end

% % % === % =========================== % === %
% % % === % LU preconditioner and GMRES % === %
% % % === % =========================== % === %

% load('Normalized.mat', 'M_K', 'B_k');
% tol = 1e-6;
% ext_itr_num = 50;
% int_itr_num = 50;

% bar_x_my_gmres = zeros(size(B_k));
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( M_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( M_K, B_k, int_itr_num, tol, ext_itr_num );
% toc;

% save('Case0507_1e2.mat');

% AFigsScript;
% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %
% === % =========================================== % === %
% === % Initialization of coordinate and grid shift % === %
% === % =========================================== % === %
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
% mu_db_prime   = [ 0,    0 ]';
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

% shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, [ w_y, w_x, w_z ], dx, dy, dz );

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
% disp('Calculation of vertex coordinate');
% Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% toc;

% % === % =================== % === %
% % === % Filling of Matrices % === %
% % === % =================== % === %

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

% B_k       = zeros(N_e, 1);
% sparseK1  = cell( N_e, 1 );
% sparseKEV = cell( N_e, 1 );
% sparseKVE = cell( 1, N_e );
% tic;
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% for vIdx = x_max_vertex * y_max_vertex: 1: 2 * x_max_vertex * y_max_vertex
% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     if m_v == 21
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
%     end
% end
% toc;
% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% disp( strcat( 'For genuine inverse of GVV, the 2-condition number is ', num2str(cond2) ) );
% disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );
% save( 'RealGVV_inv.mat', 'cond2', 'f_norm' );
% load('tmpp.mat');
% figure(2);
% clf;
% [X, Y] = meshgrid(1: 1: size(A, 1)); 
% pcolor(X, Y, abs( flipud(A) ));
% colorbar;
% shading flat;
% saveas(figure(2), 'A.jpg');

% load('M_G_VV_inv0505.mat');
% Tol = 0.4;
% sparseG_VV_inv = cell(1, N_v);
% disp('The calculation time of SAI: ');
% tic;
% sparseG_VV_inv = getSAI_sparse(sparseGVV, N_v, Tol);
% toc;
% % G_VV = zeros(N_v);
% % G_VV = recoverMatrix( sparseGVV, N_v );

% % M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
% % disp('Time for the calculation of inverse of G_VV');
% % tic;
% % M_G_VV_inv = inv(M_sparseGVV);
% % toc;

% figure(13);
% M_G_VV_inv(find(M_G_VV_inv <= 1)) = 0;
% max(M_G_VV_inv)
% spy(M_G_VV_inv);
% M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseG_VV_inv, N_v, N_v, 'Col' );
% figure(13);
% TMP_Mat(find(TMP_Mat <= 1)) = 0;
% spy(M_sparseGVV_inv_spai);

% eIdx = vIdx2eIdx(11111, 3, x_max_vertex, y_max_vertex, z_max_vertex);
% disp('KVE nan and infty check');
% for idx = 1: 1: N_e
%     tmp_vector = m_three{ idx };
%     lgth = length(tmp_vector);
%     for idx2 = 1: 1: lgth
%         if isnan( tmp_vector(idx2) )
%             [idx, idx2]
%         elseif isinf( tmp_vector(idx2) )
%             [idx, idx2]
%         end
%     end
% end

% tic;
% MidMat2 = cell(N_e, 1);
% MidMat2 = getProduct2( sparseKEV, sparseG_VV_inv, N_v );
% toc;
% % get MidMat3
% tic;
% MidMat3 = cell(N_e, 1);
% MidMat3 = getProduct2( MidMat2, sparseKVE, N_v );
% toc;



% AFigsScript;
% load('0502Debug.mat');
% Matlab_sparse_test = mySparse2MatlabSparse( sparseK, N_e );

% tic;
% disp('Calculation time of testing gmres.')
% bar_x_my_gmres_test = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num );
% toc;
% AFigsScript
% load('0502Debug.mat');
% Matlab_sparse = mySparse2MatlabSparse( sparseK, N_e );
% A = gallery('neumann', 1600) + speye(1600);
% setup.type = 'croutt';
% setup.milu = 'row';
% setup.droptol = 0.1;
% [L,U] = ilu(A,setup);
% e = ones(size(A,2),1);
% norm(A*e-L*U*e)

% load('TMP0418.mat');
% ArndIdx  = zeros(26, 1);
% ArndIdx  = get26EdgeIdx(4, 9, 8, x_max_vertex, y_max_vertex, z_max_vertex);
% leftPnt  = B_k(ArndIdx);
% ArndIdx  = get26EdgeIdx(8, 9, 4, x_max_vertex, y_max_vertex, z_max_vertex);
% rightPnt = B_k(ArndIdx);

% load('Case0421.mat');
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK1, B_k, int_itr_num, tol, ext_itr_num );
% toc;

% clc;
% clear;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% CaseName = 'Case0322';
% load( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst;
% % counter
% CaseName = 'TMP';
%     % fname = 'e:\Kevin\CapaReal\Case0301_8MHzSaline';
%     CaseDate = 'Case0319';
%     % PhiDstrbtn;
%     saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
%     saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
%     saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
%     saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
%     saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
%     saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
%     saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
%     saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
%     saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
%     saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
%     saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
%     saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');

% [ sparseS_1, B_phi ] = PutOnTopElctrd( sparseS_1, B_phi, V_0, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
%                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% [X,Y,Z,V] = flow(10);
% figure
% slice(X,Y,Z,V,[6 9],2,0);
% shading flat

% [Xq,Yq,Zq] = meshgrid(1:1:2,1:1:3,1:1:4);
% Vq = interp3(X,Y,Z,V,Xq,Yq,Zq);
% figure
% slice(Xq,Yq,Zq,Vq,[6 9],2,0);
% shading flat
% x_idx_max = 51;
% y_idx_max = 37;
% z_idx_max = 41;
% x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
% N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     - ( (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1) );
% [X,Y,Z,V] = flow(10);
% A_R = '101'
% A_R(1) = '0';
% A_R(2) = '1';
% A_R(3) = '0';

% A_R

% f = 8 * 10^6;
% T = 5;
% S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% EPSILON_R = zeros(size(S));
% SIGMA = zeros(size(S));
% for idx = 1: 1: length(S)
%     [ EPSILON_R(idx), SIGMA(idx) ] = getEpsSig(f, S(idx), T);
% end
% [ EPSILON_R, SIGMA ]
% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power250currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power280currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power300currentEst.mat');
% W

% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0205Bone';

% % % Period 1
% % CaseName = 'Power300';
% % load( strcat(fname, '\', CaseName, '.mat') );

% clc; clear; 
% % % % % V_0 = 76.78;
% Shift2d
% % loadParas;
% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % y = tumor_y + dy;
% y = 0;
% counter = 0;
% % for y = tumor_y - 2 * dy: dy: tumor_y - 2 * dy
%     y_idx = y / dy + h_torso / (2 * dy) + 1;
%     counter = counter + 9;
%     paras2dXZ = genParas2d( y, paras, dx, dy, dz );
%     figure(counter);
%     clf;
%     plotMap( paras2dXZ, dx, dz );
%     axis equal;
%     plotGridLineXZ( shiftedCoordinateXYZ, y_idx );
%     set(gcf, 'Position', get(0,'Screensize'));
% % end

% % % figure(3);
% plotRibXZ(Ribs, SSBone, dx, dz);

% % % y = tumor_y + dy;
% %     y = tumor_y;
% %     y_idx = y / dy + h_torso / (2 * dy) + 1;
% %     paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% %     figure(2);
% %     clf;
% %     plotMap( paras2dXZ, dx, dz );
% %     axis equal;
% %     plotGridLineXZ( shiftedCoordinateXYZ, y_idx );
% %     set(gcf, 'Position', get(0,'Screensize'));
% %     plotRibXZ(Ribs, SSBone, dx, dz);
% % % end

% % RibValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% % SSBoneValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% % for y = - h_torso / 2: dy: h_torso / 2
% %     y_idx = int64(y / dy + h_torso / (2 * dy) + 1);
% %     if y_idx == 8
% %         ;
% %     end
% %     [ RibValid(y_idx), SSBoneValid(y_idx) ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
% % end

% % counter = 10;
% % for x = tumor_x - 2 * dx: dx: tumor_x + 2 * dx
% %     counter = counter + 1;
% %     x_idx = x / dx + air_x / (2 * dx) + 1;
% %     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
% %     figure(counter);
% %     clf;
% %     plotYZ( paras2dYZ, dy, dz );
% %     axis equal;
% %     plotGridLineYZ( shiftedCoordinateXYZ, x_idx);
% % end


% % clc; clear;
% % CaseName = 'Power300';
% % load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\', CaseName, '.mat') );

% % flag_XZ = 1;
% % flag_XY = 0;
% % flag_YZ = 0;
% % PhiDstrbtn;

% % lala = squeeze(SegMed(16, tumor_n + 2, 29, :, :));
% % Need to Rederive the octantCube.m

% % AxA = 3;
% % if AxA == 3;
% %     disp('lala');
% % elseif AxA == 4;
% %     disp('lala4');
% % end

% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power300TmprtrXZ.fig');
% caxis auto;
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0221_3cmBolusNoFatBolusSigmaCase1\Power300TmprtrXZ.fig');
% caxis auto;
