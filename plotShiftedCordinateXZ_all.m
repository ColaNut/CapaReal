function plotShiftedCordinateXZ_all( shiftedCoordinate )

for idx = 1: 1: size(shiftedCoordinate, 2)
    scatter( shiftedCoordinate(:, idx, 1 ), shiftedCoordinate(:, idx, 2 ), 'k', 'filled', 'LineWidth', 1.5 );
    hold on;
end

end