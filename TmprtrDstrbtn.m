T_end = bar_b(:, end);

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % use bio-checker to detect air region.
% disp('Checking bio and bolus related vetrices: ');
% tic;
% bioChecker = false(x_max_vertex * y_max_vertex * z_max_vertex, 1);
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     CandiTet = find( MedTetTable(:, vIdx));
%     for itr = 1: 1: length(CandiTet)
%         TetRow = MedTetTableCell{ CandiTet(itr) };
%         MedVal = TetRow(5);
%         if MedVal >= 3
%             bioChecker(vIdx) = true;
%             break
%         end
%     end
% end
% bolusChecker = false(x_idx_max * y_idx_max * z_idx_max, 1);
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;
%     vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
%     CandiTet = find( MedTetTable(:, vIdx));
%     for itr = 1: 1: length(CandiTet)
%         TetRow = MedTetTableCell{ CandiTet(itr) };
%         MedVal = TetRow(5);
%         if MedVal == 2
%             bolusChecker(idx) = true;
%             break
%         end
%     end
% end
% toc;

if T_flagXZ == 1

    figure(21);
    clf;
    tumor_n_v = 2 * tumor_n - 1;
    % tumor_n_v = ( y_max_vertex + 1 ) / 2;
    T_xz = NaN(x_max_vertex, z_max_vertex);
    n_v = tumor_n_v;
    tic;
    disp('Getting T_xz'); 
    for vIdxXZ = 1: 1: x_max_vertex * z_max_vertex
        [ m_v, ell_v ] = getML(vIdxXZ, x_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        if bioChecker(vIdx)
            T_xz(m_v, ell_v) = T_end( vIdx );
        end
    end
    toc;

    x_mesh = zeros( z_max_vertex, x_max_vertex );
    z_mesh = zeros( z_max_vertex, x_max_vertex );
    x_mesh = squeeze(Vertex_Crdnt( :, n_v, :, 1))';
    z_mesh = squeeze(Vertex_Crdnt( :, n_v, :, 3))';

    % Apply G to plot bolus region
    tic;
    for idxXZ = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idxXZ, x_idx_max);
        m_v = 2 * m - 1;
        ell_v = 2 * ell - 1;
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( tumor_n - 1 ) * x_idx_max + m;
        if bolusChecker(idx)
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                TetRow = MedTetTableCell{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % the judgement below is based on the current test case
                if MedVal == 2
                    valid = false;
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    m_v_4   = zeros(1, 4);
                    n_v_4   = zeros(1, 4);
                    ell_v_4 = zeros(1, 4);
                    [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4), x_max_vertex, y_max_vertex, z_max_vertex);
                    P1_Crdt = zeros(1, 3);
                    P2_Crdt = zeros(1, 3);
                    P3_Crdt = zeros(1, 3);
                    P4_Crdt = zeros(1, 3);
                    P1_Crdt = 100 * squeeze( Vertex_Crdnt(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
                    P2_Crdt = 100 * squeeze( Vertex_Crdnt(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
                    P3_Crdt = 100 * squeeze( Vertex_Crdnt(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
                    P4_Crdt = 100 * squeeze( Vertex_Crdnt(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
                    P1_Crdt(2) = [];
                    P2_Crdt(2) = [];
                    P3_Crdt(2) = [];
                    P4_Crdt(2) = [];

                    if n_v_4(1) == tumor_n_v && n_v_4(2) == tumor_n_v && n_v_4(3) == tumor_n_v
                        valid = true;
                        f = [1 2 3];
                        v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                    elseif n_v_4(1) == tumor_n_v && n_v_4(2) == tumor_n_v && n_v_4(4) == tumor_n_v
                        valid = true;
                        f = [1 2 4];
                        v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                    elseif n_v_4(1) == tumor_n_v && n_v_4(3) == tumor_n_v && n_v_4(4) == tumor_n_v
                        valid = true;
                        f = [1 3 4];
                        v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                    elseif n_v_4(2) == tumor_n_v && n_v_4(3) == tumor_n_v && n_v_4(4) == tumor_n_v
                        valid = true;
                        f = [2 3 4];
                        v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                    end
                    if n_v_4(1) == tumor_n_v && n_v_4(2) == tumor_n_v && n_v_4(3) == tumor_n_v && n_v_4(4) == tumor_n_v
                        error('check');
                    end
                    if valid
                        if MedVal == 2
                            col = repmat(T_bolus, 3, 1);
                        end
                        patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                    end
                end
            end
        end
    end
    toc;

    pcolor(x_mesh * 100, z_mesh * 100, T_xz');

    axis equal;
    axis( [ - 20, 20, - 20, 20 ] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    % caxis([5, 50]);
    ylabel(cb, '$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    view(2);
    hold on;
    plotMap( paras2dXZ, dx, dz );
    plotRibXZ(Ribs, SSBone, dx, dz);

end

% end

if T_flagXY == 1

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
            PhiTpElctrd( m, n, 2 ) = bar_x_my_gmres_mod(idx);
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
            PhiTpElctrd( m, n, 3 ) = bar_x_my_gmres_mod(idx);
            ThrXYZCrndt( :, :, 3, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 3 ) = mediumTable( :, :, ell );
        end

        if ell == CrossEll - 1
            PhiTpElctrd( m, n, 1 ) = bar_x_my_gmres_mod(idx);
            ThrXYZCrndt( :, :, 1, :) = shiftedCoordinateXYZ( :, :, ell, :);
            ThrMedValue( :, :, 1 ) = mediumTable( :, :, ell );
        end

    end

    figure(6);
    clf;
    PhiTpElctrd2 = squeeze(PhiTpElctrd(:, :, 2));
    pcolor(x_mesh * 100, y_mesh * 100, abs( PhiTpElctrd2' ));
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    caxis([0, 100]);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    box on;
    % axis( [ min(min(x_mesh)) * 100, max(max(x_mesh)) * 100, ...
    %         min(min(z_mesh)) * 100, max(max(z_mesh)) * 100, ...
    %         min(min(abs( PhiHlfY2' ))), max(max(abs( PhiHlfY2' ))) ] );
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    view(2);
    hold on;
    plotXY( paras2dXY, dx, dy );
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
    figure(7);
    clf;
    myRange = [ 9.99e-2, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ]);
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18 );
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
                                    PntMidPnts9Crdnt, Intrplt9Pnts, 'XY', 0 );
        end

    end
    toc;

    caxis(log10(myRange));
    colormap jet;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ]);
    % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 18);
    set(log_axes,'fontsize',20);
    set(log_axes,'LineWidth',2.0);
    box on;
    view(2);
    % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2 ]);
    maskXY(paras2dXY(4), air_z, dx);
    plotXY( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigXY.mat') );
end

if T_flagYZ == 1

    PhiYZ       = zeros( 3, y_idx_max, z_idx_max );
    ThrXYZCrndt = zeros( 3, y_idx_max, z_idx_max, 3);
    ThrMedValue = zeros( 3, y_idx_max, z_idx_max );
    SegValueYZ  = zeros( y_idx_max, z_idx_max, 6, 8, 'uint8' );
    y_mesh      = zeros( z_idx_max, y_idx_max );
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
            % XZmidY( ell, m ) = bar_x_my_gmres_mod(idx);
            PhiYZ( 2, n, ell ) = bar_x_my_gmres_mod(idx);
            ThrXYZCrndt( 2, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 2, :, : ) = mediumTable( m, :, : );
            SegValueYZ( n, ell, :, : ) = squeeze( SegMed( m, n, ell, :, : ) );
            y_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 2))';
            z_mesh = squeeze(shiftedCoordinateXYZ( m, :, :, 3))';
            paras2dYZ = genParas2dYZ( x, paras, dy, dz );
        end

        if m == CrossM + 1
            PhiYZ( 3, n, ell ) = bar_x_my_gmres_mod(idx);
            ThrXYZCrndt( 3, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 3, :, : ) = mediumTable( m, :, : );
        end

        if m == CrossM - 1
            PhiYZ( 1, n, ell ) = bar_x_my_gmres_mod(idx);
            ThrXYZCrndt( 1, :, :, :) = shiftedCoordinateXYZ( m, :, :, :);
            ThrMedValue( 1, :, : ) = mediumTable( m, :, : );
        end

    end

    figure(11);
    clf;
    PhiYZ2 = squeeze(PhiYZ(2, :, :));
    pcolor(y_mesh * 100, z_mesh * 100, abs( PhiYZ2' ));
    axis equal;
    axis( [ - 15, 15, - 20, 20 ] );
    % shading flat
    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    % caxis([-50, 50])
    caxis([0, 100]);;
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
    plotYZ( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    box on;
    view(2);
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');

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
    figure(12);
    clf;
    myRange = [ 9.99e-2, 1e4 ];
    caxis(myRange);
    axis equal;
    axis( [ - 15, 15, - 15, 15 ]);
    cbar = colorbar('peer', gca, 'Yscale', 'log');
    set(gca, 'Visible', 'off')
    log_axes = axes('Position', get(gca, 'Position'));
    ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cbar, 'FontSize', 18);
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
    plotYZ( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
    axis equal;
    axis( [ - 15, 15, - 15, 15 ]);
    % axis( [ - 100 * h_torso / 2, 100 * h_torso / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    view(2);
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
    % save( strcat( fname, '\', CaseDate, 'TmprtrFigYZ.mat') ); 
end