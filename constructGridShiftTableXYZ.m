function [ GridShiftTableXZ ] = constructGridShiftTableXYZ( GridShiftTableXZ, x_idx, y_grid_table, h_torso, air_z, dy, dz )

% Revise for the following algorithm
% shift the grid point to the curve.
ly = length(y_grid_table);
for idx = 1: 1: ly
    y_grid_table_idx = y_grid_table{idx};
    if y_grid_table_idx(3) ~= 0
        y_idx = int16(y_grid_table_idx(1) / dy + myCeil(h_torso / 2, dy) / dy + 1);
        z_idx = int16(y_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        % note the following line
        tmp_GridShiftTable = GridShiftTableXZ{ y_idx };
        try
            tmp_GridShiftTable_element = tmp_GridShiftTable{x_idx, z_idx};
        catch
            x_idx
            z_idx
        end
        if isempty( tmp_GridShiftTable_element )
            tmp_GridShiftTable{x_idx, z_idx} = [ 3, y_grid_table_idx(3) ];
            GridShiftTableXZ{ y_idx } = tmp_GridShiftTable;
        elseif abs(y_grid_table_idx(3)) < abs(tmp_GridShiftTable_element(2))
            tmp_GridShiftTable{x_idx, z_idx} = [ 3, y_grid_table_idx(3) ];
            GridShiftTableXZ{ y_idx } = tmp_GridShiftTable;
        end
    end

    if y_grid_table_idx(6) ~= 0
        y_idx = int16(y_grid_table_idx(4) / dy + myCeil(h_torso / 2, dy) / dy + 1);
        z_idx = int16(y_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTableXZ{ y_idx };
        tmp_GridShiftTable_element = tmp_GridShiftTable{x_idx, z_idx};
        if isempty( tmp_GridShiftTable_element )
            tmp_GridShiftTable{x_idx, z_idx} = [ 3, y_grid_table_idx(6) ];
            GridShiftTableXZ{ y_idx } = tmp_GridShiftTable;
        elseif abs(y_grid_table_idx(6)) < abs(tmp_GridShiftTable_element(2))
            tmp_GridShiftTable{x_idx, z_idx} = [ 3, y_grid_table_idx(6) ];
            GridShiftTableXZ{ y_idx } = tmp_GridShiftTable;
        end
    end
end

end