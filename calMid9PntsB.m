function [ Mid9Pnts ] = calMid9PntsB( Pnts )

    Mid9Pnts = zeros( 9, 3 );

    Mid9Pnts( 1, : ) = ( Pnts( 1, : ) + Pnts( 2, : ) + Pnts( 4, : ) + Pnts( 5, : ) ) / 4;
    Mid9Pnts( 2, : ) = ( Pnts( 2, : ) + Pnts( 5, : ) ) / 2;
    Mid9Pnts( 3, : ) = ( Pnts( 2, : ) + Pnts( 3, : ) + Pnts( 5, : ) + Pnts( 6, : ) ) / 4;
    Mid9Pnts( 4, : ) = ( Pnts( 4, : ) + Pnts( 5, : ) ) / 2;
    Mid9Pnts( 5, : ) =   Pnts( 5, : );
    Mid9Pnts( 6, : ) = ( Pnts( 5, : ) + Pnts( 6, : ) ) / 2;
    Mid9Pnts( 7, : ) = ( Pnts( 4, : ) + Pnts( 5, : ) + Pnts( 7, : ) + Pnts( 8, : ) ) / 4;
    Mid9Pnts( 8, : ) = ( Pnts( 5, : ) + Pnts( 8, : ) ) / 2;
    Mid9Pnts( 9, : ) = ( Pnts( 5, : ) + Pnts( 6, : ) + Pnts( 8, : ) + Pnts( 9, : ) ) / 4;

end