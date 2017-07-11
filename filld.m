function Pnt_d = filld( p1234, Vrtx_bndry, Pnt_d, ...
                            dt, Q_s, rho, xi, zeta, cap, rho_b, cap_b, alpha, T_blood, T_bolus, ...
                            x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, ...
                            BM_bndryNum )

    % === % ============ % === %
    % === % Filling of U % === %
    % === % ============ % === %

    % get the vol
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
    P1_Crdt = squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
    P2_Crdt = squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
    P3_Crdt = squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
    P4_Crdt = squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';

    TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );
    
    P1_flag = Vrtx_bndry( m_v(1), n_v(1), ell_v(1) );
    P2_flag = Vrtx_bndry( m_v(2), n_v(2), ell_v(2) );
    P3_flag = Vrtx_bndry( m_v(3), n_v(3), ell_v(3) );
    P4_flag = Vrtx_bndry( m_v(4), n_v(4), ell_v(4) );

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