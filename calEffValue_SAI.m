function effValue = calEffValue_SAI( MidPntsCrdnt, CtrlPnt, pxCrdt, medValue )

effValue    = 0;
TriVec      = zeros(8, 3);
u           = zeros(1, 3);
% u = ( pxCrdt - p0Crdt ) ./ norm( pxCrdt - p0Crdt );

    TriVec(1, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :) );
    TriVec(2, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :) );
    TriVec(3, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :) );
    TriVec(4, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :) );
    TriVec(5, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :) );
    TriVec(6, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :) );
    TriVec(7, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :) );
    TriVec(8, :) = calTriVec( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :) );

    u = ( pxCrdt' - CtrlPnt' ) ./ ( norm( pxCrdt' - CtrlPnt' ) )^2;

effValue = medValue' * ( TriVec * u' );

end