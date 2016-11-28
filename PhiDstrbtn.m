% clc; clear;
% load('TestCase2.mat');
% rho           = [ 1,  1020,  1020,  1050, 1040 ]';
% save('TestCase2.mat');
% load('RealCase3.mat');

% XZmidY      = zeros( z_idx_max, x_idx_max );

flag_XZ = 1;
flag_YZ = 1;
flag_XY = 1;

fname = 'e:\Kevin\CapaReal\Real1124';

if flag_XZ == 1

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

        y = tumor_y;
        % y = - 10 / 100;
        CrossN = int32( y / dy + h_torso / ( 2 * dy ) + 1 );
        % CrossN = - 10 / ( 100 * dy )

        if n == CrossN
            % XZmidY( ell, m ) = bar_x_my_gmres(idx);
            PhiHlfY( m, 2, ell ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( :, 2, :, :) = shiftedCoordinateXYZ( :, n, :, :);
            ThrMedValue( :, 2, : ) = mediumTable( :, n, : );
            SegValueXZ( m, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            x_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 1))';
            z_mesh = squeeze(shiftedCoordinateXYZ( :, n, :, 3))';
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
    shading flat
    % shading interp
    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 20);
    view(2);
    hold on;
    plotMap( paras2dXZ, dx, dz );
    saveas(figure(1), fullfile(fname, 'Case1124PhiXZ'), 'fig');
    saveas(figure(1), fullfile(fname, 'Case1124PhiXZ'), 'jpg');

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
                        = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, x_idx_max, sigma, rho );
        end
    end

    % plot SAR XZ
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
    colormap jet;
    axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    set(gca,'fontsize',20);
    view(2);
    axis equal;
    plotMap( paras2dXZ, dx, dz );
    saveas(figure(2), fullfile(fname, 'Case1124SARXZ'), 'fig');
    saveas(figure(2), fullfile(fname, 'Case1124SARXZ'), 'jpg');
end

