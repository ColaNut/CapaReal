function GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    
    GVV_SideFlag = false(1, 6);
    
    if ell_v == z_max_vertex;
        GVV_SideFlag(1) = true;
    end
    if m_v == 1;
        GVV_SideFlag(2) = true;
    end
    if ell_v == 1;
        GVV_SideFlag(3) = true;
    end
    if m_v == x_max_vertex;
        GVV_SideFlag(4) = true;
    end
    if n_v == y_max_vertex;
        GVV_SideFlag(5) = true;
    end
    if n_v == 1;
        GVV_SideFlag(6) = true;
    end
end
