function [ GridShiftTable, mediumTable ] = constructGridShiftTableXZ_all( x_grid_table, z_grid_table, air_x, air_z, dx, dz, mediumTable, paras2dXZ );

% paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, fat_a, fat_c, muscle_a, muscle_c, ...
    %     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
    %     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
    %     tumor_x, tumor_z, tumor_r_prime ];
    
% 1
bolus_a = paras2dXZ(3);
bolus_c = paras2dXZ(4);

% 2
fat_a = paras2dXZ(5);
fat_c = paras2dXZ(6);

% 3
muscle_a = paras2dXZ(7);
muscle_c = paras2dXZ(8);

% 4
l_lung_x = paras2dXZ(9);
l_lung_z = paras2dXZ(10);
l_lung_a = paras2dXZ(11);
l_lung_c = paras2dXZ(12);

% 5
r_lung_x = paras2dXZ(13);
r_lung_z = paras2dXZ(14);
r_lung_a = paras2dXZ(15);
r_lung_c = paras2dXZ(16);

% 6
tumor_x = paras2dXZ(17);
tumor_z = paras2dXZ(18);
tumor_r = paras2dXZ(19);

x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);

GridShiftTable = cell( length(x_grid), length(z_grid) );
% mediumTable = ones( air_x / dx + 1, air_z / dz  + 1, 'uint8' );
% mediumTable = false(size(GridShiftTable));

lengthXArray = zeros(6, 1);
lengthZArray = zeros(6, 1);

lengthXArray(1) = length([ myCeil(0 - bolus_a, dx): dx: myFloor(0 + bolus_a, dx) ]);
lengthXArray(2) = length([ myCeil(0 - fat_a, dx): dx: myFloor(0 + fat_a, dx) ]);
lengthXArray(3) = length([ myCeil(0 - muscle_a, dx): dx: myFloor(0 + muscle_a, dx) ]);
if isreal(l_lung_a)
    lengthXArray(4) = length([ myCeil(l_lung_x - l_lung_a, dx): dx: myFloor(l_lung_x + l_lung_a, dx) ]);
end
if isreal(r_lung_a)
    lengthXArray(5) = length([ myCeil(r_lung_x - r_lung_a, dx): dx: myFloor(r_lung_x + r_lung_a, dx) ]);
end
if isreal(tumor_r)
    lengthXArray(6) = length([ myCeil(tumor_x - tumor_r, dx): dx: myFloor(tumor_x + tumor_r, dx) ]);
end

lengthZArray(1) = length([ myCeil(0 - bolus_c, dz): dz: myFloor(0 + bolus_c, dz) ]);
lengthZArray(2) = length([ myCeil(0 - fat_c, dz): dz: myFloor(0 + fat_c, dz) ]);
lengthZArray(3) = length([ myCeil(0 - muscle_c, dz): dz: myFloor(0 + muscle_c, dz) ]);
if isreal(l_lung_c)
    lengthZArray(4) = length([ myCeil(l_lung_z - l_lung_c, dz): dz: myFloor(l_lung_z + l_lung_c, dz) ]);
end
if isreal(r_lung_c)
    lengthZArray(5) = length([ myCeil(r_lung_z - r_lung_c, dz): dz: myFloor(r_lung_z + r_lung_c, dz) ]);
end
if isreal(tumor_r)
    lengthZArray(6) = length([ myCeil(tumor_z - tumor_r, dz): dz: myFloor(tumor_z + tumor_r, dz) ]);
end

% shift the grid point to the curve.
lx = length(x_grid_table);
if lx ~= sum(lengthXArray)
    error('check');
end
for idx = 1: 1: lx

    BndryNum = getBndryNum(idx, lengthXArray);

    % if BndryNum ~= 12
        x_grid_table_idx = x_grid_table{idx};
        x_idx1 = int64(x_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx2 = int64(x_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        x_idx4 = int64(x_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx5 = int64(x_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

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