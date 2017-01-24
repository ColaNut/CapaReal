function [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, ...
                                                x_idx, y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ )

lengthYArray = zeros(3, 1);

l_lung_z = paras2dYZ(11);
l_lung_b = paras2dYZ(12);
l_lung_c = paras2dYZ(13);

r_lung_z = paras2dYZ(15);
r_lung_b = paras2dYZ(16);
r_lung_c = paras2dYZ(17);

tumor_y = paras2dYZ(18);
tumor_z = paras2dYZ(19);
tumor_r = paras2dYZ(20);

if isreal(l_lung_c)
    lengthYArray(1) = length([ myCeil(l_lung_z - l_lung_c, dy): dy: myFloor(l_lung_z + l_lung_c, dy) ]);
end
if isreal(r_lung_c)
    lengthYArray(2) = length([ myCeil(r_lung_z - r_lung_c, dy): dy: myFloor(r_lung_z + r_lung_c, dy) ]);
end
if isreal(tumor_r)
    lengthYArray(3) = length([ myCeil(tumor_y - tumor_r, dy): dy: myFloor(tumor_y + tumor_r, dy) ]);
end

ly = length(y_grid_table);
if ly ~= sum(lengthYArray)
    error('check');
end
for idx = 1: 1: ly

    BndryNum = getBndryNum(idx, lengthYArray);

    y_grid_table_idx = y_grid_table{idx};
    y_idx1 = int16(y_grid_table_idx(1) / dy + myCeil(h_torso / 2, dy) / dy + 1);
    z_idx2 = int16(y_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
    y_idx4 = int16(y_grid_table_idx(4) / dy + myCeil(h_torso / 2, dy) / dy + 1);
    z_idx5 = int16(y_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

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