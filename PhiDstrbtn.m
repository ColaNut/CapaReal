clc; clear;
load('TestCase2.mat');
% XZmidY      = zeros( z_idx_max, x_idx_max );
PhiHlfY     = zeros( x_idx_max, 3, z_idx_max );
ThrXYZCrndt = zeros( x_idx_max, 3, z_idx_max, 3);
ThrMedValue = zeros( x_idx_max, 3, z_idx_max );
SegValueXZ  = zeros( x_idx_max, z_idx_max, 6, 8, 'uint8' );
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

    CrossN = int32( 0 / dy + h_torso / ( 2 * dy ) + 1 );

    if n == CrossN
        % XZmidY( ell, m ) = bar_x_my_gmres(idx);
        PhiHlfY( m, 2, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 2, :, :) = shiftedCoordinateXYZ( :, n, :, :);
        ThrMedValue( :, 2, : ) = mediumTable( :, n, : );
        SegValueXZ( m, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
        x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
        z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';
        y = 0;
        paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    end

    if n == CrossN + 1
        PhiHlfY( m, 3, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 3, :, :) = shiftedCoordinateXYZ( :, n, :, :);
        ThrMedValue( :, 3, : ) = mediumTable( :, n, : );
    end

    if n == CrossN - 1
        PhiHlfY( m, 1, ell ) = bar_x_my_gmres(idx);
        ThrXYZCrndt( :, 1, :, :) = shiftedCoordinateXYZ( :, n, :, :);
        ThrMedValue( :, 1, : ) = mediumTable( :, n, : );
    end

end

figure(1);
PhiHlfY2 = squeeze(PhiHlfY(:, 2, :));
pcolor(x_mesh * 100, z_mesh * 100, abs( PhiHlfY2' )); 
colorbar;
set(gca,'fontsize',14);
% axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
%         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
%         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
% axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
%         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
%         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
view(2);
hold on;
plotMap( paras2dXZ, dx, dz );

% calculate the E field
SARseg = zeros( x_idx_max, z_idx_max, 6, 8 );
TtrVol = zeros( x_idx_max, z_idx_max, 6, 8 );
MidPnts9Crdnt = zeros( x_idx_max, z_idx_max, 9, 3 );

for idx = 1: 1: x_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    n = 2;

    ell = int64( ( idx - m ) / x_idx_max + 1 );

    if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        [ SARseg( m, ell, :, : ), TtrVol( m, ell, :, : ), MidPnts9Crdnt( m, ell, :, : ) ] ...
                            = calSARseg( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                        dx, dy, dz, x_idx_max, z_idx_max, sigma );
    end
end

MidMedValue = squeeze( ThrMedValue(:, 2, :) );
% T1 = squeeze(ThrMedValue(:, 1, :));
% T2 = squeeze(ThrMedValue(:, 2, :));
% T3 = squeeze(ThrMedValue(:, 3, :));

% plot SAR
figure(2);
disp('Time to plot SAR');
tic;
for idx = 1: 1: x_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    ell = int64( ( idx - m ) / x_idx_max + 1 );

    PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, ell, :, :) );
    PntMidPnts9Crdnt(:, 2) = [];

    if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        plotSAR_XZ( squeeze( SARseg( m, ell, :, :) ), squeeze( TtrVol( m, ell, :, : ) ), PntMidPnts9Crdnt );
        hold on;
    end

end
toc;
axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 18);
set(gca,'fontsize',14);
view(2);
axis equal;
plotMap( paras2dXZ, dx, dz );

% figure(3);
% disp('Time to plot SAR in ROI');
% tic;
% for idx = 1: 1: x_idx_max * z_idx_max
%     % idx = ( ell - 1 ) * x_idx_max + m;
%     tmp_m = mod( idx, x_idx_max );
%     if tmp_m == 0
%         m = x_idx_max;
%     else
%         m = tmp_m;
%     end

%     ell = int64( ( idx - m ) / x_idx_max + 1 );

% % Start from here: delete the y information from PntMidPnts9Crdnt
%     PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, ell, :, :) );
%     PntMidPnts9Crdnt(:, 2) = [];

%     if m >= 64 && m <= 97 && ell >= 25 && ell <= 56 
%         plotSAR_XZ( squeeze( SARseg( m, ell, :, :) ), squeeze( TtrVol( m, ell, :, : ) ), PntMidPnts9Crdnt );
%         hold on;
%     end

% end
% toc;
% axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 18);
% set(gca,'fontsize',14);
% view(2);
% axis equal;
% plotMap( paras2dXZ, dx, dz );

% Start from here: plot the ROI. 

% az = 0;
% el = 0;
% view(az, el);

% wghtSAR = calE( PhiHlfY, ThrXYZCrndt, ThrMedValue, dx, dy, dz, x_idx_max, z_idx_max );
% % surf(x_mesh * 100, z_mesh * 100, sqrt( abs(E_x).^2 + abs(E_y).^2 + abs(E_z).^2 ), 'EdgeColor','none'); 
% pcolor(x_mesh * 100, z_mesh * 100, sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 )); 
% % shading flat;
% % shading interp;
% colorbar;
% colormap jet;
% set(gca,'fontsize',18);
% axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
%         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
%         min(min(abs( sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 ) ))), max(max(abs( sqrt( abs(Ex).^2 + abs(Ey).^2 + abs(Ez).^2 ) ))) ] );
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\sqrt{ E^\ast_x E_x + E^\ast_y E_y + E^\ast_z E_z }$ ($V/m$)','Interpreter','LaTex', 'FontSize', 18);
% view(2);
% hold on;
% plotMap( paras2dXZ, dx, dz );

% figure(3);
% E_x_normalized_0 = real(Ex) ./ sqrt( real(Ex).^2 + real(Ez).^2 );
% E_z_normalized_0 = real(Ez) ./ sqrt( real(Ex).^2 + real(Ez).^2 );
% quiver( x_mesh * 100, z_mesh * 100, E_x_normalized_0, E_z_normalized_0, 'k', 'LineWidth', 2.0 );
% set(gca,'fontsize',18);
% axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
%         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100 ] );
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% hold on;
% plotMap( paras2dXZ, dx, dz );