A = bar_x_my_gmres;

flag_XZ = 1;
flag_XY = 0;
flag_YZ = 0;

tumor_m = (tumor_x_es - es_x) / dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1;
tumor_n = (tumor_y_es - 0) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;
tumor_ell = (tumor_z_es - es_z) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1;

% masking part
w_x = w_x_B;
w_y = w_y_B;
w_z = w_z_B;
x_idx_max = x_idx_max_B;
y_idx_max = y_idx_max_B;
z_idx_max = z_idx_max_B;
x_max_vertex = x_max_vertex_B;
y_max_vertex = y_max_vertex_B;
z_max_vertex = z_max_vertex_B;
Vertex_Crdnt = Vertex_Crdnt_B;
SegMed = SegMed_B;
N_v = N_v_B;
N_e = N_e_B;
shiftedCoordinateXYZ = shiftedCoordinateXYZ_B;
% masking end

fname = 'E:\Kevin\CapaReal\1003EsoMQS';

if flag_XZ == 1
    H_XZ = zeros(x_idx_max_B, z_idx_max_B, 6, 8, 3); 
    % CrossN = int64( w_y / (2 * dy) + 1 );
    n = tumor_n;
    tic;
    disp('Getting H^(0): XZ');
    for idx = 1: 1: x_idx_max_B * z_idx_max_B
        [ m, ell ] = getML(idx, x_idx_max_B);
        if m >= 2 && m <= x_idx_max_B - 1 && ell >= 2 && ell <= z_idx_max_B - 1
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            % get 27 Pnts
            PntsIdx = zeros( 3, 9 ); 
            PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );
            PntsIdx_t = PntsIdx';
            G_27cols = sparse(N_v, 27);
            G_27cols = G(:, PntsIdx_t(:));
            % the getH_2 is now modified to getE^{(1)}: E^(1) = - j omega \mu_0 A^(1) field, 
            % where \mu_0 is amended for a dropped scaling in the GMRES procedure.
            H_XZ(m, ell, :, :, :) = getH_2( PntsIdx, Vertex_Crdnt_B, A, G_27cols, mu_r, squeeze(SegMed_B(m, n, ell, :, :)), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );
        end
    end
    toc;
    % save( strcat( fname, '\E1_XZ.mat'), 'H_XZ' );
end

H_XZabs = zeros(x_idx_max_B, z_idx_max_B, 6, 8);
for m_idx = 1: 1: x_idx_max_B
    for n_idx = 1: 1: z_idx_max_B
        for f_idx = 1: 1: 6
            for t_idx = 1: 1: 8
                H_XZabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(H_XZ(m_idx, n_idx, f_idx, t_idx, :)) );
            end
        end
    end
end

SAR_XZ_MNP = zeros(x_idx_max, z_idx_max, 6, 8);
SegMedMask = SegMed;
SegMedMask(find(SegMedMask ~= 9)) = 0;
SegMedMask(find(SegMedMask == 9)) = 1;
muPrmPrm_MNP = 0.3;
SAR_XZ_MNP = 0.5 * Omega_0 * Mu_0 * muPrmPrm_MNP * double(squeeze(SegMedMask(:, tumor_n, :, :, :))) .* H_XZabs.^2 / rho(9);

