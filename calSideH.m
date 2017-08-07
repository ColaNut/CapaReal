function OneSideH_XZ = calSideH( face9Pnts, Cpnts, face9G, cG, A, Vertex_Crdnt, mu_r, sideSegMed, x_max_vertex, y_max_vertex, z_max_vertex, varargin )

    OneSideH_XZ = zeros(1, 8, 3);
    
    nVarargs = length(varargin);
    if nVarargs == 1
        TexFlag = varargin{1};
        OneSideH_XZ(1, 1, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(9), face9Pnts(6), cG, face9G(:, [5, 9, 6]), A, Vertex_Crdnt, mu_r, sideSegMed(1), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 2, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(8), face9Pnts(9), cG, face9G(:, [5, 8, 9]), A, Vertex_Crdnt, mu_r, sideSegMed(2), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 3, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(7), face9Pnts(8), cG, face9G(:, [5, 7, 8]), A, Vertex_Crdnt, mu_r, sideSegMed(3), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 4, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(4), face9Pnts(7), cG, face9G(:, [5, 4, 7]), A, Vertex_Crdnt, mu_r, sideSegMed(4), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 5, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(1), face9Pnts(4), cG, face9G(:, [5, 1, 4]), A, Vertex_Crdnt, mu_r, sideSegMed(5), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 6, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(2), face9Pnts(1), cG, face9G(:, [5, 2, 1]), A, Vertex_Crdnt, mu_r, sideSegMed(6), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 7, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(3), face9Pnts(2), cG, face9G(:, [5, 3, 2]), A, Vertex_Crdnt, mu_r, sideSegMed(7), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
        OneSideH_XZ(1, 8, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(6), face9Pnts(3), cG, face9G(:, [5, 6, 3]), A, Vertex_Crdnt, mu_r, sideSegMed(8), x_max_vertex, y_max_vertex, z_max_vertex, TexFlag );
    else
        OneSideH_XZ(1, 1, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(9), face9Pnts(6), cG, face9G(:, [5, 9, 6]), A, Vertex_Crdnt, mu_r, sideSegMed(1), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 2, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(8), face9Pnts(9), cG, face9G(:, [5, 8, 9]), A, Vertex_Crdnt, mu_r, sideSegMed(2), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 3, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(7), face9Pnts(8), cG, face9G(:, [5, 7, 8]), A, Vertex_Crdnt, mu_r, sideSegMed(3), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 4, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(4), face9Pnts(7), cG, face9G(:, [5, 4, 7]), A, Vertex_Crdnt, mu_r, sideSegMed(4), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 5, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(1), face9Pnts(4), cG, face9G(:, [5, 1, 4]), A, Vertex_Crdnt, mu_r, sideSegMed(5), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 6, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(2), face9Pnts(1), cG, face9G(:, [5, 2, 1]), A, Vertex_Crdnt, mu_r, sideSegMed(6), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 7, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(3), face9Pnts(2), cG, face9G(:, [5, 3, 2]), A, Vertex_Crdnt, mu_r, sideSegMed(7), x_max_vertex, y_max_vertex, z_max_vertex );
        OneSideH_XZ(1, 8, :) = calH_2( Cpnts, face9Pnts(5), face9Pnts(6), face9Pnts(3), cG, face9G(:, [5, 6, 3]), A, Vertex_Crdnt, mu_r, sideSegMed(8), x_max_vertex, y_max_vertex, z_max_vertex );
    end

end