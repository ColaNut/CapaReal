function [ tmpMidPhi ] = p5FaceMidPhi( MidPhi )

    tmpMidPhi(1) = MidPhi(1, 9);
    tmpMidPhi(2) = MidPhi(1, 8);
    tmpMidPhi(3) = MidPhi(1, 7);
    tmpMidPhi(4) = MidPhi(2, 9);
    tmpMidPhi(5) = MidPhi(2, 8);
    tmpMidPhi(6) = MidPhi(2, 7);
    tmpMidPhi(7) = MidPhi(3, 9);
    tmpMidPhi(8) = MidPhi(3, 8);
    tmpMidPhi(9) = MidPhi(3, 7);

end