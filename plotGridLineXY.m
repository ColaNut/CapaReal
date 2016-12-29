function plotGridLineXY( shiftedCoordinateXYZ, ell )

    shiftedCoordinateXY = squeeze( shiftedCoordinateXYZ(:, :, ell, :) );

    shiftedCoordinateXY(:, :, 3) = [];

    mmax = 0;
    mmax = size(shiftedCoordinateXY, 1);
    nmax = 0;
    nmax = size(shiftedCoordinateXY, 2);

    for idx = 1: 1: mmax
        plot( 100* shiftedCoordinateXY(idx, :, 1), 100* shiftedCoordinateXY(idx, :, 2) );
    end

    for idx = 1: 1: nmax
        plot( 100* shiftedCoordinateXY(:, idx, 1), 100* shiftedCoordinateXY(:, idx, 2) );
    end

end