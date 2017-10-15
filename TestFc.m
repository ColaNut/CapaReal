loadParas;
loadParas_Eso0924;
paras2dXZ = genParas2d( tumor_y_es, paras, dx, dy, dz );
figure(1);
clf;
hold on;
plotMap_Eso1014( paras2dXZ, dx, dz );

Ribs = zeros(7, 9);
SSBone = zeros(1, 8);
[ Ribs, SSBone ] = BoneParas;
plotRibXZ(Ribs, SSBone, dx, dz);
axis equal;
axis([-5, 5, 0, 10]);
% plotGridLineXZ( shiftedCoordinateXYZ_B, tumor_n_B );

    % % === % =========== % === %
% % === % Getting Q_s % === %
% % === % =========== % === % 
% Q_s_Vector       = zeros(ExpandedNum, 1);
% % to-do
% % the facets and line boundary tetrahdron are ignored
% tic;
% disp('Rearranging Q_s In Domain A:');
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;

%     PntQ_s          = zeros(48, 1);
%     % rearrange (6, 8, 3) to (48, 3);
%     tmp = zeros(8, 6);
%     tmp = squeeze(Q_s(m, n, ell, :, :))';
%     PntQ_s = tmp(:);
%     Q_s_Vector( 48 * (idx - 1) + 1: 48 * idx ) = PntQ_s;
% end
% toc;

