clc; clear;
load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0906CervixMQS\0906_Cervix_preK1.mat')
load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0906CervixMQS\0907CervixMQS_zerothOrder.mat', 'H_XZ', 'H_XY', 'H_YZ', 'E_XZ', 'E_XY', 'E_YZ');
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0903LungMQS\0903LungMQS_1pnt2MHz_MuPrmPrm_secondOrder.mat');
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0829LungMQS_1dot2MHz\0829_1dot2MHz_zerothOrder.mat');

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% === === % ===================== % === === %
% === === % J_0 modification part % === === %
% === === % ===================== % === === %
% frequency from 100 kHz to 1.2 MHz; J_0 from 5,000 to 212.5
E_XZ = E_XZ * 400 / 80;
E_XY = E_XY * 400 / 80;
E_YZ = E_YZ * 400 / 80;

H_XZ = H_XZ * 400 / 80;
H_XY = H_XY * 400 / 80;
H_YZ = H_YZ * 400 / 80;

% === === % ================== % === === %
% === === % Plotting H_XZ part % === === %
% === === % ================== % === === %
H_oneXZ = H_XZ;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0906CervixMQS\';
CaseName = '0907';

H_oneXZabs = zeros(x_idx_max, z_idx_max, 6, 8);
for m_idx = 1: 1: x_idx_max
    for n_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                H_oneXZabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(H_oneXZ(m_idx, n_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

figure(8);
clf;
% plot SAR XZ
myRange = [ 1e-1, 1e4 ];
caxis(myRange);
axis equal;
axis( [ - 2.5, 2.5, - 2.5, 2.5 ] );
cbar = colorbar('peer', gca, 'Yscale', 'log');
set(gca, 'Visible', 'off')
log_axes = axes('Position', get(gca, 'Position'));
ylabel(cbar, '$\left| \bar{H}^{(0)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
set(cbar, 'FontSize', 18 );

disp('Time to plot H_XZ');
tic;
for idx = 1: 1: x_idx_max * z_idx_max
    [ m, ell ] = getML(idx, x_idx_max);
    if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
        m_v = 2 * m - 1;
        n_v = 2 * tumor_n - 1;
        ell_v = 2 * ell - 1;
        bypasser = zeros(3, 9);
        V27Crdnt = zeros(3, 9, 3);
        [ bypasser, V27Crdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
        % [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
        MidPnts9Crdnt = getMidPnts9CrdntXZ( V27Crdnt );
        plotPntH( squeeze(H_oneXZabs(m, ell, :, :)), MidPnts9Crdnt, 'XZ' );
    end
end
toc;
hold on;

caxis(log10(myRange));
colormap jet;
% axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
axis equal;
axis( [ - 2.5, 2.5, - 2.5, 2.5 ] );
set(log_axes,'fontsize',20);
set(log_axes,'LineWidth',2.0);
% zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
box on;
view(2);
paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
plotMap( paras2dXZ, dx, dz );
% plotRibXZ(Ribs, SSBone, dx, dz);
% plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
saveas(figure(8), fullfile(fname, strcat(CaseName, 'H0_XZ_MQS')), 'jpg');
% saveas(figure(9), 'E_XZ_FullWave.jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');

% === === % ================== % === === %
% === === % Plotting H_YZ part % === === %
% === === % ================== % === === %
H_oneYZ = H_YZ;
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0906CervixMQS\';
CaseName = '0907';

H_oneYZabs = zeros(x_idx_max, z_idx_max, 6, 8);
for n_idx = 1: 1: y_idx_max
    for ell_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                H_oneYZabs(n_idx, ell_idx, f_idx, t_idx) = norm( squeeze(H_oneYZ(n_idx, ell_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

figure(9);
clf;
% plot SAR YZ
myRange = [ 1e-1, 1e4 ];
caxis(myRange);
axis equal;
axis( [ - 2.5, 2.5, - 2.5, 2.5 ] );
cbar = colorbar('peer', gca, 'Yscale', 'log');
set(gca, 'Visible', 'off')
log_axes = axes('Position', get(gca, 'Position'));
ylabel(cbar, '$\left| \bar{H}^{(0)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
set(cbar, 'FontSize', 18 );

disp('Time to plot H_YZ');
tic;
for idx = 1: 1: y_idx_max * z_idx_max
    [ n, ell ] = getML(idx, x_idx_max);
    if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
        m_v = 2 * tumor_m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        bypasser = zeros(3, 9);
        V27Crdnt = zeros(3, 9, 3);
        [ bypasser, V27Crdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
        % [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
        MidPnts9Crdnt = getMidPnts9CrdntYZ( V27Crdnt );
        plotPntH( squeeze(H_oneYZabs(n, ell, :, :)), MidPnts9Crdnt, 'YZ' );
    end
end
toc;
hold on;

caxis(log10(myRange));
colormap jet;
% axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
axis equal;
axis( [ - 2.5, 2.5, - 2.5, 2.5 ] );
set(log_axes,'fontsize',20);
set(log_axes,'LineWidth',2.0);
% zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
box on;
view(2);
paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
plotYZ( paras2dYZ, dy, dz );
% plotRibYZ(Ribs, SSBone, dx, dz);
% plotGridLineYZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
saveas(figure(9), fullfile(fname, strcat(CaseName, 'H0_YZ_MQS')), 'jpg');
% saveas(figure(9), 'E_YZ_FullWave.jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
