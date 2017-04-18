function eIdxSet = get_eIdxSet( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, phaseNum )

    eIdxSet = zeros(25, 1);
    m_v     = 2 * m - 1;
    n_v     = 2 * n - 1;
    ell_v   = 2 * ell - 1;

    vIdxPrm = zeros( 3, 9 );
    vIdxPrm = get27vIdxPrm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    switch phaseNum
        case 'p1'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(3, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(3, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(3, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(3, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(3, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(3, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(3, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(3, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(3, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(3, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(3, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(3, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(3, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(3, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(3, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(3, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(3, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(3, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    case 'p2'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(3, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(3, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(3, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(3, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(3, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(3, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(2, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(2, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        case 'p3'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(1, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(1, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(1, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(1, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(1, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(1, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(1, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(1, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(1, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        case 'p4'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(2, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(3, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(3, 9), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(3, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(3, 6), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(3, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(3, 6), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(3, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(2, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(2, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(2, 6), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(1, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(2, 6), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(1, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(2, 9), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(2, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(2, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(3, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(2, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        case 'p5'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(2, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(3, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(3, 8), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(3, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(3, 8), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(3, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(3, 9), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(3, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(2, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(2, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(2, 9), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(1, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(2, 8), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(1, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(2, 8), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(2, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(3, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(3, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(2, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(2, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        case 'p6'
            eIdxSet(1)  = vIdx2eIdx(vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(2)  = vIdx2eIdx(vIdxPrm(3, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(3)  = vIdx2eIdx(vIdxPrm(3, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(4)  = vIdx2eIdx(vIdxPrm(3, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(5)  = vIdx2eIdx(vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(6)  = vIdx2eIdx(vIdxPrm(3, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(7)  = vIdx2eIdx(vIdxPrm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(8)  = vIdx2eIdx(vIdxPrm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(9)  = vIdx2eIdx(vIdxPrm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(10) = vIdx2eIdx(vIdxPrm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(11) = vIdx2eIdx(vIdxPrm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(12) = vIdx2eIdx(vIdxPrm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(13) = vIdx2eIdx(vIdxPrm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(14) = vIdx2eIdx(vIdxPrm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(15) = vIdx2eIdx(vIdxPrm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(16) = vIdx2eIdx(vIdxPrm(2, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(17) = vIdx2eIdx(vIdxPrm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(18) = vIdx2eIdx(vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(19) = vIdx2eIdx(vIdxPrm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(20) = vIdx2eIdx(vIdxPrm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(21) = vIdx2eIdx(vIdxPrm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(22) = vIdx2eIdx(vIdxPrm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(23) = vIdx2eIdx(vIdxPrm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
            eIdxSet(24) = vIdx2eIdx(vIdxPrm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);

            eIdxSet(25) = vIdx2eIdx(vIdxPrm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    otherwise
        error('check');
    end

end
