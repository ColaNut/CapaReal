function PntCurrent = getCurrentDir(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, PntSegMed, J_0 )
    PntCurrent = zeros(6, 8, 3);
    tmpMidLyr  = zeros(9, 3);

    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );

    tmpMidLyr = squeeze( MidPntsCrdnt(3, :, :) );
    PntCurrent(1, :, :) = getSideCurrentDir( PntSegMed(1, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

    tmpMidLyr = squeeze( p2Face( MidPntsCrdnt ) );
    PntCurrent(2, :, :) = getSideCurrentDir( PntSegMed(2, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

    tmpMidLyr = squeeze( p3Face( MidPntsCrdnt ) );
    PntCurrent(3, :, :) = getSideCurrentDir( PntSegMed(3, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

    tmpMidLyr = squeeze( p4Face( MidPntsCrdnt ) );
    PntCurrent(4, :, :) = getSideCurrentDir( PntSegMed(4, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

    tmpMidLyr = squeeze( p5Face( MidPntsCrdnt ) );
    PntCurrent(5, :, :) = getSideCurrentDir( PntSegMed(5, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

    tmpMidLyr = squeeze( p6Face( MidPntsCrdnt ) );
    PntCurrent(6, :, :) = getSideCurrentDir( PntSegMed(6, :), tmpMidLyr, squeeze( PntsCrdnt(2, 5, :) ), J_0 );

end