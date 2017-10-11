% % % === === % ================================= % === === %
% % % === === % Reload zeroth-order E and H field % === === %
% % % === === % =================================  % === === %
% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0824LiverMQS\0824preK1_liver.mat')
% % % load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0911LiverXiMod\MQS\0911_1dot2MHz_Liver_zerothOrder.mat');
load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0911LiverXiMod\MQS\0912_1dot2MHz_Liver_zerothOrder.mat');
load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0911LiverXiMod\MQS\0911_1dot2MHz_Liver_Q_s_MNP.mat', 'muPrmPrm_MNP', 'Omega_0');

% In 0911_1dot2MHz_Liver_zerothOrder.mat, E_XZ should be modified to E_XZ = E_XZ * (400 / 50) (1.2 / 8); 

sigma(2) = 0;

% % === === % ========= % === === %
% % === === % Flag Sets % === === %
% % === === % ========= % === === %
E_XZ_flag = 1;
E_XY_flag = 1;
E_YZ_flag = 1;

SAR_XZ_flag = 1;
SAR_XY_flag = 1;
SAR_YZ_flag = 1;

SAR_XZ_MNP_flag = 1;

% === === % ================================= % === === %
% === === % J_0 modification part (cancelled) % === === %
% === === % ================================= % === === %
% frequency from 100 kHz to 8 MHz; J_0 from 5,000 to 5,000 / 80
% the electric field is computed using Omega = 2 * pi * 8 * 10^6; instead of 2 * pi * 1.2 * 10^6

E_XZ = E_XZ * (400 / 50); 
E_XY = E_XY * (400 / 50); 
E_YZ = E_YZ * (400 / 50); 

H_XZ = H_XZ * (400 / 50); 
H_XY = H_XY * (400 / 50); 
H_YZ = H_YZ * (400 / 50); 

% === === % =============== % === === %
% === === % Parameters part % === === %
% === === % =============== % === === %
E_oneXZ = E_XZ;
E_oneXY = E_XY;
E_oneYZ = E_YZ;

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0911LiverXiMod\MQS\';
CaseName = '0911';

