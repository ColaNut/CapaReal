bar_x_my_gmres = zeros(size(B_k));
nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
bar_x_my_gmres = nrmlM_K\B_k;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
% toc;

% save('Case0524_noPre_NBC.mat', 'bar_x_my_gmres', 'B_k');

AFigsScript;

tic;
disp('Calculation time of iLU: ')
[ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-3) );
toc;
% I = 90 / 7;
% R = 2 * 10^(-2);

% Const = ( I / 2 ) * R^2;
% z = [-3: 1: 3] / 100;
% Const * sum(1 ./ (R^2 + z.^2).^1.5 )

% % % === % =================== % === %
% % % === % GMRES test function % === %
% % % === % =================== % === %

% tol = 1e-6;
% ext_itr_num = 10;
% int_itr_num = 50;

% bar_x_my_gmres = zeros(size(B_k));
% bar_x_my_gmres = nrmlM_K\B_k;

% Shift2d;
% load('0525Inv.mat', 'bar_x_my_gmres');
% bar_x_my_gmres = zeros(size(B_k));
% % % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-3) );
% % toc;

% tic;
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
% toc;
% save('0525_K.mat', 'nrmlM_K', 'B_k');
% bar_x_my_gmres = nrmlM_K\B_k;
% tol = 1e-6;
% ext_itr_num = 50;
% int_itr_num = 2;

% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres_rightPreconditioned( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;

% tol = 1e-6;
% ext_itr_num = 10;
% int_itr_num = 50;

% tic;
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num, [], [], bar_x_my_gmres );
% toc;

% % save('Case0522_1e3NBC_K1.mat', 'bar_x_my_gmres');

% AFigsScript;