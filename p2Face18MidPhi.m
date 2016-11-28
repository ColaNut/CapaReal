function [ tmpMidPhi ] = p2Face18MidPhi( MidPhi )

    tmpMidPhi = zeros(2, 9); 

    tmpMidPhi(1, 1) = MidPhi(1, 7);
    tmpMidPhi(1, 2) = MidPhi(1, 4);
    tmpMidPhi(1, 3) = MidPhi(1, 1);
    tmpMidPhi(1, 4) = MidPhi(2, 7);
    tmpMidPhi(1, 5) = MidPhi(2, 4);
    tmpMidPhi(1, 6) = MidPhi(2, 1);
    tmpMidPhi(1, 7) = MidPhi(3, 7);
    tmpMidPhi(1, 8) = MidPhi(3, 4);
    tmpMidPhi(1, 9) = MidPhi(3, 1);

    tmpMidPhi(2, 1) = MidPhi(1, 8);
    tmpMidPhi(2, 2) = MidPhi(1, 5);
    tmpMidPhi(2, 3) = MidPhi(1, 2);
    tmpMidPhi(2, 4) = MidPhi(2, 8);
    tmpMidPhi(2, 5) = MidPhi(2, 5);
    tmpMidPhi(2, 6) = MidPhi(2, 2);
    tmpMidPhi(2, 7) = MidPhi(3, 8);
    tmpMidPhi(2, 8) = MidPhi(3, 5);
    tmpMidPhi(2, 9) = MidPhi(3, 2);

end