function Crdt = v2Crdnt( vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt, Vertex_Crdnt_B, ...
                                m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top )
    Crdt = zeros(1, 3);
    vFlag = 0;
    vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
    switch vFlag
        case 0
            [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv(m_v, n_v, ell_v, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top);
            Crdt = squeeze(Vertex_Crdnt_B(m_v_B, n_v_B, ell_v_B, :));
        case { 1, 2 }
            [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            Crdt = squeeze(Vertex_Crdnt(m_v, n_v, ell_v, :));
        case 3
            vIdx_B = vIdx - N_v;
            [ m_v_B, n_v_B, ell_v_B ] = getMNL(vIdx_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
            Crdt = squeeze(Vertex_Crdnt_B(m_v_B, n_v_B, ell_v_B, :));
        otherwise
            error('check');
    end 

end