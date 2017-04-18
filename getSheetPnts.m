function SheetPnts = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable)
    
    SheetPnts = zeros( 3, 3, 3, 'uint8');
    SheetPntsXZ = zeros(9, 1, 'uint8');
    CoordinateXZ = squeeze( shiftedCoordinateXYZ(:, n, :, [1, 3]) ); 
    Med27Value = zeros(3, 9);
    Med9Value  = zeros(9, 1);
    Med27Value = get27MedValue( m, n, ell, mediumTable );
    Med9Value  = get9Med( Med27Value );
    
    if CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) >= 0 
        % II-quadrant
        MedArr = [ Med9Value(6), Med9Value(9), Med9Value(8), Med9Value(7), ...
                        Med9Value(4), Med9Value(1), Med9Value(2), Med9Value(3) ];
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) >= 0 
        % I-quadrant
        MedArr = [ Med9Value(4), Med9Value(7), Med9Value(8), Med9Value(9), ...
                        Med9Value(6), Med9Value(3), Med9Value(2), Med9Value(1) ];
    elseif CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) <= 0 
        % III-quadrant
        MedArr = [ Med9Value(6), Med9Value(3), Med9Value(2), Med9Value(1), ...
                        Med9Value(4), Med9Value(7), Med9Value(8), Med9Value(9) ];
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) <= 0 
        % IV-quadrant
        MedArr = [ Med9Value(4), Med9Value(1), Med9Value(2), Med9Value(3), ...
                        Med9Value(6), Med9Value(9), Med9Value(8), Med9Value(7) ];
    end

    firstMed = find(MedArr == 11, 1);
    lastMed  = find(MedArr == 11, 1, 'last');
    SheetPntsXZ = UpdtSheetPnts(SheetPntsXZ, firstMed);
    SheetPntsXZ = UpdtSheetPnts(SheetPntsXZ, lastMed);
    
    % SheetPnts rotation (local)
    if CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) >= 0 
        SheetPntsXZ = RecoverSheetPntsXZ( SheetPntsXZ, 2 );
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) >= 0 
        SheetPntsXZ = RecoverSheetPntsXZ( SheetPntsXZ, 1 );
    elseif CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) <= 0 
        SheetPntsXZ = RecoverSheetPntsXZ( SheetPntsXZ, 3 );
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) <= 0 
        SheetPntsXZ = RecoverSheetPntsXZ( SheetPntsXZ, 4 );
    else
        error('check');
    end

    SheetPnts(1, :, 1) = SheetPntsXZ(1);
    SheetPnts(2, :, 1) = SheetPntsXZ(2);
    SheetPnts(3, :, 1) = SheetPntsXZ(3);
    SheetPnts(1, :, 2) = SheetPntsXZ(4);
    SheetPnts(2, :, 2) = SheetPntsXZ(5);
    SheetPnts(3, :, 2) = SheetPntsXZ(6);
    SheetPnts(1, :, 3) = SheetPntsXZ(7);
    SheetPnts(2, :, 3) = SheetPntsXZ(8);
    SheetPnts(3, :, 3) = SheetPntsXZ(9);

end