tic;
for vIdx = 1: 1: 200
    bioValid = false;
    U_row = sparse(1, N_v);
    V_row = sparse(1, N_v);
    Pnt_d = 0;
    CandiTet = find( MedTetTable(:, vIdx));
end
toc;
% % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');

% % % load('0704.mat');

% % % PhiDstrbtn

% % load('TestCaseTmprtr.mat');
% % T_plot;