% clc; clear; 
% fname = 'd:\Kevin\CapaReal\0715';
% CaseName = 'Power250';
% V_0 = 74.18;
% PowerScript;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst_2;
% save( strcat(fname, '\', CaseName, 'currentEst.mat'), 'Current', 'W' );

% clc; clear;
% fname = 'd:\Kevin\CapaReal\0715';
% CaseName = 'Power280';
% V_0 = 78.50;
% PowerScript;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst_2;
% save( strcat(fname, '\', CaseName, 'currentEst.mat'), 'Current', 'W' );

% clc; clear;
% fname = 'd:\Kevin\CapaReal\0715';
% CaseName = 'Power300';
% V_0 = 81.25;
% PowerScript;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst_2;
% save( strcat(fname, '\', CaseName, 'currentEst.mat'), 'Current', 'W' );

clc; clear;
tmprtrName = '20180711_Case4';
fname = 'e:\Kevin';
% fname = 'd:\Kevin\CapaReal\';
% CaseName = 'Power250';
load( strcat(fname, '\20180711_case4.mat') );
% load( strcat(fname, '\', CaseName, '.mat') );
loadThermalParas;
dt = 15;
Duration1 = 5 * 60;
trans1 = Duration1 / dt;
Duration2 = 30 * 60;
trans2 = trans1 + Duration2 / dt;
Duration3 = 15 * 60;
trans3 = trans2 + Duration3 / dt;
timeNum_all = Duration1 + Duration2 + Duration3;
bar_b = zeros(N_v, (Duration1 + Duration2 + Duration3) / dt + 1);

% === === === === === === === % =================== % === === === === === === === %
% === === === === === === === % Getting M_U and M_V % === === === === === === === %
% === === === === === === === % =================== % === === === === === === === %

% m_U   = cell(N_v, 1);
% m_V   = cell(N_v, 1);
% disp('The filling time of m_U and m_V: ');
% tic;
% parfor vIdx = 1: 1: N_v
%     bioValid = false;
%     U_row = zeros(1, N_v);
%     V_row = zeros(1, N_v);
%     Pnt_d = 0;
%     CandiTet = find( MedTetTable(:, vIdx));
%     for itr = 1: 1: length(CandiTet)
%         % v is un-ordered vertices; while p is ordered vertices.
%         % fix the problem in the determination of v1234 here .
%         TetRow = MedTetTableCell{ CandiTet(itr) };
%         v1234 = TetRow(1: 4);
%         if length(v1234) ~= 4
%             error('check');
%         end
%         MedVal = TetRow(5);
%         % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
%         % this judgement below is based on the current test case
%         if MedVal >= 3 && MedVal <= 9
%             bioValid = true;
%             if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
%                 error('check');
%             end
%             % check the validity of Q_s_Vector input.
%             p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
%             [ U_row, V_row ] = fillUVd( p1234, Bls_bndry, U_row, V_row, Pnt_d, ...
%                         dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
%                         x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
%         end
%     end

%     if bioValid
%         m_U{vIdx} = Mrow2myRow(U_row);
%         m_V{vIdx} = Mrow2myRow(V_row);
%     else
%         m_U{vIdx} = [vIdx, 1];
%         m_V{vIdx} = [vIdx, 1];
%     end
% end
% toc;

% save( strcat(fname, '\m_U_m_V_', tmprtrName, '.mat'), 'm_U', 'm_V' );

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

Q_s_Vector = Q_s_Vector * 250 / abs(W);
FILL_BAR_D;

tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;
gmres_flag = zeros(1, (Duration1 + Duration2 + Duration3) / dt + 1);
relres = zeros(1, (Duration1 + Duration2 + Duration3) / dt + 1);

tic;
for idx = 2: 1: trans1
    [ bar_b(:, idx), gmres_flag(idx), relres(idx) ] = gmres( M_U, (M_V * bar_b(:, idx - 1) + bar_d), int_itr_num, tol, ext_itr_num );
end
toc;

pre_bar_d = bar_d;
fname = 'e:\Kevin';
load( strcat(fname, '\20180711_case4.mat'), 'Q_s_Vector', 'W' );
Q_s_Vector = Q_s_Vector * 280 / abs(W);
FILL_BAR_D;
% CaseName = 'Power280';
% load( strcat(fname, '\', CaseName, '.mat'), 'bar_d' );
[ bar_b(:, trans1 + 1), gmres_flag(trans1 + 1), relres(trans1 + 1) ] ...
    = gmres( M_U, (M_V * bar_b(:, trans1) + (pre_bar_d + bar_d) / 2), int_itr_num, tol, ext_itr_num );
tic;
for idx = trans1 + 2: 1: trans2
    [ bar_b(:, idx), gmres_flag(idx), relres(idx) ] = gmres( M_U, (M_V * bar_b(:, idx - 1) + bar_d), int_itr_num, tol, ext_itr_num );
end
toc;

pre_bar_d = bar_d;
load( strcat(fname, '\20180711_case4.mat'), 'Q_s_Vector', 'W' );
Q_s_Vector = Q_s_Vector * 300 / abs(W);
FILL_BAR_D;
% CaseName = 'Power300';
% load( strcat(fname, '\', CaseName, '.mat'), 'bar_d' );
[ bar_b(:, trans2 + 1), gmres_flag(trans2 + 1), relres(trans2 + 1) ] ...
    = gmres( M_U, (M_V * bar_b(:, trans2) + (pre_bar_d + bar_d) / 2), int_itr_num, tol, ext_itr_num );
tic;
for idx = trans2 + 2: 1: trans3 + 1
    [ bar_b(:, idx), gmres_flag(idx), relres(idx) ] = gmres( M_U, (M_V * bar_b(:, idx - 1) + bar_d), int_itr_num, tol, ext_itr_num );
end
toc;

% save( strcat(fname, '\Tmprtr2cm', tmprtrName, '.mat') );
fname = 'e:\Kevin\CapaReal\20180711_case4';
save( strcat(fname, '\20180711_case4_TmprtrTimePlot.mat') );

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot;

% return;
% dt = 15;
% timeNum_1   = 4 * 5;
% timeNum_2   = 4 * 30;
% timeNum_3   = 4 * 15;
% timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% fname = 'd:\Kevin\CapaReal\0715';

% % S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% % for idx = 1: 1: length(S)
%     % Conc = S(idx);
%     % Period 1
%     CaseName = 'Power250';
%     load( strcat(fname, '\', CaseName, '.mat') );

%     % temperature initialization
%     loadThermalParas;
%     LungRatio = 1;
%     TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum_all + 1 );
%     for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%         [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%         if mediumTable( m, n, ell ) == 2
%             TmprtrTau( m, n, ell, :) = T_bolus;
%         end
%         if mediumTable( m, n, ell ) == 1
%             TmprtrTau( m, n, ell, :) = T_air;
%         end
%         if mediumTable( m, n, ell ) == 0
%             XZ9Med = getXZ9Med(m, n, ell, mediumTable);
%             if checkAirAround( XZ9Med )
%                 % TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
%                 TmprtrTau( m, n, ell, :) = T_bolus;
%             end
%         end
%     end

%     T_bgn = 0;
%     timeNum = timeNum_1;
%     TmprtrDis;

%     % Period 2
%     CaseName = 'Power280';
%     load( strcat(fname, '\', CaseName, '.mat') );
%     T_bgn = timeNum_1 * dt;
%     timeNum = timeNum_2;
%     TmprtrDis;

%     % Period 3
%     CaseName = 'Power300';
%     load( strcat(fname, '\', CaseName, '.mat') );
%     T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
%     timeNum = timeNum_3;
%     TmprtrDis;

%     % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
%     fname = 'd:\Kevin\CapaReal\0715';
%     save( strcat(fname, '\Case0322.mat') );
% % end
