function PntSigmaE = getSigmaE( Phi27, PntsCrdnt, PntSegMed, sigma, varargin )

    modSigma = sigma;
    nVarargs = length(varargin);
    if nVarargs == 1 
        Epsilon = varargin{1};
        modSigma = Epsilon + sigma;
    end


    PntSigmaE = zeros(6, 8, 3);

    PntSigmaE(1, :, :) = calPntSigmaE( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(1, :), Phi27(3, :), Phi27(2, 5), modSigma );
    % p2
    tmpMidCrdnt = p2Face( PntsCrdnt );
    tmpMidPhi   = p2FaceMidPhi( Phi27 );
    PntSigmaE(2, :, :) = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(2, :), tmpMidPhi, Phi27(2, 5), modSigma );

    % p3
    tmpMidCrdnt = p3Face( PntsCrdnt );
    tmpMidPhi   = p3FaceMidPhi( Phi27 );
    PntSigmaE(3, :, :) = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(3, :), tmpMidPhi, Phi27(2, 5), modSigma );

    % p4
    tmpMidCrdnt = p4Face( PntsCrdnt );
    tmpMidPhi   = p4FaceMidPhi( Phi27 );
    PntSigmaE(4, :, :) = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(4, :), tmpMidPhi, Phi27(2, 5), modSigma );

    % p5
    tmpMidCrdnt = p5Face( PntsCrdnt );
    tmpMidPhi   = p5FaceMidPhi( Phi27 );
    PntSigmaE(5, :, :) = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(5, :), tmpMidPhi, Phi27(2, 5), modSigma );

    % p6
    tmpMidCrdnt = p6Face( PntsCrdnt );
    tmpMidPhi   = p6FaceMidPhi( Phi27 );
    PntSigmaE(6, :, :) = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(6, :), tmpMidPhi, Phi27(2, 5), modSigma );

end