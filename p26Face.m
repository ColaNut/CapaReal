function tmpMidCrdnt = p26Face( MidPntsCrdnt )

    tmpMidCrdnt = zeros(5, 3);
    tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 1, :) )';
    tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(2, 4, :) )';
    tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(2, 1, :) )';
    tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(2, 2, :) )';
    tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(3, 1, :) )';

end