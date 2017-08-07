function [ GridShiftTable, mediumTable ] = constructGridShiftTableXZ_all_liver( x_grid_table, z_grid_table, air_x, air_z, dx, dz, mediumTable, paras2dXZ );

% paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, fat_a, fat_c, muscle_a, muscle_c, ...
%     liver_x, liver_z, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
%     tumor_x, tumor_y, tumor_z, tumor_r_prime ];

air_x = paras2dXZ(1);
air_z = paras2dXZ(2);
bolus_a = paras2dXZ(3);
bolus_c = paras2dXZ(4);
fat_a = paras2dXZ(5);
fat_c = paras2dXZ(6);
muscle_a = paras2dXZ(7);
muscle_c = paras2dXZ(8);
liver_x = paras2dXZ(9);
liver_z = paras2dXZ(10);
liver_x_0 = paras2dXZ(11);
liver_z_0 = paras2dXZ(12);
liver_a_prime = paras2dXZ(13);
liver_c_prime = paras2dXZ(14);
liver_rotate = paras2dXZ(15);
m_1 = paras2dXZ(16);
m_2 = paras2dXZ(17);
tumor_x   = paras2dXZ(18);
tumor_y   = paras2dXZ(19);
tumor_z = paras2dXZ(20);
tumor_r_prime = paras2dXZ(21);

x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% get the variable: max_a
t = linspace( 0, 2 * pi );
X = liver_a_prime * cos(t);
Z = liver_c_prime * sin(t);
max_a = max( X * cos(liver_rotate) - Z * sin(liver_rotate) );
max_c = max( X * sin(liver_rotate) + Z * cos(liver_rotate) );

GridShiftTable = cell( length(x_grid), length(z_grid) );
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );
% mediumTable = false(size(GridShiftTable));

lengthXArray = zeros(5, 1);
lengthZArray = zeros(5, 1);

lengthXArray(1) = length([ myCeil(0 - bolus_a, dx): dx: myFloor(0 + bolus_a, dx) ]);
lengthXArray(2) = length([ myCeil(0 - fat_a, dx): dx: myFloor(0 + fat_a, dx) ]);
lengthXArray(3) = length([ myCeil(0 - muscle_a, dx): dx: myFloor(0 + muscle_a, dx) ]);
if liver_a_prime > 0
    % implement the min_x and max_x of Liver region
    lengthXArray(4) = length([ myCeil(liver_x + liver_x_0 - max_a, dx): dx: myFloor(liver_x + liver_x_0 + max_a, dx) ]);
end
if isreal(tumor_r_prime)
    lengthXArray(5) = length([ myCeil(tumor_x - tumor_r_prime, dx): dx: myFloor(tumor_x + tumor_r_prime, dx) ]);
end

lengthZArray(1) = length([ myCeil(0 - bolus_c, dz): dz: myFloor(0 + bolus_c, dz) ]);
lengthZArray(2) = length([ myCeil(0 - fat_c, dz): dz: myFloor(0 + fat_c, dz) ]);
lengthZArray(3) = length([ myCeil(0 - muscle_c, dz): dz: myFloor(0 + muscle_c, dz) ]);
if liver_c_prime > 0
    % implement the min_z and max_z of Liver region
    lengthZArray(4) = length([ myCeil(liver_z + liver_z_0 - max_c, dx): dz: myFloor(liver_z + liver_z_0 + max_c, dz) ]);
end
if isreal(tumor_r_prime)
    lengthZArray(5) = length([ myCeil(tumor_z - tumor_r_prime, dz): dz: myFloor(tumor_z + tumor_r_prime, dz) ]);
end

% shift the grid point to the curve.
lx = length(x_grid_table);
if lx ~= sum(lengthXArray)
    error('check');
end
for idx = 1: 1: lx

    % implement getBndryNum_liver.m
    BndryNum = getBndryNum(idx, lengthXArray);

    % if BndryNum ~= 12
        x_grid_table_idx = x_grid_table{idx};
        x_idx1 = int64(x_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx2 = int64(x_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        x_idx4 = int64(x_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx5 = int64(x_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

        if ( x_idx1 == 23 && z_idx2 == 22 ) || ( x_idx4 == 23 && z_idx5 == 22 )
            ;
        end

        mediumTable( x_idx1, z_idx2 ) = BndryNum;
        mediumTable( x_idx4, z_idx5 ) = BndryNum;

        if x_grid_table_idx(3) ~= 0
            tmp_GridShiftTable = GridShiftTable{ x_idx1, z_idx2 };
            if isempty(tmp_GridShiftTable)
                GridShiftTable{ x_idx1, z_idx2 } = [ 2, x_grid_table_idx(3) ];
            elseif abs(x_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
                [ x_idx1, z_idx2 ]
                warning('collision between shifts');
                GridShiftTable{ x_idx1, z_idx2 } = [ 2, x_grid_table_idx(3) ];
            end
        end

        if x_grid_table_idx(6) ~= 0
            tmp_GridShiftTable = GridShiftTable{ x_idx4, z_idx5 };
            if isempty(tmp_GridShiftTable)
                GridShiftTable{ x_idx4, z_idx5 } = [ 2, x_grid_table_idx(6) ];
            elseif abs(x_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
                [ x_idx4, z_idx5 ]
                warning('collision between shifts');
                GridShiftTable{ x_idx4, z_idx5 } = [ 2, x_grid_table_idx(6) ];
            end
        end
    % end
end

lz = length(z_grid_table);
if lz ~= sum(lengthZArray)
    error('check');
end
for idx = 1: 1: lz

    BndryNum = getBndryNum(idx, lengthZArray);

    % if BndryNum ~= 12
        z_grid_table_idx = z_grid_table{idx};
        x_idx1 = int16(z_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx2 = int16(z_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        x_idx4 = int16(z_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx5 = int16(z_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

        if ( x_idx1 == 23 && z_idx2 == 22 ) || ( x_idx4 == 23 && z_idx5 == 22 )
            ;
        end

        mediumTable( x_idx1, z_idx2 ) = BndryNum;
        mediumTable( x_idx4, z_idx5 ) = BndryNum;

        if z_grid_table_idx(3) ~= 0
            tmp_GridShiftTable = GridShiftTable{ x_idx1, z_idx2 };
            if isempty(tmp_GridShiftTable)
                GridShiftTable{ x_idx1, z_idx2 } = [ 1, z_grid_table_idx(3) ];
            elseif abs(z_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
                GridShiftTable{ x_idx1, z_idx2 } = [ 1, z_grid_table_idx(3) ];
            end
        end

        if z_grid_table_idx(6) ~= 0
            tmp_GridShiftTable = GridShiftTable{ x_idx4, z_idx5 };
            if isempty(tmp_GridShiftTable)
                GridShiftTable{ x_idx4, z_idx5 } = [ 1, z_grid_table_idx(6) ];
            elseif abs(z_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
                GridShiftTable{ x_idx4, z_idx5 } = [ 1, z_grid_table_idx(6) ];
            end
        end
    % end
end

end