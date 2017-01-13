function XZBls9Med = XZFace9Med( m, ell, BlsBndryMsk, QuadrantNum )
    XZBls9Med = zeros(9, 1);

    if QuadrantNum == 2
        XZBls9Med(1) = BlsBndryMsk( m - 1, ell - 1 );
        XZBls9Med(2) = BlsBndryMsk( m    , ell - 1 );
        XZBls9Med(3) = BlsBndryMsk( m + 1, ell - 1 );
        XZBls9Med(4) = BlsBndryMsk( m - 1, ell     );
        XZBls9Med(5) = BlsBndryMsk( m    , ell     );
        XZBls9Med(6) = BlsBndryMsk( m + 1, ell     );
        XZBls9Med(7) = BlsBndryMsk( m - 1, ell + 1 );
        XZBls9Med(8) = BlsBndryMsk( m    , ell + 1 );
        XZBls9Med(9) = BlsBndryMsk( m + 1, ell + 1 );
    elseif QuadrantNum == 1
        XZBls9Med(1) = BlsBndryMsk( m + 1, ell - 1 );
        XZBls9Med(2) = BlsBndryMsk( m    , ell - 1 );
        XZBls9Med(3) = BlsBndryMsk( m - 1, ell - 1 );
        XZBls9Med(4) = BlsBndryMsk( m + 1, ell     );
        XZBls9Med(5) = BlsBndryMsk( m    , ell     );
        XZBls9Med(6) = BlsBndryMsk( m - 1, ell     );
        XZBls9Med(7) = BlsBndryMsk( m + 1, ell + 1 );
        XZBls9Med(8) = BlsBndryMsk( m    , ell + 1 );
        XZBls9Med(9) = BlsBndryMsk( m - 1, ell + 1 );
    elseif QuadrantNum == 3
        XZBls9Med(1) = BlsBndryMsk( m - 1, ell + 1 );
        XZBls9Med(2) = BlsBndryMsk( m    , ell + 1 );
        XZBls9Med(3) = BlsBndryMsk( m + 1, ell + 1 );
        XZBls9Med(4) = BlsBndryMsk( m - 1, ell     );
        XZBls9Med(5) = BlsBndryMsk( m    , ell     );
        XZBls9Med(6) = BlsBndryMsk( m + 1, ell     );
        XZBls9Med(7) = BlsBndryMsk( m - 1, ell - 1 );
        XZBls9Med(8) = BlsBndryMsk( m    , ell - 1 );
        XZBls9Med(9) = BlsBndryMsk( m + 1, ell - 1 );
    elseif QuadrantNum == 4
        XZBls9Med(1) = BlsBndryMsk( m + 1, ell + 1 );
        XZBls9Med(2) = BlsBndryMsk( m    , ell + 1 );
        XZBls9Med(3) = BlsBndryMsk( m - 1, ell + 1 );
        XZBls9Med(4) = BlsBndryMsk( m + 1, ell     );
        XZBls9Med(5) = BlsBndryMsk( m    , ell     );
        XZBls9Med(6) = BlsBndryMsk( m - 1, ell     );
        XZBls9Med(7) = BlsBndryMsk( m + 1, ell - 1 );
        XZBls9Med(8) = BlsBndryMsk( m    , ell - 1 );
        XZBls9Med(9) = BlsBndryMsk( m - 1, ell - 1 );
    end
    
end