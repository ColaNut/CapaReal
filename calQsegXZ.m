function [ PntQseg, TtrVol ] = calQsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho, mediumTable )

    % notes actually: SARseg = zeros( 1, 1, 6, 8 );
    PntQseg   = zeros( 6, 8 );
    PntSARseg = zeros( 6, 8 );
    TtrVol    = zeros( 6, 8 );
    % rho       = ones( size(rho) );
    PntSegValue  = squeeze( SegValueXZ( m, ell, :, : ) );
                  %  air,  bolus, muscle, lung, tumor, bone, fat, effected muscle, effected adipose tissue 
    % Q_met        = [ 0,      0,   4200, 4200, 42000,    4200 ]';
    % Q_met        = [ 0,      0,   4200, 4200, 42000,    0 ]';
    % Q_met          = [ 0,      0,   4200, 1700,  8000,  4200,   5 ]';
    Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5,  4200, 5]';
    % Q_met        = [ 0,      0,   1700, 1700,  8000 ]';

    [ PntSARseg, TtrVol ] = calSARsegXZ( m, n, ell, PhiHlfY, ThrXYZCrndt, SegValueXZ, ...
                                                        x_idx_max, sigma, rho, mediumTable );

    PntSegRho = rho(PntSegValue);
    PntSegQmet = Q_met(PntSegValue);

    PntQseg   = PntSARseg .* PntSegRho + PntSegQmet;
    % PntQseg   = PntSARseg .* PntSegRho;

end