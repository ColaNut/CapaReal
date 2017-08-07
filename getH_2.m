function PntH = getH_2( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, PntSegMed, x_max_vertex, y_max_vertex, z_max_vertex )
    PntH = zeros(6, 8, 3);

    Cpnts = PntsIdx(2, 5);
    
    % p1
    face9Pnts = PntsIdx(3, :);
    fIdx = [19: 27];
    face9G = G_27cols(:, fIdx);
    PntH(1, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(1, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );
    % p2
    face9Pnts = p2Face( PntsIdx );
    fIdx = [7, 4, 1, 16, 13, 10, 25, 22, 19];
    face9G = G_27cols(:, fIdx);
    PntH(2, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(2, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );
    % p3
    face9Pnts = p3Face( PntsIdx );
    fIdx = [3, 2, 1, 6, 5, 4, 9, 8, 7];
    face9G = G_27cols(:, fIdx);
    PntH(3, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(3, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );
    % p4
    face9Pnts = p4Face( PntsIdx );
    fIdx = [3, 6, 9, 12, 15, 18, 21, 24, 27];
    face9G = G_27cols(:, fIdx);
    PntH(4, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(4, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );
    % p5
    face9Pnts = p5Face( PntsIdx );
    fIdx = [9, 8, 7, 18, 17, 16, 27, 26, 25];
    face9G = G_27cols(:, fIdx);
    PntH(5, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(5, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );
    % p6
    face9Pnts = p6Face( PntsIdx );
    fIdx = [1, 2, 3, 10, 11, 12, 19, 20, 21];
    face9G = G_27cols(:, fIdx);
    PntH(6, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27cols(:, 14), A, Vertex_Crdnt, mu_r, PntSegMed(6, :), x_max_vertex, y_max_vertex, z_max_vertex, 'H' );

end