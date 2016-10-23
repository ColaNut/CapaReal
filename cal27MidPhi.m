function [ MidPhi ] = cal27MidPhi( m, n, ell, PhiHlfY )

    Phi    = zeros( 3, 9 );
    MidPhi = zeros( 3, 9 );

    Phi = get27Phi( m, n, ell, PhiHlfY );

    MidPhi( 1, : ) = calMid9Phi( Phi(1: 2, :) );
    MidPhi( 2, : ) = calMid9PhiB( squeeze( Phi(2, :) ) );
    MidPhi( 3, : ) = calMid9Phi( Phi(2: 3, :) );

end