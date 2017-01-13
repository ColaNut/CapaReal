function SegMed = PreCalSegMed( m, ell, PntsCrdnt, BlsBndryMsk )
    SegMed = ones( 6, 8, 'uint8' );

    % second quadrant 
    if PntsCrdnt(2, 5, 1) <= 0 && PntsCrdnt(2, 5, 3) >= 0
        XZBls9Med = XZFace9Med( m, ell, BlsBndryMsk, 2 );
        SegMed = ScndQdrt(XZBls9Med);
        SegMed = RecoverSegMed(SegMed, 2);
        return;
    end

    % first quadrant
    if PntsCrdnt(2, 5, 1) >= 0 && PntsCrdnt(2, 5, 3) >= 0
        XZBls9Med = XZFace9Med( m, ell, BlsBndryMsk, 1 );
        SegMed = ScndQdrt(XZBls9Med);
        SegMed = RecoverSegMed(SegMed, 1);
        return;
    end

    % third quadrant
    if PntsCrdnt(2, 5, 1) <= 0 && PntsCrdnt(2, 5, 3) <= 0
        XZBls9Med = XZFace9Med( m, ell, BlsBndryMsk, 3 );
        SegMed = ScndQdrt(XZBls9Med);
        SegMed = RecoverSegMed(SegMed, 3);
        return;
    end

    % first quadrant
    if PntsCrdnt(2, 5, 1) >= 0 && PntsCrdnt(2, 5, 3) <= 0
        XZBls9Med = XZFace9Med( m, ell, BlsBndryMsk, 4 );
        SegMed = ScndQdrt(XZBls9Med);
        SegMed = RecoverSegMed(SegMed, 4);
        return;
    end
end