function [ tmpMidCrdnt ] = p4Face18Crdnt( MidPntsCrdnt )

    tmpMidCrdnt = zeros(2, 9, 3); 

    tmpMidCrdnt(1, 1, :) = MidPntsCrdnt(1, 3, :);
    tmpMidCrdnt(1, 2, :) = MidPntsCrdnt(1, 6, :);
    tmpMidCrdnt(1, 3, :) = MidPntsCrdnt(1, 9, :);
    tmpMidCrdnt(1, 4, :) = MidPntsCrdnt(2, 3, :);
    tmpMidCrdnt(1, 5, :) = MidPntsCrdnt(2, 6, :);
    tmpMidCrdnt(1, 6, :) = MidPntsCrdnt(2, 9, :);
    tmpMidCrdnt(1, 7, :) = MidPntsCrdnt(3, 3, :);
    tmpMidCrdnt(1, 8, :) = MidPntsCrdnt(3, 6, :);
    tmpMidCrdnt(1, 9, :) = MidPntsCrdnt(3, 9, :);

    tmpMidCrdnt(2, 1, :) = MidPntsCrdnt(1, 2, :);
    tmpMidCrdnt(2, 2, :) = MidPntsCrdnt(1, 5, :);
    tmpMidCrdnt(2, 3, :) = MidPntsCrdnt(1, 8, :);
    tmpMidCrdnt(2, 4, :) = MidPntsCrdnt(2, 2, :);
    tmpMidCrdnt(2, 5, :) = MidPntsCrdnt(2, 5, :);
    tmpMidCrdnt(2, 6, :) = MidPntsCrdnt(2, 8, :);
    tmpMidCrdnt(2, 7, :) = MidPntsCrdnt(3, 2, :);
    tmpMidCrdnt(2, 8, :) = MidPntsCrdnt(3, 5, :);
    tmpMidCrdnt(2, 9, :) = MidPntsCrdnt(3, 8, :);

end