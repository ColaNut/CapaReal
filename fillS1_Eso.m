function S1_row = fillS_Eso( p1234, S1_row, epsilonValue, N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                                Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Topx )

    Vrtx4Value = zeros(1, 4);
    nabla = zeros(4, 3);

    % get P1_Crdnt, P2_Crdt, P3_Crdt and P4_Crdt
    P1_Crdt = zeros(1, 3);
    P2_Crdt = zeros(1, 3);
    P3_Crdt = zeros(1, 3);
    P4_Crdt = zeros(1, 3);

    P1_Crdt = v2Crdnt(p1234(1), N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
    P2_Crdt = v2Crdnt(p1234(2), N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
    P3_Crdt = v2Crdnt(p1234(3), N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
    P4_Crdt = v2Crdnt(p1234(4), N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );

    nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
    nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
    nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
    nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );

    Vrtx4Value(1) = dot( nabla(1, :), nabla(1, :) );
    Vrtx4Value(2) = dot( nabla(1, :), nabla(2, :) );
    Vrtx4Value(3) = dot( nabla(1, :), nabla(3, :) );
    Vrtx4Value(4) = dot( nabla(1, :), nabla(4, :) );

    TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

    S1_row(p1234) = S1_row(p1234) + epsilonValue * Vrtx4Value / (9 * TtrVol);

end