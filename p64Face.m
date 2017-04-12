function tmpMidCrdnt = p64Face( MidPntsCrdnt )

    tmpMidCrdnt = zeros(5, 3);
    tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 2, :) )';
    tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(2, 1, :) )';
    tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(2, 2, :) )';
    tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(2, 5, :) )';
    tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(3, 2, :) )';

end