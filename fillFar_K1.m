function [ A_row1, A_row3, A_row6 ] = fillFar_K1( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    A_row1 = zeros(1, 4);
    A_row3 = zeros(1, 4);
    A_row6 = zeros(1, 4);

    p0_prm = get_idx_prm(m, n    , ell, x_max_vertex, y_max_vertex, z_max_vertex);
    p5_prm = get_idx_prm(m, n - 1, ell, x_max_vertex, y_max_vertex, z_max_vertex);

    A_row1(1) = 7 * ( p0_prm - 1 ) + 1;
    A_row1(2) = 7 * ( p5_prm - 1 ) + 1;
    A_row1(3) = - 1;
    A_row1(4) = 1;

    A_row3(1) = 7 * ( p0_prm - 1 ) + 3;
    A_row3(2) = 7 * ( p5_prm - 1 ) + 3;
    A_row3(3) = - 1;
    A_row3(4) = 1;

    A_row6(1) = 7 * ( p0_prm - 1 ) + 6;
    A_row6(2) = 7 * ( p5_prm - 1 ) + 6;
    A_row6(3) = - 1;
    A_row6(4) = 1;

end