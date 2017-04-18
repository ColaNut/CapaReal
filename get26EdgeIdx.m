function ArndIdx = get26EdgeIdx(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex)

    ArndIdx = zeros(26, 1);
    m_v     = 2 * m - 1;
    n_v     = 2 * n - 1;
    ell_v   = 2 * ell - 1;

    vIdxPrm = zeros( 3, 9 );
    vIdxPrm = get27vIdxPrm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    ArndIdx(1)  = vIdx2eIdx(vIdxPrm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(2)  = vIdx2eIdx(vIdxPrm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(3)  = vIdx2eIdx(vIdxPrm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(4)  = vIdx2eIdx(vIdxPrm(2, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(5)  = vIdx2eIdx(vIdxPrm(2, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(6)  = vIdx2eIdx(vIdxPrm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    ArndIdx(7)  = vIdx2eIdx(vIdxPrm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(8)  = vIdx2eIdx(vIdxPrm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(9)  = vIdx2eIdx(vIdxPrm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(10) = vIdx2eIdx(vIdxPrm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);

    ArndIdx(11) = vIdx2eIdx(vIdxPrm(3, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(12) = vIdx2eIdx(vIdxPrm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(13) = vIdx2eIdx(vIdxPrm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(14) = vIdx2eIdx(vIdxPrm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);

    ArndIdx(15) = vIdx2eIdx(vIdxPrm(2, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(16) = vIdx2eIdx(vIdxPrm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(17) = vIdx2eIdx(vIdxPrm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(18) = vIdx2eIdx(vIdxPrm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);

    ArndIdx(19) = vIdx2eIdx(vIdxPrm(3, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(20) = vIdx2eIdx(vIdxPrm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(21) = vIdx2eIdx(vIdxPrm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(22) = vIdx2eIdx(vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(23) = vIdx2eIdx(vIdxPrm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(24) = vIdx2eIdx(vIdxPrm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(25) = vIdx2eIdx(vIdxPrm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    ArndIdx(26) = vIdx2eIdx(vIdxPrm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);

end