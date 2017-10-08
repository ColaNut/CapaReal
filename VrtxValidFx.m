function vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top )
    
    vFlag = 0;
    if vIdx <= N_v
        vFlag = 1;
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if m_v == x_max_vertex || m_v == 1 || n_v == y_max_vertex || n_v == 1 || ell_v == z_max_vertex || ell_v == 1 
            vFlag = 2;
        end
        if m_v <= m_v_Rght && m_v >= m_v_Lft && n_v <= n_v_Far && n_v >= n_v_Near && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn 
            vFlag = 0; 
        end
    else % vIdx > N_v 
        vFlag = 3;
    end
end