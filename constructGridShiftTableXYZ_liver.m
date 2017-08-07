function [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ_liver( GridShiftTableXZ, ...
                                                x_idx, y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ )

% paras2dYZ = [ h_torso, air_x, air_z, ...
%     bolus_a, bolusHghtZ, skin_a, skin_c, muscle_a, muscleHghtZ, ...
%     liver_z, liver_y_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
%     tumor_y, tumor_z, tumor_r_prime ];

lengthYArray = zeros(2, 1);

liver_z = paras2dYZ(10);
liver_y_0 = paras2dYZ(11);
liver_z_0 = paras2dYZ(12);
liver_a_prime = paras2dYZ(13);
liver_c_prime = paras2dYZ(14);
liver_rotate = paras2dYZ(15);

m_1 = paras2dYZ(16);
m_2 = paras2dYZ(16);

tumor_y = paras2dYZ(18);
tumor_z = paras2dYZ(19);
tumor_r_prime = paras2dYZ(20);

% get the variable: max_a and max_c
t = linspace( 0, 2 * pi );
X = liver_a_prime * cos(t);
Z = liver_c_prime * sin(t);
max_a = max( X * cos(liver_rotate) - Z * sin(liver_rotate) );
max_c = max( X * sin(liver_rotate) + Z * cos(liver_rotate) );

if liver_a_prime > 0 && liver_c_prime > 0
    lengthYArray(1) = length([ myCeil(liver_z + liver_z_0 - max_c, dz): dz: myFloor(liver_z + liver_z_0 + max_c, dz) ]);
end
if isreal(tumor_r_prime)
    lengthYArray(2) = length([ myCeil(tumor_z - tumor_r_prime, dz): dz: myFloor(tumor_z + tumor_r_prime, dz) ]);
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

    if ( y_idx1 == 23 && z_idx2 == 22 ) || ( y_idx4 == 23 && z_idx5 == 22 )
        ;
    end

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