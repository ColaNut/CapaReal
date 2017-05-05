function sparseK = fillBndry_K( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, sparseK, Flag )

    % A_row1 = zeros(1, 4);
    % A_row2 = zeros(1, 4);
    % A_row4 = zeros(1, 4);
    p0_prm = get_idx_prm(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);

switch Flag
    case 'Top'
        p3_prm = get_idx_prm(m, n, ell - 1, x_max_vertex, y_max_vertex, z_max_vertex);
        sparseK(7 * ( p0_prm - 1 ) + 1,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 1, 7 * ( p0_prm - 1 ) + 1) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 1, 7 * ( p3_prm - 1 ) + 1) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 2,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 2, 7 * ( p0_prm - 1 ) + 2) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 2, 7 * ( p3_prm - 1 ) + 2) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 4,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 4, 7 * ( p0_prm - 1 ) + 4) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 4, 7 * ( p3_prm - 1 ) + 4) = - 1;
    case 'Right'
        p2_prm = get_idx_prm(m - 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);

        sparseK(7 * ( p0_prm - 1 ) + 2,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 2, 7 * ( p0_prm - 1 ) + 2) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 2, 7 * ( p2_prm - 1 ) + 2) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 3,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 3, 7 * ( p0_prm - 1 ) + 3) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 3, 7 * ( p2_prm - 1 ) + 3) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 5,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 5, 7 * ( p0_prm - 1 ) + 5) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 5, 7 * ( p2_prm - 1 ) + 5) = - 1;
    case 'Far'
        p5_prm = get_idx_prm(m, n - 1, ell, x_max_vertex, y_max_vertex, z_max_vertex);

        sparseK(7 * ( p0_prm - 1 ) + 1,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 1, 7 * ( p0_prm - 1 ) + 1) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 1, 7 * ( p5_prm - 1 ) + 1) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 3,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 3, 7 * ( p0_prm - 1 ) + 3) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 3, 7 * ( p5_prm - 1 ) + 3) = - 1;

        sparseK(7 * ( p0_prm - 1 ) + 6,                      :) = 0;
        sparseK(7 * ( p0_prm - 1 ) + 6, 7 * ( p0_prm - 1 ) + 6) = 1;
        sparseK(7 * ( p0_prm - 1 ) + 6, 7 * ( p5_prm - 1 ) + 6) = - 1;
    case 'Near'
        p6_prm = get_idx_prm(m, n + 1, ell, x_max_vertex, y_max_vertex, z_max_vertex);

        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p6_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p6_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p6_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    case 'Left'
        p2_prm = get_idx_prm(m + 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);
        % 2, 3, 5 
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p2_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p2_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p2_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    case 'Bottom'
        p1_prm = get_idx_prm(m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex);
        % 1, 2, 4
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p1_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p1_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;

        sparseK(vIdx2eIdx(p0_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p1_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    case 'Line1'
        p1_prm = get_idx_prm(m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex);
        
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p1_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    case 'Line2'
        p4_prm = get_idx_prm(m + 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex);
        
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p4_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    case 'Line3'
        p1_prm = get_idx_prm(m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex);
        
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex),                                                              :) = 0;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = 1;
        sparseK(vIdx2eIdx(p0_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex), vIdx2eIdx(p1_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex)) = - 1;
    otherwise
        error('Check');
end



    % A_row1(1) = 7 * ( p0_prm - 1 ) + 1;
    % A_row1(2) = 7 * ( p3_prm - 1 ) + 1;
    % A_row1(3) = - 1;
    % A_row1(4) = 1;

    % A_row2(1) = 7 * ( p0_prm - 1 ) + 2;
    % A_row2(2) = 7 * ( p3_prm - 1 ) + 2;
    % A_row2(3) = - 1;
    % A_row2(4) = 1;

    % A_row4(1) = 7 * ( p0_prm - 1 ) + 4;
    % A_row4(2) = 7 * ( p3_prm - 1 ) + 4;
    % A_row4(3) = - 1;
    % A_row4(4) = 1;

end