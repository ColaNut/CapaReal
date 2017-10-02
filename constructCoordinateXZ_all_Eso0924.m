function [ GridShiftTableXZ, mediumTable ] = constructCoordinateXZ_all_Eso0924( w_x_B, w_z_B, dx_B, dz_B, mediumTable )

% x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);
% GridShiftTableXZ = cell( length(x_grid), length(z_grid) );

% fill the GridTable
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all_Eso( dx_B, dz_B );

% construct the GridShiftTableXZ
% medimTable = false( air_x / dx + 1, air_z / dz  + 1);
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );

[ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXZ_all_Eso( x_grid_table, z_grid_table, w_x_B, w_z_B, dx_B, dz_B, mediumTable );

end