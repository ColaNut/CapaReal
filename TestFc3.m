top_x0  = - 1 / 100;
top_dx  = 1 / 100;
top_dy  = 4 / 100;
down_x0  = - 1 / 100;
down_dx = 1 / 100;
down_dy = 4 / 100;
AFigsScript
% % % Shift2d;
% % % load('0614Regular.mat');
% % % TEX = 'Regular';
% % AFigsScript;
% % % M_three = M_KEV * M_sparseGVV_inv_spai * M_KVE;
% load('0615_Prev.mat', 'M_K1', 'M_KEV', 'M_sparseGVV_inv_spai', 'M_KVE', 'B_k', 'bar_x_my_gmres');
% M_K1_Prev = M_K1;
% M_KEV_Prev = M_KEV;
% M_sparseGVV_inv_spai_Prev = M_sparseGVV_inv_spai;
% M_KVE_Prev = M_KVE;
% B_k_Prev = B_k;
% bar_x_my_gmres_Prev = bar_x_my_gmres;

% load('0615_Right.mat', 'M_K1', 'M_KEV', 'M_sparseGVV_inv_spai', 'M_KVE', 'B_k', 'bar_x_my_gmres');
% M_K1_Diff = M_K1 - M_K1_Prev;
% M_KEV_Diff = M_KEV - M_KEV_Prev;
% M_sparseGVV_inv_spai_Diff = M_sparseGVV_inv_spai - M_sparseGVV_inv_spai_Prev;
% M_KVE_Diff = M_KVE - M_KVE_Prev;
% B_k_Diff = B_k - B_k_Prev;
% bar_x_my_gmres_Diff = bar_x_my_gmres - bar_x_my_gmres_Prev;

% Ans = cell(6, 1);
% Ans{1} = find(M_K1_Diff);
% Ans{2} = find(M_KEV_Diff);
% Ans{3} = find(M_sparseGVV_inv_spai_Diff);
% Ans{4} = find(M_KVE_Diff);
% Ans{5} = find(B_k_Diff);
% Ans{6} = find(bar_x_my_gmres_Diff);