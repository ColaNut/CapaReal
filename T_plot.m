T_end = bar_b(:, end);

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % updating the bolus
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 2
%         T_end(v1234) = T_bolus;
%     end
% end
% % updating the muscle
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 3
%         T_end(v1234) = T_0;
%     end
% end

if T_flagXZ == 1
    figure(4);
    clf;
    tumor_n_v = 2 * tumor_n - 1;
    % tumor_n_v = ( y_max_vertex + 1 ) / 2;
    T_xz = zeros(x_max_vertex, z_max_vertex);
    n_v = tumor_n_v;
    tic;
    disp('Getting T_xz'); 
    for vIdxXZ = 1: 1: x_max_vertex * z_max_vertex
        [ m_v, ell_v ] = getML(vIdxXZ, x_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        T_xz(m_v, ell_v) = T_end( vIdx );
    end
    toc;

    % x_mesh = squeeze(Vertex_Crdnt( :, tumor_n_v, :, 1))';
    % z_mesh = squeeze(Vertex_Crdnt( :, tumor_n_v, :, 3))';
    % pcolor(x_mesh * 100, z_mesh * 100, abs( T_xz' ));

    tic;
    for vIdxXZ = 1: 1: x_max_vertex * z_max_vertex
        [ m_v, ell_v ] = getML(vIdxXZ, x_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        % CandiTet contain the indeces of tetrahedron who covers vIdx
        CandiTet = find( MedTetTable(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            % v is un-ordered vertices; while p is ordered vertices.
            % fix the problem in the determination of v1234 here.
            TetRow = MedTetTableCell{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            MedVal = MedTetTable( CandiTet(itr), v1234(1) );
            % the judgement below is based on the current test case
            if MedVal >= 2 && MedVal <= 9
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
                    if MedVal >= 3
                        col = T_0 + [ T_xz( m_v_4(f(1)), ell_v_4(f(1)) ); T_xz( m_v_4(f(2)), ell_v_4(f(2)) ); T_xz( m_v_4(f(3)), ell_v_4(f(3)) ) ];
                    elseif MedVal == 2
                        col = repmat(T_bolus, 3, 1);
                    % elseif MedVal == 1
                    %     col = repmat(T_air, 3, 1);
                    end
                    patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                end
            end
        end
    end
    toc;

    % shading interp

    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    caxis([5, 50]);
    axis( [ - 20, 20, - 15, 15 ] );
    colorbar;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    hold on;
    paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    plotMap( paras2dXZ, dx, dz );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(4), 'TestTmprtrXZ.jpg');
end

if T_flagXY == 1
    figure(5);
    clf;
    tumor_ell_v = 2 * tumor_ell - 1;
    % tumor_ell_v = ( z_max_vertex + 1 ) / 2;
    T_xy = zeros(x_max_vertex, y_max_vertex);
    ell_v = tumor_ell_v;
    tic;
    disp('Getting T_xy'); 
    for vIdxXY = 1: 1: x_max_vertex * y_max_vertex
        [ m_v, n_v ] = getML(vIdxXY, x_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        T_xy(m_v, n_v) = T_end( vIdx );
    end
    toc;

    tic;
    for vIdxXY = 1: 1: x_max_vertex * y_max_vertex
        [ m_v, n_v ] = getML(vIdxXY, x_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        % CandiTet contain the indeces of tetrahedron who covers vIdx
        CandiTet = find( MedTetTable(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            % v is un-ordered vertices; while p is ordered vertices.
            % fix the problem in the determination of v1234 here.
            TetRow = MedTetTableCell{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            MedVal = MedTetTable( CandiTet(itr), v1234(1) );
            % the judgement below is based on the current test case
            if MedVal >= 2 && MedVal <= 9
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
                P1_Crdt(3) = [];
                P2_Crdt(3) = [];
                P3_Crdt(3) = [];
                P4_Crdt(3) = [];

                if ell_v_4(1) == tumor_ell_v && ell_v_4(2) == tumor_ell_v && ell_v_4(3) == tumor_ell_v
                    valid = true;
                    f = [1 2 3];
                    v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                elseif ell_v_4(1) == tumor_ell_v && ell_v_4(2) == tumor_ell_v && ell_v_4(4) == tumor_ell_v
                    valid = true;
                    f = [1 2 4];
                    v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                elseif ell_v_4(1) == tumor_ell_v && ell_v_4(3) == tumor_ell_v && ell_v_4(4) == tumor_ell_v
                    valid = true;
                    f = [1 3 4];
                    v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                elseif ell_v_4(2) == tumor_ell_v && ell_v_4(3) == tumor_ell_v && ell_v_4(4) == tumor_ell_v
                    valid = true;
                    f = [2 3 4];
                    v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                end
                if ell_v_4(1) == tumor_ell_v && ell_v_4(2) == tumor_ell_v && ell_v_4(3) == tumor_ell_v && ell_v_4(4) == tumor_ell_v
                    error('check');
                end
                if valid
                    if MedVal >= 3
                        col = T_0 + [ T_xy( m_v_4(f(1)), n_v_4(f(1)) ); T_xy( m_v_4(f(2)), n_v_4(f(2)) ); T_xy( m_v_4(f(3)), n_v_4(f(3)) ) ];
                    elseif MedVal == 2
                        col = repmat(T_bolus, 3, 1);
                    % elseif MedVal == 1
                    %     col = repmat(T_air, 3, 1);
                    end
                    patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                end
            end
        end
    end
    toc;

    % shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    caxis([5, 50]);
    axis( [ - 20, 20, - 15, 15 ] );
    colorbar;
    hold on;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
    plotXY( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(5), 'TestTmprtrXY.jpg');
end

if T_flagYZ == 1
    figure(6);
    clf;
    tumor_m_v = 2 * tumor_m - 1;
    % m_v_mid_plot = ( x_max_vertex + 1 ) / 2;
    T_yz = zeros(y_max_vertex, z_max_vertex);
    m_v = tumor_m_v;
    tic;
    disp('Getting T_yz'); 
    for vIdxYZ = 1: 1: y_max_vertex * z_max_vertex
        [ n_v, ell_v ] = getML(vIdxYZ, y_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        T_yz(n_v, ell_v) = T_end( vIdx );
    end
    toc;

    tic;
    for vIdxYZ = 1: 1: y_max_vertex * z_max_vertex
        [ n_v, ell_v ] = getML(vIdxYZ, y_max_vertex);
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        % CandiTet contain the indeces of tetrahedron who covers vIdx
        CandiTet = find( MedTetTable(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            % v is un-ordered vertices; while p is ordered vertices.
            % fix the problem in the determination of v1234 here.
            TetRow = MedTetTableCell{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            MedVal = MedTetTable( CandiTet(itr), v1234(1) );
            % the judgement below is based on the current test case
            if MedVal >= 2 && MedVal <= 9
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
                P1_Crdt(1) = [];
                P2_Crdt(1) = [];
                P3_Crdt(1) = [];
                P4_Crdt(1) = [];

                if m_v_4(1) == tumor_m_v && m_v_4(2) == tumor_m_v && m_v_4(3) == tumor_m_v
                    valid = true;
                    f = [1 2 3];
                    v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                elseif m_v_4(1) == tumor_m_v && m_v_4(2) == tumor_m_v && m_v_4(4) == tumor_m_v
                    valid = true;
                    f = [1 2 4];
                    v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                elseif m_v_4(1) == tumor_m_v && m_v_4(3) == tumor_m_v && m_v_4(4) == tumor_m_v
                    valid = true;
                    f = [1 3 4];
                    v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                elseif m_v_4(2) == tumor_m_v && m_v_4(3) == tumor_m_v && m_v_4(4) == tumor_m_v
                    valid = true;
                    f = [2 3 4];
                    v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                end
                if m_v_4(1) == tumor_m_v && m_v_4(2) == tumor_m_v && m_v_4(3) == tumor_m_v && m_v_4(4) == tumor_m_v
                    error('check');
                end
                if valid
                    if MedVal >= 3
                        col = T_0 + [ T_yz( n_v_4(f(1)), ell_v_4(f(1)) ); T_yz( n_v_4(f(2)), ell_v_4(f(2)) ); T_yz( n_v_4(f(3)), ell_v_4(f(3)) ) ];
                    elseif MedVal == 2
                        col = repmat(T_bolus, 3, 1);
                    % elseif MedVal == 1
                    %     col = repmat(T_air, 3, 1);
                    end
                    patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                end
            end
        end
    end
    toc;

    % shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    colorbar;
    caxis([5, 50]);
    axis( [ - 15, 15, - 15, 15 ] );
    hold on;
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
    plotYZ( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(6), 'TestTmprtrYZ.jpg');
end

