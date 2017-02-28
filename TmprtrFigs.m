% clc; clear;
% % load the mat from the end of all simulations
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
% CaseName = 'Case0107';
% load( strcat(fname, '\', CaseName, '\', 'Case0107.mat') );

% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% flag_XZ_T = 0;
% flag_XY_T = 0;
% flag_YZ_T = 1;

if flag_XZ_T == 1
    % load the SAR segments in the XZ cross section in PhiDstrbtn
    load( strcat( fname, '\', CaseDate, 'TmprtrFigXZ.mat' ) );
    % load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0107\Case0107TmprtrFigXZ.mat');

    t = T_end;
    t_idx = t / dt + 1;
    T_XZ = zeros( x_idx_max, z_idx_max );
    T_XZ = squeeze( TmprtrTau( :, tumor_n, :, uint8(t_idx) ) );

    figure(21);
    clf;

    TmprSARseg = zeros( x_idx_max, z_idx_max, 6, 8 );

    for idx = 1: 1: x_idx_max * z_idx_max
        % idx = ( ell - 1 ) * x_idx_max + m;
        tmp_m = mod( idx, x_idx_max );
        if tmp_m == 0
            m = x_idx_max;
        else
            m = tmp_m;
        end
        n = tumor_n;
        % n = tumor_n - 1;
        ell = int64( ( idx - m ) / x_idx_max + 1 );

        % BioValid = false;
        % CnvctnFlag = false;
        % if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
        %     if mediumTable( m, n, ell ) == 0
        %         XZ9Med = getXYZ9Med(m, n, ell, mediumTable, 'XZ');
        %         if ~checkBolusAround( XZ9Med )
        %             BioValid = true;
        %         else
        %             if checkMuscleAround( XZ9Med )
        %                 CnvctnFlag = true;
        %             end
        %         end
        %     else
        %         BioValid = true;
        %     end
        % end
        


        % if BioValid == true || mediumTable( m, n, ell ) == 2 % In bio or bolus
        if mediumTable(m, n, ell) == 2 || mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 7 ...
            || mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 12 || mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
            TmprSARseg(m, ell, :, :) = T_XZ(m, ell);
        elseif mediumTable(m, n, ell) == 13 
            PntSegValueXZ = squeeze( SegValueXZ(m, ell, :, :) );
            TmpTmprtr = T_bolus * ones(6, 8);
            TmpTmprtr( find(PntSegValueXZ ~= 2) ) = T_XZ(m, ell);
            TmprSARseg(m, ell, :, :) = TmpTmprtr;
        elseif mediumTable(m, n, ell) == 11  
            % XZ9Med = getXYZ9Med(m, n, ell, mediumTable, 'XZ');
            % if checkAirAround( XZ9Med )
                % PntSegValueXZ = squeeze( SegValueXZ(m, ell, :, :) );
                TmpTmprtr = T_bolus * ones(6, 8);
                TmprSARseg(m, ell, :, :) = TmpTmprtr;
            % end
        else
            if mediumTable(m, n, ell) ~= 1
                [m, n, ell, mediumTable(m, n, ell)]
            end
        end
    end

    tic;
    disp('time for interpolation: ')
    x_idx_maxI = 2 * x_idx_max - 1;
    z_idx_maxI = 2 * z_idx_max - 1;
    TmprIntrpltPnts = zeros( x_idx_maxI, z_idx_maxI );

    for idxI = 1: 1: x_idx_maxI * z_idx_maxI
        % idxI = ( ellI - 1 ) * x_idx_maxI + mI;
        tmp_mI = mod( idxI, x_idx_maxI );
        if tmp_mI == 0
            mI = x_idx_maxI;
        else
            mI = tmp_mI;
        end

        ellI = int64( ( idxI - mI ) / x_idx_maxI + 1 );

        if mI >= 2 && mI <= x_idx_maxI - 1 && ellI >= 2 && ellI <= z_idx_maxI - 1 
            TmprIntrpltPnts(mI, ellI) = ExecIntrplt( mI, ellI, TmprSARseg, TtrVol, 'XZ' );
        end
    end
    toc;

    disp('Time to plot SAR');
        tic;
        for idx = 1: 1: x_idx_max * z_idx_max
            % idx = ( ell - 1 ) * x_idx_max + m;
            tmp_m = mod( idx, x_idx_max );
            if tmp_m == 0
                m = int64(x_idx_max);
            else
                m = int64(tmp_m);
            end
            ell = int64( ( idx - m ) / x_idx_max + 1 );

            if m == 16 && ell == 10
                ;
            end

            if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
                PntSegValueXZ = squeeze( SegValueXZ(m, ell, :, :) );
                TmprIntrplt9Pnts     = getIntrplt9Pnts(m, ell, TmprIntrpltPnts);
                PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, ell, :, :) );
                PntMidPnts9Crdnt(:, 2) = [];
                plotSAR_Intrplt( squeeze( SARseg( m, ell, :, :) ), squeeze( TtrVol( m, ell, :, : ) ), ...
                                        PntMidPnts9Crdnt, TmprIntrplt9Pnts, 'XZ', 1, PntSegValueXZ );
            end
        end
    toc;

    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cbar = colorbar;
    caxis([5, 50]);
    set(cbar, 'Ytick', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50], 'FontSize', 20); 
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    box on;
    view(2);
    hold on;
    paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    plotMap( paras2dXZ, dx, dz );
    % plotGridLineXZ( shiftedCoordinateXYZ, tumor_n );
    plotRibXZ(Ribs, SSBone, dx, dz);
    
    % ylabel(cbar, '$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
end

% Shrink the edge on the border line
% Add the temperature and the SAR value to the torso end.
if flag_XY_T == 1
    % load the SAR segments in the XY cross section in PhiDstrbtn
    load( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat' ) );
    % load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0107\Case0107TmprtrFigXY.mat');

    T_XY = zeros( x_idx_max, y_idx_max );
    
    t = T_end;
    t_idx = t / dt + 1;
    T_XY = squeeze( TmprtrTau( :, :, tumor_ell, uint8(t_idx) ) );

    figure(22);
    clf;

    TmprSARseg = zeros( x_idx_max, y_idx_max, 6, 8 );

    for idx = 1: 1: x_idx_max * y_idx_max
        % idx = ( ell - 1 ) * x_idx_max + m;
        tmp_m = mod( idx, x_idx_max );
        if tmp_m == 0
            m = x_idx_max;
        else
            m = tmp_m;
        end
        n = int64( ( idx - m ) / x_idx_max + 1 );
        ell = tumor_ell;

        % BioValid = false;
        % CnvctnFlag = false;

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 
        %     if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
        %         if mediumTable( m, n, ell ) == 0
        %             XY9Med = getXYZ9Med(m, n, ell, mediumTable, 'XY');
        %             if ~checkBolusAround( XY9Med )
        %                 BioValid = true;
        %             else
        %                 if checkMuscleAround( XY9Med )
        %                     CnvctnFlag = true;
        %                 end
        %             end
        %         else
        %             BioValid = true;
        %         end
        %     end

            % if BioValid == true || mediumTable( m, n, ell ) == 2 % In bio or bolus
            if mediumTable(m, n, ell) == 2 || mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 7 ...
                || mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 12 || mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
                TmprSARseg(m, n, :, :) = T_XY(m, n);
            % elseif CnvctnFlag == true
            elseif mediumTable(m, n, ell) == 13 
                PntSegValueXY = squeeze( SegValueXY(m, n, :, :) );
                TmpTmprtr = T_bolus * ones(6, 8);
                TmpTmprtr( find(PntSegValueXY ~= 2) ) = T_XY(m, n);
                TmprSARseg(m, n, :, :) = TmpTmprtr;
            elseif mediumTable(m, n, ell) == 11 
                % XY9Med = getXYZ9Med(m, n, ell, mediumTable, 'XY');
                % if checkAirAround( XY9Med )
                    % PntSegValueXY = squeeze( SegValueXY(m, n, :, :) );
                    TmpTmprtr = T_bolus * ones(6, 8);
                    TmprSARseg(m, n, :, :) = TmpTmprtr;
                % end
            end
        end
    end

    tic;
    disp('time for interpolation: ')
    x_idx_maxI = 2 * x_idx_max - 1;
    y_idx_maxI = 2 * y_idx_max - 1;
    TmprIntrpltPnts = zeros( x_idx_maxI, y_idx_maxI );

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
            TmprIntrpltPnts(mI, nI) = ExecIntrplt( mI, nI, TmprSARseg, TtrVol, 'XY' );
        end
    end
    toc;

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
                TmprIntrplt9Pnts     = getIntrplt9Pnts(m, n, TmprIntrpltPnts);
                PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(m, n, :, :) );
                PntMidPnts9Crdnt(:, 3) = [];
                plotSAR_Intrplt( squeeze( SARseg( m, n, :, :) ), squeeze( TtrVol( m, n, :, : ) ), ...
                                        PntMidPnts9Crdnt, TmprIntrplt9Pnts, 'XY', 1 );
            end
        end
    toc;
    
    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cbar = colorbar;
    caxis([5, 50]);
    set(cbar, 'Ytick', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50], 'FontSize', 20); 
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    box on;
    view(2);
    hold on;

    paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
    % paras2dXY = [ h_torso, air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
    %             l_lung_x, l_lung_y, l_lung_a_prime, l_lung_b_prime, ...
    %             r_lung_x, r_lung_y, r_lung_a_prime, r_lung_b_prime, ...
    %             tumor_x, tumor_y, tumor_r_prime ];
    maskXY(paras2dXY(4), air_z, dx);
    plotXY( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );
    
    % ylabel(cbar, '$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
end

if flag_YZ_T == 1
    % load the SAR segments in the XZ cross section in PhiDstrbtn
    load( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat' ) );
    % load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0107\Case0107TmprtrFigYZ.mat');

    t = T_end;
    t_idx = t / dt + 1;
    T_YZ = zeros( y_idx_max, z_idx_max );
    T_YZ = squeeze( TmprtrTau( tumor_m, :, :, uint8(t_idx) ) );

    figure(23);
    clf;

    TmprSARseg = zeros( y_idx_max, z_idx_max, 6, 8 );

    for idx = 1: 1: y_idx_max * z_idx_max
        m = tumor_m;
        % idx = ( ell - 1 ) * y_idx_max + n;
        tmp_n = mod( idx, y_idx_max );
        if tmp_n == 0
            n = y_idx_max;
        else
            n = tmp_n;
        end
        ell = int64( ( idx - n ) / y_idx_max + 1 );

        BioValid = false;
        CnvctnFlag = false;
        
        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            % if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
            %     if mediumTable( m, n, ell ) == 0
            %         YZ9Med = getXYZ9Med(m, n, ell, mediumTable, 'YZ');
            %         if ~checkBolusAround( YZ9Med )
            %             BioValid = true;
            %         else
            %             if checkMuscleAround( YZ9Med )
            %                 CnvctnFlag = true;
            %             end
            %         end
            %     else
            %         BioValid = true;
            %     end
            % end

            % if n >= 16 && n <= 20 && ( ell == 11 || ell == 31 )
            %     CnvctnFlag = true;
            % end

 

            % if BioValid == true || mediumTable( m, n, ell ) == 2 % In bio or bolus
            if mediumTable(m, n, ell) == 2 || mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 7 ...
                || mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 12 || mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
                TmprSARseg(n, ell, :, :) = T_YZ(n, ell);
            % elseif CnvctnFlag == true
            elseif mediumTable(m, n, ell) == 13 
                PntSegValueYZ = squeeze( SegValueYZ(n, ell, :, :) );
                TmpTmprtr = T_bolus * ones(6, 8);
                TmpTmprtr( find(PntSegValueYZ ~= 2) ) = T_YZ(n, ell);
                TmprSARseg(n, ell, :, :) = TmpTmprtr;
            % elseif mediumTable( m, n, ell ) == 0 
            elseif mediumTable(m, n, ell) == 11
                % YZ9Med = getXYZ9Med(m, n, ell, mediumTable, 'YZ');
                % if checkAirAround( YZ9Med )
                    % PntSegValueYZ = squeeze( SegValueYZ(m, ell, :, :) );
                    TmpTmprtr = T_bolus * ones(6, 8);
                    TmprSARseg(n, ell, :, :) = TmpTmprtr;
                % end
            end
        end
    end

    tic;
    disp('time for interpolation: ')
    y_idx_maxI = 2 * y_idx_max - 1;
    z_idx_maxI = 2 * z_idx_max - 1;
    TmprIntrpltPnts = zeros( y_idx_maxI, z_idx_maxI );

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
            TmprIntrpltPnts(nI, ellI) = ExecIntrplt( nI, ellI, TmprSARseg, TtrVol, 'YZ' );
        end
    end
    toc;

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
        ell = int64( ( idx - m ) / y_idx_max + 1 );

        if n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
            TmprIntrplt9Pnts     = getIntrplt9Pnts(n, ell, TmprIntrpltPnts);
            PntMidPnts9Crdnt = squeeze( MidPnts9Crdnt(n, ell, :, :) );
            PntMidPnts9Crdnt(:, 1) = [];
            % the SARseg was used as MASK.
            plotSAR_Intrplt( squeeze( SARseg( n, ell, :, :) ), squeeze( TtrVol( n, ell, :, : ) ), ...
                                    PntMidPnts9Crdnt, TmprIntrplt9Pnts, 'YZ', 1 );
        end
    end
    toc;

    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cbar = colorbar;
    caxis([5, 50]);
    set(cbar, 'Ytick', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50], 'FontSize', 20); 
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 15, 15, - 15, 15 ] );
    box on;
    view(2);
    hold on;
    paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
    plotYZ( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    
    % ylabel(cbar, '$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');
end