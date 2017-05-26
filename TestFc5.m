% % === % =================== % === %
% % === % GMRES test function % === %
% % === % =================== % === %

% A test for RCM
tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

% % bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );

p = symrcm(nrmlM_K);
nrmlM_K_RCM = nrmlM_K(p, p);

% tic;
% disp('Calculation time of iLU: ')
% [ L_K_RCM, U_K_RCM ] = ilu( nrmlM_K_RCM, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres_RCM = my_gmres_rightPreconditioned( nrmlM_K_RCM, B_k(p), int_itr_num, tol, ext_itr_num, L_K_RCM, U_K_RCM );
toc;

bar_x_my_gmres(p) = bar_x_my_gmres_RCM;

% save('0523K1_conditioned_bar_x_my_gmres.mat', 'bar_x_my_gmres');

% save('Case0522_1e3NBC_K1.mat', 'bar_x_my_gmres');

AFigsScript;