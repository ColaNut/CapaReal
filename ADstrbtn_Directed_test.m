A = bar_x_my_gmres;
bar_x_my_gmres_TMP = zeros(x_idx_max * y_idx_max * z_idx_max, 1);

if flag_XZ == 1
    for dirFlag = 1: 1: 3
    H_XZ = zeros(x_idx_max, z_idx_max, 6, 8, 3); 
    CrossN = int64( w_y / (2 * dy) + 1 );
    n = CrossN;
    for idx = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            H_XZ(m, ell, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
                                        x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
                                            A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end

    PhiHlfY     = zeros( x_idx_max, 3, z_idx_max );
    ThrXYZCrndt = zeros( x_idx_max, 3, z_idx_max, 3);
    ThrMedValue = zeros( x_idx_max, 3, z_idx_max );
    SegValueXZ  = zeros( x_idx_max, z_idx_max, 6, 8, 'uint8' );
    x_mesh      = zeros( z_idx_max, x_idx_max );
    z_mesh      = zeros( z_idx_max, x_idx_max );

    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        if n == CrossN
            PhiHlfY( m, 2, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, 2, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            ThrMedValue( :, 2, : ) = mediumTable( :, n, : );
            SegValueXZ( m, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
            z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';
            % paras2dXZ = genParas2d( y, paras, dx, dy, dz );
        end
        if n == CrossN + 1
            PhiHlfY( m, 3, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, 3, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            ThrMedValue( :, 3, : ) = mediumTable( :, n, : );
        end
        if n == CrossN - 1
            PhiHlfY( m, 1, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, 1, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            ThrMedValue( :, 1, : ) = mediumTable( :, n, : );
        end

    end

    % calculate the volume of tetrahedron and the MidPnts field
    SARseg = zeros( x_idx_max, z_idx_max, 6, 8 );
    TtrVol = zeros( x_idx_max, z_idx_max, 6, 8 );
    MidPnts9Crdnt = zeros( x_idx_max, z_idx_max, 9, 3 );

    for idx = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idx, x_idx_max);
        n = 2;
        if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            [ SARseg( m, ell, :, : ), TtrVol( m, ell, :, : ), MidPnts9Crdnt( m, ell, :, : ) ] ...
                        = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, x_idx_max, sigma, rho, ThrMedValue );
        end
    end

    for idx = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idx, x_idx_max);
        for f_idx = 1: 1: 6
            for n_idx = 1: 1: 8
                SARseg(m, ell, f_idx, n_idx) = squeeze( H_XZ(m, ell, f_idx, n_idx, dirFlag) );
            end
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    x_idx_maxI = 2 * x_idx_max - 1;
    z_idx_maxI = 2 * z_idx_max - 1;
    IntrpltPnts = zeros( x_idx_maxI, z_idx_maxI );
    for idxI = 1: 1: x_idx_maxI * z_idx_maxI
        [ mI, ellI ] = getML(idxI, x_idx_maxI);
        if mI >= 2 && mI <= x_idx_maxI - 1 && ellI >= 2 && ellI <= z_idx_maxI - 1 
            IntrpltPnts(mI, ellI) = ExecIntrplt( mI, ellI, SARseg, TtrVol, 'XZ' );
        end
    end
    toc;


    % plot H distribution in the XZ plane
    % figure(dirFlag);
    figure(dirFlag);
    % set(gcf,'position',get(0,'screensize'));
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
    % switch dirFlag
    %     case 1
    %         myRange = [ - 900, 900 ];
    %     case 2
    %         myRange = [ - 4500, 4500 ];
    %     case 3
    %         myRange = [ - 1100, 1100 ];
    %     otherwise
    %         ;
    % end
    % myRange = [ 1e1, 1e4 ];
    % caxis(myRange);
    % cbar = colorbar('peer', gca, 'Yscale', 'log');
    % set(gca, 'Visible', 'off')
    % log_axes = axes('Position', get(gca, 'Position'));
    % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cbar, 'FontSize', 18 );
    hold on;

    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            Intrplt9Pnts     = getIntrplt9Pnts(m, ell, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, ell, :, :) );
            PntMidPnts9Crdnt(:, 2) = [];
            % plotSAR_XZ( SARseg, TtrVol, PntMidPnts9Crdnt )
            plotSAR_Intrplt( squeeze( abs(SARseg( m, ell, :, :)) ), squeeze( TtrVol( m, ell, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'XZ', 1 );
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
    plotMQS( Paras_Mag );
    plotGridLineXZ( shiftedCoordinateXYZ, CrossN );
    % saveas(figure(dirFlag), fullfile(fname, strcat('H_XZ', num2str(dirFlag))), 'fig');
    saveas(figure(dirFlag), fullfile(fname, strcat('H_XZ', num2str(dirFlag))), 'jpg');
    % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigXZ.mat') );
    % save('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108\Case0108TmprtrFigXZ.mat');

    % figure(3);
    % x_shift = ( x_idx_max - 1 ) / 2 - 1;
    % z_shift = ( z_idx_max - 1 ) / 2 - 1;

    % [ X_qui, Y_qui ] = meshgrid(- x_shift: 1: x_shift, - z_shift: 1: z_shift);

    % u = zeros(2 * x_shift + 1, 2 * z_shift + 1);
    % w = zeros(2 * x_shift + 1, 2 * z_shift + 1);
    % v = zeros(2 * x_shift + 1, 2 * z_shift + 1);

    % u = squeeze( H_XZ(2: 2 + 2 * x_shift, 2: 2 + 2 * z_shift, 1, 1, 1) );
    % w = squeeze( H_XZ(2: 2 + 2 * x_shift, 2: 2 + 2 * z_shift, 1, 1, 2) );
    % v = squeeze( H_XZ(2: 2 + 2 * x_shift, 2: 2 + 2 * z_shift, 1, 1, 3) );
    % quiver(X_qui, Y_qui, u', v');
    end
    % end
end

if flag_XY == 1
    for dirFlag = 1: 1: 3
    % CrossEll = 6;
    CrossEll = int64( w_z / (2 * dz) + 1 );
    H_XY = zeros(x_idx_max, y_idx_max, 6, 8, 3); 
    ell = CrossEll;
    for idx = 1: 1: x_idx_max * y_idx_max
        [ m, n ] = getML(idx, x_idx_max);
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
            H_XY(m, n, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
                                        x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
                                            A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end

    PhiTpElctrd = zeros( x_idx_max, y_idx_max, 3 );
    ThrXYZCrndt = zeros( x_idx_max, y_idx_max, 3, 3);
    ThrMedValue = zeros( x_idx_max, y_idx_max, 3 );
    SegValueXY  = zeros( x_idx_max, y_idx_max, 6, 8, 'uint8' );
    x_mesh      = zeros( y_idx_max, x_idx_max );
    y_mesh      = zeros( y_idx_max, x_idx_max );

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

        % z = tumor_z;
        % CrossEll = ( z / dz ) + air_z / (2 * dz) +  1;
        % CrossEll = 10;

        if ell == CrossEll
            % XZmidY( ell, m ) = bar_x_my_gmres(idx);
            PhiTpElctrd( m, n, 2 ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, :, 2, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 2 ) = mediumTable( :, :, ell );
            SegValueXY( m, n, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            x_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 1))';
            y_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 2))';
            % paras2dXY = genParas2dXY( z, paras, dx, dy, dz );
            % paras2dXY = [ h_torso, air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
            %             l_lung_x, l_lung_y, l_lung_a_prime, l_lung_b_prime, ...
            %             r_lung_x, r_lung_y, r_lung_a_prime, r_lung_b_prime, ...
            %             tumor_x, tumor_y, tumor_r_prime ];
        end

        if ell == CrossEll + 1
            PhiTpElctrd( m, n, 3 ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, :, 3, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 3 ) = mediumTable( :, :, ell );
        end

        if ell == CrossEll - 1
            PhiTpElctrd( m, n, 1 ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( :, :, 1, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 1 ) = mediumTable( :, :, ell );
        end

    end

    % figure(6);
    % clf;
    % PhiTpElctrd2 = squeeze(PhiTpElctrd(:, :, 2));
    % pcolor(x_mesh * 100, y_mesh * 100, abs( PhiTpElctrd2' ));
    % axis equal;
    % axis( [ - 20, 20, - 15, 15 ] );
    % % shading flat
    % shading interp
    % colormap jet;
    % set(gca,'fontsize',20);
    % set(gca,'LineWidth',2.0);
    % cb = colorbar;
    % caxis([0, 100]);
    % ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cb, 'FontSize', 18);
    % box on;
    % % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    % %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    % %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    % view(2);
    % hold on;
    % plotXY( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');

    % calculate the E field
    SARseg = zeros( x_idx_max, y_idx_max, 6, 8 );
    TtrVol = zeros( x_idx_max, y_idx_max, 6, 8 );
    MidPnts9Crdnt = zeros( x_idx_max, y_idx_max, 9, 3 );

    for idx = 1: 1: x_idx_max * y_idx_max
        % idx = ( n - 1 ) * x_idx_max + m;
        tmp_m = mod( idx, x_idx_max );
        if tmp_m == 0
            m = x_idx_max;
        else
            m = tmp_m;
        end

        n = int64( ( idx - m ) / x_idx_max + 1 );

        ell = 2;

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
            [ SARseg( m, n, :, : ), TtrVol( m, n, :, : ), MidPnts9Crdnt( m, n, :, : ) ] ...
                = calSARsegXY( m, n, ell, PhiTpElctrd, ThrXYZCrndt, SegValueXY, x_idx_max, y_idx_max, sigma, rho );
        end
    end

    for idx = 1: 1: x_idx_max * y_idx_max
        [ m, n ] = getML(idx, x_idx_max);
        for f_idx = 1: 1: 6
            for n_idx = 1: 1: 8
                SARseg(m, n, f_idx, n_idx) = squeeze( H_XY(m, n, f_idx, n_idx, dirFlag) );
            end
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    x_idx_maxI = 2 * x_idx_max - 1;
    y_idx_maxI = 2 * y_idx_max - 1;
    IntrpltPnts = zeros( x_idx_maxI, y_idx_maxI );
    for idxI = 1: 1: x_idx_maxI * y_idx_maxI
        % idxI = ( nI - 1 ) * x_idx_maxI + mI;
        tmp_mI = mod( idxI, x_idx_maxI );
        if tmp_mI == 0
            mI = x_idx_maxI;
        else
            mI = tmp_mI;
        end
        nI = int64( ( idxI - mI ) / x_idx_maxI + 1 );

        if mI >= 2 && mI <= x_idx_maxI - 1 && nI >= 2 && nI <= y_idx_maxI - 1 
            IntrpltPnts(mI, nI) = ExecIntrplt( mI, nI, SARseg, TtrVol, 'XY' );
        end
    end
    toc;

    % plot electrode SAR
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
    % switch dirFlag
    %     case 1
    %         myRange = [ - 1500, 1500 ];
    %     case 2
    %         myRange = [ - 2500, 2500 ];
    %     case 3
    %         myRange = [ - 400, 400 ];
    %     otherwise
    %         ;
    % end
    % caxis(myRange);
    % cbar = colorbar('peer', gca, 'Yscale', 'log');
    % set(gca, 'Visible', 'off')
    % log_axes = axes('Position', get(gca, 'Position'));
    % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cbar, 'FontSize', 18 );
    hold on;
    % disp('Time to plot SAR');
    % tic;
    % for idx = 1: 1: x_idx_max * y_idx_max
    %     % idx = ( ell - 1 ) * x_idx_max + m;
    %     tmp_m = mod( idx, x_idx_max );
    %     if tmp_m == 0
    %         m = x_idx_max;
    %     else
    %         m = tmp_m;
    %     end

    %     n = int64( ( idx - m ) / x_idx_max + 1 );

    %     ell = 2;

    %     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
    %         PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, n, :, :) );
    %         PntMidPnts9Crdnt(:, 3) = [];
    %         plotSAR_XY( squeeze( SARseg( m, n, :, :) ), squeeze( TtrVol( m, n, :, : ) ), PntMidPnts9Crdnt );
    %         hold on;
    %     end

    % end
    % toc;
    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: x_idx_max * y_idx_max
        % idx = ( n - 1 ) * x_idx_max + m;
        tmp_m = mod( idx, x_idx_max );
        if tmp_m == 0
            m = int64(x_idx_max);
        else
            m = int64(tmp_m);
        end

        n = int64( ( idx - m ) / x_idx_max + 1 );

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1
            Intrplt9Pnts     = getIntrplt9Pnts(m, n, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, n, :, :) );
            PntMidPnts9Crdnt(:, 3) = [];
            plotSAR_Intrplt( squeeze( SARseg( m, n, :, :) ), squeeze( TtrVol( m, n, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'XY', 1 );
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
    plotGridLineXY( shiftedCoordinateXYZ, CrossEll );
    % saveas(figure(dirFlag + 5), fullfile(fname, strcat('H_XY', num2str(dirFlag))), 'fig');
    saveas(figure(dirFlag + 5), fullfile(fname, strcat('H_XY', num2str(dirFlag))), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat') );

    % figure(8);
    % x_shift = ( x_idx_max - 1 ) / 2 - 1;
    % y_shift = ( y_idx_max - 1 ) / 2 - 1;

    % [ X_qui, Y_qui ] = meshgrid(- x_shift: 1: x_shift, - y_shift: 1: y_shift);

    % u = zeros(2 * x_shift + 1, 2 * y_shift + 1);
    % w = zeros(2 * x_shift + 1, 2 * y_shift + 1);
    % v = zeros(2 * x_shift + 1, 2 * y_shift + 1);

    % u = squeeze( H_XY(2: 2 + 2 * x_shift, 2: 2 + 2 * y_shift, 1, 1, 1) );
    % w = squeeze( H_XY(2: 2 + 2 * x_shift, 2: 2 + 2 * y_shift, 1, 1, 2) );
    % v = squeeze( H_XY(2: 2 + 2 * x_shift, 2: 2 + 2 * y_shift, 1, 1, 3) );
    % quiver(X_qui, Y_qui, u', w');
    end
end

if flag_YZ == 1
    for dirFlag = 1: 1: 3
    CrossM = int64( w_x / (2 * dx) + 1 );
    H_YZ = zeros(y_idx_max, z_idx_max, 6, 8, 3); 
    m = CrossM;
    for idx = 1: 1: y_idx_max * z_idx_max
        [ n, ell ] = getML(idx, y_idx_max);
        if n == 7 && ell == 5
            ;
        end
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            H_YZ(n, ell, :, :, :) = getH(m, n, ell, x_idx_max, y_idx_max, ...
                                        x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, ...
                                            A, mu_r, squeeze( SegMed( m, n, ell, :, : ) ) );
        end
    end

    PhiYZ       = zeros( 3, y_idx_max, z_idx_max );
    ThrXYZCrndt = zeros( 3, y_idx_max, z_idx_max, 3);
    ThrMedValue = zeros( 3, y_idx_max, z_idx_max );
    SegValueYZ  = zeros( y_idx_max, z_idx_max, 6, 8, 'uint8' );
    y_mesh      = zeros( z_idx_max, y_idx_max );
    z_mesh      = zeros( z_idx_max, y_idx_max );

    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        
        % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);

        % x = tumor_x;
        % x = - 10 / 100;
        % CrossM = int32( x / dx + air_x / ( 2 * dx ) + 1 );
        % CrossN = - 10 / ( 100 * dy )

        if m == CrossM
            % XZmidY( ell, m ) = bar_x_my_gmres_TMP(idx);
            PhiYZ( 2, n, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( 2, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 2, :, : ) = mediumTable( m, :, : );
            SegValueYZ( n, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            y_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 2))';
            z_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 3))';
            % paras2dYZ = genParas2dYZ( x, paras, dy, dz );
        end

        if m == CrossM + 1
            PhiYZ( 3, n, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( 3, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 3, :, : ) = mediumTable( m, :, : );
        end

        if m == CrossM - 1
            PhiYZ( 1, n, ell ) = bar_x_my_gmres_TMP(idx);
            ThrXYZCrndt( 1, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 1, :, : ) = mediumTable( m, :, : );
        end

    end

    % figure(11);
    % clf;
    % PhiYZ2 = squeeze(PhiYZ(2, :, :));
    % pcolor(y_mesh * 100, z_mesh * 100, abs( PhiYZ2' ));
    % axis equal;
    % axis( [ - 15, 15, - 20, 20 ] );
    % % shading flat
    % shading interp
    % colormap jet;
    % set(gca,'fontsize',20);
    % set(gca,'LineWidth',2.0);
    % cb = colorbar;
    % % caxis([-50, 50])
    % caxis([0, 100]);;
    % % caxis([0, 100]);
    % ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cb, 'FontSize', 18);
    % box on;
    % % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    % %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    % %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    % xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % set(gca, 'Xtick', [-15, -10, -5, 0, 5, 10, 15]); 
    % % zlabel('$\left| \Phi \right| (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 20);
    % hold on;
    % % plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz, bolus_b, muscle_b );
    % plotYZ( paras2dYZ, dy, dz );
    % % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    % set(gca,'fontsize',20);
    % set(gca,'LineWidth',2.0);
    % box on;
    % view(2);
    % % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
    % % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');

    % calculate the E field
    SARseg = zeros( y_idx_max, z_idx_max, 6, 8 );
    TtrVol = zeros( y_idx_max, z_idx_max, 6, 8 );
    MidPnts9Crdnt = zeros( y_idx_max, z_idx_max, 9, 3 );

    for idx = 1: 1: y_idx_max * z_idx_max
        % idx = ( ell - 1 ) * y_idx_max + n;

        m = 2;

        tmp_n = mod( idx, y_idx_max );
        if tmp_n == 0
            n = y_idx_max;
        else
            n = tmp_n;
        end

        ell = int64( ( idx - n ) / y_idx_max + 1 );

        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            [ SARseg( n, ell, :, : ), TtrVol( n, ell, :, : ), MidPnts9Crdnt( n, ell, :, : ) ] ...
                    = calSARsegYZ( m, n, ell, PhiYZ, ThrXYZCrndt, SegValueYZ, y_idx_max, sigma, rho );
        end
    end

    for idx = 1: 1: y_idx_max * z_idx_max
        [ n, ell ] = getML(idx, y_idx_max);
        if n == 7 && ell == 5
            ;
        end
        for f_idx = 1: 1: 6
            for n_idx = 1: 1: 8
                SARseg(n, ell, f_idx, n_idx) = squeeze( H_YZ(n, ell, f_idx, n_idx, dirFlag) );
            end
        end
    end

    % interpolation
    tic;
    disp('time for interpolation: ')
    y_idx_maxI = 2 * y_idx_max - 1;
    z_idx_maxI = 2 * z_idx_max - 1;
    IntrpltPnts = zeros( y_idx_maxI, z_idx_maxI );
    for idxI = 1: 1: y_idx_maxI * z_idx_maxI
        % idxI = ( ellI - 1 ) * y_idx_maxI + nI;
        tmp_nI = mod( idxI, y_idx_maxI );
        if tmp_nI == 0
            nI = y_idx_maxI;
        else
            nI = tmp_nI;
        end

        ellI = int64( ( idxI - nI ) / y_idx_maxI + 1 );

        if nI >= 2 && nI <= y_idx_maxI - 1 && ellI >= 2 && ellI <= z_idx_maxI - 1 
            IntrpltPnts(nI, ellI) = ExecIntrplt( nI, ellI, SARseg, TtrVol, 'YZ' );
        end
    end
    toc;

    % plot SAR
    figure(dirFlag + 10);
    % set(gcf,'position',get(0,'screensize'));
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
    % switch dirFlag
    %     case 1
    %         myRange = [ - 2000, 2000 ];
    %     case 2
    %         myRange = [ - 2500, 2500 ];
    %     case 3
    %         myRange = [ - 1500, 1500 ];
    %     otherwise
    %         ;
    % end
    % myRange = [ 1e1, 1e4 ];
    % caxis(myRange);
    % cbar = colorbar('peer', gca, 'Yscale', 'log');
    % set(gca, 'Visible', 'off')
    % log_axes = axes('Position', get(gca, 'Position'));
    % ylabel(cbar, '$H$ (A/m)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cbar, 'FontSize', 25);
    hold on;
    % disp('Time to plot SAR');
    % tic;
    % for idx = 1: 1: y_idx_max * z_idx_max
    %     % idx = ( ell - 1 ) * y_idx_max + n;

    %     tmp_n = mod( idx, y_idx_max );
    %     if tmp_n == 0
    %         n = y_idx_max;
    %     else
    %         n = tmp_n;
    %     end

    %     ell = int64( ( idx - n ) / y_idx_max + 1 );

    %     if n == 9 && ell == 11
    %         ;
    %     end
    %     if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
    %         PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(n, ell, :, :) );
    %         PntMidPnts9Crdnt(:, 1) = [];
    %         plotSAR_YZ( squeeze( SARseg( n, ell, :, :) ), squeeze( TtrVol( n, ell, :, : ) ), PntMidPnts9Crdnt );
    %         hold on;
    %     end

    % end
    % toc;
    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: y_idx_max * z_idx_max
        % idx = ( ell - 1 ) * y_idx_max + n;
        tmp_n = mod( idx, y_idx_max );
        if tmp_n == 0
            n = int64(y_idx_max);
        else
            n = int64(tmp_n);
        end
        ell = int64( ( idx - n ) / y_idx_max + 1 );
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            Intrplt9Pnts     = getIntrplt9Pnts(n, ell, IntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(n, ell, :, :) );
            PntMidPnts9Crdnt(:, 1) = [];
            plotSAR_Intrplt( squeeze( SARseg( n, ell, :, :) ), squeeze( TtrVol( n, ell, :, : ) ), ...
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'YZ', 1 );
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
    % plotYZ( paras2dYZ, dy, dz );
    plotGridLineYZ( shiftedCoordinateXYZ, CrossM );
    axis equal;
    % axis( [ - 15, 15, - 15, 15 ]);
    axis( [ - 100 * w_y / 2 + 0.5, 100 * w_y / 2 - 0.5, - 100 * w_z / 2 + 0.5, 100 * w_z / 2 - 0.5 ]);
    view(2);
    % saveas(figure(dirFlag + 10), fullfile(fname, strcat('H_YZ', num2str(dirFlag))), 'fig');
    saveas(figure(dirFlag + 10), fullfile(fname, strcat('H_YZ', num2str(dirFlag))), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat') );

    % figure(13);
    % y_shift = ( y_idx_max - 1 ) / 2 - 1;
    % z_shift = ( z_idx_max - 1 ) / 2 - 1;

    % [ X_qui, Y_qui ] = meshgrid(- y_shift: 1: y_shift, - z_shift: 1: z_shift);

    % u = zeros(2 * y_shift + 1, 2 * z_shift + 1);
    % w = zeros(2 * y_shift + 1, 2 * z_shift + 1);
    % v = zeros(2 * y_shift + 1, 2 * z_shift + 1);

    % u = squeeze( H_YZ(2: 2 + 2 * y_shift, 2: 2 + 2 * z_shift, 1, 1, 1) );
    % w = squeeze( H_YZ(2: 2 + 2 * y_shift, 2: 2 + 2 * z_shift, 1, 1, 2) );
    % v = squeeze( H_YZ(2: 2 + 2 * y_shift, 2: 2 + 2 * z_shift, 1, 1, 3) );
    % quiver(X_qui, Y_qui, w', v');
    end
end