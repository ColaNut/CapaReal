function A_row = fillLine3_K1( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    A_row = zeros(1, 4);
    
    p0_prm = get_idx_prm(m, n, ell    , x_max_vertex, y_max_vertex, z_max_vertex);
    p1_prm = get_idx_prm(m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex);

    A_row(1) = vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row(2) = vIdx2eIdx(p1_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row(3) = - 1;
    A_row(4) = 1;

end