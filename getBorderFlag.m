function borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    
    borderFlag = false(1, 6);
    % up
    if ell_v == z_max_vertex
        borderFlag(1) = true;
    end
    % left
    if m_v == 1
        borderFlag(2) = true;
    end
    % down
    if ell_v == 1
        borderFlag(3) = true;
    end
    % right
    if m_v == x_max_vertex
        borderFlag(4) = true;
    end
    % far
    if n_v == y_max_vertex
        borderFlag(5) = true;
    end
    % near
    if n_v == 1
        borderFlag(6) = true;
    end
end
