function Pnt_d = filld_Fine( p1234, N_v, Pnt_d, ...
                            dt, Q_s, rho, xi, zeta, cap, rho_b, cap_b, alpha, T_blood, T_bolus, ...
                            x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                            w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                            Vertex_Crdnt, Vertex_Crdnt_B, ...
                            BndryTable, BndryTable_B, BM_bndryNum )
    
    % === % ============ % === %
    % === % Filling of U % === %
    % === % ============ % === %

    % get the vol
    P1_Crdt = zeros(1, 3);
    P2_Crdt = zeros(1, 3);
    P3_Crdt = zeros(1, 3);
    P4_Crdt = zeros(1, 3);
    P1_Crdt = v2Crdnt(p1234(1), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B );
    P2_Crdt = v2Crdnt(p1234(2), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B );
    P3_Crdt = v2Crdnt(p1234(3), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B );
    P4_Crdt = v2Crdnt(p1234(4), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B );

    TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );
    
    P1_flag = 0;
    P2_flag = 0;
    P3_flag = 0;
    P4_flag = 0;
    P1_flag = v2Crdnt(p1234(1), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, BndryTable, BndryTable_B );
    P2_flag = v2Crdnt(p1234(2), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, BndryTable, BndryTable_B );
    P3_flag = v2Crdnt(p1234(3), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, BndryTable, BndryTable_B );
    P4_flag = v2Crdnt(p1234(4), N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, BndryTable, BndryTable_B );

    unRelatedNode = 0;
    % Existence of mainedge on current surface
    if P1_flag == BM_bndryNum && P2_flag == BM_bndryNum && P3_flag == BM_bndryNum
        unRelatedNode = 4;
        % projArea = ( x_1 * y_2 + x_3 * y_1 + x_2 * y_3 ...
                    % - x_3 * y_2 - x_1 * y_3 - x_2 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P2_Crdt(2) + P3_Crdt(1) * P1_Crdt(2) + P2_Crdt(1) * P3_Crdt(2) ...
                    - P3_Crdt(1) * P2_Crdt(2) - P1_Crdt(1) * P3_Crdt(2) - P2_Crdt(1) * P1_Crdt(2) ) / 2;
        % equations for the surface: A_1 x + A_2 y + A_3 z + A = 0
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P2_Crdt(1), P2_Crdt(2), P2_Crdt(3); P3_Crdt(1), P3_Crdt(2), P3_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P2_Crdt(2), P2_Crdt(3),   1; P3_Crdt(2), P3_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P2_Crdt(1), P2_Crdt(3),   1; P3_Crdt(1), P3_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P2_Crdt(1), P2_Crdt(2),   1; P3_Crdt(1), P3_Crdt(2),   1 ] );
    elseif  P1_flag == BM_bndryNum && P2_flag == BM_bndryNum && P4_flag == BM_bndryNum
        unRelatedNode = 3;
        % projArea = ( x_1 * y_2 + x_4 * y_1 + x_2 * y_4 ...
                    % - x_4 * y_2 - x_1 * y_4 - x_2 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P2_Crdt(2) + P4_Crdt(1) * P1_Crdt(2) + P2_Crdt(1) * P4_Crdt(2) ...
                    - P4_Crdt(1) * P2_Crdt(2) - P1_Crdt(1) * P4_Crdt(2) - P2_Crdt(1) * P1_Crdt(2) ) / 2;
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P2_Crdt(1), P2_Crdt(2), P2_Crdt(3); P4_Crdt(1), P4_Crdt(2), P4_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P2_Crdt(2), P2_Crdt(3),   1; P4_Crdt(2), P4_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P2_Crdt(1), P2_Crdt(3),   1; P4_Crdt(1), P4_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P2_Crdt(1), P2_Crdt(2),   1; P4_Crdt(1), P4_Crdt(2),   1 ] );
    elseif  P1_flag == BM_bndryNum && P3_flag == BM_bndryNum && P4_flag == BM_bndryNum
        unRelatedNode = 2;
        % projArea = ( x_1 * y_3 + x_4 * y_1 + x_3 * y_4 ...
                    % - x_4 * y_3 - x_1 * y_4 - x_3 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P3_Crdt(2) + P4_Crdt(1) * P1_Crdt(2) + P3_Crdt(1) * P4_Crdt(2) ...
                    - P4_Crdt(1) * P3_Crdt(2) - P1_Crdt(1) * P4_Crdt(2) - P3_Crdt(1) * P1_Crdt(2) ) / 2;
        % triArea = norm( calTriVec( P1_Crdt, P3_Crdt, P4_Crdt ) );
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P3_Crdt(1), P3_Crdt(2), P3_Crdt(3); P4_Crdt(1), P4_Crdt(2), P4_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P3_Crdt(2), P3_Crdt(3),   1; P4_Crdt(2), P4_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P3_Crdt(1), P3_Crdt(3),   1; P4_Crdt(1), P4_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P3_Crdt(1), P3_Crdt(2),   1; P4_Crdt(1), P4_Crdt(2),   1 ] );
    end

    if P1_flag == BM_bndryNum && P2_flag == BM_bndryNum && P3_flag == BM_bndryNum && P4_flag == BM_bndryNum 
        [ m_v(1), n_v(1), ell_v(1);
          m_v(2), n_v(2), ell_v(2);
          m_v(3), n_v(3), ell_v(3);
          m_v(4), n_v(4), ell_v(4) ]
        warning('check')
    end

    if unRelatedNode ~= 0
        Pnt_d = Pnt_d + alpha * ( T_bolus - T_blood ) * sqrt( 1 + (A_1 / A_3)^2 + (A_2 / A_3)^2 ) * projArea / 3;
    end

    Pnt_d = Pnt_d + Q_s * TtrVol / 4;
    % Pnt_d = Pnt_d + ( Q_s + xi * rho * rho_b * cap_b * T_blood ) * TtrVol / 4;

end