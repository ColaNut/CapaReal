% local tumor indeices
% load('1001EsoEQS.mat', 'bar_x_my_gmresPhi');
y_idx_far  = (endo_y - 0 + tumor_hy_es / 2) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;
y_idx_near = (endo_y - 0 - tumor_hy_es / 2) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;

y_vIdx_far = 2 * y_idx_far - 1;
y_vIdx_near = 2 * y_idx_near - 1;

m_v_0_B = 2 * ( (tumor_x_es - dx_B - es_x) / dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1 ) - 1;
n_v_0_B = 2 * ( (tumor_y_es - tumor_hy_es / 2 - 0) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1 ) - 1;
ell_v_0_B = 2 * ( (tumor_z_es + dz_B - es_z) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1 ) - 1 + 1;

if flag_XZ == 1
    Phi_xz = zeros(x_max_vertex_B, z_max_vertex_B);
    n_v_B = n_v_0_B;
    tic;
    disp('Getting Phi_xz'); 
    for vIdxXZ = 1: 1: x_max_vertex_B * z_max_vertex_B
        [ m_v_B, ell_v_B ] = getML(vIdxXZ, x_max_vertex_B);
        vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        Phi_xz(m_v_B, ell_v_B) = bar_x_my_gmresPhi( vIdx );
    end
    toc;

    figure(41);
    clf;
    tic;
    for idxXZ = 1: 1: x_idx_max_B * z_idx_max_B
        [ m_B, ell_B ] = getML(idxXZ, x_idx_max_B);
        m_v_B = 2 * m_B - 1;
        ell_v_B = 2 * ell_B - 1;
        if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
            vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                % the judgement below is based on the current test case
                valid = false;
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                % to-do
                % get the vertex coordinate
                m_v_4   = zeros(1, 4);
                n_v_4   = zeros(1, 4);
                ell_v_4 = zeros(1, 4);
                [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
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

                if n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) > n_v_0_B
                    valid = true;
                    f = [1 2 3];
                    v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                elseif n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(4) == n_v_0_B && n_v_4(3) > n_v_0_B
                    valid = true;
                    f = [1 2 4];
                    v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                elseif n_v_4(1) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B && n_v_4(2) > n_v_0_B
                    valid = true;
                    f = [1 3 4];
                    v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                elseif n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B && n_v_4(1) > n_v_0_B
                    valid = true;
                    f = [2 3 4];
                    v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                end
                if n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B
                    error('check');
                end
                if valid
                    % if MedVal >= 3
                        col = abs([ Phi_xz( m_v_4(f(1)), ell_v_4(f(1)) ); Phi_xz( m_v_4(f(2)), ell_v_4(f(2)) ); Phi_xz( m_v_4(f(3)), ell_v_4(f(3)) ) ]);
                    % elseif MedVal == 2
                    %     col = repmat(T_bolus, 3, 1);
                    % % elseif MedVal == 1
                    % %     col = repmat(T_air, 3, 1);
                    % end
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
    caxis([0, 15]);
    axis equal;
    axis( [ - 5, 5, 0, 10 ] );
    cb = colorbar;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    set(cb, 'FontSize', 18);
    hold on;
    paras2dXZ = genParas2d( tumor_y_es, paras, dx, dy, dz );
    plotMap_Eso( paras2dXZ, dx, dz );
    plotRibXZ(Ribs, SSBone, dx, dz);
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(41), 'EsoEQS_PhiXZ1015.jpg');

    % figure(46);
    % clf;
    % myRange = [ 1e-1, 1e4 ];
    % caxis(myRange);
    % axis equal;
    % axis( [- 5, 5, 0, 10] );
    % cbar = colorbar('peer', gca, 'Yscale', 'log');
    % set(gca, 'Visible', 'off')
    % log_axes = axes('Position', get(gca, 'Position'));
    % ylabel(cbar, 'SAR (watt/kg)', 'Interpreter','LaTex', 'FontSize', 20);
    % set(cbar, 'FontSize', 18 );
    % hold on;

    % tic;
    % disp('Plotting SAR');
    % for idxXZ = 1: 1: x_idx_max_B * z_idx_max_B
    %     [ m_B, ell_B ] = getML(idxXZ, x_idx_max_B);
    %     m_v_B = 2 * m_B - 1;
    %     ell_v_B = 2 * ell_B - 1;
    %     if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
    %         vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
    %         % CandiTet contain the indeces of tetrahedron who covers vIdx
    %         CandiTet = find( MedTetTable_B(:, vIdx));
    %         for itr = 1: 1: length(CandiTet)
    %             % v is un-ordered vertices; while p is ordered vertices.
    %             % fix the problem in the determination of v1234 here.
    %             TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
    %             v1234 = TetRow(1: 4);
    %             MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
    %             % the judgement below is based on the current test case
    %             valid = false;
    %             p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
    %             % to-do
    %             % get the vertex coordinate
    %             m_v_4   = zeros(1, 4);
    %             n_v_4   = zeros(1, 4);
    %             ell_v_4 = zeros(1, 4);
    %             [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             P1_Crdt = zeros(1, 3);
    %             P2_Crdt = zeros(1, 3);
    %             P3_Crdt = zeros(1, 3);
    %             P4_Crdt = zeros(1, 3);
    %             P1_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
    %             P2_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
    %             P3_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
    %             P4_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
    %             [ E_field, E_square ] = calE( P1_Crdt' / 100, P2_Crdt' / 100, P3_Crdt' / 100, P4_Crdt' / 100, ...
    %                                     Phi_xz( m_v_4(1), ell_v_4(1) ), Phi_xz( m_v_4(2), ell_v_4(2) ), ...
    %                                     Phi_xz( m_v_4(3), ell_v_4(3) ), Phi_xz( m_v_4(4), ell_v_4(4) ) );
    %             col = sigma(MedVal) * E_square / (2 * rho(MedVal));
    %             P1_Crdt(2) = [];
    %             P2_Crdt(2) = [];
    %             P3_Crdt(2) = [];
    %             P4_Crdt(2) = [];

    %             if n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B
    %                 valid = true;
    %                 f = [1 2 3];
    %                 v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
    %             elseif n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(4) == n_v_0_B
    %                 valid = true;
    %                 f = [1 2 4];
    %                 v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
    %             elseif n_v_4(1) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B
    %                 valid = true;
    %                 f = [1 3 4];
    %                 v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
    %             elseif n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B
    %                 valid = true;
    %                 f = [2 3 4];
    %                 v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
    %             end
    %             if n_v_4(1) == n_v_0_B && n_v_4(2) == n_v_0_B && n_v_4(3) == n_v_0_B && n_v_4(4) == n_v_0_B
    %                 error('check');
    %             end
    %             if valid
    %                 % if MedVal >= 3
    %                 %     col = abs([ Phi_xz( m_v_4(f(1)), ell_v_4(f(1)) ); Phi_xz( m_v_4(f(2)), ell_v_4(f(2)) ); Phi_xz( m_v_4(f(3)), ell_v_4(f(3)) ) ]);
    %                 % elseif MedVal == 2
    %                 %     col = repmat(T_bolus, 3, 1);
    %                 % % elseif MedVal == 1
    %                 % %     col = repmat(T_air, 3, 1);
    %                 % end
    %                 patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'flat', 'LineStyle', 'none');
    %             end
    %         end
    %     end
    % end
    % toc;

    % % shading interp
    % caxis(log10(myRange));
    % colormap jet;
    % % axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * air_z / 2, 100 * air_z / 2 ]);
    % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    % axis equal;
    % axis( [- 5, 5, 0, 10] );
    % set(log_axes,'fontsize',20);
    % set(log_axes,'LineWidth',2.0);
    % % zlabel('$\hbox{SAR}$ (watt/$m^3$)','Interpreter','LaTex', 'FontSize', 20);
    % box on;
    % view(2);
    % paras2dXZ = genParas2d( tumor_y_es, paras, dx, dy, dz );
    % plotMap_Eso( paras2dXZ, dx, dz );
    % plotRibXZ(Ribs, SSBone, dx, dz);
    % saveas(figure(46), 'EsoEQS_SARXZ1015.jpg');

