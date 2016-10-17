function [ GridShiftTableXZ, mediumTable ] = constructCoordinateXZ_all( paras2d, dx, dz, mediumTable )

% fill the GridTable
[ x_grid_table, z_grid_table ] = fillGridTableXZ_all( paras2d, dx, dz );

% construct the GridShiftTableXZ
air_x = paras2d(1);
air_z = paras2d(2);
% medimTable = false( air_x / dx + 1, air_z / dz  + 1);
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );

[ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXZ_all( x_grid_table, z_grid_table, air_x, air_z, dx, dz, mediumTable );

% % construct shifted coordinate
% shiftedCoordinateXZ = zeros( size(GridShiftTableXZ, 1), size(GridShiftTableXZ, 2), 2 );

% x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);
% [ X_grid, Y_grid ] = meshgrid(x_grid, z_grid);
% shiftedCoordinateXZ(:, :, 1) = X_grid';
% shiftedCoordinateXZ(:, :, 2) = Y_grid';

% lx = length(x_grid);
% lz = length(z_grid);

% for x_idx = 1: 1: lx
%     for z_idx = 1: 1: lz
%         if ~isempty(GridShiftTableXZ{ x_idx, z_idx })
%             table_value = GridShiftTableXZ{ x_idx, z_idx };
%             if table_value(1) == 1
%                 shiftedCoordinateXZ( x_idx, z_idx, 1 ) = shiftedCoordinateXZ( x_idx, z_idx, 1 ) + table_value(2);
%             elseif table_value(1) == 2
%                 shiftedCoordinateXZ( x_idx, z_idx, 2 ) = shiftedCoordinateXZ( x_idx, z_idx, 2 ) + table_value(2);
%             else
%                 error('invalid direction');
%             end
%         end
%     end
% end

end