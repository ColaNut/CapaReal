function MidPnts9Crdnt = getMidPnts9CrdntXY( MidPntsCrdnt )

    MidPnts9Crdnt = zeros(9, 3);

    MidPnts9Crdnt(1, :) = MidPntsCrdnt(2, 1, :);
    MidPnts9Crdnt(2, :) = MidPntsCrdnt(2, 2, :);
    MidPnts9Crdnt(3, :) = MidPntsCrdnt(2, 3, :);
    MidPnts9Crdnt(4, :) = MidPntsCrdnt(2, 4, :);
    MidPnts9Crdnt(5, :) = MidPntsCrdnt(2, 5, :);
    MidPnts9Crdnt(6, :) = MidPntsCrdnt(2, 6, :);
    MidPnts9Crdnt(7, :) = MidPntsCrdnt(2, 7, :);
    MidPnts9Crdnt(8, :) = MidPntsCrdnt(2, 8, :);
    MidPnts9Crdnt(9, :) = MidPntsCrdnt(2, 9, :);

end