function [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ )

    PntsIdx     = zeros( 3, 9 );
    PntsCrdnt   = zeros( 3, 9, 3 );
    % PntsMed     = zeros( 3, 9 );

    PntsIdx( 1, 1 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m - 1 );
    PntsIdx( 1, 2 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m );
    PntsIdx( 1, 3 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m + 1 );
    PntsIdx( 1, 4 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m - 1 );
    PntsIdx( 1, 5 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m );
    PntsIdx( 1, 6 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m + 1 );
    PntsIdx( 1, 7 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m - 1 );
    PntsIdx( 1, 8 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m );
    PntsIdx( 1, 9 ) = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m + 1 );

    PntsIdx( 2, 1 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m - 1 );
    PntsIdx( 2, 2 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m );
    PntsIdx( 2, 3 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m + 1 );
    PntsIdx( 2, 4 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m - 1 );
    PntsIdx( 2, 5 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m );
    PntsIdx( 2, 6 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m + 1 );
    PntsIdx( 2, 7 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m - 1 );
    PntsIdx( 2, 8 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m );
    PntsIdx( 2, 9 ) = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m + 1 );

    PntsIdx( 3, 1 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m - 1 );
    PntsIdx( 3, 2 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m );
    PntsIdx( 3, 3 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m + 1 );
    PntsIdx( 3, 4 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m - 1 );
    PntsIdx( 3, 5 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m );
    PntsIdx( 3, 6 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m + 1 );
    PntsIdx( 3, 7 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m - 1 );
    PntsIdx( 3, 8 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m );
    PntsIdx( 3, 9 ) = int64( ( ell     ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m + 1 );


    % need to check whether to add squeeze or not.
    PntsCrdnt( 1, 1, : ) = shiftedCoordinateXYZ( m - 1, n - 1, ell - 1, :);
    PntsCrdnt( 1, 2, : ) = shiftedCoordinateXYZ( m    , n - 1, ell - 1, :);
    PntsCrdnt( 1, 3, : ) = shiftedCoordinateXYZ( m + 1, n - 1, ell - 1, :);
    PntsCrdnt( 1, 4, : ) = shiftedCoordinateXYZ( m - 1, n    , ell - 1, :);
    PntsCrdnt( 1, 5, : ) = shiftedCoordinateXYZ( m    , n    , ell - 1, :);
    PntsCrdnt( 1, 6, : ) = shiftedCoordinateXYZ( m + 1, n    , ell - 1, :);
    PntsCrdnt( 1, 7, : ) = shiftedCoordinateXYZ( m - 1, n + 1, ell - 1, :);
    PntsCrdnt( 1, 8, : ) = shiftedCoordinateXYZ( m    , n + 1, ell - 1, :);
    PntsCrdnt( 1, 9, : ) = shiftedCoordinateXYZ( m + 1, n + 1, ell - 1, :);

    PntsCrdnt( 2, 1, : ) = shiftedCoordinateXYZ( m - 1, n - 1, ell    , :);
    PntsCrdnt( 2, 2, : ) = shiftedCoordinateXYZ( m    , n - 1, ell    , :);
    PntsCrdnt( 2, 3, : ) = shiftedCoordinateXYZ( m + 1, n - 1, ell    , :);
    PntsCrdnt( 2, 4, : ) = shiftedCoordinateXYZ( m - 1, n    , ell    , :);
    PntsCrdnt( 2, 5, : ) = shiftedCoordinateXYZ( m    , n    , ell    , :);
    PntsCrdnt( 2, 6, : ) = shiftedCoordinateXYZ( m + 1, n    , ell    , :);
    PntsCrdnt( 2, 7, : ) = shiftedCoordinateXYZ( m - 1, n + 1, ell    , :);
    PntsCrdnt( 2, 8, : ) = shiftedCoordinateXYZ( m    , n + 1, ell    , :);
    PntsCrdnt( 2, 9, : ) = shiftedCoordinateXYZ( m + 1, n + 1, ell    , :);

    PntsCrdnt( 3, 1, : ) = shiftedCoordinateXYZ( m - 1, n - 1, ell + 1, :);
    PntsCrdnt( 3, 2, : ) = shiftedCoordinateXYZ( m    , n - 1, ell + 1, :);
    PntsCrdnt( 3, 3, : ) = shiftedCoordinateXYZ( m + 1, n - 1, ell + 1, :);
    PntsCrdnt( 3, 4, : ) = shiftedCoordinateXYZ( m - 1, n    , ell + 1, :);
    PntsCrdnt( 3, 5, : ) = shiftedCoordinateXYZ( m    , n    , ell + 1, :);
    PntsCrdnt( 3, 6, : ) = shiftedCoordinateXYZ( m + 1, n    , ell + 1, :);
    PntsCrdnt( 3, 7, : ) = shiftedCoordinateXYZ( m - 1, n + 1, ell + 1, :);
    PntsCrdnt( 3, 8, : ) = shiftedCoordinateXYZ( m    , n + 1, ell + 1, :);
    PntsCrdnt( 3, 9, : ) = shiftedCoordinateXYZ( m + 1, n + 1, ell + 1, :);

    % PntsMed( 1, 1 ) = mediumTable( PntsIdx( 1, 1 ) );
    % PntsMed( 1, 2 ) = mediumTable( PntsIdx( 1, 2 ) );
    % PntsMed( 1, 3 ) = mediumTable( PntsIdx( 1, 3 ) );
    % PntsMed( 1, 4 ) = mediumTable( PntsIdx( 1, 4 ) );
    % PntsMed( 1, 5 ) = mediumTable( PntsIdx( 1, 5 ) );
    % PntsMed( 1, 6 ) = mediumTable( PntsIdx( 1, 6 ) );
    % PntsMed( 1, 7 ) = mediumTable( PntsIdx( 1, 7 ) );
    % PntsMed( 1, 8 ) = mediumTable( PntsIdx( 1, 8 ) );
    % PntsMed( 1, 9 ) = mediumTable( PntsIdx( 1, 9 ) );

    % PntsMed( 2, 1 ) = mediumTable( PntsIdx( 2, 1 ) );
    % PntsMed( 2, 2 ) = mediumTable( PntsIdx( 2, 2 ) );
    % PntsMed( 2, 3 ) = mediumTable( PntsIdx( 2, 3 ) );
    % PntsMed( 2, 4 ) = mediumTable( PntsIdx( 2, 4 ) );
    % PntsMed( 2, 5 ) = mediumTable( PntsIdx( 2, 5 ) );
    % PntsMed( 2, 6 ) = mediumTable( PntsIdx( 2, 6 ) );
    % PntsMed( 2, 7 ) = mediumTable( PntsIdx( 2, 7 ) );
    % PntsMed( 2, 8 ) = mediumTable( PntsIdx( 2, 8 ) );
    % PntsMed( 2, 9 ) = mediumTable( PntsIdx( 2, 9 ) );

    % PntsMed( 3, 1 ) = mediumTable( PntsIdx( 3, 1 ) );
    % PntsMed( 3, 2 ) = mediumTable( PntsIdx( 3, 2 ) );
    % PntsMed( 3, 3 ) = mediumTable( PntsIdx( 3, 3 ) );
    % PntsMed( 3, 4 ) = mediumTable( PntsIdx( 3, 4 ) );
    % PntsMed( 3, 5 ) = mediumTable( PntsIdx( 3, 5 ) );
    % PntsMed( 3, 6 ) = mediumTable( PntsIdx( 3, 6 ) );
    % PntsMed( 3, 7 ) = mediumTable( PntsIdx( 3, 7 ) );
    % PntsMed( 3, 8 ) = mediumTable( PntsIdx( 3, 8 ) );
    % PntsMed( 3, 9 ) = mediumTable( PntsIdx( 3, 9 ) );

end