A = bar_x_my_gmres;
bar_x_my_gmres_TMP = zeros(x_idx_max * y_idx_max * z_idx_max, 1);

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

if flag_XZ == 1
    H_XZ = zeros(x_idx_max, z_idx_max, 6, 8, 3); 
    % CrossN = int64( w_y / (2 * dy) + 1 );
    n = tumor_n;
    tic;
    disp('Getting E^(0): XZ');
    for idx = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            % get 27 Pnts
            PntsIdx = zeros( 3, 9 ); 
            PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            PntsIdx_t = PntsIdx';
            G_27cols = sparse(N_v, 27);
            G_27cols = G(:, PntsIdx_t(:));
            % the getH_2 is now modified to getE^{(1)}: E^(1) = - j omega \mu_0 A^(1) field, 
            % where \mu_0 is amended for a dropped scaling in the GMRES procedure.
            H_XZ(m, ell, :, :, :) = - j * Omega_0 * Mu_0 * getEfromA( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
        end
    end
    toc;
    % save( strcat( fname, '\E1_XZ.mat'), 'H_XZ' );
end

if flag_XZ == 1
    for dirFlag = 1: 1: 3
        n = tumor_n;
        XZCrdnt = zeros( x_idx_max, z_idx_max, 3);
        x_mesh      = zeros( z_idx_max, x_idx_max );
        z_mesh      = zeros( z_idx_max, x_idx_max );

        XZCrdnt = shiftedCoordinateXYZ( :, n, :, :);
        x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
        z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';

        TtrVol = zeros( x_idx_max, z_idx_max, 6, 8 );
        % % update the TtrVol
        % for idx = 1: 1: x_idx_max * z_idx_max
        %     [ m, ell ] = getML(idx, x_idx_max);
        %     n = 2;
        %     if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        %         [ tmp1, TtrVol( m, ell, :, : ), tmp2 ] ...
        %                     = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, x_idx_max, sigma, rho, ThrMedValue );
        %     end
        % end

        figure(dirFlag);
        set(figure(dirFlag),'name', strcat(Fname, num2str(dirFlag)),'numbertitle','off')
        clf;
        switch dirFlag
            case 1
                % myRange = [ - 300, 300 ];
            case 2
                % myRange = [ - 450, 450 ];
            case 3
                % myRange = [ - 300, 300 ];
            otherwise
                ;
        end
        % caxis(myRange);
        % cbar = colorbar('peer', gca, 'Yscale', 'log');
        % set(gca, 'Visible', 'off')
        % log_axes = axes('Position', get(gca, 'Position'));
        % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
        % set(cbar, 'FontSize', 18 );
        hold on;

        % TtrVol is approximated as the same for all the tetrahedra
        disp('Time to plot SAR');
        tic;
        for idx = 1: 1: x_idx_max * z_idx_max
            [ m, ell ] = getML(idx, x_idx_max);
            if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
                m_v = 2 * m - 1;
                n_v = 2 * n - 1;
                ell_v = 2 * ell - 1;
                bypasser = zeros(3, 9);
                V27Crdnt = zeros(3, 9, 3);
                [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
                MidPnts9Crdnt = getMidPnts9CrdntXZ( V27Crdnt );
                plotPntH( abs(squeeze(H_XZ(m, ell, :, :, dirFlag))), MidPnts9Crdnt, 'XZ' );
            end
        end
        toc;

        % caxis(myRange);
        colorbar
        switch dirFlag
            % case 1
            %     set(colorbar, 'YTick', [-450, -400: 100: 300]);
            case 2
                % set(colorbar, 'YTick', [-450: 50: 450]);
            % case 3
            %     set(colorbar, 'YTick', [-450, -400: 100: 300]);
        end
        % caxis(log10(myRange));
        colormap jet;
        axis equal;
        axis( [ - 100 * w_x / 2 + 0.5, 100 * w_x / 2 - 0.5, - 100 * w_z / 2 + 0.5, 100 * w_z / 2 - 0.5 ]);
        xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
        ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
        set(gca,'fontsize',20);
        set(gca,'LineWidth',2.0);
        % set(log_axes,'fontsize',20);
        % set(log_axes,'LineWidth',2.0);
        zlabel('$H$ (A/m)','Interpreter','LaTex', 'FontSize', 20);
        box on;
        view(2);
        hold on;
        % plotMQS( Paras_Mag );
        paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
        plotMap( paras2dXZ, dx, dz );
        % plotGridLineXZ( shiftedCoordinateXYZ, CrossN );
        saveas(figure(dirFlag), fullfile(fname, strcat('E_XZ', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigXZ.mat') );
        % save('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108\Case0108TmprtrFigXZ.mat');
    end
end

if flag_XY == 1
    H_XY = zeros(x_idx_max, y_idx_max, 6, 8, 3); 
    ell = tumor_ell;
    % ell = CrossEll;
    tic;
    disp('Getting E^(0): XY');
    for idx = 1: 1: x_idx_max * y_idx_max
        [ m, n ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            PntsIdx = zeros( 3, 9 ); 
            PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            PntsIdx_t = PntsIdx';
            G_27cols = sparse(N_v, 27);
            G_27cols = G(:, PntsIdx_t(:));
            % the getH_2 is now modified to getE^{(1)}.
            H_XY(m, n, :, :, :) = - j * Omega_0 * Mu_0 * getEfromA( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
            % H_XY(m, n, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
            %                             x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
            %                                 A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end
    toc;
    % save( strcat( fname, '\E1_XY.mat'), 'H_XY');
end

if flag_XY == 1
    for dirFlag = 1: 1: 3
        % CrossEll = int64( w_z / (2 * dz) + 1 );
        ell = tumor_ell;
        XYCrdnt = zeros( x_idx_max, y_idx_max, 3, 3);
        x_mesh      = zeros( y_idx_max, x_idx_max );
        y_mesh      = zeros( y_idx_max, x_idx_max );

        XYCrdnt = shiftedCoordinateXYZ( :, :, ell, :);
        x_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 1))';
        y_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 2))';

        TtrVol = zeros( x_idx_max, y_idx_max, 6, 8 );
        % update the TtrVol
        % for idx = 1: 1: x_idx_max * y_idx_max
        %     % idx = ( n - 1 ) * x_idx_max + m;
        %     tmp_m = mod( idx, x_idx_max );
        %     if tmp_m == 0
        %         m = x_idx_max;
        %     else
        %         m = tmp_m;
        %     end

        %     n = int64( ( idx - m ) / x_idx_max + 1 );

        %     ell = 2;

        %     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
        %         [ SARseg( m, n, :, : ), TtrVol( m, n, :, : ), MidPnts9Crdnt( m, n, :, : ) ] ...
        %             = calSARsegXY( m, n, ell, PhiTpElctrd, ThrXYZCrndt, SegValueXY, x_idx_max, y_idx_max, sigma, rho );
        %     end
        % end

        figure(dirFlag + 5);
        % set(gcf,'position',get(0,'screensize'));
        set(figure(dirFlag + 5),'name', strcat(Fname, num2str(dirFlag)),'numbertitle','off')
        clf;
        switch dirFlag
            case 1
                % myRange = [ - 350, 350 ];
            case 2
                % myRange = [ - 300, 300 ];
            case 3
                % myRange = [ - 150, 150 ];
            otherwise
                ;
        end
        % caxis(myRange);
        % cbar = colorbar('peer', gca, 'Yscale', 'log');
        % set(gca, 'Visible', 'off')
        % log_axes = axes('Position', get(gca, 'Position'));
        % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
        % set(cbar, 'FontSize', 18 );
        hold on;

        disp('Time to plot SAR');
        tic;
        for idx = 1: 1: x_idx_max * y_idx_max
            [ m, n ] = getML(idx, x_idx_max);
            if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1
                m_v = 2 * m - 1;
                n_v = 2 * n - 1;
                ell_v = 2 * ell - 1;
                bypasser = zeros(3, 9);
                V27Crdnt = zeros(3, 9, 3);
                [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
                MidPnts9Crdnt = getMidPnts9CrdntXY( V27Crdnt );
                plotPntH( abs(squeeze(H_XY(m, n, :, :, dirFlag))), MidPnts9Crdnt, 'XY' );
            end
        end
        toc;
        
        % caxis(log10(myRange));
        colorbar
        % caxis(myRange);
        switch dirFlag
            case 1
                % set(colorbar, 'YTick', [-350: 50: 350]);
            % case 2
            %     set(colorbar, 'YTick', [-450: 50: 450]);
            % case 3
            %     set(colorbar, 'YTick', [-450, -400: 100: 300]);
        end
        colormap jet;
        xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
        ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
        axis equal;
        zlabel('$H$ (A/m)','Interpreter','LaTex', 'FontSize', 18);
        set(gca,'fontsize',20)
        set(gca,'LineWidth',2.0);
        % set(log_axes,'fontsize',20);
        % set(log_axes,'LineWidth',2.0);
        box on;
        view(2);
        axis( [ - 100 * w_x / 2 + 0.5, 100 * w_x / 2 - 0.5, - 100 * w_y / 2 + 0.5, 100 * w_y / 2 - 0.5 ]);
        % maskXY(paras2dXY(4), air_z, dx);
        % plotXY( paras2dXY, dx, dy );
        paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
        plotXY( paras2dXY, dx, dy );
        % plotGridLineXY( shiftedCoordinateXYZ, CrossEll );
        saveas(figure(dirFlag + 5), fullfile(fname, strcat('E_XY', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat') );
    end
end

if flag_YZ == 1
    H_YZ = zeros(y_idx_max, z_idx_max, 6, 8, 3); 
    m = tumor_m;
    % m = CrossM;
    tic;
    disp('Getting E^(0): YZ');
    for idx = 1: 1: y_idx_max * z_idx_max
        [ n, ell ] = getML(idx, y_idx_max);
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            % get 27 Pnts
            PntsIdx = zeros( 3, 9 ); 
            PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            PntsIdx_t = PntsIdx';
            G_27cols = sparse(N_v, 27);
            G_27cols = G(:, PntsIdx_t(:));
            % the getH_2 is now modified to getE^{(1)}.
            H_YZ(n, ell, :, :, :) = - j * Omega_0 * Mu_0 * getEfromA( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
            % H_YZ(n, ell, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
            %                             x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
            %                                 A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end
    toc;
    % save( strcat( fname, '\E1_YZ.mat'), 'H_YZ' );
end

if flag_YZ == 1
    for dirFlag = 1: 1: 3
        % CrossM = int64( w_x / (2 * dx) + 1 );
        m = tumor_m;
        YZCrdnt = zeros( y_idx_max, z_idx_max, 3);
        y_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 2))';
        z_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 3))';

        % Update the TtrVol
        TtrVol = zeros( y_idx_max, z_idx_max, 6, 8 );

        % plot SAR
        figure(dirFlag + 10);
        set(figure(dirFlag + 10),'name', strcat(Fname, num2str(dirFlag)),'numbertitle','off')
        clf;
        switch dirFlag
            case 1
                % myRange = [ - 150, 150 ];
            case 2
                % myRange = [ - 200, 200 ];
            case 3
                % myRange = [ - 200, 200 ];
            otherwise
                ;
        end
        % myRange = [ 1e1, 1e4 ];
        % caxis(myRange);
        % cbar = colorbar('peer', gca, 'Yscale', 'log');
        % set(gca, 'Visible', 'off')
        % log_axes = axes('Position', get(gca, 'Position'));
        % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
        % set(cbar, 'FontSize', 25);
        hold on;
        
        disp('Time to plot SAR');
        tic;
        for idx = 1: 1: x_idx_max * y_idx_max
            [ n, ell ] = getML(idx, y_idx_max);
            if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
                m_v = 2 * m - 1;
                n_v = 2 * n - 1;
                ell_v = 2 * ell - 1;
                bypasser = zeros(3, 9);
                V27Crdnt = zeros(3, 9, 3);
                [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, Vertex_Crdnt );
                MidPnts9Crdnt = getMidPnts9CrdntYZ( V27Crdnt );
                plotPntH( abs(squeeze(H_YZ(n, ell, :, :, dirFlag))), MidPnts9Crdnt, 'YZ' );
            end
        end
        toc;

        % caxis(myRange);
        colorbar;
        % caxis(log10(myRange));
        switch dirFlag
            case 1
                % set(colorbar, 'YTick', [-150: 50: 150]);
            % case 2
            %     set(colorbar, 'YTick', [-450: 50: 450]);
            % case 3
            %     set(colorbar, 'YTick', [-450, -400: 100: 300]);
        end
        colormap jet;
        set(gca,'fontsize',20);
        set(gca,'LineWidth',2.0);
        % set(log_axes,'fontsize',25);
        % set(log_axes,'LineWidth',2.0);
        box on;
        xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
        ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
        % set(log_axes, 'Xtick', [-15, -10, -5, 0, 5, 10, 15]); 
        % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
        paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
        plotYZ( paras2dYZ, dy, dz );
        % plotGridLineYZ( shiftedCoordinateXYZ, CrossM );
        axis equal;
        % axis( [ - 15, 15, - 15, 15 ]);
        axis( [ - 100 * w_y / 2 + 0.5, 100 * w_y / 2 - 0.5, - 100 * w_z / 2 + 0.5, 100 * w_z / 2 - 0.5 ]);
        view(2);
        saveas(figure(dirFlag + 10), fullfile(fname, strcat('E_YZ', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat') );
    end
end