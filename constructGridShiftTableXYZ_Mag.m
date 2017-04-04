function [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ_Mag( GridShiftTableXZ, ...
                                                x_idx, y_grid_table, mediumTable, paras2dYZ_Mag )

w_x          = paras2dYZ_Mag(1);
w_y          = paras2dYZ_Mag(2);
w_z          = paras2dYZ_Mag(3);

dx           = paras2dYZ_Mag(9);
dy           = paras2dYZ_Mag(10);
dz           = paras2dYZ_Mag(11);

ly = size(y_grid_table, 1);

for idx = 1: 1: ly

    % BndryNum = getBndryNum(idx, lengthYArray);
    BndryNum = 11;

    y_grid_table_idx = y_grid_table(idx, :);
    y_idx1 = int16(y_grid_table_idx(1) / dy + myCeil(w_y / 2, dy) / dy + 1);
    z_idx2 = int16(y_grid_table_idx(2) / dz + myCeil(w_z / 2, dz) / dz + 1);
    y_idx4 = int16(y_grid_table_idx(4) / dy + myCeil(w_y / 2, dy) / dy + 1);
    z_idx5 = int16(y_grid_table_idx(5) / dz + myCeil(w_z / 2, dz) / dz + 1);

    mediumTable( x_idx, y_idx1, z_idx2 ) = BndryNum;
    mediumTable( x_idx, y_idx4, z_idx5 ) = BndryNum;

    if y_grid_table_idx(3) ~= 0
        % note the following line
        tmp_GridShiftTable = GridShiftTableXZ{ y_idx1 };
        tmp_GridShiftTable_element = tmp_GridShiftTable{x_idx, z_idx2};
        if isempty( tmp_GridShiftTable_element )
            tmp_GridShiftTable{x_idx, z_idx2} = [ 3, y_grid_table_idx(3) ];
            GridShiftTableXZ{ y_idx1 } = tmp_GridShiftTable;
        elseif abs(y_grid_table_idx(3)) < abs(tmp_GridShiftTable_element(2))
            tmp_GridShiftTable{x_idx, z_idx2} = [ 3, y_grid_table_idx(3) ];
            GridShiftTableXZ{ y_idx1 } = tmp_GridShiftTable;
        end
    end

    if y_grid_table_idx(6) ~= 0
        tmp_GridShiftTable = GridShiftTableXZ{ y_idx4 };
        tmp_GridShiftTable_element = tmp_GridShiftTable{x_idx, z_idx5};
        if isempty( tmp_GridShiftTable_element )
            tmp_GridShiftTable{x_idx, z_idx5} = [ 3, y_grid_table_idx(6) ];
            GridShiftTableXZ{ y_idx4 } = tmp_GridShiftTable;
        elseif abs(y_grid_table_idx(6)) < abs(tmp_GridShiftTable_element(2))
            tmp_GridShiftTable{x_idx, z_idx5} = [ 3, y_grid_table_idx(6) ];
            GridShiftTableXZ{ y_idx4 } = tmp_GridShiftTable;
        end
    end
end

end