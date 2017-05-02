function sparseGVV = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex )
    
    sparseGVV = zeros(54, 1);
    PntsIdx     = zeros( 3, 9 );
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    sparseGVV(1) = PntsIdx(1, 1);   sparseGVV(10) = PntsIdx(2, 1);    sparseGVV(19) = PntsIdx(3, 1);
    sparseGVV(2) = PntsIdx(1, 2);   sparseGVV(11) = PntsIdx(2, 2);    sparseGVV(20) = PntsIdx(3, 2);
    sparseGVV(3) = PntsIdx(1, 3);   sparseGVV(12) = PntsIdx(2, 3);    sparseGVV(21) = PntsIdx(3, 3);
    sparseGVV(4) = PntsIdx(1, 4);   sparseGVV(13) = PntsIdx(2, 4);    sparseGVV(22) = PntsIdx(3, 4);
    sparseGVV(5) = PntsIdx(1, 5);   sparseGVV(14) = PntsIdx(2, 5);    sparseGVV(23) = PntsIdx(3, 5);
    sparseGVV(6) = PntsIdx(1, 6);   sparseGVV(15) = PntsIdx(2, 6);    sparseGVV(24) = PntsIdx(3, 6);
    sparseGVV(7) = PntsIdx(1, 7);   sparseGVV(16) = PntsIdx(2, 7);    sparseGVV(25) = PntsIdx(3, 7);
    sparseGVV(8) = PntsIdx(1, 8);   sparseGVV(17) = PntsIdx(2, 8);    sparseGVV(26) = PntsIdx(3, 8);
    sparseGVV(9) = PntsIdx(1, 9);   sparseGVV(18) = PntsIdx(2, 9);    sparseGVV(27) = PntsIdx(3, 9);

    TetCount = zeros(3, 9);
    UnitTetVol = calTtrVol( squeeze(Vertex_Crdnt(1, 1, 1, :)), squeeze(Vertex_Crdnt(1, 1, 2, :)), squeeze(Vertex_Crdnt(2, 1, 2, :)), squeeze(Vertex_Crdnt(2, 2, 2, :)) );
    switch flag
        case { '111', '000' }
            TetCount(1, 1) = 6;    TetCount(2, 1) = 4;       TetCount(3, 1) = 6;
            TetCount(1, 2) = 4;    TetCount(2, 2) = 8;       TetCount(3, 2) = 4;
            TetCount(1, 3) = 6;    TetCount(2, 3) = 4;       TetCount(3, 3) = 6;
            TetCount(1, 4) = 4;    TetCount(2, 4) = 8;       TetCount(3, 4) = 4;
            TetCount(1, 5) = 8;    TetCount(2, 5) = 48 * 2;  TetCount(3, 5) = 8;
            TetCount(1, 6) = 4;    TetCount(2, 6) = 8;       TetCount(3, 6) = 4;
            TetCount(1, 7) = 6;    TetCount(2, 7) = 4;       TetCount(3, 7) = 6;
            TetCount(1, 8) = 4;    TetCount(2, 8) = 8;       TetCount(3, 8) = 4;
            TetCount(1, 9) = 6;    TetCount(2, 9) = 4;       TetCount(3, 9) = 6;
        case { '011', '100' }
            TetCount(1, 1) = 0;    TetCount(2, 1) = 0;       TetCount(3, 1) = 0;
            TetCount(1, 2) = 4;    TetCount(2, 2) = 4;       TetCount(3, 2) = 4;
            TetCount(1, 3) = 0;    TetCount(2, 3) = 0;       TetCount(3, 3) = 0;
            TetCount(1, 4) = 0;    TetCount(2, 4) = 8;       TetCount(3, 4) = 0;
            TetCount(1, 5) = 4;    TetCount(2, 5) = 16 * 2;  TetCount(3, 5) = 4;
            TetCount(1, 6) = 0;    TetCount(2, 6) = 8;       TetCount(3, 6) = 0;
            TetCount(1, 7) = 0;    TetCount(2, 7) = 0;       TetCount(3, 7) = 0;
            TetCount(1, 8) = 4;    TetCount(2, 8) = 4;       TetCount(3, 8) = 4;
            TetCount(1, 9) = 0;    TetCount(2, 9) = 0;       TetCount(3, 9) = 0;
        case { '101', '010' }
            TetCount(1, 1) = 0;    TetCount(2, 1) = 0;       TetCount(3, 1) = 0;
            TetCount(1, 2) = 0;    TetCount(2, 2) = 8;       TetCount(3, 2) = 0;
            TetCount(1, 3) = 0;    TetCount(2, 3) = 0;       TetCount(3, 3) = 0;
            TetCount(1, 4) = 4;    TetCount(2, 4) = 4;       TetCount(3, 4) = 4;
            TetCount(1, 5) = 4;    TetCount(2, 5) = 16 * 2;  TetCount(3, 5) = 4;
            TetCount(1, 6) = 4;    TetCount(2, 6) = 4;       TetCount(3, 6) = 4;
            TetCount(1, 7) = 0;    TetCount(2, 7) = 0;       TetCount(3, 7) = 0;
            TetCount(1, 8) = 0;    TetCount(2, 8) = 8;       TetCount(3, 8) = 0;
            TetCount(1, 9) = 0;    TetCount(2, 9) = 0;       TetCount(3, 9) = 0;
        case { '110', '001' }
            TetCount(1, 1) = 0;    TetCount(2, 1) = 4;       TetCount(3, 1) = 0;
            TetCount(1, 2) = 0;    TetCount(2, 2) = 4;       TetCount(3, 2) = 0;
            TetCount(1, 3) = 0;    TetCount(2, 3) = 4;       TetCount(3, 3) = 0;
            TetCount(1, 4) = 0;    TetCount(2, 4) = 4;       TetCount(3, 4) = 0;
            TetCount(1, 5) = 8;    TetCount(2, 5) = 16 * 2;  TetCount(3, 5) = 8;
            TetCount(1, 6) = 0;    TetCount(2, 6) = 4;       TetCount(3, 6) = 0;
            TetCount(1, 7) = 0;    TetCount(2, 7) = 4;       TetCount(3, 7) = 0;
            TetCount(1, 8) = 0;    TetCount(2, 8) = 4;       TetCount(3, 8) = 0;
            TetCount(1, 9) = 0;    TetCount(2, 9) = 4;       TetCount(3, 9) = 0;
        otherwise
            error('check')
    end

    if GVV_SideFlag(1) 
        TetCount(3, :) = 0;
        TetCount(2, :) = TetCount(2, :) / 2;
    end
    if GVV_SideFlag(3) 
        TetCount(1, :) = 0;
        TetCount(2, :) = TetCount(2, :) / 2;
    end
    if GVV_SideFlag(2) 
        TetCount(1, 1) = 0;     TetCount(2, 1) = 0;     TetCount(3, 1) = 0;
        TetCount(1, 4) = 0;     TetCount(2, 4) = 0;     TetCount(3, 4) = 0;
        TetCount(1, 7) = 0;     TetCount(2, 7) = 0;     TetCount(3, 7) = 0;

        TetCount(1, 2) = TetCount(1, 2) / 2;
        TetCount(1, 5) = TetCount(1, 5) / 2;
        TetCount(1, 8) = TetCount(1, 8) / 2;
        TetCount(2, 2) = TetCount(2, 2) / 2;
        TetCount(2, 5) = TetCount(2, 5) / 2;
        TetCount(2, 8) = TetCount(2, 8) / 2;
        TetCount(3, 2) = TetCount(3, 2) / 2;
        TetCount(3, 5) = TetCount(3, 5) / 2;
        TetCount(3, 8) = TetCount(3, 8) / 2;
    end
    if GVV_SideFlag(4) 
        TetCount(1, 3) = 0;     TetCount(2, 3) = 0;     TetCount(3, 3) = 0;
        TetCount(1, 6) = 0;     TetCount(2, 6) = 0;     TetCount(3, 6) = 0;
        TetCount(1, 9) = 0;     TetCount(2, 9) = 0;     TetCount(3, 9) = 0;

        TetCount(1, 2) = TetCount(1, 2) / 2;
        TetCount(1, 5) = TetCount(1, 5) / 2;
        TetCount(1, 8) = TetCount(1, 8) / 2;
        TetCount(2, 2) = TetCount(2, 2) / 2;
        TetCount(2, 5) = TetCount(2, 5) / 2;
        TetCount(2, 8) = TetCount(2, 8) / 2;
        TetCount(3, 2) = TetCount(3, 2) / 2;
        TetCount(3, 5) = TetCount(3, 5) / 2;
        TetCount(3, 8) = TetCount(3, 8) / 2;
    end
    if GVV_SideFlag(5) 
        TetCount(1, 7) = 0;     TetCount(2, 7) = 0;     TetCount(3, 7) = 0;
        TetCount(1, 8) = 0;     TetCount(2, 8) = 0;     TetCount(3, 8) = 0;
        TetCount(1, 9) = 0;     TetCount(2, 9) = 0;     TetCount(3, 9) = 0;

        TetCount(1, 4) = TetCount(1, 4) / 2;
        TetCount(1, 5) = TetCount(1, 5) / 2;
        TetCount(1, 6) = TetCount(1, 6) / 2;
        TetCount(2, 4) = TetCount(2, 4) / 2;
        TetCount(2, 5) = TetCount(2, 5) / 2;
        TetCount(2, 6) = TetCount(2, 6) / 2;
        TetCount(3, 4) = TetCount(3, 4) / 2;
        TetCount(3, 5) = TetCount(3, 5) / 2;
        TetCount(3, 6) = TetCount(3, 6) / 2;
    end
    if GVV_SideFlag(6) 
        TetCount(1, 1) = 0;     TetCount(2, 1) = 0;     TetCount(3, 1) = 0;
        TetCount(1, 2) = 0;     TetCount(2, 2) = 0;     TetCount(3, 2) = 0;
        TetCount(1, 3) = 0;     TetCount(2, 3) = 0;     TetCount(3, 3) = 0;

        TetCount(1, 4) = TetCount(1, 4) / 2;
        TetCount(1, 5) = TetCount(1, 5) / 2;
        TetCount(1, 6) = TetCount(1, 6) / 2;
        TetCount(2, 4) = TetCount(2, 4) / 2;
        TetCount(2, 5) = TetCount(2, 5) / 2;
        TetCount(2, 6) = TetCount(2, 6) / 2;
        TetCount(3, 4) = TetCount(3, 4) / 2;
        TetCount(3, 5) = TetCount(3, 5) / 2;
        TetCount(3, 6) = TetCount(3, 6) / 2;
    end

    TetCount = TetCount * UnitTetVol;

    sparseGVV(28: 36) = TetCount(1, :)';
    sparseGVV(37: 45) = TetCount(2, :)';
    sparseGVV(46: 54) = TetCount(3, :)';
end