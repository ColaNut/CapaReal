function [ shiftedCoordinate ] = constructCoordinateXYZ( GridShiftTable, paras, dx, dy, dz )

h_torso = paras(1);
air_x = paras(2);
air_z = paras(3);

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);
z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% construct shifted coordinate
shiftedCoordinate = zeros( length(x_grid), length(y_grid), length(z_grid), 3 );

[ X_grid, Y_grid, Z_grid ] = meshgrid( y_grid, x_grid, z_grid );
shiftedCoordinate(:, :, :, 1) = Y_grid;
shiftedCoordinate(:, :, :, 2) = X_grid;
shiftedCoordinate(:, :, :, 3) = Z_grid;

lx = length(x_grid);
ly = length(y_grid);
lz = length(z_grid);

for x_idx = 1: 1: lx
    for y_idx = 1: 1: ly
        for z_idx = 1: 1: lz
            try
            if ~isempty(GridShiftTable{ x_idx, y_idx, z_idx })
                table_value = GridShiftTable{ x_idx, y_idx, z_idx };
                if table_value(1) == 1
                    shiftedCoordinate( x_idx, y_idx, z_idx, 1 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 1 ) + table_value(2);
                elseif table_value(1) == 2
                    shiftedCoordinate( x_idx, y_idx, z_idx, 3 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 3 ) + table_value(2);
                elseif table_value(1) == 3
                    shiftedCoordinate( x_idx, y_idx, z_idx, 2 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 2 ) + table_value(2);
                else
                    error('invalid direction');
                end
            end
            catch
                IDX = [ x_idx, y_idx, z_idx ]
                sizeofGrid = size(GridShiftTable)
            end
        end
    end
end

end