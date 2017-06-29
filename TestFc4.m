% === % =========================================== % === %
% === % Refine the SegMed on the computation domain % === %
% === % =========================================== % === % 

% x- and z-direction.
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if m == 1 || m == x_idx_max || ell == 1 && ell == z_idx_max 
        SegMed(m, n, ell, :, :) = uint8(1);
    end
end 
toc;

% y-direction.
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n == 1 || n == y_idx_max
        tmpSeg = zeros(6, 8, 'uint8');
        SegCopy = zeros(8, 1, 'uint8');
        SegCopy(1) = SegMed(m, 2, ell, 4, 1);
        SegCopy(2) = SegMed(m, 2, ell, 1, 1);
        SegCopy(3) = SegMed(m, 2, ell, 1, 3);
        SegCopy(4) = SegMed(m, 2, ell, 2, 1);
        SegCopy(5) = SegMed(m, 2, ell, 2, 5);
        SegCopy(6) = SegMed(m, 2, ell, 3, 1);
        SegCopy(7) = SegMed(m, 2, ell, 3, 3);
        SegCopy(8) = SegMed(m, 2, ell, 4, 5);

        tmpSeg(4, 1) = SegCopy(1); tmpSeg(4, 2) = SegCopy(1); tmpSeg(4, 3) = SegCopy(1); tmpSeg(4, 4) = SegCopy(1); tmpSeg(5, 4) = SegCopy(1); tmpSeg(6, 1) = SegCopy(1);
        tmpSeg(1, 1) = SegCopy(2); tmpSeg(1, 2) = SegCopy(2); tmpSeg(1, 7) = SegCopy(2); tmpSeg(1, 8) = SegCopy(2); tmpSeg(5, 3) = SegCopy(2); tmpSeg(6, 2) = SegCopy(2); 
        tmpSeg(1, 3) = SegCopy(3); tmpSeg(1, 4) = SegCopy(3); tmpSeg(1, 5) = SegCopy(3); tmpSeg(1, 6) = SegCopy(3); tmpSeg(5, 2) = SegCopy(3); tmpSeg(6, 3) = SegCopy(3); 
        tmpSeg(2, 1) = SegCopy(4); tmpSeg(2, 2) = SegCopy(4); tmpSeg(2, 3) = SegCopy(4); tmpSeg(2, 4) = SegCopy(4); tmpSeg(5, 1) = SegCopy(4); tmpSeg(6, 4) = SegCopy(4); 
        tmpSeg(2, 5) = SegCopy(5); tmpSeg(2, 6) = SegCopy(5); tmpSeg(2, 7) = SegCopy(5); tmpSeg(2, 8) = SegCopy(5); tmpSeg(5, 8) = SegCopy(5); tmpSeg(6, 5) = SegCopy(5); 
        tmpSeg(3, 1) = SegCopy(6); tmpSeg(3, 2) = SegCopy(6); tmpSeg(3, 7) = SegCopy(6); tmpSeg(3, 8) = SegCopy(6); tmpSeg(5, 7) = SegCopy(6); tmpSeg(6, 6) = SegCopy(6); 
        tmpSeg(3, 3) = SegCopy(7); tmpSeg(3, 4) = SegCopy(7); tmpSeg(3, 5) = SegCopy(7); tmpSeg(3, 6) = SegCopy(7); tmpSeg(5, 6) = SegCopy(7); tmpSeg(6, 7) = SegCopy(7); 
        tmpSeg(4, 5) = SegCopy(8); tmpSeg(4, 6) = SegCopy(8); tmpSeg(4, 7) = SegCopy(8); tmpSeg(4, 8) = SegCopy(8); tmpSeg(5, 5) = SegCopy(8); tmpSeg(6, 8) = SegCopy(8); 
        SegMed(m, n, ell, :, :) = tmpSeg;
    end
end 
toc;

% === === === === === === === === ===  % ====== % === === === === === === === === === %
% === === === === === === === === ===  % K part % === === === === === === === === === %
% === === === === === === === === ===  % ====== % === === === === === === === === == %

% start from here: run for sigmaE

% designing a small case ?
% implement getSigmaE
% those beyond computation domain can be anything
% check if tetRow is valid in the filling of Bk ?
% the following code may be incorporated into getPntMedTetTable
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
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

% build up an adjacenct Tet Table
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
                % modify the filling of B_k therein
                [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
                    G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
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
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(nrmlB_k));
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\nrmlB_k;
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
toc;

% % save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

AFigsScript;

% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % toc;

% copy Shift2d_Right to another m file. and use Shift2d_Right in below.
% main work lies in: modify the fillK's fillBk part.
% build up a test for thick current ?

% PhiDstrbtn;

% CurrentEst;

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x = A \ B;
% toc;

% PhiDstrbtn;
% FigsScript;