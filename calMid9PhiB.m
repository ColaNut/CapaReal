function [ Mid9Phi ] = calMid9PhiB( Phi2 )

    Mid9Phi = zeros( 1, 9 );
    % Phi2 means: TwoLyrPhi

    Mid9Phi(1) = ( Phi2(1) + Phi2(2) + Phi2(4) + Phi2(5) ) / 4;
    Mid9Phi(2) = ( Phi2(2) + Phi2(5) ) / 2;
    Mid9Phi(3) = ( Phi2(2) + Phi2(3) + Phi2(5) + Phi2(6) ) / 4;
    Mid9Phi(4) = ( Phi2(4) + Phi2(5) ) / 2;
    Mid9Phi(5) =   Phi2(5);
    Mid9Phi(6) = ( Phi2(5) + Phi2(6) ) / 2;
    Mid9Phi(7) = ( Phi2(4) + Phi2(5) + Phi2(7) + Phi2(8) ) / 4;
    Mid9Phi(8) = ( Phi2(5) + Phi2(8) ) / 2;
    Mid9Phi(9) = ( Phi2(5) + Phi2(6) + Phi2(8) + Phi2(9) ) / 4;

end