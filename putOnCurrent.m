function [ PntSegMed, PntCurrent ] = putOnCurrent(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, J_0 )

    CoordinateXZ = squeeze( shiftedCoordinateXYZ(:, n, :, [1, 3]) ); 
    mediumTableXZ = squeeze( mediumTable(:, n, :) );
    PntSegMed = ones(6, 8, 'uint8');
    PntCurrent = zeros(6, 8, 3);
    medIn = uint8(3); % idx of conductor (current sheet)
    Med27Value = zeros(3, 9);
    Med9Value  = zeros(9, 1);
    Med27Value = get27MedValue( m, n, ell, mediumTable );
    Med9Value  = get9Med( Med27Value );

    % map to the second quadrant
    if CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) >= 0 
        % II-quadrant
        PntSegMed = RecoverSegMed( PntSegMed, 2 );
        MedArr = [ Med9Value(6), Med9Value(9), Med9Value(8), Med9Value(7), ...
                        Med9Value(4), Med9Value(1), Med9Value(2), Med9Value(3) ];
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) >= 0 
        % I-quadrant
        PntSegMed = RecoverSegMed( PntSegMed, 1 );
        MedArr = [ Med9Value(4), Med9Value(7), Med9Value(8), Med9Value(9), ...
                        Med9Value(6), Med9Value(3), Med9Value(2), Med9Value(1) ];
    elseif CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) <= 0 
        % III-quadrant
        PntSegMed = RecoverSegMed( PntSegMed, 3 );
        MedArr = [ Med9Value(6), Med9Value(3), Med9Value(2), Med9Value(1), ...
                        Med9Value(4), Med9Value(6), Med9Value(7), Med9Value(8) ];
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) <= 0 
        % IV-quadrant
        PntSegMed = RecoverSegMed( PntSegMed, 4 );
        MedArr = [ Med9Value(4), Med9Value(1), Med9Value(2), Med9Value(3), ...
                        Med9Value(6), Med9Value(9), Med9Value(8), Med9Value(7) ];
    end

    firstMed = find(MedArr == 11, 1);
    lastMed  = find(MedArr == 11, 1, 'last');
    if isempty(firstMed)
        error('Check');
    end
    for idx = firstMed: 1: lastMed - 1
        PntSegMed = UpdtSegMedXZ(PntSegMed, medIn, idx);
    end

    % recover to its original quadrant
    if CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) >= 0 
        PntSegMed = RecoverSegMed( PntSegMed, 2 );
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) >= 0 
        PntSegMed = RecoverSegMed( PntSegMed, 1 );
    elseif CoordinateXZ(m, ell, 1) <= 0 && CoordinateXZ(m, ell, 2) <= 0 
        PntSegMed = RecoverSegMed( PntSegMed, 3 );
    elseif CoordinateXZ(m, ell, 1) >= 0 && CoordinateXZ(m, ell, 2) <= 0 
        PntSegMed = RecoverSegMed( PntSegMed, 4 );
    else
        error('check');
    end

    PntCurrent = getCurrentDir(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, PntSegMed, J_0 );
end