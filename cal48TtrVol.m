function TtrVol = cal48TtrVol( MidPntsCrdnt )
    
    TtrVol = zeros( 6, 8 );

    TtrVol(1, :) = cal8TtrVol( squeeze( MidPntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ) );

    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    TtrVol(2, :) = cal8TtrVol( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    TtrVol(3, :) = cal8TtrVol( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    TtrVol(4, :) = cal8TtrVol( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    TtrVol(5, :) = cal8TtrVol( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    TtrVol(6, :) = cal8TtrVol( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

end