% tic;
% disp('Rearrangement of Q_s_B In Domain B: ');
% BaseIdx = 48 * x_idx_max * y_idx_max * z_idx_max;
% for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
%     [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;

%     PntQ_s          = zeros(48, 1);
%     % rearrange (6, 8, 3) to (48, 3);
%     tmp = zeros(8, 6);
%     tmp = squeeze(Q_s_B(m, n, ell, :, :))';
%     PntQ_s = tmp(:);
%     Q_s_Vector( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntQ_s;
% end
% toc;

% Q_s_Vector(~validTetTable) = [];

% % Data=magic(100);
% % c=[0.1 1 10 100 1000];
% % contourf(log(Data(:,:)),log(c));
% % colormap(bone);  %Color palate named "bone"
% % caxis(log([c(1) c(length(c))]));
% % colorbar('FontSize',11,'YTick',log(c),'YTickLabel',c);
% % set('gca','YTicklabel','$10^2$ (cm)','interpreter','latex') 
% % for PartNum = 1: 1: 8
% %     load(strcat('D:\Kevin\CapaReal\0808\0808MQS_conformal_postK', num2str(PartNum), '.mat'), 'B_k', 'm_K1', 'm_K2', 'm_KEV', 'm_KVE');
% %     % ne_B_k = find(~cellfun(@isempty,B_k));
% %     ne_m_K1 = find(~cellfun(@isempty,m_K1));
% %     ne_m_K2 = find(~cellfun(@isempty,m_K2));
% %     ne_m_KEV = find(~cellfun(@isempty,m_KEV));
% %     ne_m_KVE = find(~cellfun(@isempty,m_KVE));

% %     length(ne_m_K1)
% %     length(ne_m_K2)
% %     length(ne_m_KEV)
% %     length(ne_m_KVE)
% %     % total_B_k(ne_B_k) = B_k(ne_B_k);
% %     % total_m_K1(ne_m_K1) = m_K1(ne_m_K1);
% %     % total_m_K2(ne_m_K2) = m_K2(ne_m_K2);
% %     % total_m_KEV(ne_m_KEV) = m_KEV(ne_m_KEV);
% %     % total_m_KVE(ne_m_KVE) = m_KVE(ne_m_KVE);
% % end

% % % % % % load('EQS_Phi.mat');
% % % % % % % === === === === === === === === % ========== % === === === === === === === === %
% % % % % % % === === === === === === === === % K part (1) % === === === === === === === === %
% % % % % % % === === === === === === === === % ========== % === === === === === === === === %

% % % % % Vrtx_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
% % % % % %  2: computational domain boundary
% % % % % n_far  = y_idx_max - 1;
% % % % % n_near = 2;
% % % % % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% % % % %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % % %     borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
% % % % %     if my_F(borderFlag, 1)
% % % % %         Vrtx_bndry(m_v, n_v, ell_v) = 2;
% % % % %     end
% % % % % end

% % % % % Bls_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% % % % % % 13: bolus-muscle boundary
% % % % % BM_bndryNum = 13;
% % % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % % %     if n >= n_near && n <= n_far && mediumTable(m, n, ell) == BM_bndryNum
% % % % %         m_v = 2 * m - 1;
% % % % %         n_v = 2 * n - 1;
% % % % %         ell_v = 2 * ell - 1;
% % % % %         Bls_bndry(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
% % % % %             = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, ...
% % % % %                 Bls_bndry(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1), BM_bndryNum );
% % % % %     end
% % % % % end
% % % % % Bls_bndry(:, 1, :) = Bls_bndry(:, 2, :);
% % % % % Bls_bndry(:, end, :) = Bls_bndry(:, end - 1, :);

% % % % % % check if tetRow is valid in the filling of Bk ?
% % % % % % the following code may be incorporated into getPntMedTetTable
% % % % % SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
% % % % % Q_s    = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
% % % % % tic;
% % % % % disp('calclation time of SigmeE and Q_s');
% % % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % % %     m_v = 2 * m - 1;
% % % % %     n_v = 2 * n - 1;
% % % % %     ell_v = 2 * ell - 1;
% % % % %     Phi27 = zeros(3, 9);
% % % % %     PntsIdx      = zeros( 3, 9 );
% % % % %     PntsCrdnt    = zeros( 3, 9, 3 );
% % % % %     % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
% % % % %     [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
% % % % %     PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
% % % % %     Phi27 = bar_x_my_gmresPhi(PntsIdx);

% % % % %     [ SigmaE(m, n, ell, :, :, :), Q_s(m, n, ell, :, :) ] = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), sigma, j * Omega_0 * Epsilon_0 * epsilon_r_pre );
% % % % % end
% % % % % toc;

% % % % % % === % ==================================== % === %
% % % % % % === % Trimming: Invalid set to 30 (byndCD) % === %
% % % % % % === % ==================================== % === % 

% % % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % % %     if ell == z_idx_max
% % % % %         SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % %     if ell == 1
% % % % %         SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % %     if m   == 1
% % % % %         SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % %     if m   == x_idx_max
% % % % %         SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % %     if n   == y_idx_max
% % % % %         SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % %     if n   == 1
% % % % %         SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % % %     end
% % % % % end

% % % % % % === % ========================================================== % === %
% % % % % % === % Conducting Current Assignment and MedTetTable Construction % === %
% % % % % % === % ========================================================== % === % 

% % % % tic;
% % % % disp('Assigning each tetrahdron with a conducting current');
% % % % J_xyz            = zeros(0, 3);
% % % % Q_s_Vector       = zeros(0, 1);
% % % % MedTetTableCell  = cell(0, 1);
% % % % % rearrange SigmaE and Q_s; construct the MedTetTableCell
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     m_v = 2 * m - 1;
% % % %     n_v = 2 * n - 1;
% % % %     ell_v = 2 * ell - 1;

% % % %     PntJ_xyz        = zeros(48, 3);
% % % %     PntMedTetTableCell  = cell(48, 1);
% % % %     PntQ_s          = zeros(48, 1);
% % % %     % rearrange (6, 8, 3) to (48, 3);
% % % %     tmp = zeros(8, 6);
% % % %     tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
% % % %     PntJ_xyz(:, 1) = tmp(:);
% % % %     tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
% % % %     PntJ_xyz(:, 2) = tmp(:);
% % % %     tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
% % % %     PntJ_xyz(:, 3) = tmp(:);
% % % %     % to-do
% % % %     tmp = squeeze(Q_s(m, n, ell, :, :))';
% % % %     PntQ_s = tmp(:);
% % % %     PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %     validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );

% % % %     % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
% % % %     % start from here: the temperature is getting lower, and the Q_s and J_xyz is in the order 0.35 and 0.002, respectively.
% % % %     J_xyz        = vertcat(J_xyz, PntJ_xyz(validTet, :));
% % % %     MedTetTableCell  = vertcat(MedTetTableCell, PntMedTetTableCell(validTet));
% % % %     Q_s_Vector   = vertcat(Q_s_Vector, PntQ_s(validTet));
% % % % end
% % % % toc;

% % % % validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
% % % %                 + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

% % % % if size(MedTetTableCell, 1) ~= validNum
% % % %     error('check the construction');
% % % % end

% % % % MedTetTable = sparse(validNum, N_v);
% % % % tic;
% % % % disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
% % % % MedTetTable = mySparse2MatlabSparse( MedTetTableCell, validNum, N_v, 'Row' );
% % % % toc;

% % % % save('MedTetTableCell.mat', 'MedTetTableCell');

% % % % % === === === === === === === === % ========== % === === === === === === === === %
% % % % % === === === === === === === === % K part (2) % === === === === === === === === %
% % % % % === === === === === === === === % ========== % === === === === === === === === %

% % % % % === % ==================== % === %
% % % % % === % Parameters used in K % === %
% % % % % === % ==================== % === %

% % % %               % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
% % % % mu_prime      = [   1,     1,      1,     1,     1,     1,     1 ]';
% % % % mu_db_prime   = [   0,     0,      0,     0,     0,     0,     0 ]';
% % % % % mu_db_prime   = [ 0,    0.62 ]';
% % % % mu_r          = mu_prime - i * mu_db_prime;

% % % % % === % =============================== % === %
% % % % % === % Constructing The Directed Graph % === %
% % % % % === % =============================== % === %

