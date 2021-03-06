% % clc; clear;
% fname = 'E:\Kevin\20180811_case4_nonLinear';
% % EQS_Flag = 1;
% % FullWave_Flag = 0;
% % if EQS_Flag
%     CaseName = '20180816_LungEQS_case4_nonlinear';
% % elseif FullWave_Flag
% %     CaseName = '0715FullWavePhi';
% % end
% load( strcat(fname, '\', CaseName, '.mat'), 'bar_x_my_gmresPhi' );
% % load( strcat(fname, '\BasicParameters.mat') );

E_zeroXZ = zeros(x_idx_max, z_idx_max, 6, 8, 3);
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_n    = int64( h_torso / (2 * dy) + 1 );
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n == tumor_n && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        Phi27 = zeros(3, 9);
        PntsIdx      = zeros( 3, 9 );
        PntsCrdnt    = zeros( 3, 9, 3 );
        % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
        [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
        PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
        Phi27 = bar_x_my_gmresPhi(PntsIdx);
        E_zeroXZ(m, ell, :, :, :) = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), ones(size(sigma)), zeros(size(sigma)) );
    end
end
toc;

E_zeroXZabs = zeros(x_idx_max, z_idx_max, 6, 8);
for m_idx = 1: 1: x_idx_max
    for n_idx = 1: 1: z_idx_max
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                E_zeroXZabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(E_zeroXZ(m_idx, n_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

figure(9);
clf;
% % plot SAR XZ
% axis equal;
% axis( [ - 20, 20, - 15, 15 ] );
% myRange = [ 1e-1, 1e4 ];
% caxis(myRange);
% % cbar = colorbar('peer', gca, 'Yscale', 'log');
% set(gca, 'Visible', 'off')
% log_axes = axes('Position', get(gca, 'Position'));
% % if EQS_Flag
% %     ylabel(cbar, '$\left| \bar{E}^{(0)} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
% % elseif FullWave_Flag
% %     ylabel(cbar, '$\left| \bar{E} \ \right|$ (V/m)', 'Interpreter','LaTex', 'FontSize', 20);
% % end
% % set(cbar, 'FontSize', 18 );

disp('Time to plot SAR');
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
        plotPntH( squeeze(E_zeroXZabs(m, ell, :, :)), MidPnts9Crdnt, 'XZ' );
    end
end
toc;
hold on;

myRange_specific = [ 1e-1, 1e-0, 1e1, 1e2, 1e3, 1e4 ];
myRange = [ myRange_specific(1), myRange_specific(end) ];
cb = colorbar;
colormap jet;
caxis(log10(myRange));
axis equal;
axis( [ - 20, 20, - 15, 15 ] );
% set(cb, 'FontSize', 18, 'YTick', log10(myRange_specific), 'YTickLabel', myRange_specific);
set(cb, 'FontSize', 15, 'YTick', log10(myRange_specific), 'TickLabelInterpreter', 'latex', 'YTickLabel', {'$10^{-1}$', '$10^0$', '$10^1$', '$10^2$', '$10^3$', '$10^4$'});

cb.Label.Interpreter = 'LaTex';
cb.Label.String = '$\left| \bar{E}^{(0)} \ \right|$ (V/m)';
cb.Label.FontSize = 15;
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 15);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 15);
axis equal;
axis( [ - 20, 20, - 15, 15 ] );
set(gca,'fontsize', 15);
set(gca,'LineWidth',2.0);
box on;
view(2);
plotMap( paras2dXZ, dx, dz );
plotRibXZ(Ribs, SSBone, dx, dz);

% caxis(log10(myRange));
% colormap jet;
% % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% axis equal;
% axis( [ - 20, 20, - 15, 15 ] );
% set(log_axes,'fontsize',20);
% set(log_axes,'LineWidth',2.0);
% % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
% box on;
% view(2);
% paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );
% plotRibXZ(Ribs, SSBone, dx, dz);
% % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
% % if EQS_Flag
% %     saveas(figure(9), fullfile(fname, strcat('\', CaseName, 'E_0_XZ_EQS(bw)')), 'jpg');
% % elseif FullWave_Flag
% %     saveas(figure(9), fullfile(fname, 'Power300E_XZ_EQS(bw)'), 'jpg');
% % end
% % saveas(figure(9), 'E_XZ_FullWave.jpg');

saveas(figure(9), 'E_XZ_0.jpg');