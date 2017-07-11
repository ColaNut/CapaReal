[ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_c, dx, dz );
% Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
% Ztable = [ x1, int_grid_z, x2, int_grid_z ];
UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );
[ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max );
CurrentEst
% % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');

% % % % load('0704.mat');

% % % % PhiDstrbtn

% % % load('TestCaseTmprtr.mat');
% % % T_plot;