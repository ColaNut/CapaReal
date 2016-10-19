% clc; clear;
% load('FirstTest.mat');
% XZmidY      = zeros( z_idx_max, x_idx_max );
XZmidY_E    = zeros( x_idx_max, 3, z_idx_max );
ThrXYZCrndt = zeros( x_idx_max, 3, z_idx_max, 3);
x_mesh      = zeros( z_idx_max, x_idx_max );
z_mesh      = zeros( z_idx_max, x_idx_max );

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
        % XZmidY( ell, m ) = bar_x_my_gmres(idx);
        XZmidY_E( m, 2, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 2, :, :) = shiftedCoordinateXYZ( :, n, :, :);
        x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
        z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';
        y = 0;
        paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    end

    if n == int32( ( 1 + y_idx_max ) / 2 ) + 1
        XZmidY_E( m, 3, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 3, :, :) = shiftedCoordinateXYZ( :, n, :, :);
    end

    if n == int32( ( 1 + y_idx_max ) / 2 ) - 1
        XZmidY_E( m, 1, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 1, :, :) = shiftedCoordinateXYZ( :, n, :, :);
    end

end

figure(1);
XZmidY = squeeze(XZmidY_E(:, 2, :));
pcolor(x_mesh * 100, z_mesh * 100, abs( XZmidY' )); 
colorbar;
set(gca,'fontsize',14);
axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
        min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
        min(min(abs( XZmidY' ))), max(max(abs( XZmidY' ))) ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
view(2);
hold on;
plotMap( paras2dXZ, dx, dz );

Ex = zeros( size(XZmidY') );
Ey = zeros( size(XZmidY') );
Ez = zeros( size(XZmidY') );

figure(2);
[ Ex, Ey, Ez ] = calE( XZmidY_E, ThrXYZCrndt, dx, dy, dz, x_idx_max, z_idx_max );
% surf(x_mesh * 100, z_mesh * 100, sqrt( abs(E_x).^2 + abs(E_y).^2 + abs(E_z).^2 ), 'EdgeColor','none'); 
pcolor(x_mesh * 100, z_mesh * 100, sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 )); 
% shading flat;
% shading interp;
colorbar;
colormap jet;
set(gca,'fontsize',18);
axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
        min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
        min(min(abs( sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 ) ))), max(max(abs( sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 ) ))) ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
zlabel('$\sqrt{ E^\ast_x E_x + E^\ast_y E_y + E^\ast_z E_z }$ ($V/m$)','Interpreter','LaTex', 'FontSize', 18);
view(2);
hold on;
plotMap( paras2dXZ, dx, dz );

figure(3);
E_x_normalized_0 = real(Ex) ./ sqrt( real(Ex).^2 + real(Ez).^2 );
E_z_normalized_0 = real(Ez) ./ sqrt( real(Ex).^2 + real(Ez).^2 );
quiver( x_mesh * 100, z_mesh * 100, E_x_normalized_0, E_z_normalized_0, 'k', 'LineWidth', 2.0 );
set(gca,'fontsize',18);
axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
        min(min(z_mesh)) * 100, max(max(z_mesh)) * 100 ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
hold on;
plotMap( paras2dXZ, dx, dz );