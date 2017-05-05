% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0115Bolus1cm';
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');

% function BxB = TestFc
%     BxB = zeros(1, 3);
% end
% plotMap( paras2dXZ, dx, dz );
% plotRibXZ(Ribs, SSBone, dx, dz);
% plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
% axis equal;
% [Tet32Value(5, 3), Tet32Value(6, 4);
% Tet32Value(6, 3), Tet32Value(7, 4);
% Tet32Value(7, 3), Tet32Value(8, 4);
% Tet32Value(4, 3), Tet32Value(5, 4);
% Tet32Value(8, 3), Tet32Value(1, 4);
% Tet32Value(3, 3), Tet32Value(4, 4);
% Tet32Value(2, 3), Tet32Value(3, 4);
% Tet32Value(1, 3), Tet32Value(2, 4)]

% counter = 0;
% mnell_table = zeros(1, 3);
% collectBPhi = 0;
% for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     if B_phi( idx ) ~= 0
%         collectBPhi = vertcat(collectBPhi, B_phi(idx));
%         counter = counter + 1;
%         [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
%         mnell_table = vertcat(mnell_table, [m, n, ell]);
%     end
% end
% clc; clear;
% load('First.mat');
% load('Case0504.mat', 'sparseK1', 'MidMat3', 'N_e');
% sparseK = cell( N_e, 1 );
% tic;
% NrmlRow_K1 = zeros(1, N_e);
% NrmlRow_MidMat3 = zeros(1, N_e);
% for e_idx = 1: 1: N_e
%     NrmlRow_K1 = sparse2NrmlVec( sparseK1{ e_idx }', N_e )';
%     NrmlRow_MidMat3 = sparse2NrmlVec( MidMat3{ e_idx }', N_e )';
%     sparseK{ e_idx } = Nrml2Sparse( NrmlRow_K1 - NrmlRow_MidMat3 );
% end
% toc;

% tic;
% M_KEV = mySparse2MatlabSparse( sparseKEV(1: 100), 100, N_v, 'Row' );
% M_KVE = mySparse2MatlabSparse( sparseKVE(1: 100), N_v, 100, 'Col' );
% toc;
% disp('Calculation time of matrix product in 100^2 unit');
% tic;
% Test_product = M_KEV * G_VV_inv * M_KVE;
% toc;

% % check NaN
% disp('KEV nan and infty check');
% for idx = 1: 1: N_e
%     tmp_vector = sparseKEV{ idx };
%     lgth = length(tmp_vector);
%     for idx2 = 1: 1: lgth
%         if isnan( tmp_vector(idx2) )
%             [idx, idx2]
%         elseif isinf( tmp_vector(idx2) )
%             [idx, idx2]
%         end
%     end
% end
% load('Case0504_LU_1e2.mat', 'B_k', 'sparseK1', 'sparseKEV', 'sparseKVE');

load('M_G_VV_inv0505.mat');
% Tol = 0.4;
% sparseG_VV_inv = cell(1, N_v);
% disp('The calculation time of SAI: ');
% tic;
% sparseG_VV_inv = getSAI_sparse(sparseGVV, N_v, Tol);
% toc;
% % G_VV = zeros(N_v);
% % G_VV = recoverMatrix( sparseGVV, N_v );

% % M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
% % disp('Time for the calculation of inverse of G_VV');
% % tic;
% % M_G_VV_inv = inv(M_sparseGVV);
% % toc;

% % figure(13);
% % M_G_VV_inv(find(M_G_VV_inv <= 1)) = 0;
% % max(M_G_VV_inv)
% % spy(M_G_VV_inv);
% M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseG_VV_inv, N_v, N_v, 'Col' );
% figure(13);
% % TMP_Mat(find(TMP_Mat <= 1)) = 0;
% spy(M_sparseGVV_inv_spai);

% eIdx = vIdx2eIdx(11111, 3, x_max_vertex, y_max_vertex, z_max_vertex);
% disp('KVE nan and infty check');
% for idx = 1: 1: N_e
%     tmp_vector = m_three{ idx };
%     lgth = length(tmp_vector);
%     for idx2 = 1: 1: lgth
%         if isnan( tmp_vector(idx2) )
%             [idx, idx2]
%         elseif isinf( tmp_vector(idx2) )
%             [idx, idx2]
%         end
%     end
% end

% tic;
% MidMat2 = cell(N_e, 1);
% MidMat2 = getProduct2( sparseKEV, sparseG_VV_inv, N_v );
% toc;
% % get MidMat3
% tic;
% MidMat3 = cell(N_e, 1);
% MidMat3 = getProduct2( MidMat2, sparseKVE, N_v );
% toc;



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

% clc;
% clear;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% CaseName = 'Case0322';
% load( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst;
% % counter
% CaseName = 'TMP';
%     % fname = 'e:\Kevin\CapaReal\Case0301_8MHzSaline';
%     CaseDate = 'Case0319';
%     % PhiDstrbtn;
%     saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
%     saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
%     saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
%     saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
%     saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
%     saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
%     saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
%     saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
%     saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
%     saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
%     saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
%     saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');

% [ sparseS_1, B_phi ] = PutOnTopElctrd( sparseS_1, B_phi, V_0, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
%                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% [X,Y,Z,V] = flow(10);
% figure
% slice(X,Y,Z,V,[6 9],2,0);
% shading flat

% [Xq,Yq,Zq] = meshgrid(1:1:2,1:1:3,1:1:4);
% Vq = interp3(X,Y,Z,V,Xq,Yq,Zq);
% figure
% slice(Xq,Yq,Zq,Vq,[6 9],2,0);
% shading flat
% x_idx_max = 51;
% y_idx_max = 37;
% z_idx_max = 41;
% x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
% N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
%     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
%     - ( (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1) );
% [X,Y,Z,V] = flow(10);
% A_R = '101'
% A_R(1) = '0';
% A_R(2) = '1';
% A_R(3) = '0';

% A_R

% f = 8 * 10^6;
% T = 5;
% S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% EPSILON_R = zeros(size(S));
% SIGMA = zeros(size(S));
% for idx = 1: 1: length(S)
%     [ EPSILON_R(idx), SIGMA(idx) ] = getEpsSig(f, S(idx), T);
% end
% [ EPSILON_R, SIGMA ]
% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power250currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power280currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power300currentEst.mat');
% W

% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0205Bone';

% % % Period 1
% % CaseName = 'Power300';
% % load( strcat(fname, '\', CaseName, '.mat') );

% clc; clear; 
% % % % % V_0 = 76.78;
% Shift2d
% % loadParas;
% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % y = tumor_y + dy;
% y = 0;
% counter = 0;
% % for y = tumor_y - 2 * dy: dy: tumor_y - 2 * dy
%     y_idx = y / dy + h_torso / (2 * dy) + 1;
%     counter = counter + 9;
%     paras2dXZ = genParas2d( y, paras, dx, dy, dz );
%     figure(counter);
%     clf;
%     plotMap( paras2dXZ, dx, dz );
%     axis equal;
%     plotGridLineXZ( shiftedCoordinateXYZ, y_idx );
%     set(gcf, 'Position', get(0,'Screensize'));
% % end

% % % figure(3);
% plotRibXZ(Ribs, SSBone, dx, dz);

% % % y = tumor_y + dy;
% %     y = tumor_y;
% %     y_idx = y / dy + h_torso / (2 * dy) + 1;
% %     paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% %     figure(2);
% %     clf;
% %     plotMap( paras2dXZ, dx, dz );
% %     axis equal;
% %     plotGridLineXZ( shiftedCoordinateXYZ, y_idx );
% %     set(gcf, 'Position', get(0,'Screensize'));
% %     plotRibXZ(Ribs, SSBone, dx, dz);
% % % end

% % RibValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% % SSBoneValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% % for y = - h_torso / 2: dy: h_torso / 2
% %     y_idx = int64(y / dy + h_torso / (2 * dy) + 1);
% %     if y_idx == 8
% %         ;
% %     end
% %     [ RibValid(y_idx), SSBoneValid(y_idx) ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
% % end

% % counter = 10;
% % for x = tumor_x - 2 * dx: dx: tumor_x + 2 * dx
% %     counter = counter + 1;
% %     x_idx = x / dx + air_x / (2 * dx) + 1;
% %     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
% %     figure(counter);
% %     clf;
% %     plotYZ( paras2dYZ, dy, dz );
% %     axis equal;
% %     plotGridLineYZ( shiftedCoordinateXYZ, x_idx);
% % end


% % clc; clear;
% % CaseName = 'Power300';
% % load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\', CaseName, '.mat') );

% % flag_XZ = 1;
% % flag_XY = 0;
% % flag_YZ = 0;
% % PhiDstrbtn;

% % lala = squeeze(SegMed(16, tumor_n + 2, 29, :, :));
% % Need to Rederive the octantCube.m

% % AxA = 3;
% % if AxA == 3;
% %     disp('lala');
% % elseif AxA == 4;
% %     disp('lala4');
% % end

% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0222_100kHz\Power300TmprtrXZ.fig');
% caxis auto;
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0221_3cmBolusNoFatBolusSigmaCase1\Power300TmprtrXZ.fig');
% caxis auto;
