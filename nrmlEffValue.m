function [ effValue ] = nrmlEffValue( MidPntsCrdnt, p0Crdt, pxCrdt, medValue )

effValue = 0;
TriArea = zeros(8, 1);
u = ( pxCrdt - p0Crdt ) ./ norm( pxCrdt - p0Crdt );

    TriArea(1) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :), u );
    TriArea(2) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :), u );
    TriArea(3) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :), u );
    TriArea(4) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :), u );
    TriArea(5) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :), u );
    TriArea(6) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :), u );
    TriArea(7) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :), u );
    TriArea(8) = calTriArea( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :), u );

% effValue = effArea / distance;
effValue = medValue * sum( TriArea ) / norm( p0Crdt - pxCrdt );

end