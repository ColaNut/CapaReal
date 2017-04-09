function [ A_row1, A_row2, A_row4 ] = fillBttm_K1( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    A_row1 = zeros(1, 4);
    A_row2 = zeros(1, 4);
    A_row4 = zeros(1, 4);

    p0_prm = get_idx_prm(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);
    p1_prm = get_idx_prm(m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex);

    A_row1(1) = vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row1(2) = vIdx2eIdx(p1_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row1(3) = - 1;
    A_row1(4) = 1;

    A_row2(1) = vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row2(2) = vIdx2eIdx(p1_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row2(3) = - 1;
    A_row2(4) = 1;

    A_row4(1) = vIdx2eIdx(p0_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row4(2) = vIdx2eIdx(p1_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex);
    A_row4(3) = - 1;
    A_row4(4) = 1;

end