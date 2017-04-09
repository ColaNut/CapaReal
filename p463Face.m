function FaceCrdnt = p463Face( MidPntsCrdnt )

    FaceCrdnt = zeros(7, 3);
    tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 4, :) )';
    tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(1, 1, :) )';
    tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(1, 2, :) )';
    tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(1, 5, :) )';
    tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(2, 1, :) )';
    tmpMidCrdnt(6, :) = squeeze( MidPntsCrdnt(2, 2, :) )';
    tmpMidCrdnt(7, :) = squeeze( MidPntsCrdnt(2, 5, :) )';

end