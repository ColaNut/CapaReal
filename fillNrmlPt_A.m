function [ A_row, SegMed ] = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable )

    % A_row        = zeros(1, x_idx_max * y_idx_max * z_idx_max);
    A_row        = zeros( 1, 14 );
    PntsIdx      = zeros( 3, 9 );
    MedValue     = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
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
        A_row(8) = nrmlEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(3, 5, :) ), 1 );
        % p2
        tmpMidCrdnt = p2Face( MidPntsCrdnt );
        A_row(9) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 4, :) ), 1 );
        % p3
        tmpMidCrdnt = p3Face( MidPntsCrdnt );
        A_row(10) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(1, 5, :) ), 1 );
        % p4
        tmpMidCrdnt = p4Face( MidPntsCrdnt );
        A_row(11) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 6, :) ), 1 );
        % p5
        tmpMidCrdnt = p5Face( MidPntsCrdnt );
        A_row(12) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 8, :) ), 1 );
        % p6
        tmpMidCrdnt = p6Face( MidPntsCrdnt );
        A_row(13) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 2, :) ), 1 );
    end
    % p0
    SegMed    = SegMed .* mediumTable(m, n, ell);
    A_row(14) = - ( A_row(8) + A_row(9) + A_row(10) + A_row(11) + A_row(12) + A_row(13) );
    % A_row( PntsIdx(2, 5) ) = - ( A_row( PntsIdx(3, 5) ) + A_row( PntsIdx(2, 4) ) + A_row( PntsIdx(1, 5) ) + ...
    %                             A_row( PntsIdx(2, 6) ) + A_row( PntsIdx(2, 8) ) + A_row( PntsIdx(2, 2) ) );
end