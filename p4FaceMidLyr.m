function [ tmpMidLyr ] = p4FaceMidLyr( PntsCrdnt )

    tmpMidLyr = zeros(9, 3);

    tmpMidLyr(1, :) = squeeze( PntsCrdnt(1, 2, :));
    tmpMidLyr(2, :) = squeeze( PntsCrdnt(1, 5, :));
    tmpMidLyr(3, :) = squeeze( PntsCrdnt(1, 8, :));
    tmpMidLyr(4, :) = squeeze( PntsCrdnt(2, 2, :));
    tmpMidLyr(5, :) = squeeze( PntsCrdnt(2, 5, :));
    tmpMidLyr(6, :) = squeeze( PntsCrdnt(2, 8, :));
    tmpMidLyr(7, :) = squeeze( PntsCrdnt(3, 2, :));
    tmpMidLyr(8, :) = squeeze( PntsCrdnt(3, 5, :));
    tmpMidLyr(9, :) = squeeze( PntsCrdnt(3, 8, :));

end