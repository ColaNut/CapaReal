function [ MedValue ] = get27MedValue( m, n, ell, mediumTable )
    
    MedValue     = zeros( 3, 9 );

    MedValue( 1, 1 ) = mediumTable( m - 1, n - 1, ell - 1 );
    MedValue( 1, 2 ) = mediumTable( m    , n - 1, ell - 1 );
    MedValue( 1, 3 ) = mediumTable( m + 1, n - 1, ell - 1 );
    MedValue( 1, 4 ) = mediumTable( m - 1, n    , ell - 1 );
    MedValue( 1, 5 ) = mediumTable( m    , n    , ell - 1 );
    MedValue( 1, 6 ) = mediumTable( m + 1, n    , ell - 1 );
    MedValue( 1, 7 ) = mediumTable( m - 1, n + 1, ell - 1 );
    MedValue( 1, 8 ) = mediumTable( m    , n + 1, ell - 1 );
    MedValue( 1, 9 ) = mediumTable( m + 1, n + 1, ell - 1 );

    MedValue( 2, 1 ) = mediumTable( m - 1, n - 1, ell     );
    MedValue( 2, 2 ) = mediumTable( m    , n - 1, ell     );
    MedValue( 2, 3 ) = mediumTable( m + 1, n - 1, ell     );
    MedValue( 2, 4 ) = mediumTable( m - 1, n    , ell     );
    MedValue( 2, 5 ) = mediumTable( m    , n    , ell     );
    MedValue( 2, 6 ) = mediumTable( m + 1, n    , ell     );
    MedValue( 2, 7 ) = mediumTable( m - 1, n + 1, ell     );
    MedValue( 2, 8 ) = mediumTable( m    , n + 1, ell     );
    MedValue( 2, 9 ) = mediumTable( m + 1, n + 1, ell     );

    MedValue( 3, 1 ) = mediumTable( m - 1, n - 1, ell + 1 );
    MedValue( 3, 2 ) = mediumTable( m    , n - 1, ell + 1 );
    MedValue( 3, 3 ) = mediumTable( m + 1, n - 1, ell + 1 );
    MedValue( 3, 4 ) = mediumTable( m - 1, n    , ell + 1 );
    MedValue( 3, 5 ) = mediumTable( m    , n    , ell + 1 );
    MedValue( 3, 6 ) = mediumTable( m + 1, n    , ell + 1 );
    MedValue( 3, 7 ) = mediumTable( m - 1, n + 1, ell + 1 );
    MedValue( 3, 8 ) = mediumTable( m    , n + 1, ell + 1 );
    MedValue( 3, 9 ) = mediumTable( m + 1, n + 1, ell + 1 );

end