if flag_XZ == 1
    for dirFlag = 1: 1: 5
        n = tumor_n;
        XZCrdnt = zeros( x_idx_max_B, z_idx_max_B, 3);
        x_mesh      = zeros( z_idx_max_B, x_idx_max_B );
        z_mesh      = zeros( z_idx_max_B, x_idx_max_B );

        XZCrdnt = shiftedCoordinateXYZ_B( :, n, :, :);
        x_mesh = squeeze(shiftedCoordinateXYZ_B( :, n, :, 1))';
        z_mesh = squeeze(shiftedCoordinateXYZ_B( :, n, :, 3))';

        TtrVol = zeros( x_idx_max_B, z_idx_max_B, 6, 8 );
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
        if dirFlag < 4
            tic;
            disp('Time to plot H_XZ');
            for idx = 1: 1: x_idx_max_B * z_idx_max_B
                [ m, ell ] = getML(idx, x_idx_max_B);
                if m >= 2 && m <= x_idx_max_B - 1 && ell >= 2 && ell <= z_idx_max_B - 1
                    m_v = 2 * m - 1;
                    n_v = 2 * n - 1;
                    ell_v = 2 * ell - 1;
                    bypasser = zeros(3, 9);
                    V27Crdnt = zeros(3, 9, 3);
                    [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B );
                    MidPnts9Crdnt = getMidPnts9CrdntXZ( V27Crdnt );
                    plotPntH( abs(squeeze(H_XZ(m, ell, :, :, dirFlag))), MidPnts9Crdnt, 'XZ' );
                end
            end
            toc;
        elseif dirFlag == 4
            tic;
            disp('Time to plot H_XZabs');
            for idx = 1: 1: x_idx_max_B * z_idx_max_B
                [ m, ell ] = getML(idx, x_idx_max_B);
                if m >= 2 && m <= x_idx_max_B - 1 && ell >= 2 && ell <= z_idx_max_B - 1
                    m_v = 2 * m - 1;
                    n_v = 2 * n - 1;
                    ell_v = 2 * ell - 1;
                    bypasser = zeros(3, 9);
                    V27Crdnt = zeros(3, 9, 3);
                    [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B );
                    MidPnts9Crdnt = getMidPnts9CrdntXZ( V27Crdnt );
                    plotPntH( abs(squeeze(H_XZabs(m, ell, :, :))), MidPnts9Crdnt, 'XZ' );
                end
            end
            toc;
        else
            tic;
            disp('Time to plot SAR_XZ_MNP');
            for idx = 1: 1: x_idx_max_B * z_idx_max_B
                [ m, ell ] = getML(idx, x_idx_max_B);
                if m >= 2 && m <= x_idx_max_B - 1 && ell >= 2 && ell <= z_idx_max_B - 1
                    m_v = 2 * m - 1;
                    n_v = 2 * n - 1;
                    ell_v = 2 * ell - 1;
                    bypasser = zeros(3, 9);
                    V27Crdnt = zeros(3, 9, 3);
                    [ bypasser, V27Crdnt ] = get27Pnts( m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B );
                    MidPnts9Crdnt = getMidPnts9CrdntXZ( V27Crdnt );
                    plotPntH( abs(squeeze(SAR_XZ_MNP(m, ell, :, :))), MidPnts9Crdnt, 'XZ' );
                end
            end
            toc;
        end
                

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
        % axis( [ - 100 * w_x / 2 + 0.5, 100 * w_x / 2 - 0.5, - 100 * w_z / 2 + 0.5, 100 * w_z / 2 - 0.5 ]);
        axis( [ - 5, 5, 0, 10 ] );
        caxis( [- 1, 4] );
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
        paras2dXZ = genParas2d( tumor_y_es, paras, dx, dy, dz );
        plotMap_Eso( paras2dXZ, dx, dz );
        % plotGridLineXZ( shiftedCoordinateXYZ, CrossN );
        saveas(figure(dirFlag), fullfile(fname, strcat('H_XZ', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigXZ.mat') );
        % save('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108\Case0108TmprtrFigXZ.mat');
    end
end

if flag_XY == 1
    H_XY = zeros(x_idx_max, y_idx_max, 6, 8, 3); 
    ell = tumor_ell;
    % ell = CrossEll;
    tic;
    disp('Getting H^(0): XY');
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
            H_XY(m, n, :, :, :) = getH_2( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
            % H_XY(m, n, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
            %                             x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
            %                                 A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end
    toc;
    % save( strcat( fname, '\E1_XY.mat'), 'H_XY');
    H_XYabs = zeros(x_idx_max, y_idx_max, 6, 8);
    for m_idx = 1: 1: x_idx_max
        for n_idx = 1: 1: y_idx_max
            for f_idx = 1: 1: 6
                for t_idx = 1: 1: 8
                    H_XYabs(m_idx, n_idx, f_idx, t_idx) = norm( squeeze(H_XY(m_idx, n_idx, f_idx, t_idx, :)) );
                end
            end
        end
    end

end

if flag_XY == 1
    for dirFlag = 1: 1: 4
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
        if dirFlag ~= 4
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
        else
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
                    plotPntH( abs(squeeze(H_XYabs(m, n, :, :))), MidPnts9Crdnt, 'XY' );
                end
            end
            toc;
        end
        
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
        axis( [ - 5, 5, - 5, 5 ] );
        caxis( [- 1, 4] );
        % axis( [ - 100 * w_x / 2 + 0.5, 100 * w_x / 2 - 0.5, - 100 * w_y / 2 + 0.5, 100 * w_y / 2 - 0.5 ]);
        % maskXY(paras2dXY(4), air_z, dx);
        % plotXY( paras2dXY, dx, dy );
        paras2dXY = genParas2dXY( tumor_z_es, paras, dx, dy, dz );
        plotXY_Eso( paras2dXY, dx, dy );
        % plotGridLineXY( shiftedCoordinateXYZ, CrossEll );
        saveas(figure(dirFlag + 5), fullfile(fname, strcat('H_XY', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat') );
    end
end

if flag_YZ == 1
    H_YZ = zeros(y_idx_max, z_idx_max, 6, 8, 3); 
    m = tumor_m;
    % m = CrossM;
    tic;
    disp('Getting H^(0): YZ');
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
            H_YZ(n, ell, :, :, :) = getH_2( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
            % H_YZ(n, ell, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
            %                             x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
            %                                 A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end
    toc;
    % save( strcat( fname, '\E1_YZ.mat'), 'H_YZ' );

    H_YZabs = zeros(y_idx_max, z_idx_max, 6, 8);
    for n_idx = 1: 1: y_idx_max
        for ell_idx = 1: 1: z_idx_max
            for f_idx = 1: 1: 6
                for t_idx = 1: 1: 8
                    H_YZabs(n_idx, ell_idx, f_idx, t_idx) = norm( squeeze(H_YZ(n_idx, ell_idx, f_idx, t_idx, :)) );
                end
            end
        end
    end
end

if flag_YZ == 1
    for dirFlag = 1: 1: 4
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
        
        if dirFlag ~= 4
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
        else
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
                    plotPntH( abs(squeeze(H_YZabs(n, ell, :, :))), MidPnts9Crdnt, 'YZ' );
                end
            end
            toc;
        end

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
        paras2dYZ = genParas2dYZ( tumor_x_es, paras, dy, dz );
        plotYZ_Eso( paras2dYZ, dy, dz );
        % plotGridLineYZ( shiftedCoordinateXYZ, CrossM );
        axis equal;
        axis( [ - 5, 5, 0, 10 ] );
        caxis( [- 1, 4] );
        % axis( [ - 15, 15, - 15, 15 ]);
        % axis( [ - 100 * w_y / 2 + 0.5, 100 * w_y / 2 - 0.5, - 100 * w_z / 2 + 0.5, 100 * w_z / 2 - 0.5 ]);
        view(2);
        saveas(figure(dirFlag + 10), fullfile(fname, strcat('H_YZ', num2str(dirFlag))), 'jpg');
        % save( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat') );
    end
end