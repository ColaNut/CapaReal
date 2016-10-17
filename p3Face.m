function [ tmpMidCrdnt ] = p3Face( MidPntsCrdnt )

    tmpMidCrdnt(1, 1, :) = MidPntsCrdnt(1, 3, :);
    tmpMidCrdnt(1, 2, :) = MidPntsCrdnt(1, 2, :);
    tmpMidCrdnt(1, 3, :) = MidPntsCrdnt(1, 1, :);
    tmpMidCrdnt(1, 4, :) = MidPntsCrdnt(1, 6, :);
    tmpMidCrdnt(1, 5, :) = MidPntsCrdnt(1, 5, :);
    tmpMidCrdnt(1, 6, :) = MidPntsCrdnt(1, 4, :);
    tmpMidCrdnt(1, 7, :) = MidPntsCrdnt(1, 9, :);
    tmpMidCrdnt(1, 8, :) = MidPntsCrdnt(1, 8, :);
    tmpMidCrdnt(1, 9, :) = MidPntsCrdnt(1, 7, :);

end