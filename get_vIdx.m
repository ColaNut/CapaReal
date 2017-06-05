function vIdx = get_vIdx( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex )

    if m_v >= 1 && m_v <= x_max_vertex && n_v >= 1 && n_v <= y_max_vertex && ell_v >= 1 && ell_v <= z_max_vertex 
        % volume
        vIdx = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v );
    else
        vIdx = int64( x_max_vertex * y_max_vertex * z_max_vertex / 2 );
    end

end