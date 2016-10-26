function [ tmpMidLyr ] = p1FaceMidLyr( PntsCrdnt )

    tmpMidLyr = zeros(9, 3);

    tmpMidLyr(1, :) = squeeze( PntsCrdnt(2, 1, :));
    tmpMidLyr(2, :) = squeeze( PntsCrdnt(2, 2, :));
    tmpMidLyr(3, :) = squeeze( PntsCrdnt(2, 3, :));
    tmpMidLyr(4, :) = squeeze( PntsCrdnt(2, 4, :));
    tmpMidLyr(5, :) = squeeze( PntsCrdnt(2, 5, :));
    tmpMidLyr(6, :) = squeeze( PntsCrdnt(2, 6, :));
    tmpMidLyr(7, :) = squeeze( PntsCrdnt(2, 7, :));
    tmpMidLyr(8, :) = squeeze( PntsCrdnt(2, 8, :));
    tmpMidLyr(9, :) = squeeze( PntsCrdnt(2, 9, :));

end