% === === % =================== % === === %
% === === % Preparing Abs value % === === %
% === === % =================== % === === %
E_oneXZabs = zeros(x_idx_max, z_idx_max, 6, 8);
for m_idx = 1: 1: x_idx_max
    for ell_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                E_oneXZabs(m_idx, ell_idx, f_idx, t_idx) = norm( squeeze(E_oneXZ(m_idx, ell_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

H_XZabs = zeros(x_idx_max, z_idx_max, 6, 8);
for m_idx = 1: 1: x_idx_max
    for ell_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                H_XZabs(m_idx, ell_idx, f_idx, t_idx) = norm( squeeze(H_XZ(m_idx, ell_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

E_oneXYabs = zeros(x_idx_max, y_idx_max, 6, 8);
for m_idx = 1: 1: x_idx_max
    for n_idx = 1: 1: y_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                E_oneXYabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(E_oneXY(m_idx, n_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

E_oneYZabs = zeros(y_idx_max, z_idx_max, 6, 8);
for n_idx = 1: 1: y_idx_max
    for ell_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                E_oneYZabs(n_idx, ell_idx, f_idx, t_idx) = norm( squeeze(E_oneYZ(n_idx, ell_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

% === === % ====== % === === %
% === === % E part % === === %
% === === % ====== % === === %
if E_XZ_flag
    figure(27);
    clf;
    % plot SAR XZ
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, '$\left| \bar{E}^{(1)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot E_XZ');
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
            plotPntH( squeeze(E_oneXZabs(m, ell, :, :)), MidPnts9Crdnt, 'XZ' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverXZ( paras, tumor_y, dx, dz );
    % paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    % plotMap( paras2dXZ, dx, dz );
    % plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(27), fullfile(fname, strcat(CaseName, 'E1_XZ_MQS(bw)')), 'jpg');
end

if E_XY_flag
    figure(28);
    clf;
    % plot SAR XZ
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 10, 10 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, '$\left| \bar{E}^{(1)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot E_XY');
    tic;
    for idx = 1: 1: x_idx_max * y_idx_max
        [ m, n ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * tumor_ell - 1;
            bypasser = zeros(3, 9);
            V27Crdnt = zeros(3, 9, 3);
            [ bypasser, V27Crdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
            % [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
            MidPnts9Crdnt = getMidPnts9CrdntXY( V27Crdnt );
            plotPntH( squeeze(E_oneXYabs(m, n, :, :)), MidPnts9Crdnt, 'XY' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 10, 10 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverXY( paras, tumor_z, dx, dy );
    % paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
    % plotXY( paras2dXY, dx, dy );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(28), fullfile(fname, strcat(CaseName, 'E1_XY_MQS(bw)')), 'jpg');
end

if E_YZ_flag
    figure(29);
    clf;
    % plot SAR XZ
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 10, 10, - 15, 15 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, '$\left| \bar{E}^{(1)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot E_YZ');
    tic;
    for idx = 1: 1: y_idx_max * z_idx_max
        [ n, ell ] = getML(idx, y_idx_max);
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            m_v = 2 * tumor_m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            bypasser = zeros(3, 9);
            V27Crdnt = zeros(3, 9, 3);
            [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
            MidPnts9Crdnt = getMidPnts9CrdntYZ( V27Crdnt );
            plotPntH( squeeze(E_oneYZabs(n, ell, :, :)), MidPnts9Crdnt, 'YZ' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 10, 10, - 15, 15 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverYZ( paras, tumor_x, dy, dz );
    % paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
    % plotYZ( paras2dYZ, dy, dz );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(29), fullfile(fname, strcat(CaseName, 'E1_YZ_MQS(bw)')), 'jpg');
end

% === === % ======== % === === %
% === === % SAR part % === === %
% === === % ======== % === === %
tmpSegMed = SegMed;
tmpSegMed(find(tmpSegMed > 7)) = 1;
SAR_XZ = zeros(x_idx_max, z_idx_max, 6, 8);
SAR_XY = zeros(x_idx_max, y_idx_max, 6, 8);
SAR_YZ = zeros(y_idx_max, z_idx_max, 6, 8);
if SAR_XZ_flag
    SAR_XZ = sigma( squeeze(tmpSegMed(:, tumor_n, :, :, :)) ) .* E_oneXZabs.^2 ./ (2 * rho( squeeze(tmpSegMed(:, tumor_n, :, :, :)) ));

    figure(31);
    clf;
    % plot SAR XZ
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot SAR-XZ');
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
            plotPntH( squeeze(SAR_XZ(m, ell, :, :)), MidPnts9Crdnt, 'XZ' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverXZ( paras, tumor_y, dx, dz );
    % paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    % plotMap( paras2dXZ, dx, dz );
    % plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(31), fullfile(fname, strcat(CaseName, 'SAR_XZ_MQS(bw)')), 'jpg');
    % % saveas(figure(31), 'E_XZ_FullWave.jpg');
end

if SAR_XY_flag
    SAR_XY = sigma( squeeze(tmpSegMed(:, :, tumor_ell, :, :)) ) .* E_oneXYabs.^2 ./ (2 * rho( squeeze(tmpSegMed(:, :, tumor_ell, :, :)) ));

    figure(32);
    clf;
    % plot SAR XY
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 10, 10 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot SAR-XY');
    tic;
    for idx = 1: 1: x_idx_max * y_idx_max
        [ m, n ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * tumor_ell - 1;
            bypasser = zeros(3, 9);
            V27Crdnt = zeros(3, 9, 3);
            [ bypasser, V27Crdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
            % [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
            MidPnts9Crdnt = getMidPnts9CrdntXY( V27Crdnt );
            plotPntH( squeeze(SAR_XY(m, n, :, :)), MidPnts9Crdnt, 'XY' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 10, 10 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverXY( paras, tumor_z, dx, dy );
    % paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
    % plotXY( paras2dXY, dx, dy );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(32), fullfile(fname, strcat(CaseName, 'SAR_XY_MQS(bw)')), 'jpg');
    % % saveas(figure(32), 'E_XZ_FullWave.jpg');
end

if SAR_YZ_flag
    SAR_YZ = sigma( squeeze(tmpSegMed(tumor_m, :, :, :, :)) ) .* E_oneYZabs.^2 ./ (2 * rho( squeeze(tmpSegMed(tumor_m, :, :, :, :)) ));

    figure(33);
    clf;
    % plot SAR XY
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 10, 10, - 15, 15 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot SAR-YZ');
    tic;
    for idx = 1: 1: y_idx_max * z_idx_max
        [ n, ell ] = getML(idx, y_idx_max);
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            if n == (y_idx_max + 1) / 2 && ell == (z_idx_max + 1) / 2
                ;
            end
            m_v = 2 * tumor_m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            bypasser = zeros(3, 9);
            V27Crdnt = zeros(3, 9, 3);
            [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
            MidPnts9Crdnt = getMidPnts9CrdntYZ( V27Crdnt );
            plotPntH( squeeze(SAR_YZ(n, ell, :, :)), MidPnts9Crdnt, 'YZ' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 10, 10, - 15, 15 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverYZ( paras, tumor_x, dy, dz );
    % paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
    % plotYZ( paras2dYZ, dy, dz );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(33), fullfile(fname, strcat(CaseName, 'SAR_YZ_MQS(bw)')), 'jpg');
    % % saveas(figure(33), 'E_XZ_FullWave.jpg');
end

% === === % ============================= % === === %
% === === % SAR of Magnetic nano-particle % === === %
% === === % ============================= % === === %
SAR_XZ_MNP = zeros(x_idx_max, z_idx_max, 6, 8);
SegMedMask = SegMed;
SegMedMask(find(SegMedMask ~= 5)) = 0;
SegMedMask(find(SegMedMask == 5)) = 1;
if SAR_XZ_MNP_flag
    % muPrmPrm_MNP = 4.4743;
    % muPrmPrm_MNP = 0.3759;
    % muPrmPrm_MNP = 0.6214;
    SAR_XZ_MNP = 0.5 * Omega_0 * Mu_0 * muPrmPrm_MNP * double(squeeze(SegMedMask(:, tumor_n, :, :, :))) .* H_XZabs.^2 / rho(5);
    
    figure(34);
    clf;
    % plot SAR XZ
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel(cbar, '$\Vert \bar{E}^{(0)} \ \Vert$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );

    disp('Time to plot SAR-XZ-MNP');
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
            plotPntH( squeeze(SAR_XZ_MNP(m, ell, :, :)), MidPnts9Crdnt, 'XZ' );
        end
    end
    toc;
    hold on;

    caxis(log10(myRange));
    colormap gray;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotLiverXZ( paras, tumor_y, dx, dz );
    % paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    % plotMap( paras2dXZ, dx, dz );
    % plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(34), fullfile(fname, strcat(CaseName, 'Liver_SAR_XZ_MNP_MQS(bw)')), 'jpg');
    % % saveas(figure(34), 'E_XZ_FullWave.jpg');
end