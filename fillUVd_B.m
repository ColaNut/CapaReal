function [ U_row, V_row, Pnt_d ] = fillUVd_B( p1234, N_v, U_row, V_row, Pnt_d, ...
                                                dt, Q_s, rho, xi, zeta, cap, rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                                x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                                                w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                                Vertex_Crdnt, Vertex_Crdnt_B, ...
                                                BndryTable, BndryTable_B, BM_bndryNum )
    % === % ============ % === %
    % === % Filling of U % === %
    % === % ============ % === %
    % calculation of lamdaM_lmdaN_V
    lamdaM_lmdaN_V = zeros(1, 4);
    % get P1_Crdnt, P2_Crdt, P3_Crdt and P4_Crdt
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
    W_ratio = [2, 1, 1, 1];
    lamdaM_lmdaN_V = repmat(TtrVol, 1, 4) .*  W_ratio / 20;

    U_row(p1234) = U_row(p1234) + ( (1 / dt) * rho * cap + 0.5 * xi * rho * rho_b * cap_b ) * lamdaM_lmdaN_V;

    % === % ====================== % === %
    % === % Filling of V and Pnt_d % === %
    % === % ====================== % === %

    V_row(p1234) = V_row(p1234) + ( (1 / dt) * rho * cap - 0.5 * xi * rho * rho_b * cap_b ) * lamdaM_lmdaN_V;
    
    % to-do
    % getting P1_flag, P2_flag, P3_flag and P4_flag
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

    % calculation of lamdaM_lmdaN_over_S1
    lamdaM_lmdaN_S1 = zeros(1, 4);

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
        maskWeight = [2, 1, 1, 1];
        maskWeight(unRelatedNode) = 0;
        lamdaM_lmdaN_S1 = maskWeight * alpha * sqrt( 1 + (A_1 / A_3)^2 + (A_2 / A_3)^2 ) * projArea / 12;
        U_row(p1234) = U_row(p1234) + 0.5 * lamdaM_lmdaN_S1;
        V_row(p1234) = V_row(p1234) - 0.5 * lamdaM_lmdaN_S1;
        Pnt_d = Pnt_d + alpha * ( T_bolus - T_blood ) * sqrt( 1 + (A_1 / A_3)^2 + (A_2 / A_3)^2 ) * projArea / 3;
    end

    % calculation of nabla_lamdaM_cdot_nabla_lamdaN
    nabla_lamdaM_cdot_nabla_lamdaN = zeros(1, 4);

    % determine the InnExtText 
    InnExtText = '';
    if dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) > 0
        InnExtText = 'inn';
    elseif dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) < 0
        InnExtText = 'ext';
    else
        error('Check the P1, P2, P3 and P4 Crdnt');
    end

    nabla = zeros(4, 3);
    switch InnExtText
        case 'inn'
            nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
            nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
            nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
            nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );
        case 'ext'
            nabla(1, :) = calTriVec( P2_Crdt, P4_Crdt, P3_Crdt );
            nabla(2, :) = calTriVec( P4_Crdt, P1_Crdt, P3_Crdt );
            nabla(3, :) = calTriVec( P4_Crdt, P2_Crdt, P1_Crdt );
            nabla(4, :) = calTriVec( P3_Crdt, P1_Crdt, P2_Crdt );
        otherwise
            error('check');
    end

    nabla_lamdaM_cdot_nabla_lamdaN = zeta * dot( repmat(nabla(1, :), 4, 1), nabla, 2 )' / ( 9 * TtrVol );
    U_row(p1234) = U_row(p1234) + 0.5 * nabla_lamdaM_cdot_nabla_lamdaN;
    V_row(p1234) = V_row(p1234) - 0.5 * nabla_lamdaM_cdot_nabla_lamdaN;

    Pnt_d = Pnt_d + Q_s * TtrVol / 4;
    % Pnt_d = Pnt_d + ( Q_s + xi * rho * rho_b * cap_b * T_blood ) * TtrVol / 4;

end