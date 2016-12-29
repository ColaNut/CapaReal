function plotGridLineYZ( shiftedCoordinateXYZ, m )

    shiftedCoordinateYZ = squeeze( shiftedCoordinateXYZ(m, :, :, :) );

    shiftedCoordinateYZ(:, :, 1) = [];

    nmax = 0;
    nmax = size(shiftedCoordinateYZ, 1);
    ellmax = 0;
    ellmax = size(shiftedCoordinateYZ, 2);

    for idx = 1: 1: nmax
        plot( 100* shiftedCoordinateYZ(idx, :, 1), 100* shiftedCoordinateYZ(idx, :, 2) );
    end

    for idx = 1: 1: ellmax
        plot( 100* shiftedCoordinateYZ(:, idx, 1), 100* shiftedCoordinateYZ(:, idx, 2) );
    end

end