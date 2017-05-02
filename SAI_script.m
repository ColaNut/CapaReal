% clc; clear; 
% w_x = 10 / 100;
% w_y = 10 / 100;
% w_z = 10 / 100;

% h_x = 2 / 100;
% h_y = 2 / 100;
% h_z = 2 / 100;

% dx = 1 / 100;
% dy = 1 / 100;
% dz = 1 / 100;

% Paras_SAI = [ w_x, w_y, w_z, h_x, h_y, h_z, dx, dy, dz ];

% V_0 = 10;
% Epsilon_0     = 10^(-9) / (36 * pi);
% Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz

% epsilon_r_pre = [ 1,  113 ]';
% sigma         = [ 0, 0.61 ]';
% epsilon_r     = epsilon_r_pre - j * sigma / ( Epsilon_0 * Omega_0 );

% x_idx_max = w_x / dx + 1;
% y_idx_max = w_y / dy + 1;
% z_idx_max = w_z / dz + 1;
% N = x_idx_max * y_idx_max * z_idx_max;

% % construct shiftedCoordinate
% shiftedCoordinate = zeros(x_idx_max, y_idx_max, z_idx_max, 3);
% for x_idx = 1: 1: x_idx_max
%     x = (x_idx - 1) * dx - w_x / 2;
%     shiftedCoordinate(x_idx, :, :, 1) = x;
% end
% for y_idx = 1: 1: y_idx_max
%     y = (y_idx - 1) * dy - w_y / 2;
%     shiftedCoordinate(:, y_idx, :, 2) = y;
% end
% for z_idx = 1: 1: z_idx_max
%     z = (z_idx - 1) * dz - w_z / 2;
%     shiftedCoordinate(:, :, z_idx, 3) = z;
% end

% % get roughMed
% mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% for y = - w_y / 2: dy: w_y / 2
%     paras2dXZ_SAI = genParas2dXZ_SAI( y, Paras_SAI );
%     y_idx = y / dy + w_y / (2 * dy) + 1;
%     sample_valid = paras2dXZ_SAI(10);
%     if sample_valid
%         x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
%         x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

%         z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
%         z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

%         mediumTable(x_idx_left: x_idx_rght, int64(y_idx), z_idx_down: z_idx_up) = uint8(2);
%     end
% end

% % get SegMed
% SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if mediumTable(m, n, ell) == uint8(2)
%         SegMed(m, n, ell, :, :) = uint8(2);

%         x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
%         x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

%         y_idx_near = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
%         y_idx_far  = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);

%         z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
%         z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

%         if ell == z_idx_up
%             SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if ell == z_idx_down
%             SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if m   == x_idx_left
%             SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if m   == x_idx_rght
%             SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if n   == y_idx_far
%             SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%         if n   == y_idx_near
%             SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 1 );
%         end
%     end
% end

