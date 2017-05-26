tic;
disp('The filling time of K_1, K_EV, K_VE and B: ');
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    auxiSegMed = ones(6, 8, 'uint8');
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = false(2, 6);
    % first row: prime coordinate
    % second row: original coordinate
    corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % 1: up; 2: left; 3: down; 4: righ; 5: far; 6: near
    % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
    % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );

    % if m_v == 6 && n_v == 13 && ell_v == 12 % the second- quadrant
    if m_v == 12 && n_v == 13 && ell_v == 6  % the four-th quadrant
    % volume
    switch flag
        case { '111', '000' }
            fc = str2func('fillNrml_K_Type1');
        case { '100', '011' }
            fc = str2func('fillNrml_K_Type2');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '101', '010' }
            fc = str2func('fillNrml_K_Type3');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '110', '001' }
            fc = str2func('fillNrml_K_Type4');
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        otherwise
            error('check');
    end
    % volume
    if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
        [ sparseK1{7 * ( vIdx_prm - 1 ) + 1}, sparseK1{7 * ( vIdx_prm - 1 ) + 2}, sparseK1{7 * ( vIdx_prm - 1 ) + 3}, ...
            sparseK1{7 * ( vIdx_prm - 1 ) + 4}, sparseK1{7 * ( vIdx_prm - 1 ) + 5}, sparseK1{7 * ( vIdx_prm - 1 ) + 6}, ...
            sparseK1{7 * ( vIdx_prm - 1 ) + 7}, sparseKEV{7 * ( vIdx_prm - 1 ) + 1}, sparseKEV{7 * ( vIdx_prm - 1 ) + 2}, ...
            sparseKEV{7 * ( vIdx_prm - 1 ) + 3}, sparseKEV{7 * ( vIdx_prm - 1 ) + 4}, sparseKEV{7 * ( vIdx_prm - 1 ) + 5}, ...
            sparseKEV{7 * ( vIdx_prm - 1 ) + 6}, sparseKEV{7 * ( vIdx_prm - 1 ) + 7}, sparseKVE{7 * ( vIdx_prm - 1 ) + 1}, ...
            sparseKVE{7 * ( vIdx_prm - 1 ) + 2}, sparseKVE{7 * ( vIdx_prm - 1 ) + 3}, sparseKVE{7 * ( vIdx_prm - 1 ) + 4}, ...
            sparseKVE{7 * ( vIdx_prm - 1 ) + 5}, sparseKVE{7 * ( vIdx_prm - 1 ) + 6}, sparseKVE{7 * ( vIdx_prm - 1 ) + 7}, B_k ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    % three surfaces
    if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    % three lines
    if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    if m_v == 1 && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
        [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fc( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, SheetPntsTable, J_0, corner_flag, edgeTable );
    end
    end
end
toc;


% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %


% check NaN
% disp('K nan and infty check');
% for idx = 1: 1: N_e
%     tmp_vector = sparseK{ idx };
%     lgth = length(tmp_vector);
%     for idx2 = 1: 1: lgth
%         if isnan( tmp_vector(idx2) )
%             [idx, idx2]
%         elseif isinf( tmp_vector(idx2) )
%             [idx, idx2]
%         end
%     end
% end

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 10;

% % bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% % tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-1, 'udiag', 1) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;
% AFigsScript;

% load('bar_x_my_gmres.mat', 'bar_x_my_gmres');

% flag_XZ = 1;
% flag_XY = 0;
% flag_YZ = 0;

% for shIdx = 2: 1: 24
%     ADstrbtn
% end

% clc; clear;
% load('GVV_test.mat');
% load('TMP_m_three.mat', 'TMP_m_three', 'sparseK1', 'sparseKEV', 'sparseGVV', 'sparseGVV_inv', 'sparseKVE' );
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);
% TMP_M_three = cell(99, 1);

% for idx = 1: 1: 99
%     TMP_M_three{ idx } = mySparse2MatlabSparse( TMP_m_three( idx ), 1, N_e, 'Row' );
% end

% norm( nrmlM_K * bar_x_my_gmres - B_k) / norm(B_k)
% AFigsScript;
% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 10;

% bar_x_my_gmres = zeros(size(B_k));
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;

% AFigsScript;

% MidMat2 = getProduct2( sparseKEV( 42 ), sparseGVV_inv );
% TMP_MidMat2 = cell(1, 1);
% TMP_MidMat2{ 1 } = mySparse2MatlabSparse( MidMat2( 1 ), 1, N_v, 'Row' );

% MidMat3 = getProduct2( MidMat2( 1 ), sparseKVE );
% TMP_MidMat3 = cell(1, 1);
% TMP_MidMat3{ 1 } = mySparse2MatlabSparse( MidMat3( 1 ), 1, N_e, 'Row' );

% TMP_KEV = cell(7, 1);
% for idx = 1: 1: 7
%     TMP_KEV{ idx } = mySparse2MatlabSparse( sparseKEV( 5159 + idx ), 1, N_v, 'Row' );
% end

% TMP_GVVinv = cell(1, N_v);
% for idx = 1: 1: N_v
%     TMP_GVVinv{ idx } = mySparse2MatlabSparse( sparseGVV_inv( idx ), N_v, 1, 'Col' );
% end

% TMP_KVE = cell(1, N_v);
% for idx = 1: 1: N_v
%     TMP_KVE{ idx } = mySparse2MatlabSparse( sparseKVE( idx ), N_v, 1, 'Col' );
% end

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% ==== % =========== % ==== %
% ==== % BORDER LINE % ==== %
% ==== % =========== % ==== %

% AFigsScript;
% load('0502Debug.mat');
% Matlab_sparse_test = mySparse2MatlabSparse( sparseK, N_e );

% tic;
% disp('Calculation time of testing gmres.')
% bar_x_my_gmres_test = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num );
% toc;
% AFigsScript
% load('0502Debug.mat');
% Matlab_sparse = mySparse2MatlabSparse( sparseK, N_e );
% A = gallery('neumann', 1600) + speye(1600);
% setup.type = 'croutt';
% setup.milu = 'row';
% setup.droptol = 0.1;
% [L,U] = ilu(A,setup);
% e = ones(size(A,2),1);
% norm(A*e-L*U*e)

% load('TMP0418.mat');
% ArndIdx  = zeros(26, 1);
% ArndIdx  = get26EdgeIdx(4, 9, 8, x_max_vertex, y_max_vertex, z_max_vertex);
% leftPnt  = B_k(ArndIdx);
% ArndIdx  = get26EdgeIdx(8, 9, 4, x_max_vertex, y_max_vertex, z_max_vertex);
% rightPnt = B_k(ArndIdx);

% load('Case0421.mat');
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK1, B_k, int_itr_num, tol, ext_itr_num );
% toc;