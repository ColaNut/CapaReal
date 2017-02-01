function [ A_row, SegMed ] = fillBndrPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                    mediumTable, epsilon_r )

    % A_row         = zeros( 1, x_idx_max * y_idx_max * z_idx_max );
    A_row         = zeros( 1, 14 );
    PntsIdx       = zeros( 3, 9 );
    PntsCrdnt     = zeros( 3, 9, 3 );
    PntsMed       = zeros( 3, 9 );
    MidPntsCrdnt  = zeros( 3, 9, 3 );
    tmpMidCrdnt   = zeros( 1, 9, 3 );
    tmpMed2Layers = zeros( 2, 9 );
    BlsMed2Layers = zeros( 1, 9 );
    tmpMidLyr     = zeros( 9, 3 );
    sideEffect    = zeros( 6, 4 );
    SegMed        = ones( 6, 8, 'uint8' );
    
    [ PntsIdx, PntsCrdnt ]  = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    PntsMed                 = get27PntsMed( PntsIdx, mediumTable );
    MidPntsCrdnt            = calMid27Pnts( PntsCrdnt );

    A_row(1)  = PntsIdx(3, 5);
    A_row(2)  = PntsIdx(2, 4);
    A_row(3)  = PntsIdx(1, 5);
    A_row(4)  = PntsIdx(2, 6);
    A_row(5)  = PntsIdx(2, 8);
    A_row(6)  = PntsIdx(2, 2);
    A_row(7)  = PntsIdx(2, 5);

    % % try
    % XZBls9Med = zeros(9, 1);
    % if BlsBndryMsk(m, ell) == 11 || BlsBndryMsk(m, ell) == 12
    %     SegMed = PreCalSegMed( m, ell, PntsCrdnt, BlsBndryMsk );
    % end

    % % two special cases: 
    % if m == 19 && (n >= 16 && n <= 20) && (ell == 12 || ell == 30)
    %     SegMed = specialSegMed(m, n, ell);
    % end

    % p1
    tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    if PntsMed(3, 5) ~= 0
        [ A_row(8), sideEffect(1, :) ] = nrmlEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(3, 5, :) ), epsilon_r( PntsMed(3, 5) ) );
        SegMed(1, :) = ones( size(SegMed(1, :)) ) * PntsMed(3, 5);
    else
    tmpMed2Layers = p1FaceMed( PntsMed );
        [ A_row(8), SegMed(1, :), sideEffect(1, :) ] = bndrEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(3, 5, :) ), tmpMed2Layers, epsilon_r, SegMed(1, :) );
    end

    % p2
    tmpMidLyr   = p2FaceMidLyr( PntsCrdnt );
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    if PntsMed(2, 4) ~= 0
        [ A_row(9), sideEffect(2, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 4, :) ), epsilon_r( PntsMed(2, 4) ) );
        SegMed(2, :) = ones( size(SegMed(2, :)) ) * PntsMed(2, 4);
    else
    tmpMed2Layers = p2FaceMed( PntsMed );
        [ A_row(9), SegMed(2, :), sideEffect(2, :) ] = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 4, :) ), tmpMed2Layers, epsilon_r, SegMed(2, :) );
    end

    % p3
    tmpMidLyr   = p3FaceMidLyr( PntsCrdnt );
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    if PntsMed(1, 5) ~= 0
        [ A_row(10), sideEffect(3, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(1, 5, :) ), epsilon_r( PntsMed(1, 5) ) );
        SegMed(3, :) = ones( size(SegMed(3, :)) ) * PntsMed(1, 5);
    else
    tmpMed2Layers = p3FaceMed( PntsMed );
        [ A_row(10), SegMed(3, :), sideEffect(3, :) ] = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(1, 5, :) ), tmpMed2Layers, epsilon_r, SegMed(3, :) );
    end

    % p4
    tmpMidLyr   = p4FaceMidLyr( PntsCrdnt );
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    if PntsMed(2, 6) ~= 0
        [ A_row(11), sideEffect(4, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 6, :) ), epsilon_r( PntsMed(2, 6) ) );
        SegMed(4, :) = ones( size(SegMed(4, :)) ) * PntsMed(2, 6);
    else
    tmpMed2Layers = p4FaceMed( PntsMed );
        [ A_row(11), SegMed(4, :), sideEffect(4, :) ] = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 6, :) ), tmpMed2Layers, epsilon_r, SegMed(4, :) );
    end

    % p5
    tmpMidLyr   = p5FaceMidLyr( PntsCrdnt );
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    if PntsMed(2, 8) ~= 0
        [ A_row(12), sideEffect(5, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 8, :) ), epsilon_r( PntsMed(2, 8) ) );
        SegMed(5, :) = ones( size(SegMed(5, :)) ) * PntsMed(2, 8);
    else
    tmpMed2Layers = p5FaceMed( PntsMed );
        [ A_row(12), SegMed(5, :), sideEffect(5, :) ] = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 8, :) ), tmpMed2Layers, epsilon_r, SegMed(5, :) );
    end

    % p6
    tmpMidLyr   = p6FaceMidLyr( PntsCrdnt );
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    if PntsMed(2, 2) ~= 0
        [ A_row(13), sideEffect(6, :) ] = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 2, :) ), epsilon_r( PntsMed(2, 2) ) );
        SegMed(6, :) = ones( size(SegMed(6, :)) ) * PntsMed(2, 2);
    else
    tmpMed2Layers = p6FaceMed( PntsMed );
        [ A_row(13), SegMed(6, :), sideEffect(6, :) ] = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                                        tmpMidLyr, squeeze( PntsCrdnt(2, 2, :) ), tmpMed2Layers, epsilon_r, SegMed(6, :) );
    end
    % catch
    %     [ m, n, ell ]
    %     PntsMed
    %     squeeze( tmpMidCrdnt )
    % end
    
    % p0
    A_row(8) = A_row(8) + sideEffect(2, 2) + sideEffect(4, 2) + sideEffect(5, 2) + sideEffect(6, 2);
    A_row(9) = A_row(9) + sideEffect(1, 3) + sideEffect(3, 1) + sideEffect(5, 1) + sideEffect(6, 3);
    A_row(10) = A_row(10) + sideEffect(2, 4) + sideEffect(4, 4) + sideEffect(5, 4) + sideEffect(6, 4);
    A_row(11) = A_row(11) + sideEffect(1, 1) + sideEffect(3, 3) + sideEffect(5, 3) + sideEffect(6, 1);
    A_row(12) = A_row(12) + sideEffect(1, 2) + sideEffect(2, 3) + sideEffect(3, 2) + sideEffect(4, 1);
    A_row(13) = A_row(13) + sideEffect(1, 4) + sideEffect(2, 1) + sideEffect(3, 4) + sideEffect(4, 3);
    A_row(14) = - ( A_row(8) + A_row(9) + A_row(10) + A_row(11) + A_row(12) + A_row(13) );

end