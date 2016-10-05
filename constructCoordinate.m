function [ shiftedCoordinate ] = constructCoordinate( GridShiftTable, a, b, dx, dz )

shiftedCoordinate = zeros( size(GridShiftTable, 1), size(GridShiftTable, 2), 2 );
% check for the storage size of cell array and matrix

x_grid = - myCeil(a, dx): dx: myCeil(a, dx);
y_grid = - myCeil(b, dz): dz: myCeil(b, dz);

[ X_grid, Y_grid ] = meshgrid(x_grid, y_grid);
shiftedCoordinate(:, :, 1) = X_grid';
shiftedCoordinate(:, :, 2) = Y_grid';

% shift the grid point to the curve.
for x_idx = 1: 1: 2 * myCeil(a, dx) / dx + 1
    for y_idx = 1: 1: 2 * myCeil(b, dz) / dz + 1
        if ~isempty(GridShiftTable{ x_idx, y_idx })
            table_value = GridShiftTable{ x_idx, y_idx };
            if table_value(1) == 1
                shiftedCoordinate( x_idx, y_idx, 1 ) = shiftedCoordinate( x_idx, y_idx, 1 ) + table_value(2);
            elseif table_value(1) == 2
                shiftedCoordinate( x_idx, y_idx, 2 ) = shiftedCoordinate( x_idx, y_idx, 2 ) + table_value(2);
            else
                error('invalid direction');
            end
        end
    end
end

end