if flag_YZ == 1

    PhiYZ       = zeros( 3, y_idx_max, z_idx_max );
    ThrXYZCrndt = zeros( 3, y_idx_max, z_idx_max, 3);
    ThrMedValue = zeros( 3, y_idx_max, z_idx_max );
    SegValueYZ  = zeros( y_idx_max, z_idx_max, 6, 8, 'uint8' );
    x_mesh      = zeros( z_idx_max, y_idx_max );
    z_mesh      = zeros( z_idx_max, y_idx_max );

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

        x = tumor_x;
        % x = - 10 / 100;
        CrossM = int32( x / dx + air_x / ( 2 * dx ) + 1 );
        % CrossN = - 10 / ( 100 * dy )

        if m == CrossM
            % XZmidY( ell, m ) = bar_x_my_gmres(idx);
            PhiYZ( 2, n, ell ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( 2, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 2, :, : ) = mediumTable( m, :, : );
            SegValueYZ( n, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            y_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 2))';
            z_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 3))';
            paras2dYZ = genParas2dYZ( x, paras, dy, dz );
        end

        if m == CrossM + 1
            PhiYZ( 3, n, ell ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( 3, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 3, :, : ) = mediumTable( m, :, : );
        end

        if m == CrossM - 1
            PhiYZ( 1, n, ell ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( 1, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 1, :, : ) = mediumTable( m, :, : );
        end

    end

    figure(6);
    PhiYZ2 = squeeze(PhiYZ(2, :, :));
    pcolor(y_mesh * 100, z_mesh * 100, abs( PhiYZ2' ));
    shading flat
    % shading interp
    colorbar;
    colormap jet;
    % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 20);
    hold on;
    % plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz, bolus_b, muscle_b );
    plotYZ( paras2dYZ, dy, dz );
    set(gca,'fontsize',20);
    view(2);
    saveas(figure(6), fullfile(fname, 'Case1124PhiYZ'), 'fig');
    saveas(figure(6), fullfile(fname, 'Case1124PhiYZ'), 'jpg');

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

    % plot SAR
    figure(7);
    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: y_idx_max * z_idx_max
        % idx = ( ell - 1 ) * y_idx_max + n;

        tmp_n = mod( idx, y_idx_max );
        if tmp_n == 0
            n = y_idx_max;
        else
            n = tmp_n;
        end

        ell = int64( ( idx - n ) / y_idx_max + 1 );

        if n == 9 && ell == 11
            ;
        end
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(n, ell, :, :) );
            PntMidPnts9Crdnt(:, 1) = [];
            plotSAR_YZ( squeeze( SARseg( n, ell, :, :) ), squeeze( TtrVol( n, ell, :, : ) ), PntMidPnts9Crdnt );
            hold on;
        end

    end
    toc;
    colormap jet;
    set(gca,'fontsize',20);
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    plotYZ( paras2dYZ, dy, dz );
    axis equal;
    axis( [ - 100 * h_torso / 2, 100 * h_torso / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    view(2);
    saveas(figure(7), fullfile(fname, 'Case1124SARYZ'), 'fig');
    saveas(figure(7), fullfile(fname, 'Case1124SARYZ'), 'jpg');
end

if flag_XY == 1

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

        z = tumor_z;
        CrossEll = ( z / dz ) + air_z / (2 * dz) +  1;
        % CrossEll = 10;

        if ell == CrossEll
            % XZmidY( ell, m ) = bar_x_my_gmres(idx);
            PhiTpElctrd( m, n, 2 ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( :, :, 2, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 2 ) = mediumTable( :, :, ell );
            SegValueXY( m, n, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            x_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 1))';
            y_mesh = squeeze(shiftedCoordinateXYZ( :, :, ell, 2))';
            paras2dXY = genParas2dXY( z, paras, dx, dy, dz );
            % paras2dXY = [ h_torso, air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
            %             l_lung_x, l_lung_y, l_lung_a_prime, l_lung_b_prime, ...
            %             r_lung_x, r_lung_y, r_lung_a_prime, r_lung_b_prime, ...
            %             tumor_x, tumor_y, tumor_r_prime ];
        end

        if ell == CrossEll + 1
            PhiTpElctrd( m, n, 3 ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( :, :, 3, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 3 ) = mediumTable( :, :, ell );
        end

        if ell == CrossEll - 1
            PhiTpElctrd( m, n, 1 ) = bar_x_my_gmres(idx);
            ThrXYZCrndt( :, :, 1, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 1 ) = mediumTable( :, :, ell );
        end

    end

    figure(11);
    PhiTpElctrd2 = squeeze(PhiTpElctrd(:, :, 2));
    pcolor(x_mesh * 100, y_mesh * 100, abs( PhiTpElctrd2' ));
    shading flat
    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    view(2);
    hold on;
    plotXY( paras2dXY, dx, dy );
    saveas(figure(11), fullfile(fname, 'Case1124PhiXY'), 'fig');
    saveas(figure(11), fullfile(fname, 'Case1124PhiXY'), 'jpg');

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

    % plot electrode SAR
    figure(12);
    disp('Time to plot SAR');
    tic;
    for idx = 1: 1: x_idx_max * y_idx_max
        % idx = ( ell - 1 ) * x_idx_max + m;
        tmp_m = mod( idx, x_idx_max );
        if tmp_m == 0
            m = x_idx_max;
        else
            m = tmp_m;
        end

        n = int64( ( idx - m ) / x_idx_max + 1 );

        ell = 2;

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, n, :, :) );
            PntMidPnts9Crdnt(:, 3) = [];
            plotSAR_XY( squeeze( SARseg( m, n, :, :) ), squeeze( TtrVol( m, n, :, : ) ), PntMidPnts9Crdnt );
            hold on;
        end

    end
    toc;
    colormap jet;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 18);
    set(gca,'fontsize',20);
    view(2);
    axis equal;
    axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    plotXY( paras2dXY, dx, dy );
    saveas(figure(12), fullfile(fname, 'Case1124SARXY'), 'fig');
    saveas(figure(12), fullfile(fname, 'Case1124SARXY'), 'jpg');
end