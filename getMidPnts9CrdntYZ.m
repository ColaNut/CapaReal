function MidPnts9Crdnt = getMidPnts9CrdntYZ( MidPntsCrdnt )

    MidPnts9Crdnt = zeros(9, 3);

    MidPnts9Crdnt(1, :) = MidPntsCrdnt(1, 2, :);
    MidPnts9Crdnt(2, :) = MidPntsCrdnt(1, 5, :);
    MidPnts9Crdnt(3, :) = MidPntsCrdnt(1, 8, :);
    MidPnts9Crdnt(4, :) = MidPntsCrdnt(2, 2, :);
    MidPnts9Crdnt(5, :) = MidPntsCrdnt(2, 5, :);
    MidPnts9Crdnt(6, :) = MidPntsCrdnt(2, 8, :);
    MidPnts9Crdnt(7, :) = MidPntsCrdnt(3, 2, :);
    MidPnts9Crdnt(8, :) = MidPntsCrdnt(3, 5, :);
    MidPnts9Crdnt(9, :) = MidPntsCrdnt(3, 8, :);

end