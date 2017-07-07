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
Q_s_Vector  = zeros(0, 1);
MedTetTable = sparse(0, N_v);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntJ_xyz       = sparse(48, 3);
    PntMedTetTable = sparse(48, N_v);
    PntQ_s         = sparse(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
    PntJ_xyz(:, 1) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
    PntJ_xyz(:, 2) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
    PntJ_xyz(:, 3) = tmp(:);
    % to-do
    tmp = squeeze(Q_s(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    PntMedTetTable = getPntMedTetTable( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );

    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
    % start from here: the temperature is getting lower, and the Q_s and J_xyz is in the order 0.35 and 0.002, respectively.
    J_xyz       = vertcat(J_xyz, PntJ_xyz(validTet, :));
    MedTetTable = vertcat(MedTetTable, PntMedTetTable(validTet, :));
    Q_s_Vector  = vertcat(Q_s_Vector, PntQ_s(validTet));
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(MedTetTable, 1) ~= validNum
    error('check the construction');
end

% === === === === === === === === % ================ % === === === === === === === === %
% === === === === === === === === % Temperature part % === === === === === === === === %
% === === === === === === === === % ================ % === === === === === === === === %

dt = 20; % 20 seconds
timeNum_all = 60; % 1 minutes
% timeNum_all = 50 * 60; % 50 minutes
loadThermalParas;

M_U   = sparse(N_v, N_v);
M_V   = sparse(N_v, N_v);
bar_d = zeros(N_v, 1);
disp('The filling time of M_U, M_V and d_m: ');
tic;
for vIdx = 1: 1: N_v
    bioValid = false;
    U_row = sparse(1, N_v);
    V_row = sparse(1, N_v);
    Pnt_d = 0;
    CandiTet = find( MedTetTable(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        % v is un-ordered vertices; while p is ordered vertices.
        % fix the problem in the determination of v1234 here .
        v1234 = find( MedTetTable( CandiTet(itr), : ) );
        if length(v1234) ~= 4
            error('check');
        end
        MedVal = MedTetTable( CandiTet(itr), v1234(1) );
        % this judgement below is based on the current test case
        if MedVal >= 3 && MedVal <= 9
            bioValid = true;
            if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                error('check');
            end
            % check the validity of Q_s_Vector input.
            p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
            [ U_row, V_row, Pnt_d ] = fillUVd( p1234, Bls_bndry, U_row, V_row, Pnt_d, ...
                        dt, Q_s_Vector(CandiTet(itr)), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                        x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
        end
    end

    if bioValid
        M_U(vIdx, :) = U_row;
        M_V(vIdx, :) = V_row;
        bar_d(vIdx) = Pnt_d;
    else
        U_row(vIdx) = 1;
        V_row(vIdx) = 1;
        M_U(vIdx, :) = U_row;
        M_V(vIdx, :) = V_row;
    end
end
toc;

return;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %

tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
TetNum = size(MedTetTable, 1);
% get rid of redundancy

% % updating the bolus
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 2
%         Ini_bar_b(v1234) = T_bolus;
%     end
% end
% % updating the muscle
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 3
%         Ini_bar_b(v1234) = T_0;
%     end
% end

bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %

% implement the updating function 
tic;
for idx = 2: 1: size(bar_b, 2)
    bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot;

% === === === === === === === === % ========== % === === === === === === === === %
% === === === === === === === === % K part (2) % === === === === === === === === %
% === === === === === === === === % ========== % === === === === === === === === %

% === % ==================== % === %
% === % Parameters used in K % === %
% === % ==================== % === %

              % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
mu_prime      = [   1,     1,      1,     1,     1,     1,     1 ]';
mu_db_prime   = [   0,     0,      0,     0,     0,     0,     0 ]';
% mu_db_prime   = [ 0,    0.62 ]';
mu_r          = mu_prime - i * mu_db_prime;

% === % =============================== % === %
% === % Constructing The Directed Graph % === %
% === % =============================== % === %

starts = [];
ends = [];
vals = [];
borderFlag = false(1, 6);
disp('Constructing the directed graph');
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    if strcmp(flag, '000') && ~mod(ell_v, 2)
        [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
    end
end
G = sparse(starts, ends, vals, N_v, N_v);
toc;
[ P1, P2 ] = find(G);
l_G = length(find(G));

% undirected graph
uG = G + G';

% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %

B_k = zeros(N_e, 1);
M_K1 = sparse(N_e, N_e);
M_K2 = sparse(N_e, N_e);
M_KEV = sparse(N_e, N_v);
M_KVE = sparse(N_v, N_e);
edgeChecker = false(l_G, 1);
cFlagChecker = false(l_G, 1);
BioFlag = true(N_v, 1);

tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
for lGidx = 1: 1: l_G
    eIdx = full( G(P1(lGidx), P2(lGidx)) );
    Candi = [];
    % get candidate points
    P1_cand = uG(P1(lGidx), :);
    P2_cand = uG(P2(lGidx), :);
    P1_nz = find(P1_cand);
    P2_nz = find(P2_cand);
    for CandiFinder = 1: 1: length(P1_nz)
        if find(P2_nz == P1_nz(CandiFinder))
            Candi = horzcat(Candi, P1_nz(CandiFinder));
        end
    end
    % get adjacent tetrahdron
    K1_6 = sparse(1, N_e); 
    K2_6 = sparse(1, N_e); 
    Kev_4 = sparse(1, N_v);
    Kve_4 = sparse(N_v, 1);
    B_k_Pnt = 0;
    cFlag = false;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                MedVal = MedTetTable( tetRow, v1234(1) );
                % use tetRow to check the accordance of SigmaE and J_xyz
                [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
                    G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
                    Vrtx_bndry( P1(lGidx) ), Vrtx_bndry( P2(lGidx) ), Vrtx_bndry( Candi(itr) ), Vrtx_bndry( Candi(TetFinder) ), ...
                    K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt, J_xyz(tetRow, :), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
            end
        end
    end

    if isempty(K1_6) || isempty(K2_6) || isempty(Kev_4)
        disp('K1, K2 or KEV: empty');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if isnan(K1_6) | isinf(K1_6) | isnan(K2_6) | isinf(K2_6)
        disp('K1 or K2: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if isnan(Kev_4) | isinf(Kev_4)
        disp('Kev: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if edgeChecker(eIdx) == true
        lGidx
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        error('check')
    end

    edgeChecker(eIdx) = true;
    M_K1(eIdx, :)  = K1_6;
    M_K2(eIdx, :)  = K2_6;
    M_KEV(eIdx, :) = Kev_4;
    M_KVE(:, eIdx) = Kve_4;
    B_k(eIdx) = B_k_Pnt;
end
toc;

% === % ========== % === %
% === % GVV matrix % === %
% === % ========== % === %

% modify according to Regular Tetrahedra version.
sparseGVV = cell(1, N_v);
disp('The filling time of G_VV: ');
tic;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    GVV_SideFlag = false(1, 6);
    GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
    if isempty( find( GVV_SideFlag ) )
        sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                                            z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
    else
        sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    end
end
toc;

% === % =================== % === %
% === % Calculation of SPAI % === %
% === % =================== % === %

TEX = 'Right';
CaseTEX = 'Case1';
Tol = 0.2;
GVV_test; % a script
% load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

% === % ========================= % === %
% === % Matrices product to get K % === %
% === % ========================= % === %

M_K = sparse(N_e, N_e);
M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

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
tic;
disp('Calculation time of iLU: ')
[ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
toc;
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\nrmlB_k;
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
toc;

w_y = h_torso;
w_x = air_x;
w_z = air_z;
AFigsScript;

% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;