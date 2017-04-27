function corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    
    corner_flag = false(2, 6);
    if ell_v == z_max_vertex
        corner_flag(1, 1) = true;
    end
    if m_v == 2
        corner_flag(1, 2) = true;
    end
    if m_v == 1
        corner_flag(2, 2) = true;
    end
    if ell_v == 2
        corner_flag(1, 3) = true;
    end
    if ell_v == 1
        corner_flag(2, 3) = true;
    end
    if m_v == x_max_vertex
        corner_flag(1, 4) = true;
    end
    if n_v == y_max_vertex
        corner_flag(1, 5) = true;
    end
    if n_v == 2
        corner_flag(1, 6) = true;
    end
    if n_v == 1
        corner_flag(2, 6) = true;
    end
end