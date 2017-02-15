function SARseg = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, SARseg, mediumTable, medValue, InnOut )
    
    if shiftedCoordinateXYZ(m, n, ell, 1) <= 0 && shiftedCoordinateXYZ(m, n, ell, 3) >= 0 
        Med9    = squeeze( mediumTable(m - 1: m + 1, n, ell - 1: ell + 1) );
    elseif shiftedCoordinateXYZ(m, n, ell, 1) >= 0 && shiftedCoordinateXYZ(m, n, ell, 3) >= 0 
        SARseg = RecoverSegMed(SARseg, 1);
        Med9   = QdrntRt( squeeze( mediumTable(m - 1: m + 1, n, ell - 1: ell + 1) ), '1st' );
    elseif shiftedCoordinateXYZ(m, n, ell, 1) <= 0 && shiftedCoordinateXYZ(m, n, ell, 3) <= 0 
        SARseg = RecoverSegMed(SARseg, 3);
        Med9   = QdrntRt( squeeze( mediumTable(m - 1: m + 1, n, ell - 1: ell + 1) ), '3rd' );
    elseif shiftedCoordinateXYZ(m, n, ell, 1) >= 0 && shiftedCoordinateXYZ(m, n, ell, 3) <= 0 
        SARseg = RecoverSegMed(SARseg, 4);
        Med9   = QdrntRt( squeeze( mediumTable(m - 1: m + 1, n, ell - 1: ell + 1) ), '4th' );
    end

    SARseg = Updating( m, n, ell, SARseg, Med9, medValue, InnOut);

    if shiftedCoordinateXYZ(m, n, ell, 1) <= 0 && shiftedCoordinateXYZ(m, n, ell, 3) >= 0 
        ;
    elseif shiftedCoordinateXYZ(m, n, ell, 1) >= 0 && shiftedCoordinateXYZ(m, n, ell, 3) >= 0 
        SARseg = RecoverSegMed(SARseg, 1);
    elseif shiftedCoordinateXYZ(m, n, ell, 1) <= 0 && shiftedCoordinateXYZ(m, n, ell, 3) <= 0 
        SARseg = RecoverSegMed(SARseg, 3);
    elseif shiftedCoordinateXYZ(m, n, ell, 1) >= 0 && shiftedCoordinateXYZ(m, n, ell, 3) <= 0 
        SARseg = RecoverSegMed(SARseg, 4);
    end

end