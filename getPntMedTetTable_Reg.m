function PntMedTetTable = getPntMedTetTable_Reg( SegMedReg, N_v_r, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex )
    % PntMedTetTable = getPntMedTetTable_Reg( squeeze(SegMedReg(m - 1, n - 1, ell - 1, :)), N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    PntMedTetTable = sparse(24, N_v_r);
    PntsIdx     = zeros( 3, 9 ); 
    PntsIdx = get27Pnts_KEV( m_v - 1, n_v - 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex );

    % 24 Tet with 24x4 indeces
    nzCols = zeros(24, 4);
    Cpnts = 0;

    nzCols(1, :)  = [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 7)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 8)) ];
    nzCols(2, :)  = [ v2r(PntsIdx(3, 7)), v2r(PntsIdx(3, 1)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 4)) ];
    nzCols(3, :)  = [ v2r(PntsIdx(3, 1)), v2r(PntsIdx(3, 3)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 2)) ];
    nzCols(4, :)  = [ v2r(PntsIdx(3, 3)), v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 6)) ];
    
    nzCols(5, :)  = [ v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 7)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 8)) ];
    nzCols(6, :)  = [ v2r(PntsIdx(1, 7)), v2r(PntsIdx(1, 1)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 4)) ];
    nzCols(7, :)  = [ v2r(PntsIdx(1, 1)), v2r(PntsIdx(1, 3)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 2)) ];
    nzCols(8, :)  = [ v2r(PntsIdx(1, 3)), v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 6)) ];

    nzCols(9, :)  = [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(1, 9)), v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 6)) ];
    nzCols(10, :) = [ v2r(PntsIdx(3, 7)), v2r(PntsIdx(1, 7)), v2r(PntsIdx(2, 4)), v2r(PntsIdx(2, 8)) ];
    nzCols(11, :) = [ v2r(PntsIdx(3, 1)), v2r(PntsIdx(1, 1)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 4)) ];
    nzCols(12, :) = [ v2r(PntsIdx(3, 3)), v2r(PntsIdx(1, 3)), v2r(PntsIdx(2, 6)), v2r(PntsIdx(2, 2)) ];

    nzCols(13, :) = [ v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 6)), v2r(PntsIdx(3, 5)) ];
    nzCols(14, :) = [ v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 4)), v2r(PntsIdx(3, 5)) ];
    nzCols(15, :) = [ v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 4)), v2r(PntsIdx(1, 5)) ];
    nzCols(16, :) = [ v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 6)), v2r(PntsIdx(1, 5)) ];

    nzCols(17, :) = [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 6)), v2r(PntsIdx(2, 8)) ];
    nzCols(18, :) = [ v2r(PntsIdx(3, 7)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 4)) ];
    nzCols(19, :) = [ v2r(PntsIdx(3, 1)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 4)), v2r(PntsIdx(2, 2)) ];
    nzCols(20, :) = [ v2r(PntsIdx(3, 3)), v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 6)) ];

    nzCols(21, :) = [ v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 6)), v2r(PntsIdx(2, 8)) ];
    nzCols(22, :) = [ v2r(PntsIdx(1, 7)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 4)) ];
    nzCols(23, :) = [ v2r(PntsIdx(1, 1)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 4)), v2r(PntsIdx(2, 2)) ];
    nzCols(24, :) = [ v2r(PntsIdx(1, 3)), v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 6)) ];

    for idx = 1: 1: 24
        PntMedTetTable(idx, nzCols(idx, :)) = repmat(SegMedReg(idx), 1, 4);
    end

end