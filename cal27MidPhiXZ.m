function [ MidPhi ] = cal27MidPhiXZ( m, n, ell, PhiHlfY, ThrMedValue )

    Phi    = zeros( 3, 9 );
    MidPhi = zeros( 3, 9 );

    Phi = get27Phi( m, n, ell, PhiHlfY );

    MidPhi( 1, : ) = calMid9Phi( Phi(1: 2, :) );
    MidPhi( 2, : ) = calMid9PhiB( squeeze( Phi(2, :) ) );
    MidPhi( 3, : ) = calMid9Phi( Phi(2: 3, :) );

    % a modification of 2d case: crude version
    Med9 = zeros(1, 9, 'uint8');
    Med9 = [ ThrMedValue(m - 1, n, ell - 1), ThrMedValue(m, n, ell - 1), ThrMedValue(m + 1, n, ell - 1), ...
             ThrMedValue(m - 1, n, ell    ), ThrMedValue(m, n, ell    ), ThrMedValue(m + 1, n, ell    ), ...
             ThrMedValue(m - 1, n, ell + 1), ThrMedValue(m, n, ell + 1), ThrMedValue(m + 1, n, ell + 1) ];
    if Med9(5) >= 10
        if length( find(Med9 == Med9(5)) ) ~= 3
            Med9;
            [m, n, ell];
        end
    end

    if Med9(1) == Med9(5) && Med9(5) >= 10
        MidPhi(1, 1) = ( Phi(2, 2) + Phi(1, 1) ) / 2;
        MidPhi(1, 4) = ( Phi(2, 5) + Phi(1, 4) ) / 2;
        MidPhi(1, 7) = ( Phi(2, 8) + Phi(1, 7) ) / 2;
    end
    if Med9(3) == Med9(5) && Med9(5) >= 10
        MidPhi(1, 3) = ( Phi(2, 2) + Phi(1, 3) ) / 2;
        MidPhi(1, 6) = ( Phi(2, 5) + Phi(1, 6) ) / 2;
        MidPhi(1, 9) = ( Phi(2, 8) + Phi(1, 9) ) / 2;
    end
    if Med9(7) == Med9(5) && Med9(5) >= 10
        MidPhi(3, 1) = ( Phi(2, 2) + Phi(3, 1) ) / 2;
        MidPhi(3, 4) = ( Phi(2, 5) + Phi(3, 4) ) / 2;
        MidPhi(3, 7) = ( Phi(2, 8) + Phi(3, 7) ) / 2;
    end
    if Med9(9) == Med9(5) && Med9(5) >= 10
        MidPhi(3, 3) = ( Phi(2, 2) + Phi(3, 3) ) / 2;
        MidPhi(3, 6) = ( Phi(2, 5) + Phi(3, 6) ) / 2;
        MidPhi(3, 9) = ( Phi(2, 8) + Phi(3, 9) ) / 2;
    end

    if Med9(2) == Med9(4) && Med9(2) >= 10
        MidPhi(1, 1) = ( Phi(1, 2) + Phi(2, 1) ) / 2;
        MidPhi(1, 4) = ( Phi(1, 5) + Phi(2, 4) ) / 2;
        MidPhi(1, 7) = ( Phi(1, 8) + Phi(2, 7) ) / 2;
    end
    if Med9(2) == Med9(6) && Med9(2) >= 10
        MidPhi(1, 3) = ( Phi(1, 2) + Phi(2, 3) ) / 2;
        MidPhi(1, 6) = ( Phi(1, 5) + Phi(2, 6) ) / 2;
        MidPhi(1, 9) = ( Phi(1, 8) + Phi(2, 9) ) / 2;
    end
    if Med9(4) == Med9(8) && Med9(8) >= 10
        MidPhi(3, 1) = ( Phi(3, 2) + Phi(2, 1) ) / 2;
        MidPhi(3, 4) = ( Phi(3, 5) + Phi(2, 4) ) / 2;
        MidPhi(3, 7) = ( Phi(3, 8) + Phi(2, 7) ) / 2;
    end
    if Med9(6) == Med9(8) && Med9(8) >= 10
        MidPhi(3, 3) = ( Phi(3, 2) + Phi(2, 3) ) / 2;
        MidPhi(3, 6) = ( Phi(3, 5) + Phi(2, 6) ) / 2;
        MidPhi(3, 9) = ( Phi(3, 8) + Phi(2, 9) ) / 2;
    end

end