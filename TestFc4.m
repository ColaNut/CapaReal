tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(B_k));
% nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\B_k;
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
toc;

% save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

AFigsScript;