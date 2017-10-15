T_end = bar_b(:, end);

disp('Checking bio and bolus related vetrices: ');
tic;
bioChecker = false(x_idx_max_B * y_idx_max_B * z_idx_max_B, 1);
for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m_B, n_B, ell_B ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v_B = 2 * m_B - 1;
    n_v_B = 2 * n_B - 1;
    ell_v_B = 2 * ell_B - 1;
    vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
    CandiTet = find( MedTetTable_B(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        TetRow = MedTetTableCell_B{ CandiTet(itr) };
        MedVal = TetRow(5);
        if MedVal >= 2
            bioChecker(idx) = true;
            break
        end
    end
end
toc;

if T_flagXZ == 1
    figure(21);
    clf;
    tumor_n_B   = ( tumor_y_es - 0 ) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;
    tumor_n_v_B = 2 * tumor_n_B - 1;
    T_xz = zeros(x_max_vertex_B, z_max_vertex_B);
    n_v_B = tumor_n_v_B;
    tic;
    disp('Getting T_xz'); 
    for vIdxXZ = 1: 1: x_max_vertex_B * z_max_vertex_B
        [ m_v_B, ell_v_B ] = getML(vIdxXZ, x_max_vertex_B);
        vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        T_xz(m_v_B, ell_v_B) = T_end( vIdx );
    end
    toc;

    tic;
    for idxXZ = 1: 1: x_idx_max_B * z_idx_max_B
        [ m_B, ell_B ] = getML(idxXZ, x_idx_max_B);
        idx = ( ell_B - 1 ) * x_idx_max_B * y_idx_max_B + ( tumor_n_B - 1 ) * x_idx_max_B + m_B;
        if bioChecker(idx)
            m_v_B = 2 * m_B - 1;
            ell_v_B = 2 * ell_B - 1;
            if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
                vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
                % CandiTet contain the indeces of tetrahedron who covers vIdx
                CandiTet = find( MedTetTable_B(:, vIdx));
                for itr = 1: 1: length(CandiTet)
                    % v is un-ordered vertices; while p is ordered vertices.
                    % fix the problem in the determination of v1234 here.
                    TetRow = MedTetTableCell_B{ CandiTet(itr) };
                    v1234 = TetRow(1: 4);
                    MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                    % the judgement below is based on the current test case
                    if MedVal >= 2 && MedVal <= 9 
                        valid = false;
                        p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                        m_v_4   = zeros(1, 4);
                        n_v_4   = zeros(1, 4);
                        ell_v_4 = zeros(1, 4);
                        [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        P1_Crdt = zeros(1, 3);
                        P2_Crdt = zeros(1, 3);
                        P3_Crdt = zeros(1, 3);
                        P4_Crdt = zeros(1, 3);
                        P1_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
                        P2_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
                        P3_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
                        P4_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
                        P1_Crdt(2) = [];
                        P2_Crdt(2) = [];
                        P3_Crdt(2) = [];
                        P4_Crdt(2) = [];

                        if n_v_4(1) == tumor_n_v_B && n_v_4(2) == tumor_n_v_B && n_v_4(3) == tumor_n_v_B && n_v_4(4) > tumor_n_v_B
                            valid = true;
                            f = [1 2 3];
                            v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                        elseif n_v_4(1) == tumor_n_v_B && n_v_4(2) == tumor_n_v_B && n_v_4(4) == tumor_n_v_B && n_v_4(3) > tumor_n_v_B
                            valid = true;
                            f = [1 2 4];
                            v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                        elseif n_v_4(1) == tumor_n_v_B && n_v_4(3) == tumor_n_v_B && n_v_4(4) == tumor_n_v_B && n_v_4(2) > tumor_n_v_B
                            valid = true;
                            f = [1 3 4];
                            v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                        elseif n_v_4(2) == tumor_n_v_B && n_v_4(3) == tumor_n_v_B && n_v_4(4) == tumor_n_v_B && n_v_4(1) > tumor_n_v_B
                            valid = true;
                            f = [2 3 4];
                            v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                        end
                        if n_v_4(1) == tumor_n_v_B && n_v_4(2) == tumor_n_v_B && n_v_4(3) == tumor_n_v_B && n_v_4(4) == tumor_n_v_B
                            error('check');
                        end
                        if valid
                            if MedVal >= 3
                                col = T_0 + [ T_xz( m_v_4(f(1)), ell_v_4(f(1)) ); T_xz( m_v_4(f(2)), ell_v_4(f(2)) ); T_xz( m_v_4(f(3)), ell_v_4(f(3)) ) ];
                            % elseif MedVal == 2
                            %     col = repmat(0, 3, 1);
                            % elseif MedVal == 1
                            %     col = repmat(T_air, 3, 1);
                            end
                            patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                        end
                    end
                end
            end
        end
    end
    toc;

    % shading interp

    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    caxis([30, 50]);
    axis equal;
    axis( [ - 5, 5, 0, 10 ] );
    cb = colorbar;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    hold on;
    paras2dXZ = genParas2d( tumor_y_es, paras, dx, dy, dz );
    plotMap_Eso( paras2dXZ, dx, dz );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(21), 'EsoMQSTmprtrXZ1011.jpg');
end

if T_flagXY == 1
    figure(22);
    clf;
    tumor_ell_B   = ( tumor_z_es - es_z ) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1;
    tumor_ell_v_B = 2 * tumor_ell_B - 1;
    T_xy = zeros(x_max_vertex_B, y_max_vertex_B);
    ell_v_B = tumor_ell_v_B;
    tic;
    disp('Getting T_xy'); 
    for vIdxXY = 1: 1: x_max_vertex_B * y_max_vertex_B
        [ m_v_B, n_v_B ] = getML(vIdxXY, x_max_vertex_B);
        vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        T_xy(m_v_B, n_v_B) = T_end( vIdx );
    end
    toc;

    tic;
    for idxXY = 1: 1: x_idx_max_B * y_idx_max_B
        [ m_B, n_B ] = getML(idxXY, x_idx_max_B);
        idx = ( tumor_ell_B - 1 ) * x_idx_max_B * y_idx_max_B + ( n_B - 1 ) * x_idx_max_B + m_B;
        if bioChecker(idx)
            m_v_B = 2 * m_B - 1;
            n_v_B = 2 * n_B - 1;
            if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 
                vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
                % CandiTet contain the indeces of tetrahedron who covers vIdx
                CandiTet = find( MedTetTable_B(:, vIdx));
                for itr = 1: 1: length(CandiTet)
                    % v is un-ordered vertices; while p is ordered vertices.
                    % fix the problem in the determination of v1234 here.
                    TetRow = MedTetTableCell_B{ CandiTet(itr) };
                    v1234 = TetRow(1: 4);
                    MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                    % the judgement below is based on the current test case
                    if MedVal >= 2 && MedVal <= 9
                        valid = false;
                        p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                        m_v_4   = zeros(1, 4);
                        n_v_4   = zeros(1, 4);
                        ell_v_4 = zeros(1, 4);
                        [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        P1_Crdt = zeros(1, 3);
                        P2_Crdt = zeros(1, 3);
                        P3_Crdt = zeros(1, 3);
                        P4_Crdt = zeros(1, 3);
                        P1_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
                        P2_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
                        P3_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
                        P4_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
                        P1_Crdt(3) = [];
                        P2_Crdt(3) = [];
                        P3_Crdt(3) = [];
                        P4_Crdt(3) = [];

                        if ell_v_4(1) == tumor_ell_v_B && ell_v_4(2) == tumor_ell_v_B && ell_v_4(3) == tumor_ell_v_B && ell_v_4(4) >= tumor_ell_v_B
                            valid = true;
                            f = [1 2 3];
                            v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                        elseif ell_v_4(1) == tumor_ell_v_B && ell_v_4(2) == tumor_ell_v_B && ell_v_4(4) == tumor_ell_v_B && ell_v_4(3) >= tumor_ell_v_B
                            valid = true;
                            f = [1 2 4];
                            v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                        elseif ell_v_4(1) == tumor_ell_v_B && ell_v_4(3) == tumor_ell_v_B && ell_v_4(4) == tumor_ell_v_B && ell_v_4(2) >= tumor_ell_v_B
                            valid = true;
                            f = [1 3 4];
                            v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                        elseif ell_v_4(2) == tumor_ell_v_B && ell_v_4(3) == tumor_ell_v_B && ell_v_4(4) == tumor_ell_v_B && ell_v_4(1) >= tumor_ell_v_B
                            valid = true;
                            f = [2 3 4];
                            v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                        end
                        if ell_v_4(1) == tumor_ell_v_B && ell_v_4(2) == tumor_ell_v_B && ell_v_4(3) == tumor_ell_v_B && ell_v_4(4) == tumor_ell_v_B
                            error('check');
                        end
                        if valid
                            if MedVal >= 3
                                col = T_0 + [ T_xy( m_v_4(f(1)), n_v_4(f(1)) ); T_xy( m_v_4(f(2)), n_v_4(f(2)) ); T_xy( m_v_4(f(3)), n_v_4(f(3)) ) ];
                            % elseif MedVal == 2
                            %     col = repmat(0, 3, 1);
                            % elseif MedVal == 1
                            %     col = repmat(T_air, 3, 1);
                            end
                            patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                        end
                    end
                end
            end
        end
    end
    toc;

    % shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    caxis([30, 50]);
    axis equal;
    axis( [ - 5, 5, - 5, 5 ] );
    cb = colorbar;
    set(cb, 'FontSize', 18);
    hold on;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    paras2dXY = genParas2dXY( tumor_z_es, paras, dx, dy, dz );
    plotXY_Eso( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(22), 'EsoMQSTmprtrXY1011.jpg');
end

if T_flagYZ == 1
    figure(23);
    clf;
    tumor_m_B   = ( tumor_x_es - es_x ) / dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1;
    tumor_m_v_B = 2 * tumor_m_B - 1;
    T_yz = zeros(y_max_vertex_B, z_max_vertex_B);
    m_v_B = tumor_m_v_B;
    tic;
    disp('Getting T_yz'); 
    for vIdxYZ = 1: 1: y_max_vertex_B * z_max_vertex_B
        [ n_v_B, ell_v_B ] = getML(vIdxYZ, y_max_vertex_B);
        vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        T_yz(n_v_B, ell_v_B) = T_end( vIdx );
    end
    toc;

    tic;
    for idxYZ = 1: 1: y_idx_max_B * z_idx_max_B
        [ n_B, ell_B ] = getML(idxYZ, y_idx_max_B);
        idx = ( ell_B - 1 ) * x_idx_max_B * y_idx_max_B + ( n_B - 1 ) * x_idx_max_B + tumor_m_B;
        if bioChecker(idx)
            n_v_B = 2 * n_B - 1;
            ell_v_B = 2 * ell_B - 1;
            if n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
                vIdx = ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
                % CandiTet contain the indeces of tetrahedron who covers vIdx
                CandiTet = find( MedTetTable_B(:, vIdx));
                for itr = 1: 1: length(CandiTet)
                    % v is un-ordered vertices; while p is ordered vertices.
                    % fix the problem in the determination of v1234 here.
                    TetRow = MedTetTableCell_B{ CandiTet(itr) };
                    v1234 = TetRow(1: 4);
                    MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                    % the judgement below is based on the current test case
                    if MedVal >= 2 && MedVal <= 9
                        valid = false;
                        p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                        m_v_4   = zeros(1, 4);
                        n_v_4   = zeros(1, 4);
                        ell_v_4 = zeros(1, 4);
                        [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                        P1_Crdt = zeros(1, 3);
                        P2_Crdt = zeros(1, 3);
                        P3_Crdt = zeros(1, 3);
                        P4_Crdt = zeros(1, 3);
                        P1_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
                        P2_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
                        P3_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
                        P4_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
                        P1_Crdt(1) = [];
                        P2_Crdt(1) = [];
                        P3_Crdt(1) = [];
                        P4_Crdt(1) = [];

                        if m_v_4(1) == tumor_m_v_B && m_v_4(2) == tumor_m_v_B && m_v_4(3) == tumor_m_v_B && m_v_4(4) >= tumor_m_v_B
                            valid = true;
                            f = [1 2 3];
                            v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                        elseif m_v_4(1) == tumor_m_v_B && m_v_4(2) == tumor_m_v_B && m_v_4(4) == tumor_m_v_B && m_v_4(3) >= tumor_m_v_B
                            valid = true;
                            f = [1 2 4];
                            v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                        elseif m_v_4(1) == tumor_m_v_B && m_v_4(3) == tumor_m_v_B && m_v_4(4) == tumor_m_v_B && m_v_4(2) >= tumor_m_v_B
                            valid = true;
                            f = [1 3 4];
                            v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                        elseif m_v_4(2) == tumor_m_v_B && m_v_4(3) == tumor_m_v_B && m_v_4(4) == tumor_m_v_B && m_v_4(1) >= tumor_m_v_B
                            valid = true;
                            f = [2 3 4];
                            v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                        end
                        if m_v_4(1) == tumor_m_v_B && m_v_4(2) == tumor_m_v_B && m_v_4(3) == tumor_m_v_B && m_v_4(4) == tumor_m_v_B
                            error('check');
                        end
                        if valid
                            if MedVal >= 3
                                col = T_0 + [ T_yz( n_v_4(f(1)), ell_v_4(f(1)) ); T_yz( n_v_4(f(2)), ell_v_4(f(2)) ); T_yz( n_v_4(f(3)), ell_v_4(f(3)) ) ];
                            % elseif MedVal == 2
                            %     col = repmat(0, 3, 1);
                            % elseif MedVal == 1
                            %     col = repmat(T_air, 3, 1);
                            end
                            patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'interp', 'LineStyle', 'none');
                        end
                    end
                end
            end
        end
    end
    toc;

    % shading interp
    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    cb = colorbar;
    set(cb, 'FontSize', 18);
    caxis([30, 50]);
    axis equal;
    axis( [ - 5, 5, 0, 10 ] );
    hold on;
    box on;
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    paras2dYZ = genParas2dYZ( tumor_x_es, paras, dy, dz );
    plotYZ_Eso( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(23), 'EsoMQSTmprtrYZ1011.jpg');
end

