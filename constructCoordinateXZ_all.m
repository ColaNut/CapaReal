function [ GridShiftTableXZ, mediumTable ] = constructCoordinateXZ_all( paras2d, dx, dz, mediumTable )

% x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);
% GridShiftTableXZ = cell( length(x_grid), length(z_grid) );

% fill the GridTable
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all( paras2d, dx, dz );

% construct the GridShiftTableXZ
air_x = paras2d(1);
air_z = paras2d(2);
% medimTable = false( air_x / dx + 1, air_z / dz  + 1);
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );

[ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXZ_all( x_grid_table, z_grid_table, air_x, air_z, dx, dz, mediumTable, paras2d );

end