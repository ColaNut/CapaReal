function [ GridShiftTableXZ, mediumTable ] = constructCoordinateXZ_all_Mag( paras2dXZ_Mag, mediumTable )

% fill the GridTable
x_grid_table = [];
z_grid_table = [];
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all_Mag( paras2dXZ_Mag );

% construct the GridShiftTableXZ
[ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXZ_all_Mag( x_grid_table, z_grid_table, mediumTable, paras2dXZ_Mag );

end