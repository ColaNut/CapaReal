% % GVV matrix
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

% % method I:
% M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
% disp('Time for the calculation of inverse of G_VV');
% tic;
% M_GVV_inv = inv(M_sparseGVV);
% toc;
% save('GVV_test.mat');

% === % === % === % === %
% save('GVV_test.mat'); %
% === % === % === % === %

% load('GVV_test.mat');

M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
n_s = 27;
% for Tol = 0.2: 0.1: 0.2
    sparseGVV_inv = cell(1, N_v);
    disp('The calculation time of SAI: ');
    tic;
    [ sparseGVV_inv, column_res ] = getSAI_sparse(sparseGVV, N_v, Tol, n_s);
    toc;
    M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
    tic;
    cond2 = cond(full(M_sparseGVV * M_sparseGVV_inv_spai), 2);
    disp( strcat( 'For Tol = ', num2str(Tol), ', the 2-condition number is ', num2str(cond2) ) );
    disp('The calculation time of 2-condition number of AM: ');
    toc;
    tic;
    f_norm = norm(M_sparseGVV * M_sparseGVV_inv_spai - sparseId, 'fro');
    disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );
    disp('The calculation time of Frobenius norm of AM - I: ');
    toc;
    save( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv', 'column_res', 'cond2', 'f_norm' );
% end

% tic;
% cond2 = cond(full(M_sparseGVV * M_GVV_inv), 2);
% disp('The calculation time of 2-condition number of A A^(-1): ');
% toc;
% tic;
% f_norm = norm(M_sparseGVV * M_GVV_inv - sparseId, 'fro');
% disp('The calculation time of Frobenius norm of A A^(-1) - I: ');
% toc;
% disp( strcat( 'The 2-condition number of A A^(-1) is ', num2str(cond2) ) );
% disp( strcat( 'and the Frobenius norm of A A^(-1) - I is ', num2str(f_norm) ) );
% save( 'RealGVV_inv.mat', 'cond2', 'f_norm' );

% === % ===== % === %
% === % AMEND % === %
% === % ===== % === %

% load('GVV_test.mat');

% sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
% n_s = 27;
% for Tol = 0.1: 0.1: 0.5
%     load( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv' );
%     M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
%     disp('The calculation time of 2-condition number of AM: ');
%     tic;
%     cond2 = cond(full(M_sparseGVV * M_sparseGVV_inv_spai), 2);
%     toc;
%     disp('The calculation time of Frobenius norm of AM - I: ');
%     tic;
%     f_norm = norm(M_sparseGVV * M_sparseGVV_inv_spai - sparseId, 'fro');
%     toc;
%     disp( strcat( 'For Tol = ', num2str(Tol), ', the 2-condition number is ', num2str(cond2) ) );
%     disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );
%     save( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv', 'cond2', 'f_norm' );
% end

% tic;
% cond2 = cond(full(M_sparseGVV * M_GVV_inv), 2);
% disp('The calculation time of 2-condition number of A A^(-1): ');
% toc;
% tic;
% f_norm = norm(M_sparseGVV * M_GVV_inv - sparseId, 'fro');
% disp('The calculation time of Frobenius norm of A A^(-1) - I: ');
% toc;
% disp( strcat( 'The 2-condition number of A A^(-1) is ', num2str(cond2) ) );
% disp( strcat( 'and the Frobenius norm of A A^(-1) - I is ', num2str(f_norm) ) );
% save( 'RealGVV_inv.mat', 'cond2', 'f_norm' );

% === % ==== % === %
% === % Rest % === %
% === % ==== % === %

% load('GVV_test.mat');
% sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
% M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
% sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
% tic;
% cond2 = cond(full(M_sparseGVV), 2);
% disp('The calculation time of 2-condition number of A: ');
% toc;
% tic;
% f_norm = norm(M_sparseGVV - sparseId, 'fro');
% disp('The calculation time of Frobenius norm of A - I: ');
% toc;
% disp( strcat( 'The 2-condition number of A I is ', num2str(cond2) ) );
% disp( strcat( 'and the Frobenius norm of A I - I is ', num2str(f_norm) ) );

% === % ========================= % === %
% === % Visualization of Matrices % === %
% === % ========================= % === %


% [X, Y] = meshgrid(1: 1: N_v); 

% figure(10);
% clf;
% [X, Y] = meshgrid(1: 1: N_v); 
% pcolor( X, Y, abs( flipud(full(M_GVV_inv)) ) );
% colorbar;
% shading flat;
% saveas(figure(2), 'A.jpg');
% disp( strcat( 'The maximum value of A^(-1) is: ', num2str(max(max(M_GVV_inv))) ) );

% figure(11);
% clf;
% Tol = 0.1;
% load( strcat('SAI_Tol', num2str(Tol), '.mat'), 'sparseGVV_inv' );
% M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
% pcolor( X, Y, abs( flipud(full(M_sparseGVV_inv_spai)) ) );
% colorbar;
% shading flat;
% disp( strcat( 'The maximum value of A^(-1)_SAI is: ', num2str(max(max(M_sparseGVV_inv_spai))) ) );
% saveas(figure(3), 'A_SAI.jpg');


% max(M_GVV_inv);
% % A_Inv = inv(A);

% % x = A \ B;

% % r = norm(A * x - B);
% relRes = norm( A_SAI * B - x ) / norm(x)
% relRes2 = norm( B - A * A_SAI * B ) / norm(B)

% Id_Matrix = diag( repmat( 1, 1, size(A, 1) ) );

% AM_norm = norm(A * A_SAI - Id_Matrix, 'fro')
% CondiNum = cond(A * A_SAI)

% AM_norm_inv = norm(A * A_Inv - Id_Matrix, 'fro')
% CondiNum_inv = cond(A * A_Inv)


% % length(find(column_res > 0.4));
% % Id_Matrix = diag( repmat( 1, 1, size(A, 1) ) );
% % norm(A * A_SAI - Id_Matrix)
% % % % save('A_SAI_A_Inv.mat');
% % % load('A_SAI_A_Inv.mat');

% % x_mesh      = zeros( z_idx_max, x_idx_max );
% % z_mesh      = zeros( z_idx_max, x_idx_max );
% x_SAI = A_SAI * B;
% for idx = 1: 1: N
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     Phi(m ,n, ell) = x_SAI(idx);
% end

% % [ x_mesh, z_mesh ] = meshgrid(-w_x / 2: dx: w_x / 2);
% figure(2);
% clf;
% pcolor(x_mesh * 100, z_mesh * 100, abs( squeeze( Phi(:, int64( w_y / (2 * dy) + 1 ), :) )' ));
% axis equal;
% % shading flat
% shading interp
% colormap jet;
% set(gca,'fontsize',20);
% set(gca,'LineWidth',2.0);
% cb = colorbar;
% % caxis([-50, 50]);
% % caxis([0, 100]);
% ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
% set(cb, 'FontSize', 18);
% box on;
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);

% % figure(2);
% % clf;
% % [X, Y] = meshgrid(1: 1: size(A, 1)); 
% % pcolor(X, Y, abs( flipud(A) ));
% % colorbar;
% % shading flat;
% % saveas(figure(2), 'A.jpg');

% % figure(3);
% % clf;
% % pcolor(X, Y, abs( flipud(A_SAI) ));
% % colorbar;
% % shading flat;
% % saveas(figure(3), 'A_SAI.jpg');

% % figure(4);
% % clf;
% % pcolor(X, Y, abs( flipud(A_Inv) ));
% % colorbar;
% % shading flat;
% % saveas(figure(4), 'A_Inv.jpg');

% % normalized the matrix
% % calculate the corresponding residual of SAI solutoin and the inverse solution;
% % and check why the SAI only have one element in each column