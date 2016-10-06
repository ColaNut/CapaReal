function [ shiftedCoordinate ] = constructCoordinateXZ_all( paras, dx, dz )

% fill the GridTable
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all( paras, dx, dz );

% construct the GridShiftTable
air_x = paras(1);
air_z = paras(2);
GridShiftTable = constructGridShiftTableXZ_all( x_grid_table, z_grid_table, air_x, air_z, dx, dz );

% construct shifted coordinate
shiftedCoordinate = zeros( size(GridShiftTable, 1), size(GridShiftTable, 2), 2 );

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);
[ X_grid, Y_grid ] = meshgrid(x_grid, z_grid);
shiftedCoordinate(:, :, 1) = X_grid';
shiftedCoordinate(:, :, 2) = Y_grid';

lx = length(x_grid);
lz = length(z_grid);

for x_idx = 1: 1: lx
    for z_idx = 1: 1: lz
        if ~isempty(GridShiftTable{ x_idx, z_idx })
            table_value = GridShiftTable{ x_idx, z_idx };
            if table_value(1) == 1
                shiftedCoordinate( x_idx, z_idx, 1 ) = shiftedCoordinate( x_idx, z_idx, 1 ) + table_value(2);
            elseif table_value(1) == 2
                shiftedCoordinate( x_idx, z_idx, 2 ) = shiftedCoordinate( x_idx, z_idx, 2 ) + table_value(2);
            else
                error('invalid direction');
            end
        end
    end
end

end