% % % % starts = [];
% % % % ends = [];
% % % % vals = [];
% % % % borderFlag = false(1, 6);
% % % % disp('Constructing the directed graph');
% % % % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% % % %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %     flag = getMNL_flag(m_v, n_v, ell_v);
% % % %     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %     % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
% % % %     if strcmp(flag, '000') && ~mod(ell_v, 2)
% % % %         [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
% % % %     end
% % % % end
% % % % G = sparse(ends, starts, vals, N_v, N_v);
% % % % toc;
% % % % % the validity of Vals is needed.
% % % % [ P2, P1, Vals ] = find(G);
% % % % [ Vals, idxSet ] = sort(Vals);
% % % % P1 = P1(idxSet);
% % % % P2 = P2(idxSet);
% % % % l_G = length(P1);

% % % % % undirected graph
% % % % uG = G + G';

% % % % % === % =================================== % === %
% % % % % === % Filling Time of K1, Kev, Kve and Bk % === %
% % % % % === % =================================== % === %

% % % % B_k = zeros(N_e, 1);
% % % % m_K1 = cell(N_e, 1);
% % % % edgeChecker = false(l_G, 1);
% % % % tic; 
% % % % disp('The filling time of K_1, K_EV, K_VE and B: ');
% % % % for eIdx = 1: 1: l_G
% % % %     % eIdx = full( G(P2(lGidx), P1(lGidx)) );
% % % %     Candi = [];
% % % %     % get candidate points
% % % %     P1_cand = uG(:, P1(eIdx));
% % % %     P2_cand = uG(:, P2(eIdx));
% % % %     P1_nz = find(P1_cand);
% % % %     P2_nz = find(P2_cand);
% % % %     for CandiFinder = 1: 1: length(P1_nz)
% % % %         if find(P2_nz == P1_nz(CandiFinder))
% % % %             Candi = horzcat(Candi, P1_nz(CandiFinder));
% % % %         end
% % % %     end
% % % %     % get adjacent tetrahdron
% % % %     K1_6 = zeros(1, N_e); 
% % % %     B_k_Pnt = 0;
% % % %     cFlag = false;
% % % %     for TetFinder = 1: 1: length(Candi) - 1
% % % %         for itr = TetFinder + 1: length(Candi)
% % % %             if uG( Candi(TetFinder), Candi(itr) )
% % % %                 % linked to become a tetrahedron
% % % %                 v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
% % % %                 tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
% % % %                 if length(tetRow) ~= 1
% % % %                     error('check te construction of MedTetTable');
% % % %                 end
% % % %                 MedVal = MedTetTable( tetRow, v1234(1) );
% % % %                 % use tetRow to check the accordance of SigmaE and J_xyz
% % % %                 [ K1_6, B_k_Pnt ] = fillK1_FW( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
% % % %                     G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), ...
% % % %                     Vrtx_bndry( P1(eIdx) ), Vrtx_bndry( P2(eIdx) ), Vrtx_bndry( Candi(itr) ), Vrtx_bndry( Candi(TetFinder) ), ...
% % % %                     K1_6, B_k_Pnt, J_xyz(tetRow, :), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
% % % %             end
% % % %         end
% % % %     end

% % % %     if isempty(K1_6) 
% % % %         disp('K1, K2 or KEV: empty');
% % % %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %         [ m_v, n_v, ell_v, edgeNum ]
% % % %     end
% % % %     if isnan(K1_6)
% % % %         disp('K1 or K2: NaN or Inf');
% % % %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %         [ m_v, n_v, ell_v, edgeNum ]
% % % %     end
% % % %     if edgeChecker(eIdx) == true
% % % %         eIdx
% % % %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %         [ m_v, n_v, ell_v, edgeNum ]
% % % %         error('check')
% % % %     end

% % % %     edgeChecker(eIdx) = true;
    
% % % %     m_K1{eIdx} = Mrow2myRow(K1_6);
% % % %     B_k(eIdx) = B_k_Pnt;
% % % % end
% % % % toc;

% % % % M_K1 = sparse(N_e, N_e);
% % % % tic;
% % % % disp('Transfroming M_K1, M_K2, M_KEV and M_KVE')
% % % % M_K1 = mySparse2MatlabSparse( m_K1, N_e, N_e, 'Row' );
% % % % toc;

% % % % M_K = sparse(N_e, N_e);
% % % % M_K = M_K1;
% % % % % M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% % % % % === % ============================ % === %
% % % % % === % Sparse Normalization Process % === %
% % % % % === % ============================ % === %

% % % % tic;
% % % % disp('Time for normalization');
% % % % sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
% % % % nrmlM_K = sptmp * M_K;
% % % % nrmlB_k = sptmp * B_k;
% % % % toc;

% % % % % === % ============================================================ % === %
% % % % % === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% % % % % === % ============================================================ % === %

% % % load('D:\Kevin\CapaReal\0715\0715K1.mat');

% % % tol = 1e-6;
% % % ext_itr_num = 5;
% % % int_itr_num = 20;

% % % bar_x_my_gmres = zeros(size(nrmlB_k));
% % % % tic;
% % % % disp('Calculation time of iLU: ')
% % % % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % % % toc;
% % % % tic; 
% % % % disp('Computational time for solving Ax = b: ')
% % % % bar_x_my_gmres = nrmlM_K\nrmlB_k;
% % % % toc;
% % % tic;
% % % disp('The gmres solutin of Ax = B: ');
% % % bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
% % % toc;

% % % w_y = h_torso;
% % % w_x = air_x;
% % % w_z = air_z;
% % % AFigsScript;

% % % % tic;
% % % % disp('Calculation time of iLU: ')
% % % % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % % % toc;