function [ A_row ] = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max )

    A_row        = zeros(1, x_idx_max * y_idx_max * z_idx_max);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
    
    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );

    if length(find(PntsIdx)) == 27
        dx = PntsCrdnt(2, 6, 1) - PntsCrdnt(2, 5, 1);
        dy = PntsCrdnt(2, 8, 2) - PntsCrdnt(2, 5, 2);
        dz = PntsCrdnt(3, 5, 3) - PntsCrdnt(2, 5, 3);
        A_row( PntsIdx(3, 5) ) = dx * dy / dz;
        A_row( PntsIdx(2, 4) ) = dy * dz / dx;
        A_row( PntsIdx(1, 5) ) = dx * dy / dz;
        A_row( PntsIdx(2, 6) ) = dy * dz / dx;
        A_row( PntsIdx(2, 8) ) = dx * dz / dy;
        A_row( PntsIdx(2, 2) ) = dx * dz / dy;
    else
        % p1
        A_row( PntsIdx(3, 5) ) = nrmlEffValue( squeeze( MidPntsCrdnt(3, :, :) ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(3, 5, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(3, 5, :) ) );
        % p2
        tmpMidCrdnt = p2Face( MidPntsCrdnt );
        A_row( PntsIdx(2, 4) ) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 4, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 4, :) ) );
        % p3
        tmpMidCrdnt = p3Face( MidPntsCrdnt );
        A_row( PntsIdx(1, 5) ) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(1, 5, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(1, 5, :) ) );
        % p4
        tmpMidCrdnt = p4Face( MidPntsCrdnt );
        A_row( PntsIdx(2, 6) ) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 6, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 6, :) ) );
        % p5
        tmpMidCrdnt = p5Face( MidPntsCrdnt );
        A_row( PntsIdx(2, 8) ) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 8, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 8, :) ) );
        % p6
        tmpMidCrdnt = p6Face( MidPntsCrdnt );
        A_row( PntsIdx(2, 2) ) = nrmlEffValue( squeeze( tmpMidCrdnt ), ...
                                            squeeze( PntsCrdnt(2, 5, :) ), squeeze( PntsCrdnt(2, 2, :) ), 1 ) ...
                                / norm( squeeze( PntsCrdnt(2, 5, :) - PntsCrdnt(2, 2, :) ) );
    end
    % p0
    A_row( PntsIdx(2, 5) ) = - ( A_row( PntsIdx(3, 5) ) + A_row( PntsIdx(2, 4) ) + A_row( PntsIdx(1, 5) ) + ...
                                A_row( PntsIdx(2, 6) ) + A_row( PntsIdx(2, 8) ) + A_row( PntsIdx(2, 2) ) );
end