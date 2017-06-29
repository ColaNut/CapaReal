load('0624tmp.mat', 'bar_x_my_gmresPhi');
% start from here: run for sigmaE

% designing a small case ?
% implement getSigmaE
% those beyond computation domain can be anything
% check if tetRow is valid in the filling of Bk ?
% the following code may be incorporated into getPntMedTetTable
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    Phi27 = zeros(3, 9);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
    [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    Phi27 = bar_x_my_gmresPhi(PntsIdx);

    SigmaE(m, n, ell, :, :, :) = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), sigma );
end
toc;

% === % ==================================== % === %
% === % Trimming: Invalid set to 30 (byndCD) % === %
% === % ==================================== % === % 

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
end

% === % ========================================================== % === %
% === % Conducting Current Assignment and MedTetTable Construction % === %
% === % ========================================================== % === % 

tic;
disp('Assigning each tetrahdron with a conducting current');
J_xyz = zeros(0, 3);
MedTetTable = sparse(0, N_v);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntJ_xyz       = sparse(48, 3);
    PntMedTetTable = sparse(48, N_v);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
    PntJ_xyz(:, 1) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
    PntJ_xyz(:, 2) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
    PntJ_xyz(:, 3) = tmp(:);
    PntMedTetTable = getPntMedTetTable( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );

    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz

    J_xyz       = vertcat(J_xyz, PntJ_xyz(validTet, :));
    MedTetTable = vertcat(MedTetTable, PntMedTetTable(validTet, :));
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(MedTetTable, 1) ~= validNum
    error('check the construction');
end

% % === % ========== % === %
% % === % GVV matrix % === %
% % === % ========== % === %

% % modify according to Regular Tetrahedra version.
% sparseGVV = cell(1, N_v);
% disp('The filling time of G_VV: ');
% tic;
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     GVV_SideFlag = false(1, 6);
%     GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%     if isempty( find( GVV_SideFlag ) )
%         sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
%                                             z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
%     else
%         sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
%     end
% end
% toc;

% % === % =================== % === %
% % === % Calculation of SPAI % === %
% % === % =================== % === %

% TEX = 'Right';
% CaseTEX = 'TestSimple';
% Tol = 0.2;
% GVV_test; % a script
% % load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

% % === % ========================= % === %
% % === % Matrices product to get K % === %
% % === % ========================= % === %

% M_K = sparse(N_e, N_e);
% M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% % === % ============================ % === %
% % === % Sparse Normalization Process % === %
% % === % ============================ % === %

% tic;
% disp('Time for normalization');
% sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
% nrmlM_K = sptmp * M_K;
% nrmlB_k = sptmp * B_k;
% toc;

% % === % ============================================================ % === %
% % === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% % === % ============================================================ % === %

% tol = 1e-6;
% ext_itr_num = 10;
% int_itr_num = 50;

bar_x_my_gmres = zeros(size(nrmlB_k));
tic; 
disp('Computational time for solving Ax = b: ')
bar_x_my_gmres = nrmlM_K\nrmlB_k;
toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
% toc;

% % % save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

w_y = h_torso;
w_x = air_x;
w_z = air_z;
AFigsScript;

% % % tic;
% % % disp('Calculation time of iLU: ')
% % % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % % toc;

% % copy Shift2d_Right to another m file. and use Shift2d_Right in below.
% % main work lies in: modify the fillK's fillBk part.
% % build up a test for thick current ?

% % PhiDstrbtn;

% % CurrentEst;

% % disp('The calculation time for inverse matrix: ');
% % tic;
% % bar_x = A \ B;
% % toc;

% % PhiDstrbtn;
% % FigsScript;