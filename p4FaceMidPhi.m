function [ tmpMidPhi ] = p4FaceMidPhi( MidPhi )

    tmpMidPhi(1) = MidPhi(1, 3);
    tmpMidPhi(2) = MidPhi(1, 6);
    tmpMidPhi(3) = MidPhi(1, 9);
    tmpMidPhi(4) = MidPhi(2, 3);
    tmpMidPhi(5) = MidPhi(2, 6);
    tmpMidPhi(6) = MidPhi(2, 9);
    tmpMidPhi(7) = MidPhi(3, 3);
    tmpMidPhi(8) = MidPhi(3, 6);
    tmpMidPhi(9) = MidPhi(3, 9);

end