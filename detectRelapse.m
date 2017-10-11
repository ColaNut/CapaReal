function vFlag = detectRelapse(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top )

    % vFlag = 0, 1 and 2, correspond to normal points, invalid vIdx in domain B and boundary points
    vFlag = 0;

    if vIdx <= N_v
        [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        if m_v <= m_v_Rght + 1 && m_v >= m_v_Lft - 1 && n_v <= n_v_Far + 1 && n_v >= n_v_Near - 1 && ell_v <= ell_v_Top + 1 && ell_v >= ell_v_Dwn - 1 
            vFlag = 2; 
            if m_v <= m_v_Rght && m_v >= m_v_Lft && n_v <= n_v_Far && n_v >= n_v_Near && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn 
                vFlag = 1; 
            end
        end
    else % vIdx > N_v 
        [ m_v_B, n_v_B, ell_v_B ] = getMNL(vIdx - N_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
        if m_v_B == x_max_vertex_B || m_v_B == 1 || n_v_B == y_max_vertex_B || n_v_B == 1 || ell_v_B == z_max_vertex_B || ell_v_B == 1 
            vFlag = 2;
        end
    end

end