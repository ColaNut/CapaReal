function [ Mid9Pnts ] = calMid9Pnts( Pnts )

    Mid9Pnts = zeros( 9, 3 );

    Mid9Pnts( 1, : ) = ( Pnts( 1, 1, : ) + Pnts( 1, 2, : ) + Pnts( 1, 4, : ) + Pnts( 1, 5, : ) ) / 8 ...
                + ( Pnts( 2, 1, : ) + Pnts( 2, 2, : ) + Pnts( 2, 4, : ) + Pnts( 2, 5, : ) ) / 8;
    Mid9Pnts( 2, : ) = ( Pnts( 1, 2, : ) + Pnts( 1, 5, : ) ) / 4 ...
                + ( Pnts( 2, 2, : ) + Pnts( 2, 5, : ) ) / 4;
    Mid9Pnts( 3, : ) = ( Pnts( 1, 2, : ) + Pnts( 1, 3, : ) + Pnts( 1, 5, : ) + Pnts( 1, 6, : ) ) / 8 ...
                + ( Pnts( 2, 2, : ) + Pnts( 2, 3, : ) + Pnts( 2, 5, : ) + Pnts( 2, 6, : ) ) / 8;
    Mid9Pnts( 4, : ) = ( Pnts( 1, 4, : ) + Pnts( 1, 5, : ) ) / 4 ...
                + ( Pnts( 2, 4, : ) + Pnts( 2, 5, : ) ) / 4;
    Mid9Pnts( 5, : ) = ( Pnts( 1, 5, : ) + Pnts( 2, 5, : ) ) / 2;
    Mid9Pnts( 6, : ) = ( Pnts( 1, 5, : ) + Pnts( 1, 6, : ) ) / 4 ...
                + ( Pnts( 2, 5, : ) + Pnts( 2, 6, : ) ) / 4;
    Mid9Pnts( 7, : ) = ( Pnts( 1, 4, : ) + Pnts( 1, 5, : ) + Pnts( 1, 7, : ) + Pnts( 1, 8, : ) ) / 8 ...
                + ( Pnts( 2, 4, : ) + Pnts( 2, 5, : ) + Pnts( 2, 7, : ) + Pnts( 2, 8, : ) ) / 8;
    Mid9Pnts( 8, : ) = ( Pnts( 1, 5, : ) + Pnts( 1, 8, : ) ) / 4 ...
                + ( Pnts( 2, 5, : ) + Pnts( 2, 8, : ) ) / 4;
    Mid9Pnts( 9, : ) = ( Pnts( 1, 5, : ) + Pnts( 1, 6, : ) + Pnts( 1, 8, : ) + Pnts( 1, 9, : ) ) / 8 ...
                + ( Pnts( 2, 5, : ) + Pnts( 2, 6, : ) + Pnts( 2, 8, : ) + Pnts( 2, 9, : ) ) / 8;

end