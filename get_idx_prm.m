function idx_prm = get_idx_prm( m, n, ell, x_max_vertex, y_max_vertex )

    m_prm = m - 1;
    n_prm = n - 1;
    ell_prm = ell - 1;

    x_max_vertex_prm = x_max_vertex - 1;
    y_max_vertex_prm = y_max_vertex - 1;

    idx_prm = int64( ( ell_prm - 1 ) * x_max_vertex_prm * y_max_vertex_prm + ( n_prm - 1 ) * x_max_vertex_prm + m_prm );

end