T_end = bar_b(:, end);

if T_flagXZ == 1
    figure(4);
    n_v_mid_plot = ( y_max_vertex + 1 ) / 2;
    T_xz = zeros(x_max_vertex, z_max_vertex);
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if n_v == n_v_mid_plot
            T_xz(m_v, ell_v) = T_end(vIdx);
        end
    end

    % x_mesh = squeeze(Vertex_Crdnt( :, n_v_mid_plot, :, 1))';
    % z_mesh = squeeze(Vertex_Crdnt( :, n_v_mid_plot, :, 3))';
    % pcolor(x_mesh * 100, z_mesh * 100, abs( T_xz' ));

    tic;
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if n_v == n_v_mid_plot
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                v1234 = find( MedTetTable( CandiTet(itr), : ) );
                MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % the judgement below is based on the current test case
                if MedVal == 3
                    valid = false;
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    m_v   = zeros(1, 4);
                    n_v   = zeros(1, 4);
                    ell_v = zeros(1, 4);
                    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(p1234(1), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(p1234(2), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(p1234(3), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(p1234(4), x_max_vertex, y_max_vertex, z_max_vertex);
                    P1_Crdt = zeros(1, 3);
                    P2_Crdt = zeros(1, 3);
                    P3_Crdt = zeros(1, 3);
                    P4_Crdt = zeros(1, 3);
                    P1_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
                    P2_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
                    P3_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
                    P4_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';
                    P1_Crdt(2) = [];
                    P2_Crdt(2) = [];
                    P3_Crdt(2) = [];
                    P4_Crdt(2) = [];

                    if n_v(1) == n_v_mid_plot && n_v(2) == n_v_mid_plot && n_v(3) == n_v_mid_plot
                        valid = true;
                        f = [1 2 3];
                        v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                    elseif n_v(1) == n_v_mid_plot && n_v(2) == n_v_mid_plot && n_v(4) == n_v_mid_plot
                        valid = true;
                        f = [1 2 4];
                        v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                    elseif n_v(1) == n_v_mid_plot && n_v(3) == n_v_mid_plot && n_v(4) == n_v_mid_plot
                        valid = true;
                        f = [1 3 4];
                        v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                    elseif n_v(2) == n_v_mid_plot && n_v(3) == n_v_mid_plot && n_v(4) == n_v_mid_plot
                        valid = true;
                        f = [2 3 4];
                        v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                    end
                    if n_v(1) == n_v_mid_plot && n_v(2) == n_v_mid_plot && n_v(3) == n_v_mid_plot && n_v(4) == n_v_mid_plot
                        error('check');
                    end
                    if valid
                        col = [ T_xz( m_v(f(1)), ell_v(f(1)) ); T_xz( m_v(f(2)), ell_v(f(2)) ); T_xz( m_v(f(3)), ell_v(f(3)) ) ];
                        patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp');
                    end
                end
            end
        end
    end
    toc;

    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    hold on;
    plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
end

if T_flagXY == 1
    figure(5);
    ell_v_mid_plot = ( z_max_vertex + 1 ) / 2;
    T_xy = zeros(x_max_vertex, y_max_vertex);
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if ell_v == ell_v_mid_plot
            T_xy(m_v, n_v) = T_end(vIdx);
        end
    end

    tic;
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if ell_v == ell_v_mid_plot
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                v1234 = find( MedTetTable( CandiTet(itr), : ) );
                MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % the judgement below is based on the current test case
                if MedVal == 3
                    valid = false;
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    m_v   = zeros(1, 4);
                    n_v   = zeros(1, 4);
                    ell_v = zeros(1, 4);
                    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(p1234(1), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(p1234(2), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(p1234(3), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(p1234(4), x_max_vertex, y_max_vertex, z_max_vertex);
                    P1_Crdt = zeros(1, 3);
                    P2_Crdt = zeros(1, 3);
                    P3_Crdt = zeros(1, 3);
                    P4_Crdt = zeros(1, 3);
                    P1_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
                    P2_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
                    P3_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
                    P4_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';
                    P1_Crdt(3) = [];
                    P2_Crdt(3) = [];
                    P3_Crdt(3) = [];
                    P4_Crdt(3) = [];

                    if ell_v(1) == ell_v_mid_plot && ell_v(2) == ell_v_mid_plot && ell_v(3) == ell_v_mid_plot
                        valid = true;
                        f = [1 2 3];
                        v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                    elseif ell_v(1) == ell_v_mid_plot && ell_v(2) == ell_v_mid_plot && ell_v(4) == ell_v_mid_plot
                        valid = true;
                        f = [1 2 4];
                        v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                    elseif ell_v(1) == ell_v_mid_plot && ell_v(3) == ell_v_mid_plot && ell_v(4) == ell_v_mid_plot
                        valid = true;
                        f = [1 3 4];
                        v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                    elseif ell_v(2) == ell_v_mid_plot && ell_v(3) == ell_v_mid_plot && ell_v(4) == ell_v_mid_plot
                        valid = true;
                        f = [2 3 4];
                        v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                    end
                    if ell_v(1) == ell_v_mid_plot && ell_v(2) == ell_v_mid_plot && ell_v(3) == ell_v_mid_plot && ell_v(4) == ell_v_mid_plot
                        error('check');
                    end
                    if valid
                        col = [ T_xy( m_v(f(1)), n_v(f(1)) ); T_xy( m_v(f(2)), n_v(f(2)) ); T_xy( m_v(f(3)), n_v(f(3)) ) ];
                        patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp');
                    end
                end
            end
        end
    end
    toc;

    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    hold on;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    plotGridLineXY( shiftedCoordinateXYZ, ell_v_mid_plot );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
end

if T_flagYZ == 1
    figure(6);
    m_v_mid_plot = ( x_max_vertex + 1 ) / 2;
    T_yz = zeros(y_max_vertex, z_max_vertex);
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if m_v == m_v_mid_plot
            T_yz(n_v, ell_v) = T_end(vIdx);
        end
    end

    tic;
    for vIdx = 1: 1: N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if m_v == m_v_mid_plot
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                v1234 = find( MedTetTable( CandiTet(itr), : ) );
                MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % the judgement below is based on the current test case
                if MedVal == 3
                    valid = false;
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    m_v   = zeros(1, 4);
                    n_v   = zeros(1, 4);
                    ell_v = zeros(1, 4);
                    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(p1234(1), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(p1234(2), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(p1234(3), x_max_vertex, y_max_vertex, z_max_vertex);
                    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(p1234(4), x_max_vertex, y_max_vertex, z_max_vertex);
                    P1_Crdt = zeros(1, 3);
                    P2_Crdt = zeros(1, 3);
                    P3_Crdt = zeros(1, 3);
                    P4_Crdt = zeros(1, 3);
                    P1_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
                    P2_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
                    P3_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
                    P4_Crdt = 100 * squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';
                    P1_Crdt(1) = [];
                    P2_Crdt(1) = [];
                    P3_Crdt(1) = [];
                    P4_Crdt(1) = [];

                    if m_v(1) == m_v_mid_plot && m_v(2) == m_v_mid_plot && m_v(3) == m_v_mid_plot
                        valid = true;
                        f = [1 2 3];
                        v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                    elseif m_v(1) == m_v_mid_plot && m_v(2) == m_v_mid_plot && m_v(4) == m_v_mid_plot
                        valid = true;
                        f = [1 2 4];
                        v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                    elseif m_v(1) == m_v_mid_plot && m_v(3) == m_v_mid_plot && m_v(4) == m_v_mid_plot
                        valid = true;
                        f = [1 3 4];
                        v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                    elseif m_v(2) == m_v_mid_plot && m_v(3) == m_v_mid_plot && m_v(4) == m_v_mid_plot
                        valid = true;
                        f = [2 3 4];
                        v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                    end
                    if m_v(1) == m_v_mid_plot && m_v(2) == m_v_mid_plot && m_v(3) == m_v_mid_plot && m_v(4) == m_v_mid_plot
                        error('check');
                    end
                    if valid
                        col = [ T_yz( n_v(f(1)), ell_v(f(1)) ); T_yz( n_v(f(2)), ell_v(f(2)) ); T_yz( n_v(f(3)), ell_v(f(3)) ) ];
                        patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp');
                    end
                end
            end
        end
    end
    toc;

    shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    hold on;
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    plotGridLineYZ( shiftedCoordinateXYZ, m_v_mid_plot );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
end