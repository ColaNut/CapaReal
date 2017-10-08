% Vertex_Crdnt_B_unshift(:, :, :, 3) = Vertex_Crdnt_B(:, :, :, 3);
% Vertex_Crdnt_B(:, :, :, 3) = Vertex_Crdnt_B(:, :, :, 3) + es_z;

tumor_m = (tumor_x_es - es_x) / dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1;
tumor_n = (tumor_y_es - 0) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;
tumor_ell = (tumor_z_es - es_z) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1;

flag_XZ = 0;
flag_XY = 0;
flag_YZ = 1;

% bar_x_my_gmres_mod = zeros(x_idx_max * y_idx_max * z_idx_max, 1);
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;
%     p0_v = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
%     bar_x_my_gmres_mod(idx) = bar_x_my_gmresPhi(p0_v);
% end

if flag_XZ == 1

    PhiXZ        = zeros( x_max_vertex_B, 3, z_max_vertex_B );
    % Vertex_CrdntXZ = zeros( x_max_vertex_B, 3, z_max_vertex_B, 3);
    % ThrMedValue    = zeros( x_idx_max_B, 3, z_idx_max_B );
    % SegValueXZ     = zeros( x_idx_max_B, z_idx_max_B, 6, 8, 'uint8' );
    x_mesh = zeros( z_max_vertex_B, x_max_vertex_B );
    z_mesh = zeros( z_max_vertex_B, x_max_vertex_B );

    for vIdx_B = 1: 1: x_max_vertex_B * y_max_vertex_B * z_max_vertex_B
        [ m_v_B, n_v_B, ell_v_B ] = getMNL(vIdx_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
        tumor_n_v = 2 * tumor_n - 1;
        if n_v_B == tumor_n_v
            PhiXZ( m_v_B, 2, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, 2, :, :) = Vertex_Crdnt_B( :, n_v_B, :, :);
            % ThrMedValue( :, 2, : ) = mediumTable( :, n, : );
            % SegValueXZ( m, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
        end
        if n == tumor_n_v + 1
            PhiXZ( m_v_B, 3, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, 3, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            % ThrMedValue( :, 3, : ) = mediumTable( :, n, : );
        end
        if n == tumor_n_v - 1
            PhiXZ( m_v_B, 1, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, 1, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            % ThrMedValue( :, 1, : ) = mediumTable( :, n, : );
        end
    end

    figure(1);
    clf;
    x_mesh = squeeze(Vertex_Crdnt_B( :, tumor_n_v, :, 1))';
    z_mesh = squeeze(Vertex_Crdnt_B( :, tumor_n_v, :, 3))';
    pcolor(x_mesh * 100, z_mesh * 100, abs( squeeze(PhiXZ(:, 2, :))' ));
    axis equal;
    axis( [- 5, 5, 0, 10] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    % caxis([-50, 50]);
    caxis([0, 10]);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\left| \Phi \right| (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 20);
    view(2);
    hold on;
    paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    plotMap_Eso( paras2dXZ, dx, dz );
    plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
    % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');

    % === === % ============ % === === %
    % === === % Plotting SAR % === === %
    % === === % ============ % === === %

    % calculate the E field
    SARseg = zeros( x_idx_max_B, z_idx_max_B, 6, 8 );
    TtrVol = zeros( x_idx_max_B, z_idx_max_B, 6, 8 );
    MidPnts9Crdnt = zeros( x_idx_max_B, z_idx_max_B, 9, 3 );
    for idx = 1: 1: x_idx_max_B * z_idx_max_B
        [ m_B, ell_B ] = getML(idx, x_idx_max_B);
        n_B = CrossN;
        if m_B >= 2 && m_B <= x_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1 
            [ SARseg( m_B, ell_B, :, : ), TtrVol( m_B, ell_B, :, : ), MidPnts9Crdnt( m_B, ell_B, :, : ) ] ...
                        = calSARsegXZ_vrtx( m_B, int64(n_B), ell_B, PhiXZ, x_max_vertex_B, y_max_vertex_B, ...
                            Vertex_Crdnt_B, squeeze(SegMed_B(m_B, n_B, ell_B, :, :)), sigma, rho );
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    IntrpltPnts = zeros( x_max_vertex_B, z_max_vertex_B );
    for vIdx_B = 1: 1: x_max_vertex_B * z_max_vertex_B
        [ m_v_B, ell_v_B ] = getML(vIdx_B, x_max_vertex_B);
        if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
            IntrpltPnts(m_v_B, ell_v_B) = ExecIntrplt( m_v_B, ell_v_B, SARseg, TtrVol, 'XZ' );
        end
    end
    toc;

    % plot SAR XZ
    figure(2);
    clf;
    myRange = [ 1e-1, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [- 5, 5, 0, 10] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );
    hold on;

    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: x_idx_max_B * z_idx_max_B
        [ m_B, ell_B ] = getML(idx, x_idx_max_B);
        if m_B >= 2 && m_B <= x_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1
            m_v_B = 2 * m_B - 1;
            n_v_B = tumor_n_v;
            ell_v_B = 2 * ell_B - 1;
            Intrplt9Pnts     = getIntrplt9Pnts(m_B, ell_B, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m_B, ell_B, :, :) );
            PntMidPnts9Crdnt(:, 2) = [];
            plotSAR_Intrplt( squeeze( SARseg( m_B, ell_B, :, :) ), squeeze( TtrVol( m_B, ell_B, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'XZ', 0 );
        end

    end
    toc;

    caxis(log10(myRange));
    colormap jet;
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [- 5, 5, 0, 10] );
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    box on;
    view(2);
    plotMap_Eso( paras2dXZ, dx, dz );
    plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
    % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigXZ.mat') );
    % save('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108\Case0108TmprtrFigXZ.mat');
end

if flag_XY == 1

    PhiXY = zeros( x_max_vertex_B, y_max_vertex_B, 3 );
    % ThrXYZCrndt = zeros( x_idx_max, y_idx_max, 3, 3);
    % ThrMedValue = zeros( x_idx_max, y_idx_max, 3 );
    % SegValueXY  = zeros( x_idx_max_B, y_idx_max_B, 6, 8, 'uint8' );
    x_mesh      = zeros( y_max_vertex_B, x_max_vertex_B );
    y_mesh      = zeros( y_max_vertex_B, x_max_vertex_B );
    tumor_ell_v = 2 * tumor_ell - 1;

    for vIdx_B = 1: 1: x_max_vertex_B * y_max_vertex_B * z_max_vertex_B
        [ m_v_B, n_v_B, ell_v_B ] = getMNL(vIdx_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
        if ell_v_B == tumor_ell_v
            % XZmidY( ell, m ) = bar_x_my_gmres(idx);
            PhiXY( m_v_B, n_v_B, 2 ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, :, 2, :) = shiftedCoordinateXYZ( :, :, ell, :);
            % ThrMedValue( :, :, 2 ) = mediumTable( :, :, ell );
            % SegValueXY( m, n, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
        end

        if ell == tumor_ell_v + 1
            PhiXY( m_v_B, n_v_B, 3 ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, :, 3, :) = shiftedCoordinateXYZ( :, :, ell, :);
            % ThrMedValue( :, :, 3 ) = mediumTable( :, :, ell );
        end

        if ell == tumor_ell_v - 1
            PhiXY( m_v_B, n_v_B, 1 ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( :, :, 1, :) = shiftedCoordinateXYZ( :, :, ell, :);
            % ThrMedValue( :, :, 1 ) = mediumTable( :, :, ell );
        end

    end

    figure(6);
    clf;
    x_mesh = squeeze(Vertex_Crdnt_B( :, :, tumor_ell_v, 1))';
    y_mesh = squeeze(Vertex_Crdnt_B( :, :, tumor_ell_v, 2))';
    pcolor(x_mesh * 100, y_mesh * 100, abs( squeeze(PhiXY(:, :, 2))' ));
    axis equal;
    axis( [- 5, 5, - 5, 5] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    caxis([0, 10]);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    view(2);
    hold on;
    paras2dXY = genParas2dXY( tumor_z_es, paras, dx, dy, dz );
    plotXY_Eso( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');

    % calculate the E field
    SARseg = zeros( x_idx_max_B, y_idx_max_B, 6, 8 );
    TtrVol = zeros( x_idx_max_B, y_idx_max_B, 6, 8 );
    MidPnts9Crdnt = zeros( x_idx_max_B, y_idx_max_B, 9, 3 );
    for idx = 1: 1: x_idx_max_B * y_idx_max_B
        [ m_B, n_B ] = getML(idx, x_idx_max_B);
        ell_B = CrossEll;
        if m_B >= 2 && m_B <= x_idx_max_B - 1 && n_B >= 2 && n_B <= y_idx_max_B - 1 
            % to-do
            % implement the calSARsegXY_vrtx.m
            [ SARseg( m_B, n_B, :, : ), TtrVol( m_B, n_B, :, : ), MidPnts9Crdnt( m_B, n_B, :, : ) ] ...
                = calSARsegXY_vrtx( m_B, n_B, int64(ell_B), PhiXY, x_max_vertex_B, y_max_vertex_B, ...
                    Vertex_Crdnt_B, squeeze(SegMed_B(m_B, n_B, ell_B, :, :)), sigma, rho );
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    IntrpltPnts = zeros( x_max_vertex_B, y_max_vertex_B );
    for vIdx_B = 1: 1: x_max_vertex_B * y_max_vertex_B
        [ m_v_B, n_v_B ] = getML(vIdx_B, x_max_vertex_B);
        if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 
            IntrpltPnts(m_v_B, n_v_B) = ExecIntrplt( m_v_B, n_v_B, SARseg, TtrVol, 'XY' );
        end
    end
    toc;

    % plot electrode SAR
    figure(7);
    clf;
    myRange = [ 9.99e-2, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [- 5, 5, - 5, 5] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );
    hold on;

    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: x_idx_max_B * y_idx_max_B
        [ m_B, n_B ] = getML(idx, x_idx_max_B);
        if m_B >= 2 && m_B <= x_idx_max_B - 1 && n_B >= 2 && n_B <= y_idx_max_B - 1
            m_v_B = 2 * m_B - 1;
            n_v_B = 2 * n_B - 1; 
            ell_v_B = tumor_ell_v;
            Intrplt9Pnts     = getIntrplt9Pnts(m_B, n_B, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m_B, n_B, :, :) );
            PntMidPnts9Crdnt(:, 3) = [];
            plotSAR_Intrplt( squeeze( SARseg( m_B, n_B, :, :) ), squeeze( TtrVol( m_B, n_B, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'XY', 0 );
        end
    end
    toc;

    caxis(log10(myRange));
    colormap jet;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [- 5, 5, - 5, 5] );
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 18);
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    box on;
    view(2);
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    maskXY(paras2dXY(4), air_z, dx);
    plotXY_Eso( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat') );
end

if flag_YZ == 1

    PhiYZ       = zeros( 3, y_max_vertex_B, z_max_vertex_B );
    % ThrXYZCrndt = zeros( 3, y_idx_max, z_idx_max, 3);
    % ThrMedValue = zeros( 3, y_idx_max, z_idx_max );
    % SegValueYZ  = zeros( y_idx_max, z_idx_max, 6, 8, 'uint8' );
    y_mesh      = zeros( z_max_vertex_B, y_max_vertex_B );
    z_mesh      = zeros( z_max_vertex_B, y_max_vertex_B );

    for vIdx_B = 1: 1: x_max_vertex_B * y_max_vertex_B * z_max_vertex_B
        [ m_v_B, n_v_B, ell_v_B ] = getMNL(vIdx_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
        tumor_m_v = 2 * tumor_m - 1;
        if m_v_B == tumor_m_v
            PhiYZ( 2, n_v_B, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( 2, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            % ThrMedValue( 2, :, : ) = mediumTable( m, :, : );
            % SegValueYZ( n, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
        end
        if m_v_B == tumor_m_v + 1
            PhiYZ( 3, n_v_B, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( 3, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            % ThrMedValue( 3, :, : ) = mediumTable( m, :, : );
        end
        if m_v_B == tumor_m_v - 1
            PhiYZ( 1, n_v_B, ell_v_B ) = bar_x_my_gmresPhi(N_v + vIdx_B);
            % ThrXYZCrndt( 1, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            % ThrMedValue( 1, :, : ) = mediumTable( m, :, : );
        end
    end

    figure(11);
    clf;
    y_mesh = squeeze(Vertex_Crdnt_B( tumor_m_v, :, :, 2))';
    z_mesh = squeeze(Vertex_Crdnt_B( tumor_m_v, :, :, 3))';
    pcolor(y_mesh * 100, z_mesh * 100, abs( squeeze(PhiYZ(2, :, :))' ));
    axis equal;
    axis( [- 5, 5, 0, 10] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    % caxis([-50, 50])
    caxis([0, 10]);;
    % caxis([0, 100]);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    box on;
    % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    set(gca, 'Xtick', [-15, -10, -5, 0, 5, 10, 15]); 
    % zlabel('$\left| \Phi \right| (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 20);
    hold on;
    % plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz, bolus_b, muscle_b );
    paras2dYZ = genParas2dYZ( tumor_x_es, paras, dy, dz );
    plotYZ_Eso( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    box on;
    view(2);
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');

    % === === % ============ % === === %
    % === === % Plotting SAR % === === %
    % === === % ============ % === === %
    % calculate the E field
    SARseg = zeros( y_idx_max_B, z_idx_max_B, 6, 8 );
    TtrVol = zeros( y_idx_max_B, z_idx_max_B, 6, 8 );
    MidPnts9Crdnt = zeros( y_idx_max_B, z_idx_max_B, 9, 3 );
    for idx = 1: 1: y_idx_max * z_idx_max
        [ n_B, ell_B ] = getML(idx, y_idx_max_B);
        m_B = tumor_m;
        if n_B >= 2 && n_B <= y_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1 
            [ SARseg( n_B, ell_B, :, : ), TtrVol( n_B, ell_B, :, : ), MidPnts9Crdnt( n_B, ell_B, :, : ) ] ...
                    = calSARsegYZ_vrtx( int64(m_B), n_B, ell_B, PhiYZ, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B, squeeze(SegMed_B(m_B, n_B, ell_B, :, :)), sigma, rho );
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    IntrpltPnts = zeros( y_max_vertex_B, z_max_vertex_B );
    for vIdx_B = 1: 1: y_max_vertex_B * z_max_vertex_B
        [ n_v_B, ell_v_B ] = getML(vIdx_B, y_max_vertex_B);
        if n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
            IntrpltPnts(n_v_B, ell_v_B) = ExecIntrplt( n_v_B, ell_v_B, SARseg, TtrVol, 'YZ' );
        end
    end
    toc;

    % plot SAR
    figure(12);
    clf;
    myRange = [ 9.99e-2, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [- 5, 5, 0, 10] );
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18);
    hold on;
    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: y_idx_max_B * z_idx_max_B
        [ n_B, ell_B ] = getML(idx, y_idx_max_B);
        if n_B >= 2 && n_B <= y_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1
            m_v_B = tumor_m_v;
            n_v_B = 2 * n_B - 1;
            ell_v_B = 2 * ell_B - 1;
            Intrplt9Pnts     = getIntrplt9Pnts(n_B, ell_B, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(n_B, ell_B, :, :) );
            PntMidPnts9Crdnt(:, 1) = [];
            plotSAR_Intrplt( squeeze( SARseg( n_B, ell_B, :, :) ), squeeze( TtrVol( n_B, ell_B, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'YZ', 0 );
        end
    end
    toc;

    caxis(log10(myRange));
    colormap jet;
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    box on;
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    set(log_axes, 'Xtick', [-15, -10, -5, 0, 5, 10, 15]); 
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    plotYZ_Eso( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    axis equal;
    axis( [- 5, 5, 0, 10] );
    % axis( [ - 100 * h_torso / 2, 100 * h_torso / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    view(2);
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat') ); 
end