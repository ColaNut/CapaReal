% E_zeroXZ = zeros(x_idx_max, z_idx_max, 6, 8, 3);
% n_mid    = int64( h_torso / (2 * dy) + 1 );
% tic;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if n == n_mid
%         m_v = 2 * m - 1;
%         n_v = 2 * n - 1;
%         ell_v = 2 * ell - 1;
%         Phi27 = zeros(3, 9);
%         PntsIdx      = zeros( 3, 9 );
%         PntsCrdnt    = zeros( 3, 9, 3 );
%         % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
%         [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
%         PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
%         Phi27 = bar_x_my_gmresPhi(PntsIdx);

%         E_zeroXZ(m, ell, :, :, :) = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), ones(size(sigma)), zeros(size(sigma)) );
%     end
% end
% toc;

% E_zeroXZabs = zeros(x_idx_max, z_idx_max, 6, 8);
% for m_idx = 1: 1: x_idx_max
%     for n_idx = 1: 1: z_idx_max
%         for f_idx = 1: 1: 6
%             for t_idx = 1: 1: 8
%                 E_zeroXZabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(E_zeroXZ(m_idx, n_idx, f_idx, t_idx, :)) );
%             end
%         end
%     end
% end

figure(9);
clf;
% plot SAR XZ
myRange = [ 1e-1, 1e4 ];
caxis(myRange);
cbar = colorbar('peer', gca, 'Yscale', 'log');
set(gca, 'Visible', 'off')
log_axes = axes('Position', get(gca, 'Position'));
ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
set(cbar, 'FontSize', 18 );

disp('Time to plot SAR');
tic;
for idx = 1: 1: x_idx_max * z_idx_max
    [ m, ell ] = getML(idx, x_idx_max);
    if ell == z_idx_max - 1
        ;
    end
    if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
        m_v = 2 * m - 1;
        n_v = 2 * n_mid - 1;
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

caxis(log10(myRange));
colormap jet;
% axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
axis equal;
axis( [ - 20, 20, - 20, 20 ] );
set(log_axes,'fontsize',20);
set(log_axes,'LineWidth',2.0);
% zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
box on;
view(2);
plotMap( paras2dXZ, dx, dz );
plotRibXZ(Ribs, SSBone, dx, dz);
% plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
saveas(figure(9), 'E_zero_XZ_FullWave.jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');

