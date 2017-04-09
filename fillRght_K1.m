function [ A_row2, A_row3, A_row5 ] = fillRght_K1( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    A_row2 = zeros(1, 4);
    A_row3 = zeros(1, 4);
    A_row5 = zeros(1, 4);

    p0_prm = get_idx_prm(m    , n, ell, x_max_vertex, y_max_vertex, z_max_vertex);
    p2_prm = get_idx_prm(m - 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);

    A_row2(1) = 7 * ( p0_prm - 1 ) + 2;
    A_row2(2) = 7 * ( p2_prm - 1 ) + 2;
    A_row2(3) = - 1;
    A_row2(4) = 1;

    A_row3(1) = 7 * ( p0_prm - 1 ) + 3;
    A_row3(2) = 7 * ( p2_prm - 1 ) + 3;
    A_row3(3) = - 1;
    A_row3(4) = 1;

    A_row5(1) = 7 * ( p0_prm - 1 ) + 5;
    A_row5(2) = 7 * ( p2_prm - 1 ) + 5;
    A_row5(3) = - 1;
    A_row5(4) = 1;

end