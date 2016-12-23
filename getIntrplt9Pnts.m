function [ Intrplt9Pnts ] = getIntrplt9Pnts(m, ell, IntrpltPnts)
    Intrplt9Pnts = zeros(9, 1);

    Intrplt9Pnts(1) = IntrpltPnts(2 * m - 2, 2 * ell - 2);
    Intrplt9Pnts(2) = IntrpltPnts(2 * m - 1, 2 * ell - 2);
    Intrplt9Pnts(3) = IntrpltPnts(2 * m    , 2 * ell - 2);
    Intrplt9Pnts(4) = IntrpltPnts(2 * m - 2, 2 * ell - 1);
    Intrplt9Pnts(5) = IntrpltPnts(2 * m - 1, 2 * ell - 1);
    Intrplt9Pnts(6) = IntrpltPnts(2 * m    , 2 * ell - 1);
    Intrplt9Pnts(7) = IntrpltPnts(2 * m - 2, 2 * ell    );
    Intrplt9Pnts(8) = IntrpltPnts(2 * m - 1, 2 * ell    );
    Intrplt9Pnts(9) = IntrpltPnts(2 * m    , 2 * ell    );
    
end