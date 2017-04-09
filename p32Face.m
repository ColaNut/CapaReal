function FaceCrdnt = p32Face( MidPntsCrdnt )

    FaceCrdnt = zeros(5, 3);
    tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 1, :) )';
    tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(1, 5, :) )';
    tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(1, 4, :) )';
    tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(2, 4, :) )';
    tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(1, 7, :) )';

end