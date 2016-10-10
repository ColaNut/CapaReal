function plot3ShiftedCoordinate( shiftedCoordinate, h_torso, dy );

len_sc = length( shiftedCoordinate );
for ext_idx = 1: 1: len_sc
    y = - h_torso / 2 + (ext_idx - 1) * dy;
    shiftedCoordinateXZ = shiftedCoordinate{ext_idx};
    for idx = 1: 1: size(shiftedCoordinateXZ, 2)
        scatter3( shiftedCoordinateXZ(:, idx, 1 ), shiftedCoordinateXZ(:, idx, 2 ), ...
            ones(size(shiftedCoordinateXZ(:, idx, 1))) * y, 10, 'k', 'filled' );
        plot3( shiftedCoordinateXZ(:, idx, 1 ), shiftedCoordinateXZ(:, idx, 2 ), ...
            ones(size(shiftedCoordinateXZ(:, idx, 1))) * y, 'k', 'LineWidth', 0.5 );
        hold on;
    end

    for idx = 1: 1: size(shiftedCoordinateXZ, 1)
        plot3( shiftedCoordinateXZ(idx, :, 1 ), shiftedCoordinateXZ(idx, :, 2 ), ...
            ones(size(shiftedCoordinateXZ(idx, :, 1))) * y, 'k', 'LineWidth', 0.5 );
        hold on;
    end
end

end