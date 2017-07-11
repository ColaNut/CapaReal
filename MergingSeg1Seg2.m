% % in the post part
% m_K1_post = cell(N_e, 1);
% B_k_post  = zeros(N_e, 1);

% m_K1_post = m_K1; 
% B_k_post = B_k; 

% save('m_k_B_k_Post.m', 'm_K1_post', 'B_k_post');

% % in the pre-part:

load('m_k_B_k_Post.mat', 'm_K1_post', 'B_k_post');

m_K1(l_G / 2 + 1: l_G) = m_K1_post(l_G / 2 + 1: l_G);
B_k(l_G / 2 + 1: l_G) = B_k_post(l_G / 2 + 1: l_G);

save('total_mK1_B_k.mat', 'm_K1', 'B_k');

M_K1 = sparse(N_e, N_e);
tic;
disp('Transfroming M_K1')
M_K1 = mySparse2MatlabSparse( m_K1, N_e, N_e, 'Row' );
toc;

save('M_K1.mat', 'M_K1');

M_K = sparse(N_e, N_e);
M_K = M_K1;

clearvars M_K1
% M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% === % ============================ % === %
% === % Sparse Normalization Process % === %
% === % ============================ % === %

tic;
disp('Time for normalization');
sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
nrmlM_K = sptmp * M_K;
nrmlB_k = sptmp * B_k;
toc;

% === % ============================================================ % === %
% === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% === % ============================================================ % === %

tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

bar_x_my_gmres = zeros(size(nrmlB_k));
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\nrmlB_k;
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
toc;

w_y = h_torso;
w_x = air_x;
w_z = air_z;
AFigsScript;
