function [ PntSARseg, TtrVol ] = calPntSAR( m, n, ell, Phi, shiftedCoordinateXYZ, PntSegValue, ...
                                                        x_idx_max, y_idx_max, sigma, rho )

    % notes actually: SARseg = zeros( 1, 1, 6, 8 );
    PntSARseg = zeros( 6, 8 );

    % the PntsIdx is a dummy variable here.
    PntsIdx      = zeros( 3, 9 );
    % MedValue     = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
    MidPhi       = zeros( 3, 9 );
    tmpMidPhi    = zeros( 9 );
    % PntSegValue  = squeeze( SegValueXZ( m, ell, :, : ) );
    
    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );
    MidPnts9Crdnt = getMidPnts9CrdntXZ( MidPntsCrdnt );
    % MedValue     = get27MedValue( m, n, ell, ThrMedValue );
    MidPhi       = cal27MidPhi( m, n, ell, Phi );

% Start from here: cal the volume, the E_x, the E_y and the E_z, and get the corresponding PntSegValue value.
    % p1
    [ PntSARseg(1, :), TtrVol(1, :) ] = calPntSARseg( squeeze( MidPntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(1, :), MidPhi(3, :), MidPhi(2, 5), sigma, rho );
    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    tmpMidPhi   = p2FaceMidPhi( MidPhi );
    [ PntSARseg(2, :), TtrVol(2, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(2, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    tmpMidPhi   = p3FaceMidPhi( MidPhi );
    [ PntSARseg(3, :), TtrVol(3, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(3, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    tmpMidPhi   = p4FaceMidPhi( MidPhi );
    [ PntSARseg(4, :), TtrVol(4, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(4, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    tmpMidPhi   = p5FaceMidPhi( MidPhi );
    [ PntSARseg(5, :), TtrVol(5, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(5, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    tmpMidPhi   = p6FaceMidPhi( MidPhi );
    [ PntSARseg(6, :), TtrVol(6, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                PntSegValue(6, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

end