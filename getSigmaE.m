function [ PntSigmaE, PntQ_s ] = getSigmaE( Phi27, PntsCrdnt, PntSegMed, sigma, Epsilon )

    % modSigma = sigma;
    % nVarargs = length(varargin);
    % if nVarargs == 1 
    %     Epsilon = varargin{1};
    %     modSigma = Epsilon + sigma;
    % end

    PntSigmaE = zeros(6, 8, 3);
    PntQ_s    = zeros(6, 8);

    [ PntSigmaE(1, :, :), PntQ_s(1, :) ] = calPntSigmaE( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(1, :), Phi27(3, :), Phi27(2, 5), sigma, Epsilon );
    % p2
    tmpMidCrdnt = p2Face( PntsCrdnt );
    tmpMidPhi   = p2FaceMidPhi( Phi27 );
    [ PntSigmaE(2, :, :), PntQ_s(2, :) ] = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(2, :), tmpMidPhi, Phi27(2, 5), sigma, Epsilon );

    % p3
    tmpMidCrdnt = p3Face( PntsCrdnt );
    tmpMidPhi   = p3FaceMidPhi( Phi27 );
    [ PntSigmaE(3, :, :), PntQ_s(3, :) ] = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(3, :), tmpMidPhi, Phi27(2, 5), sigma, Epsilon );

    % p4
    tmpMidCrdnt = p4Face( PntsCrdnt );
    tmpMidPhi   = p4FaceMidPhi( Phi27 );
    [ PntSigmaE(4, :, :), PntQ_s(4, :) ] = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(4, :), tmpMidPhi, Phi27(2, 5), sigma, Epsilon );

    % p5
    tmpMidCrdnt = p5Face( PntsCrdnt );
    tmpMidPhi   = p5FaceMidPhi( Phi27 );
    [ PntSigmaE(5, :, :), PntQ_s(5, :) ] = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(5, :), tmpMidPhi, Phi27(2, 5), sigma, Epsilon );

    % p6
    tmpMidCrdnt = p6Face( PntsCrdnt );
    tmpMidPhi   = p6FaceMidPhi( Phi27 );
    [ PntSigmaE(6, :, :), PntQ_s(6, :) ] = calPntSigmaE( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                                PntSegMed(6, :), tmpMidPhi, Phi27(2, 5), sigma, Epsilon );

end