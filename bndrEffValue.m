function [ effValue, SegMed, sideEffect ] = bndrEffValue( MidPntsCrdnt, tmpMidLyr, pxCrdt, tmpMed2Layers, epsilon_r )

effValue    = 0;
sideEffect  = zeros(1, 4);
TriVec      = zeros(8, 3);
u           = zeros(5, 3);
wghtTri     = zeros(8, 3);
SegMed      = ones(1, 8, 'uint8');
weight      = zeros(8, 1);
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

[ weight, SegMed ] = calWeight( tmpMed2Layers, epsilon_r );
wghtTri = repmat(weight, 1, 3) .* TriVec;

% [ 1, 2, 3, 4 ] = [ right, up, left, down ];
sideEffect(1) = ( wghtTri(1, :) + wghtTri(2, :) + wghtTri(7, :) + wghtTri(8, :) ) * u(1, :)';
sideEffect(2) = ( wghtTri(1, :) + wghtTri(2, :) + wghtTri(3, :) + wghtTri(4, :) ) * u(2, :)';
sideEffect(3) = ( wghtTri(3, :) + wghtTri(4, :) + wghtTri(5, :) + wghtTri(6, :) ) * u(3, :)';
sideEffect(4) = ( wghtTri(5, :) + wghtTri(6, :) + wghtTri(7, :) + wghtTri(8, :) ) * u(4, :)';

effValue = sum( wghtTri * u(5, :)' );

end