% % fill in the matrix A 
% A = zeros( N, N );
% B = zeros( N, 1 );
% for idx = 1: 1: N
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if m >= 2  && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         A(idx, :) = fillA_SAI( m, n, ell, shiftedCoordinate, x_idx_max, y_idx_max, z_idx_max, squeeze(SegMed(m, n, ell, :, :)), epsilon_r );
%     elseif ell == z_idx_max
%         A(idx, :) = fillTop_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif ell == 1
%         A(idx, :) = fillBttm_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
%         A(idx, :) = fillRight_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
%         A(idx, :) = fillLeft_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         A(idx, :) = fillFront_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         A(idx, :) = fillBack_A_SAI( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     end
% end

% % endow the potential
% for idx = 1: 1: N
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
%     z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

%     if mediumTable(m, n, ell) == 2 
%         if ell == z_idx_up 
%             B(idx) = V_0;
%             A_row_SAI    = zeros(1, x_idx_max * y_idx_max * z_idx_max);
%             A_row_SAI(idx) = 1;
%             A(idx, :) = A_row_SAI;
%         elseif ell == z_idx_down
%             A_row_SAI    = zeros(1, x_idx_max * y_idx_max * z_idx_max);
%             A_row_SAI(idx) = 1;
%             A(idx, :) = A_row_SAI;
%         end
%     end
% end

% % Normalize each rows
% for idx = 1: 1: N
%     % tmp_vector = sparseS{ idx };
%     % num = uint8(size(tmp_vector, 2)) / 2;
%     % MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
%     MAX_row_value = max( abs( A(idx, :) ) );
%     % tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
%     % sparseS{ idx } = tmp_vector;
%     A(idx, :) = A(idx, :) ./ MAX_row_value;
%     B(idx) = B(idx) ./ MAX_row_value;
% end

% load('tmpp.mat');

Tol = 0.2: 0.1: 1.0;
r_SAI = zeros(length(Tol), 1);

% for idx = 1: 1: length(Tol)
%     % sparse approximate inverse 
%     % G_vv = diag(repmat(1, 1, 1000));
%     A_SAI = zeros(size(A));
%     A_Inv = zeros(size(A));

%     tic;
%     disp('calculation of SAI of A');
%     A_SAI = getSAI(A, Tol(idx));
%     toc;
%     % calculate the residual: 
%     r_SAI(idx) = norm(A * ( A_SAI * B ) - B) / norm(B);
% end

dim = size(A, 1);
sparseA = cell(1, dim);
A_SAI = zeros(dim, dim);
try
for idx = 1: 1: dim
    if idx == 13
        ;
    end
    sparseA{ idx } = Nrml2Sparse( A(:, idx)' )';
end
catch
    idx
end

sparseA_SAI = cell(1, dim);

tic;
[ sparseA_SAI, column_res ] = getSAI_sparse(sparseA, dim, 0.3);
toc;

for idx = 1: 1: dim
    A_SAI(:, idx) = sparse2NrmlVec( sparseA_SAI{ idx }, dim );
end

A_Inv = inv(A);

x = A \ B;


% r = norm(A * x - B);
relRes = norm( A_SAI * B - x ) / norm(x)
relRes2 = norm( B - A * A_SAI * B ) / norm(B)

% length(find(column_res > 0.4));
% Id_Matrix = diag( repmat( 1, 1, size(A, 1) ) );
% norm(A * A_SAI - Id_Matrix)
% % % save('A_SAI_A_Inv.mat');
% % load('A_SAI_A_Inv.mat');

% x_mesh      = zeros( z_idx_max, x_idx_max );
% z_mesh      = zeros( z_idx_max, x_idx_max );
x_SAI = A_SAI * B;
for idx = 1: 1: N
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    Phi(m ,n, ell) = x_SAI(idx);
end

x_mesh = squeeze(shiftedCoordinate( :, int64( w_y / (2 * dy) + 1 ), :, 1))';
z_mesh = squeeze(shiftedCoordinate( :, int64( w_y / (2 * dy) + 1 ), :, 3))';

% [ x_mesh, z_mesh ] = meshgrid(-w_x / 2: dx: w_x / 2);
figure(2);
clf;
pcolor(x_mesh * 100, z_mesh * 100, abs( squeeze( Phi(:, int64( w_y / (2 * dy) + 1 ), :) )' ));
axis equal;
% shading flat
shading interp
colormap jet;
set(gca,'fontsize',20);
set(gca,'LineWidth',2.0);
cb = colorbar;
% caxis([-50, 50]);
% caxis([0, 100]);
ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
set(cb, 'FontSize', 18);
box on;
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);

% figure(2);
% clf;
% [X, Y] = meshgrid(1: 1: size(A, 1)); 
% pcolor(X, Y, abs( flipud(A) ));
% colorbar;
% shading flat;
% saveas(figure(2), 'A.jpg');

% figure(3);
% clf;
% pcolor(X, Y, abs( flipud(A_SAI) ));
% colorbar;
% shading flat;
% saveas(figure(3), 'A_SAI.jpg');

% figure(4);
% clf;
% pcolor(X, Y, abs( flipud(A_Inv) ));
% colorbar;
% shading flat;
% saveas(figure(4), 'A_Inv.jpg');

% normalized the matrix
% calculate the corresponding residual of SAI solutoin and the inverse solution;
% and check why the SAI only have one element in each column