function [ A_row ] = fillBndrPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                    mediumTable, epsilon_r )

    % A_row         = zeros( 1, x_idx_max * y_idx_max * z_idx_max );
    A_row         = zeros( 1, 14 );
    PntsIdx       = zeros( 3, 9 );
    PntsCrdnt     = zeros( 3, 9, 3 );
    PntsMed       = zeros( 3, 9 );
    MidPntsCrdnt  = zeros( 3, 9, 3 );
    tmpMidCrdnt   = zeros( 1, 9, 3 );
    tmpMed2Layers = zeros( 2, 9 );
    
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

    % p1
    try
    if PntsMed(3, 5) ~= 0
        A_row(8) = nrmlEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(3, 5, :) ), epsilon_r( PntsMed(3, 5) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(3, 5, :) ) );
    else
    tmpMed2Layers = p1FaceMed( PntsMed );
        A_row(8) = bndrEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(3, 5, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(3, 5, :) ) );
    end

    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    if PntsMed(2, 4) ~= 0
        A_row(9) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 4, :) ), epsilon_r( PntsMed(2, 4) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 4, :) ) );
    else
    tmpMed2Layers = p2FaceMed( PntsMed );
        A_row(9) = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 4, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 4, :) ) );
    end

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    if PntsMed(1, 5) ~= 0
        A_row(10) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(1, 5, :) ), epsilon_r( PntsMed(1, 5) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(1, 5, :) ) );
    else
    tmpMed2Layers = p3FaceMed( PntsMed );
        A_row(10) = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(1, 5, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(1, 5, :) ) );
    end

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    if PntsMed(2, 6) ~= 0
        A_row(11) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 6, :) ), epsilon_r( PntsMed(2, 6) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 6, :) ) );
    else
    tmpMed2Layers = p4FaceMed( PntsMed );
        A_row(11) = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 6, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 6, :) ) );
    end

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    if PntsMed(2, 8) ~= 0
        A_row(12) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 8, :) ), epsilon_r( PntsMed(2, 8) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 8, :) ) );
    else
    tmpMed2Layers = p5FaceMed( PntsMed );
        A_row(12) = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 8, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 8, :) ) );
    end

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    if PntsMed(2, 2) ~= 0
        A_row(13) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 2, :) ), epsilon_r( PntsMed(2, 2) ) ) ...
            / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 2, :) ) );
    else
    tmpMed2Layers = p6FaceMed( PntsMed );
        A_row(13) = bndrEffValue( squeeze( tmpMidCrdnt ), ...
                squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 2, :) ), tmpMed2Layers, epsilon_r ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 2, :) ) );
    end
    catch
        PntsIdx(2, 5)
        PntsMed
        tmpMed2Layers
    end

    % p0
    A_row(14) = - ( A_row(8) + A_row(9) + A_row(10) + A_row(11) + A_row(12) + A_row(13) );
    % A_row( PntsIdx(2, 5) ) = - ( A_row( PntsIdx(3, 5) ) + A_row( PntsIdx(2, 4) ) + A_row( PntsIdx(1, 5) ) + ...
    %                             A_row( PntsIdx(2, 6) ) + A_row( PntsIdx(2, 8) ) + A_row( PntsIdx(2, 2) ) );
end