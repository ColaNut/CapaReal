function [ GridShiftTable ] = constructGridShiftTableXZ_all( x_grid_table, z_grid_table, air_x, air_z, dx, dz );

x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);

GridShiftTable = cell( length(x_grid), length(z_grid) );

% shift the grid point to the curve.
lx = length(x_grid_table);
for idx = 1: 1: lx
    x_grid_table_idx = x_grid_table{idx};
    if x_grid_table_idx(3) ~= 0
        x_idx = int16(x_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx = int16(x_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(3) ];
        elseif abs(x_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
            warning('collision between shifts');
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(3) ];
        end
    end

    if x_grid_table_idx(6) ~= 0
        x_idx = int16(x_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx = int16(x_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(6) ];
        elseif abs(x_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
            warning('collision between shifts');
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(6) ];
        end
    end
end

lz = length(z_grid_table);
for idx = 1: 1: lz
    z_grid_table_idx = z_grid_table{idx};
    if z_grid_table_idx(3) ~= 0
        x_idx = int16(z_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx = int16(z_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(3) ];
        elseif abs(z_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(3) ];
        end
    end

    if z_grid_table_idx(6) ~= 0
        x_idx = int16(z_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx = int16(z_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(6) ];
        elseif abs(z_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(6) ];
        end
    end
end

end