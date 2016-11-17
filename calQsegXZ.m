function [ PntSARseg, TtrVol ] = calQsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho )

    % notes actually: SARseg = zeros( 1, 1, 6, 8 );
    PntSARseg = zeros( 6, 8 );
    TtrVol    = zeros( 6, 8 );
    rho       = ones( size(rho) );

    [ PntSARseg, TtrVol ] = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho );

end