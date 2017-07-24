function PntMedTetTableCell = getPntMedTetTable_3( N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex )
    
    PntMedTetTableCell = cell(48, 1);
    p1234_48 = zeros(48, 4);
    % PntSegMed_t = PntSegMed';
    % get 27 Pnts index
    PntsIdx     = zeros( 3, 9 ); 
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    nzCols = zeros(48, 4);
    Cpnts = 0;
    face9Pnts = zeros(1, 9); 

    % p1
    Cpnts = PntsIdx(2, 5);
    face9Pnts = PntsIdx(3, :);
    nzCols(1: 8, :) = get32Idx(face9Pnts, Cpnts);
    % p2
    face9Pnts = p2Face( PntsIdx );
    nzCols(9: 16, :) = get32Idx(face9Pnts, Cpnts);
    % p3
    face9Pnts = p3Face( PntsIdx );
    nzCols(17: 24, :) = get32Idx(face9Pnts, Cpnts);
    % p4
    face9Pnts = p4Face( PntsIdx );
    nzCols(25: 32, :) = get32Idx(face9Pnts, Cpnts);
    % p5
    face9Pnts = p5Face( PntsIdx );
    nzCols(33: 40, :) = get32Idx(face9Pnts, Cpnts);
    % p6
    face9Pnts = p6Face( PntsIdx );
    nzCols(41: 48, :) = get32Idx(face9Pnts, Cpnts);

    p1234_48 = getp1234_48;
    for idx = 1: 1: 48
        PntMedTetTableCell{idx} = [ nzCols(idx, :), p1234_48(idx, :) ];
        % PntMedTetTable(idx, nzCols(idx, :)) = repmat(PntSegMed_t(idx), 1, 4);
    end

end