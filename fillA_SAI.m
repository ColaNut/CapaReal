function A_row_SAI = fillA_SAI( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, PntSegMed, epsilon_r )

    A_row_SAI    = zeros(1, x_idx_max * y_idx_max * z_idx_max);
    A_row        = zeros( 1, 14 );
    PntsIdx      = zeros( 3, 9 );
    % MedValue     = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
    tmpMidLyr    = zeros( 9, 3 );
    sideEffect   = zeros( 6, 4 );
    
    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );
    % MedValue     = get27MedValue( m, n, ell, mediumTable );

    A_row(1)  = PntsIdx(3, 5);
    A_row(2)  = PntsIdx(2, 4);
    A_row(3)  = PntsIdx(1, 5);
    A_row(4)  = PntsIdx(2, 6);
    A_row(5)  = PntsIdx(2, 8);
    A_row(6)  = PntsIdx(2, 2);
    A_row(7)  = PntsIdx(2, 5);

    % p1
    A_row(8) = calEffValue_SAI( squeeze( MidPntsCrdnt(3, :, :) ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(3, 5, :) ), epsilon_r( PntSegMed(1, :) ) );
    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    A_row(9) = calEffValue_SAI( squeeze( tmpMidCrdnt ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 4, :) ), epsilon_r( PntSegMed(2, :) ) );
    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    A_row(10) = calEffValue_SAI( squeeze( tmpMidCrdnt ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(1, 5, :) ), epsilon_r( PntSegMed(3, :) ) );
    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    A_row(11) = calEffValue_SAI( squeeze( tmpMidCrdnt ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 6, :) ), epsilon_r( PntSegMed(4, :) ) );
    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    A_row(12) = calEffValue_SAI( squeeze( tmpMidCrdnt ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 8, :) ), epsilon_r( PntSegMed(5, :) ) );
    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    A_row(13) = calEffValue_SAI( squeeze( tmpMidCrdnt ), ...
                    squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 2, :) ), epsilon_r( PntSegMed(6, :) ) );
    
    % p0
    A_row(14) = - ( A_row(8) + A_row(9) + A_row(10) + A_row(11) + A_row(12) + A_row(13) );

    A_row_SAI( A_row(1) ) = A_row(8);
    A_row_SAI( A_row(2) ) = A_row(9);
    A_row_SAI( A_row(3) ) = A_row(10);
    A_row_SAI( A_row(4) ) = A_row(11);
    A_row_SAI( A_row(5) ) = A_row(12);
    A_row_SAI( A_row(6) ) = A_row(13);
    A_row_SAI( A_row(7) ) = A_row(14);

end