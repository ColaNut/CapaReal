function [ Phi ] = get27Phi( m, n, ell, PhiHlfY )
    
    Phi = zeros( 3, 9 );

    Phi( 1, 1 ) = PhiHlfY( m - 1, n - 1, ell - 1 );
    Phi( 1, 2 ) = PhiHlfY( m    , n - 1, ell - 1 );
    Phi( 1, 3 ) = PhiHlfY( m + 1, n - 1, ell - 1 );
    Phi( 1, 4 ) = PhiHlfY( m - 1, n    , ell - 1 );
    Phi( 1, 5 ) = PhiHlfY( m    , n    , ell - 1 );
    Phi( 1, 6 ) = PhiHlfY( m + 1, n    , ell - 1 );
    Phi( 1, 7 ) = PhiHlfY( m - 1, n + 1, ell - 1 );
    Phi( 1, 8 ) = PhiHlfY( m    , n + 1, ell - 1 );
    Phi( 1, 9 ) = PhiHlfY( m + 1, n + 1, ell - 1 );

    Phi( 2, 1 ) = PhiHlfY( m - 1, n - 1, ell     );
    Phi( 2, 2 ) = PhiHlfY( m    , n - 1, ell     );
    Phi( 2, 3 ) = PhiHlfY( m + 1, n - 1, ell     );
    Phi( 2, 4 ) = PhiHlfY( m - 1, n    , ell     );
    Phi( 2, 5 ) = PhiHlfY( m    , n    , ell     );
    Phi( 2, 6 ) = PhiHlfY( m + 1, n    , ell     );
    Phi( 2, 7 ) = PhiHlfY( m - 1, n + 1, ell     );
    Phi( 2, 8 ) = PhiHlfY( m    , n + 1, ell     );
    Phi( 2, 9 ) = PhiHlfY( m + 1, n + 1, ell     );

    Phi( 3, 1 ) = PhiHlfY( m - 1, n - 1, ell + 1 );
    Phi( 3, 2 ) = PhiHlfY( m    , n - 1, ell + 1 );
    Phi( 3, 3 ) = PhiHlfY( m + 1, n - 1, ell + 1 );
    Phi( 3, 4 ) = PhiHlfY( m - 1, n    , ell + 1 );
    Phi( 3, 5 ) = PhiHlfY( m    , n    , ell + 1 );
    Phi( 3, 6 ) = PhiHlfY( m + 1, n    , ell + 1 );
    Phi( 3, 7 ) = PhiHlfY( m - 1, n + 1, ell + 1 );
    Phi( 3, 8 ) = PhiHlfY( m    , n + 1, ell + 1 );
    Phi( 3, 9 ) = PhiHlfY( m + 1, n + 1, ell + 1 );

end