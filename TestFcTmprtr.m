% fname = 'D:\Kevin\CapaReal\0715';
% load( strcat(fname, '\BasicParameters.mat') );
% load( strcat(fname, '\', 'Tmprtr2cm0715Test.mat'), 'MedTetTable', 'MedTetTableCell' );
% disp('Checking the tumor related vetrices: ');
% tic;
% bioChecker = false(N_v, 1);
% for vIdx = 1: 1: N_v
%     CandiTet = find( MedTetTable(:, vIdx));
%     for itr = 1: 1: length(CandiTet)
%         TetRow = MedTetTableCell{ CandiTet(itr) };
%         MedVal = TetRow(5);
%         if MedVal == 5 
%             bioChecker(vIdx) = true;
%             break
%         end
%     end
% end
% toc;
% save('TumorVidx.mat', 'bioChecker');
% clc; clear;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0715';
% load( strcat(fname, '\BasicParameters.mat') );
% load( strcat(fname, '\', 'Tmprtr2cm0715Test.mat'), 'bar_b' );
load( strcat(fname, '\', 'TumorVidx.mat') );

T_end = bar_b(:, end);
[ MT, Midx ] = max( T_end(find(bioChecker)))

% loadThermalParas;
% dt = 15;
% Duration1 = 5 * 60;
% trans1 = Duration1 / dt;
% Duration2 = 30 * 60;
% trans2 = trans1 + Duration2 / dt;
% Duration3 = 20 * 60;
% trans3 = trans2 + Duration3 / dt;
% timeNum_all = Duration1 + Duration2 + Duration3;
% bar_b = zeros(N_v, (Duration1 + Duration2 + Duration3) / dt + 1);

% % === === === === === === === % =================== % === === === === === === === %
% % === === === === === === === % Getting M_U and M_V % === === === === === === === %
% % === === === === === === === % =================== % === === === === === === === %

% load('m_U_m_V_prevParas.mat', 'm_U', 'm_V');

% M_U   = sparse(N_v, N_v);
% M_V   = sparse(N_v, N_v);
% tic;
% disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
% M_U = mySparse2MatlabSparse( m_U, N_v, N_v, 'Row' );
% M_V = mySparse2MatlabSparse( m_V, N_v, N_v, 'Row' );
% toc;

% % === === === === === === === % ===================== % === === === === === === === %
% % === === === === === === === % Ending of M_U and M_V % === === === === === === === %
% % === === === === === === === % ===================== % === === === === === === === %

% tic;
% for idx = 2: 1: trans1
%     bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
% end
% toc;

% % pre_bar_d = bar_d;
% % CaseName = 'Power280';
% % load( strcat(fname, '\', CaseName, '.mat'), 'bar_d' );
% % bar_b(:, trans1 + 1) = M_U\(M_V * bar_b(:, trans1) + (pre_bar_d + bar_d) / 2);
% % tic;
% % for idx = trans1 + 2: 1: trans2
% %     bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
% % end
% % toc;

% % pre_bar_d = bar_d;
% % CaseName = 'Power300';
% % load( strcat(fname, '\', CaseName, '.mat'), 'bar_d' );
% % bar_b(:, trans2 + 1) = M_U\(M_V * bar_b(:, trans2) + (pre_bar_d + bar_d) / 2);
% % tic;
% % for idx = trans2 + 2: 1: trans3 + 1
% %     bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
% % end
% % toc;

% % T_flagXZ = 1;
% % T_flagXY = 1;
% % T_flagYZ = 1;

% % T_plot;

% % return;
% % % dt = 15;
% % % timeNum_1   = 4 * 5;
% % % timeNum_2   = 4 * 30;
% % % timeNum_3   = 4 * 15;
% % % timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

% % % % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% % % fname = 'd:\Kevin\CapaReal\0710';

% % % % S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% % % % for idx = 1: 1: length(S)
% % %     % Conc = S(idx);
% % %     % Period 1
% % %     CaseName = 'Power250';
% % %     load( strcat(fname, '\', CaseName, '.mat') );

% % %     % temperature initialization
% % %     loadThermalParas;
% % %     LungRatio = 1;
% % %     TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum_all + 1 );
% % %     for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % %         [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % %         if mediumTable( m, n, ell ) == 2
% % %             TmprtrTau( m, n, ell, :) = T_bolus;
% % %         end
% % %         if mediumTable( m, n, ell ) == 1
% % %             TmprtrTau( m, n, ell, :) = T_air;
% % %         end
% % %         if mediumTable( m, n, ell ) == 0
% % %             XZ9Med = getXZ9Med(m, n, ell, mediumTable);
% % %             if checkAirAround( XZ9Med )
% % %                 % TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
% % %                 TmprtrTau( m, n, ell, :) = T_bolus;
% % %             end
% % %         end
% % %     end

% % %     T_bgn = 0;
% % %     timeNum = timeNum_1;
% % %     TmprtrDis;

% % %     % Period 2
% % %     CaseName = 'Power280';
% % %     load( strcat(fname, '\', CaseName, '.mat') );
% % %     T_bgn = timeNum_1 * dt;
% % %     timeNum = timeNum_2;
% % %     TmprtrDis;

% % %     % Period 3
% % %     CaseName = 'Power300';
% % %     load( strcat(fname, '\', CaseName, '.mat') );
% % %     T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
% % %     timeNum = timeNum_3;
% % %     TmprtrDis;

% % %     % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% % %     fname = 'd:\Kevin\CapaReal\0710';
% % %     save( strcat(fname, '\Case0322.mat') );
% % % % end


% % % == debugger ==

% % % load('Tmprtr2cm.mat', 'dt');
% % % load('Tmprtr2cm.mat', 'bar_b');
% % % load('Tmprtr2cm.mat', 'Duration1', 'Duration2', 'Duration3');
% % % load('Tmprtr2cm.mat', 'bar_d');
% % % load('Tmprtr2cm.mat', 'Q_s');
% % % loadParas;

% % % tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% % % tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% % % tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % % m_v = 2 * tumor_m - 1;
% % % n_v = 2 * tumor_n - 1;
% % % ell_v = 2 * tumor_ell - 1;

% % % squeeze( Q_s(tumor_m, tumor_n, tumor_ell, :, :) )

% % % x_idx_max = air_x / dx + 1;
% % % y_idx_max = h_torso / dy + 1;
% % % z_idx_max = air_z / dz + 1;

% % % x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% % % y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% % % z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;

% % % load('Tmprtr2cm.mat', 'm_V');

% % % idx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v