end

if flag_XY == 1
    figure(42);
    clf;
    ell_v_B = ell_v_0_B;
    Phi_xy = zeros(x_max_vertex_B, y_max_vertex_B);
    tic;
    disp('Getting Phi_xy'); 
    for vIdxXY = 1: 1: x_max_vertex_B * y_max_vertex_B
        [ m_v_B, n_v_B ] = getML(vIdxXY, x_max_vertex_B);
        vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        Phi_xy(m_v_B, n_v_B) = bar_x_my_gmresPhi( vIdx );
    end
    toc;

    tic;
    for idxXY = 1: 1: x_idx_max_B * y_idx_max_B
        [ m_B, n_B ] = getML(idxXY, x_idx_max_B);
        m_v_B = 2 * m_B - 1;
        n_v_B = 2 * n_B - 1;
        vIdx = N_v + ( ell_v_0_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                valid = false;
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                m_v_4   = zeros(1, 4);
                n_v_4   = zeros(1, 4);
                ell_v_4 = zeros(1, 4);
                [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
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

                if ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) >= ell_v_0_B
                    valid = true;
                    f = [1 2 3];
                    v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                elseif ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(4) == ell_v_0_B && ell_v_4(3) >= ell_v_0_B
                    valid = true;
                    f = [1 2 4];
                    v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                elseif ell_v_4(1) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B && ell_v_4(2) >= ell_v_0_B
                    valid = true;
                    f = [1 3 4];
                    v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                elseif ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B && ell_v_4(1) >= ell_v_0_B
                    valid = true;
                    f = [2 3 4];
                    v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                end
                if ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B
                    error('check');
                end
                if valid
                    % if MedVal >= 3
                        col = abs([ Phi_xy( m_v_4(f(1)), n_v_4(f(1)) ); Phi_xy( m_v_4(f(2)), n_v_4(f(2)) ); Phi_xy( m_v_4(f(3)), n_v_4(f(3)) ) ]);
                    % elseif MedVal == 2
                    %     col = repmat(T_bolus, 3, 1);
                    % elseif MedVal == 1
                    %     col = repmat(T_air, 3, 1);
                    % end
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
    caxis([0, 15]);
    axis equal;
    axis( [ - 5, 5, - 5, 5 ] );
    cb = colorbar;
    set(cb, 'FontSize', 18);
    hold on;
    box on;
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    paras2dXY = genParas2dXY( tumor_z_es, paras, dx, dy, dz );
    plotXY_Eso( paras2dXY, dx, dy );
    % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(42), 'EsoEQS_PhiXY1015.jpg');

    % figure(47);
    % clf;
    % tic;
    % for idxXY = 1: 1: x_idx_max_B * y_idx_max_B
    %     [ m_B, n_B ] = getML(idxXY, x_idx_max_B);
    %     m_v_B = 2 * m_B - 1;
    %     n_v_B = 2 * n_B - 1;
    %     vIdx = N_v + ( ell_v_0_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
    %     if m_v_B >= 2 && m_v_B <= x_max_vertex_B - 1 && n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 
    %         % CandiTet contain the indeces of tetrahedron who covers vIdx
    %         CandiTet = find( MedTetTable_B(:, vIdx));
    %         for itr = 1: 1: length(CandiTet)
    %             % v is un-ordered vertices; while p is ordered vertices.
    %             % fix the problem in the determination of v1234 here.
    %             TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
    %             v1234 = TetRow(1: 4);
    %             MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
    %             valid = false;
    %             p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
    %             m_v_4   = zeros(1, 4);
    %             n_v_4   = zeros(1, 4);
    %             ell_v_4 = zeros(1, 4);
    %             [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    %             P1_Crdt = zeros(1, 3);
    %             P2_Crdt = zeros(1, 3);
    %             P3_Crdt = zeros(1, 3);
    %             P4_Crdt = zeros(1, 3);
    %             P1_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(1), n_v_4(1), ell_v_4(1), :) )';
    %             P2_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(2), n_v_4(2), ell_v_4(2), :) )';
    %             P3_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(3), n_v_4(3), ell_v_4(3), :) )';
    %             P4_Crdt = 100 * squeeze( Vertex_Crdnt_B(m_v_4(4), n_v_4(4), ell_v_4(4), :) )';
    %             [ E_field, E_square ] = calE( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
    %                             Phi_xz( m_v_4(1), ell_v_4(1) ), Phi_xz( m_v_4(2), ell_v_4(2) ), ...
    %                             Phi_xz( m_v_4(3), ell_v_4(3) ), Phi_xz( m_v_4(4), ell_v_4(4) ) );
    %             col = sigma(MedVal) * E_square / (2 * rho(MedVal));
    %             P1_Crdt(3) = [];
    %             P2_Crdt(3) = [];
    %             P3_Crdt(3) = [];
    %             P4_Crdt(3) = [];

    %             if ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B
    %                 valid = true;
    %                 f = [1 2 3];
    %                 v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
    %             elseif ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(4) == ell_v_0_B
    %                 valid = true;
    %                 f = [1 2 4];
    %                 v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
    %             elseif ell_v_4(1) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B
    %                 valid = true;
    %                 f = [1 3 4];
    %                 v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
    %             elseif ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B
    %                 valid = true;
    %                 f = [2 3 4];
    %                 v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
    %             end
    %             if ell_v_4(1) == ell_v_0_B && ell_v_4(2) == ell_v_0_B && ell_v_4(3) == ell_v_0_B && ell_v_4(4) == ell_v_0_B
    %                 error('check');
    %             end
    %             if valid
    %                 % if MedVal >= 3
    %                 %     col = abs([ Phi_xy( m_v_4(f(1)), n_v_4(f(1)) ); Phi_xy( m_v_4(f(2)), n_v_4(f(2)) ); Phi_xy( m_v_4(f(3)), n_v_4(f(3)) ) ]);
    %                 % elseif MedVal == 2
    %                 %     col = repmat(T_bolus, 3, 1);
    %                 % elseif MedVal == 1
    %                 %     col = repmat(T_air, 3, 1);
    %                 % end
    %                 patch('Faces', [1, 2, 3], 'Vertices', v, 'FaceVertexCData', col, 'FaceColor', 'flat', 'LineStyle', 'none');
    %             end
    %         end
    %     end
    % end
    % toc;

    % % shading interp
    % colormap jet;
    % set(gca,'fontsize',20);
    % set(gca,'LineWidth',2.0);
    % caxis([0, 15]);
    % axis equal;
    % axis( [ - 5, 5, - 5, 5 ] );
    % cb = colorbar;
    % set(cb, 'FontSize', 18);
    % hold on;
    % box on;
    % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    % ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    % paras2dXY = genParas2dXY( tumor_z_es, paras, dx, dy, dz );
    % plotXY_Eso( paras2dXY, dx, dy );
    % % plotGridLineXY( shiftedCoordinateXYZ, tumor_ell_v );
    % % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    % saveas(figure(47), 'EsoEQS_SARXY1015.jpg');
