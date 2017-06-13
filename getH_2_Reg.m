function PntH = getH_2_Reg( G_13Idx, Vertex_Crdnt, A, G_13rows, mu_r, x_max_vertex, y_max_vertex, z_max_vertex )
    
    PntH = zeros(8, 3);

    % Cpnts = PntsIdx(2, 5);
    PntH(1, :) = calH_2( G_13Idx(12), G_13Idx(3), G_13Idx(6), G_13Idx(7), ...
                        G_13rows(12, :), vertcat(G_13rows(3, :), G_13rows(6, :), G_13rows(7, :)), A, Vertex_Crdnt, mu_r, 1, x_max_vertex, y_max_vertex, z_max_vertex, 'Regular' );
    PntH(2, :) = calH_2( G_13Idx(11), G_13Idx(12), G_13Idx(10), G_13Idx(7), ...
                        G_13rows(11, :), vertcat(G_13rows(12, :), G_13rows(10, :), G_13rows(7, :)), A, Vertex_Crdnt, mu_r, 1, x_max_vertex, y_max_vertex, z_max_vertex, 'Regular' );
    PntH(3, :) = calH_2( G_13Idx(2), G_13Idx(11), G_13Idx(5), G_13Idx(7), ...
                        G_13rows(2, :), vertcat(G_13rows(11, :), G_13rows(5, :), G_13rows(7, :)), A, Vertex_Crdnt, mu_r, 1, x_max_vertex, y_max_vertex, z_max_vertex, 'Regular' );
    PntH(4, :) = calH_2( G_13Idx(3), G_13Idx(2), G_13Idx(1), G_13Idx(7), ...
                        G_13rows(3, :), vertcat(G_13rows(2, :), G_13rows(1, :), G_13rows(7, :)), A, Vertex_Crdnt, mu_r, 1, x_max_vertex, y_max_vertex, z_max_vertex, 'Regular' );
    % implement the rest 7 tetrahedra
    % ...
    
    % % p1
    % face9Pnts = PntsIdx(3, :);
    % fIdx = [19: 27];
    % face9G = G_27rows(fIdx, :);
    % PntH(1, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(1, :), x_max_vertex, y_max_vertex, z_max_vertex );
    % % p2
    % face9Pnts = p2Face( PntsIdx );
    % fIdx = [7, 4, 1, 16, 13, 10, 25, 22, 19];
    % face9G = G_27rows(fIdx, :);
    % PntH(2, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(2, :), x_max_vertex, y_max_vertex, z_max_vertex );
    % % p3
    % face9Pnts = p3Face( PntsIdx );
    % fIdx = [3, 2, 1, 6, 5, 4, 9, 8, 7];
    % face9G = G_27rows(fIdx, :);
    % PntH(3, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(3, :), x_max_vertex, y_max_vertex, z_max_vertex );
    % % p4
    % face9Pnts = p4Face( PntsIdx );
    % fIdx = [3, 6, 9, 12, 15, 18, 21, 24, 27];
    % face9G = G_27rows(fIdx, :);
    % PntH(4, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(4, :), x_max_vertex, y_max_vertex, z_max_vertex );
    % % p5
    % face9Pnts = p5Face( PntsIdx );
    % fIdx = [9, 8, 7, 18, 17, 16, 27, 26, 25];
    % face9G = G_27rows(fIdx, :);
    % PntH(5, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(5, :), x_max_vertex, y_max_vertex, z_max_vertex );
    % % p6
    % face9Pnts = p6Face( PntsIdx );
    % fIdx = [1, 2, 3, 10, 11, 12, 19, 20, 21];
    % face9G = G_27rows(fIdx, :);
    % PntH(6, :, :) = calSideH(face9Pnts, Cpnts, face9G, G_27rows(14, :), A, Vertex_Crdnt, mu_r, PntSegMed(6, :), x_max_vertex, y_max_vertex, z_max_vertex );

end