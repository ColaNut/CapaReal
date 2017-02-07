function [ PntQseg, TtrVol ] = calQsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho )

    % notes actually: SARseg = zeros( 1, 1, 6, 8 );
    PntQseg   = zeros( 6, 8 );
    PntSARseg = zeros( 6, 8 );
    TtrVol    = zeros( 6, 8 );
    rho       = ones( size(rho) );
    PntSegValue  = squeeze( SegValueXZ( m, ell, :, : ) );
                  % air, bolus, muscle, lung, tumor, bone
    Q_met        = [ 0,      0,   4200, 4200, 42000,    0 ]';
    % Q_met        = [ 0,      0,   1700, 1700, 8000 ]';

    [ PntSARseg, TtrVol ] = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho );

    PntSegRho = rho(PntSegValue);
    PntSegQmet = Q_met(PntSegValue);

    PntQseg   = PntSARseg .* PntSegRho + PntSegQmet;
    % PntQseg   = PntSARseg .* PntSegRho;

end