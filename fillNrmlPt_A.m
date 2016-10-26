function [ A_row, SegMed ] = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable )

    % A_row        = zeros(1, x_idx_max * y_idx_max * z_idx_max);
    A_row        = zeros( 1, 14 );
    PntsIdx      = zeros( 3, 9 );
    MedValue     = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
    tmpMidLyr    = zeros( 9, 3 );
    sideEffect   = zeros( 6, 4 );
    SegMed       = ones( 6, 8, 'uint8' );
    
    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );
    MedValue     = get27MedValue( m, n, ell, mediumTable );

    A_row(1)  = PntsIdx(3, 5);
    A_row(2)  = PntsIdx(2, 4);
    A_row(3)  = PntsIdx(1, 5);
    A_row(4)  = PntsIdx(2, 6);
    A_row(5)  = PntsIdx(2, 8);
    A_row(6)  = PntsIdx(2, 2);
    A_row(7)  = PntsIdx(2, 5);

    if length(find(MedValue)) == 27
        dx = PntsCrdnt(2, 6, 1) - PntsCrdnt(2, 5, 1);
        dy = PntsCrdnt(2, 8, 2) - PntsCrdnt(2, 5, 2);
        dz = PntsCrdnt(3, 5, 3) - PntsCrdnt(2, 5, 3);

        A_row(8)  = dx * dy / dz;
        A_row(9)  = dy * dz / dx;
        A_row(10) = dx * dy / dz;
        A_row(11) = dy * dz / dx;
        A_row(12) = dx * dz / dy;
        A_row(13) = dx * dz / dy;
    else
        % p1
        tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
        [ A_row(8), sideEffect(1, :) ] = nrmlEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                                                tmpMidLyr, squeeze( PntsCrdnt(3, 5, :) ), 1 );
        % p2
        tmpMidLyr   = p2FaceMidLyr( PntsCrdnt );
        tmpMidCrdnt = p2Face( MidPntsCrdnt );
        [ A_row(9), sideEffect(2, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                                tmpMidLyr, squeeze( PntsCrdnt(2, 4, :) ), 1 );
        % p3
        tmpMidLyr   = p3FaceMidLyr( PntsCrdnt );
        tmpMidCrdnt = p3Face( MidPntsCrdnt );
        [ A_row(10), sideEffect(3, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                                tmpMidLyr, squeeze( PntsCrdnt(1, 5, :) ), 1 );
        % p4
        tmpMidLyr   = p4FaceMidLyr( PntsCrdnt );
        tmpMidCrdnt = p4Face( MidPntsCrdnt );
        [ A_row(11), sideEffect(4, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            tmpMidLyr, squeeze( PntsCrdnt(2, 6, :) ), 1 );
        % p5
        tmpMidLyr   = p5FaceMidLyr( PntsCrdnt );
        tmpMidCrdnt = p5Face( MidPntsCrdnt );
        [ A_row(12), sideEffect(5, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            tmpMidLyr, squeeze( PntsCrdnt(2, 8, :) ), 1 );
        % p6
        tmpMidLyr   = p6FaceMidLyr( PntsCrdnt );
        tmpMidCrdnt = p6Face( MidPntsCrdnt );
        [ A_row(13), sideEffect(6, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            tmpMidLyr, squeeze( PntsCrdnt(2, 2, :) ), 1 );
    end
    % p0
    SegMed    = SegMed .* mediumTable(m, n, ell);
    A_row(8) = A_row(8) + sideEffect(2, 2) + sideEffect(4, 2) + sideEffect(5, 2) + sideEffect(6, 2);
    A_row(9) = A_row(9) + sideEffect(1, 3) + sideEffect(3, 1) + sideEffect(5, 1) + sideEffect(6, 3);
    A_row(10) = A_row(10) + sideEffect(2, 4) + sideEffect(4, 4) + sideEffect(5, 4) + sideEffect(6, 4);
    A_row(11) = A_row(11) + sideEffect(1, 1) + sideEffect(3, 3) + sideEffect(5, 3) + sideEffect(6, 1);
    A_row(12) = A_row(12) + sideEffect(1, 2) + sideEffect(2, 3) + sideEffect(3, 2) + sideEffect(4, 1);
    A_row(13) = A_row(13) + sideEffect(1, 4) + sideEffect(2, 1) + sideEffect(3, 4) + sideEffect(4, 3);
    A_row(14) = - ( A_row(8) + A_row(9) + A_row(10) + A_row(11) + A_row(12) + A_row(13) );
end