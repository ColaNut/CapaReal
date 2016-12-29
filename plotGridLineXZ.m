function plotGridLineXZ( shiftedCoordinateXYZ, n )

    shiftedCoordinateXZ = squeeze( shiftedCoordinateXYZ(:, n, :, :) );

    shiftedCoordinateXZ(:, :, 2) = [];

    mmax = 0;
    mmax = size(shiftedCoordinateXZ, 1);
    ellmax = 0;
    ellmax = size(shiftedCoordinateXZ, 2);

    for idx = 1: 1: mmax
        plot( 100* shiftedCoordinateXZ(idx, :, 1), 100* shiftedCoordinateXZ(idx, :, 2) );
    end

    for idx = 1: 1: ellmax
        plot( 100* shiftedCoordinateXZ(:, idx, 1), 100* shiftedCoordinateXZ(:, idx, 2) );
    end

end