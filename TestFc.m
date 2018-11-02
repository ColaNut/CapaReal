if T_flagXZ == 1
    figure(21);
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
    for idxXZ = 1: 1: x_idx_max * z_idx_max
        [ m, ell ] = getML(idxXZ, x_idx_max);
        m_v = 2 * m - 1;
        ell_v = 2 * ell - 1;
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( tumor_n - 1 ) * x_idx_max + m;
        if bioChecker(idx)
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
    end
    toc;

    % shading interp

    colormap jet;
    set(gca,'fontsize',20);
    set(gca,'LineWidth',2.0);
    caxis([5, 50]);
    axis equal;
    axis( [ - 20, 20, - 15, 15 ] );
    cb = colorbar;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    ylabel(cb, '$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    hold on;
    paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
    plotMap( paras2dXZ, dx, dz );
    plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    % saveas(figure(21), 'TmprtrXZ_0615Case1.jpg');
end