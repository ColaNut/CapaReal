function [ tmpMidCrdnt ] = p5Face( MidPntsCrdnt )

    tmpMidCrdnt(1, 1, :) = MidPntsCrdnt(1, 9, :);
    tmpMidCrdnt(1, 2, :) = MidPntsCrdnt(1, 8, :);
    tmpMidCrdnt(1, 3, :) = MidPntsCrdnt(1, 7, :);
    tmpMidCrdnt(1, 4, :) = MidPntsCrdnt(2, 9, :);
    tmpMidCrdnt(1, 5, :) = MidPntsCrdnt(2, 8, :);
    tmpMidCrdnt(1, 6, :) = MidPntsCrdnt(2, 7, :);
    tmpMidCrdnt(1, 7, :) = MidPntsCrdnt(3, 9, :);
    tmpMidCrdnt(1, 8, :) = MidPntsCrdnt(3, 8, :);
    tmpMidCrdnt(1, 9, :) = MidPntsCrdnt(3, 7, :);

end