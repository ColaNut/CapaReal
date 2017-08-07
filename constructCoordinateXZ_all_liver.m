function [ GridShiftTableXZ, mediumTable ] = constructCoordinateXZ_all_liver( paras2dXZ_liver, dx, dz, mediumTable )

% x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);
% GridShiftTableXZ = cell( length(x_grid), length(z_grid) );

% fill the GridTable
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all_liver( paras2dXZ_liver, dx, dz );

% construct the GridShiftTableXZ
air_x = paras2dXZ_liver(1);
air_z = paras2dXZ_liver(2);
% medimTable = false( air_x / dx + 1, air_z / dz  + 1);
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );

[ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXZ_all_liver( x_grid_table, z_grid_table, air_x, air_z, dx, dz, mediumTable, paras2dXZ_liver );

end