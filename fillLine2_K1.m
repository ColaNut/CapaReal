function A_row = fillLine2_K1( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    A_row = zeros(1, 4);
    
    p0_prm = get_idx_prm(m    , n, ell, x_max_vertex, y_max_vertex, z_max_vertex);
    p4_prm = get_idx_prm(m + 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);

    A_row(1) = vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row(2) = vIdx2eIdx(p4_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row(3) = - 1;
    A_row(4) = 1;

end