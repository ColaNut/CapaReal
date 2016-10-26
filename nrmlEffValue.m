function [ effValue, sideEffect ] = nrmlEffValue( MidPntsCrdnt, tmpMidLyr, pxCrdt, medValue )

effValue    = 0;
sideEffect  = zeros(1, 4);
TriVec      = zeros(8, 3);
u           = zeros(5, 3);
% u = ( pxCrdt - p0Crdt ) ./ norm( pxCrdt - p0Crdt );

    TriVec(1, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :) );
    TriVec(2, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :) );
    TriVec(3, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :) );
    TriVec(4, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :) );
    TriVec(5, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :) );
    TriVec(6, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :) );
    TriVec(7, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :) );
    TriVec(8, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :) );

    u(1, :) = ( tmpMidLyr(6, :) - tmpMidLyr(5, :) ) ./ ( norm( tmpMidLyr(6, :) - tmpMidLyr(5, :) ) )^2;
    u(2, :) = ( tmpMidLyr(8, :) - tmpMidLyr(5, :) ) ./ ( norm( tmpMidLyr(8, :) - tmpMidLyr(5, :) ) )^2;
    u(3, :) = ( tmpMidLyr(4, :) - tmpMidLyr(5, :) ) ./ ( norm( tmpMidLyr(4, :) - tmpMidLyr(5, :) ) )^2;
    u(4, :) = ( tmpMidLyr(2, :) - tmpMidLyr(5, :) ) ./ ( norm( tmpMidLyr(2, :) - tmpMidLyr(5, :) ) )^2;
    u(5, :) = ( pxCrdt' - tmpMidLyr(5, :) ) ./ ( norm( pxCrdt' - tmpMidLyr(5, :) ) )^2;

% effValue = effArea / distance;

sideEffect(1) = medValue * ( TriVec(1, :) + TriVec(2, :) + TriVec(7, :) + TriVec(8, :) ) * u(1, :)';
sideEffect(2) = medValue * ( TriVec(1, :) + TriVec(2, :) + TriVec(3, :) + TriVec(4, :) ) * u(2, :)';
sideEffect(3) = medValue * ( TriVec(3, :) + TriVec(4, :) + TriVec(5, :) + TriVec(6, :) ) * u(3, :)';
sideEffect(4) = medValue * ( TriVec(5, :) + TriVec(6, :) + TriVec(7, :) + TriVec(8, :) ) * u(4, :)';

effValue = medValue * sum( TriVec * u(5, :)' );

end