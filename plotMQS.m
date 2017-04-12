function plotMQS( Paras_Mag )

% Paras_Mag = [ w_x, w_y, w_z, ...
%                 h_x, h_y, h_z, ...
%                 ell_y, r_c, ...
                % dx, dy, dz ];

% m -> cm
w_x     = Paras_Mag(1)  * 100;
w_y     = Paras_Mag(2)  * 100;
w_z     = Paras_Mag(3)  * 100;

h_x     = Paras_Mag(4)  * 100;
h_y     = Paras_Mag(5)  * 100;
h_z     = Paras_Mag(6)  * 100;
ell_y   = Paras_Mag(7)  * 100;
r_c     = Paras_Mag(8)  * 100;

dx      = Paras_Mag(9)  * 100;
dy      = Paras_Mag(10) * 100;
dz      = Paras_Mag(11) * 100;

h_conductor = 0.5; % (cm)

plotEllipse( r_c, 0, - r_c, 0, r_c, dx, dz );
plotEllipse( r_c + h_conductor, 0, - r_c - h_conductor, 0, r_c + h_conductor, dx, dz );

% % plot electrode
% t = linspace( 0, 2 * pi, 400 );
% X = bolus_a * cos(t);
% Z = bolus_b * sin(t);
% ElectrodeX = tumor_x;
% % The below parameters need to be synchronize with UpElecrode and DwnELectrode
% h_x_halfUp = 6;
% h_x_halfDwn = 10;
% UpIdx = find( Z > 0 & X >= ElectrodeX - h_x_halfUp & X <= ElectrodeX + h_x_halfUp );
% DwnIdx = find( Z < 0 & X >= ElectrodeX - h_x_halfDwn & X <= ElectrodeX + h_x_halfDwn );
% plot(X(UpIdx), Z(UpIdx), 'Color', [0, 0, 0], 'LineWidth', 4.5);
% hold on;
% plot(X(DwnIdx), Z(DwnIdx), 'Color', [0, 0, 0], 'LineWidth', 4.5);
% hold on;
% % Phi: 2.7; 2.7
% % SAR: 4.5; 4.5

% x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% [ X_grid, Z_grid ] = meshgrid(x_grid, z_grid);
% % for idx = 1: 1: size(Z_grid, 1)
% %     scatter( x_grid, Z_grid(idx, :), 10 );
% %     hold on;
% % end
% % axis( [ min(x_grid), max(x_grid), min(z_grid), max(z_grid) ] );

end