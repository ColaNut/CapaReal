function [ tmpMidPhi ] = p2FaceMidPhi( MidPhi )

    tmpMidPhi(1) = MidPhi(1, 7);
    tmpMidPhi(2) = MidPhi(1, 4);
    tmpMidPhi(3) = MidPhi(1, 1);
    tmpMidPhi(4) = MidPhi(2, 7);
    tmpMidPhi(5) = MidPhi(2, 4);
    tmpMidPhi(6) = MidPhi(2, 1);
    tmpMidPhi(7) = MidPhi(3, 7);
    tmpMidPhi(8) = MidPhi(3, 4);
    tmpMidPhi(9) = MidPhi(3, 1);

end