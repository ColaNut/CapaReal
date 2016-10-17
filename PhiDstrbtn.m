% clc; clear;
% load('FirstTest.mat');
XZmidY = zeros( z_idx_max, x_idx_max );
x_mesh = zeros( z_idx_max, x_idx_max );
z_mesh = zeros( z_idx_max, x_idx_max );
tmpCrdt = zeros( x_idx_max, z_idx_max, 2);
% tmpCrdt(:, :, 1) = shiftedCoordinateXYZ(:, 6, :, 1);
% tmpCrdt(:, :, 2) = shiftedCoordinateXYZ(:, 6, :, 3);

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    
    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    if mod( idx, x_idx_max * y_idx_max ) == 0
        n = y_idx_max;
    else
        n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
    end
    
    ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

    if n == int32( ( 1 + y_idx_max ) / 2 )
        XZmidY( ell, m ) = bar_x(idx);
        x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
        z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';
    end


    % if m == 4
    %     XZmidY( ell_all, n ) = bar_x_da(idx);
    % end
end

figure(1);
pcolor(x_mesh * 100, z_mesh * 100, abs(XZmidY)); 
colorbar;
set(gca,'fontsize',14);
axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, min(min(abs(XZmidY))), max(max(abs(XZmidY))) ] );
% axis( [ (- d_x) * 100, (w_0 + d_x) * 100, (- d_z(1)) * 100, (sum(thickness) + d_z(9)) * 100, min(min(Cross_section_da_mid)), max(max(Cross_section_da_mid)) ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
view(2);
hold on;

% tmpCrdt(:, :, 1) = 100 * x_mesh;
% tmpCrdt(:, :, 2) = 100 * z_mesh;
% plotShiftedCordinateXZ_all( tmpCrdt );

