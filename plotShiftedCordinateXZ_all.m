function plotShiftedCordinateXZ_all( shiftedCoordinate )

for idx = 1: 1: size(shiftedCoordinate, 2)
    scatter( shiftedCoordinate(:, idx, 1 ), shiftedCoordinate(:, idx, 2 ), 10, 'k', 'filled' );
    plot( shiftedCoordinate(:, idx, 1 ), shiftedCoordinate(:, idx, 2 ), 'k', 'LineWidth', 0.5 );
    hold on;
end

for idx = 1: 1: size(shiftedCoordinate, 1)
    plot( shiftedCoordinate(idx, :, 1 ), shiftedCoordinate(idx, :, 2 ), 'k', 'LineWidth', 0.5 );
    hold on;
end

end