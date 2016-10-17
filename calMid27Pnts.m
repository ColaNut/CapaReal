function [ MidPntsCrdnt ] = calMid27Pnts( PntsCrdnt )
    MidPntsCrdnt = zeros( 3, 9, 3 );

    MidPntsCrdnt( 1, :, : ) = calMid9Pnts( PntsCrdnt(1: 2, :, :) );
    MidPntsCrdnt( 2, :, : ) = calMid9PntsB( squeeze( PntsCrdnt(2, :, :) ) );
    MidPntsCrdnt( 3, :, : ) = calMid9Pnts( PntsCrdnt(2: 3, :, :) );

end