end

if flag_YZ == 1
    figure(43);
    clf;
    Phi_yz = zeros(y_max_vertex_B, z_max_vertex_B);
    m_v_B = m_v_0_B;
    tic;
    disp('Getting Phi_yz'); 
    for vIdxYZ = 1: 1: y_max_vertex_B * z_max_vertex_B
        [ n_v_B, ell_v_B ] = getML(vIdxYZ, y_max_vertex_B);
        vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        Phi_yz(n_v_B, ell_v_B) = bar_x_my_gmresPhi( vIdx );
    end
    toc;

    tic;
    for idxYZ = 1: 1: y_idx_max_B * z_idx_max_B
        [ n_B, ell_B ] = getML(idxYZ, y_idx_max_B);
        n_v_B = 2 * n_B - 1;
        ell_v_B = 2 * ell_B - 1;
        vIdx = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        if n_v_B >= 2 && n_v_B <= y_max_vertex_B - 1 && ell_v_B >= 2 && ell_v_B <= z_max_vertex_B - 1 
            % CandiTet contain the indeces of tetrahedron who covers vIdx
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here.
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                MedVal = MedTetTable_B( CandiTet(itr), v1234(1) );
                valid = false;
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                m_v_4   = zeros(1, 4);
                n_v_4   = zeros(1, 4);
                ell_v_4 = zeros(1, 4);
                [ m_v_4(1), n_v_4(1), ell_v_4(1) ] = getMNL(p1234(1) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(2), n_v_4(2), ell_v_4(2) ] = getMNL(p1234(2) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(3), n_v_4(3), ell_v_4(3) ] = getMNL(p1234(3) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
                [ m_v_4(4), n_v_4(4), ell_v_4(4) ] = getMNL(p1234(4) - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
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

                if m_v_4(1) == m_v_0_B && m_v_4(2) == m_v_0_B && m_v_4(3) == m_v_0_B && m_v_4(4) >= m_v_0_B
                    valid = true;
                    f = [1 2 3];
                    v = [ P1_Crdt; P2_Crdt; P3_Crdt ];
                elseif m_v_4(1) == m_v_0_B && m_v_4(2) == m_v_0_B && m_v_4(4) == m_v_0_B && m_v_4(3) >= m_v_0_B
                    valid = true;
                    f = [1 2 4];
                    v = [ P1_Crdt; P2_Crdt; P4_Crdt ];
                elseif m_v_4(1) == m_v_0_B && m_v_4(3) == m_v_0_B && m_v_4(4) == m_v_0_B && m_v_4(2) >= m_v_0_B
                    valid = true;
                    f = [1 3 4];
                    v = [ P1_Crdt; P3_Crdt; P4_Crdt ];
                elseif m_v_4(2) == m_v_0_B && m_v_4(3) == m_v_0_B && m_v_4(4) == m_v_0_B && m_v_4(1) >= m_v_0_B
                    valid = true;
                    f = [2 3 4];
                    v = [ P2_Crdt; P3_Crdt; P4_Crdt ];
                end
                if m_v_4(1) == m_v_0_B && m_v_4(2) == m_v_0_B && m_v_4(3) == m_v_0_B && m_v_4(4) == m_v_0_B
                    error('check');
                end
                if valid
                    % if MedVal >= 3
                        col = abs([ Phi_yz( n_v_4(f(1)), ell_v_4(f(1)) ); Phi_yz( n_v_4(f(2)), ell_v_4(f(2)) ); Phi_yz( n_v_4(f(3)), ell_v_4(f(3)) ) ]);
                    % elseif MedVal == 2
                    %     col = repmat(T_bolus, 3, 1);
                    % elseif MedVal == 1
                    %     col = repmat(T_air, 3, 1);
                    % end
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
    cb = colorbar;
    set(cb, 'FontSize', 18);
    caxis([0, 15]);
    axis equal;
    axis( [ - 5, 5, 0, 10 ] );
    hold on;
    box on;
    xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 25);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 25);
    ylabel(cb, '$\left| \Phi \right|$ ($V$)', 'Interpreter','LaTex', 'FontSize', 20);
    paras2dYZ = genParas2dYZ( tumor_x_es, paras, dy, dz );
    plotYZ_Eso( paras2dYZ, dy, dz );
    % plotGridLineYZ( shiftedCoordinateXYZ, tumor_m_v );
    % plotMap( paras2dXZ, dx, dz, top_x0, top_dx, down_dx );
    % plotGridLineXZ( shiftedCoordinateXYZ, uint64(y / dy + h_torso / (2 * dy) + 1) );
    saveas(figure(43), 'EsoEQS_PhiYZ1015.jpg');
end