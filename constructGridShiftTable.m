function [ GridShiftTable ] = constructGridShiftTable( x_grid_table, z_grid_table, a, b, dx, dz )

x_grid = - myCeil(a, dx): dx: myCeil(a, dx);
z_grid = - myCeil(b, dz): dz: myCeil(b, dz);

GridShiftTable = cell( length(x_grid), length(z_grid) );

% shift the grid point to the curve.
for idx = 1: 1: 2 * myFloor(a, dx) / dx + 1
    x_grid_table_idx = x_grid_table{idx};
    if x_grid_table_idx(3) ~= 0
        x_idx = int16(x_grid_table_idx(1) / dx + myCeil(a, dx) / dx + 1);
        z_idx = int16(x_grid_table_idx(2) / dz + myCeil(b, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(3) ];
        elseif abs(x_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(3) ];
        end
    end

    if x_grid_table_idx(6) ~= 0
        x_idx = int16(x_grid_table_idx(4) / dx + myCeil(a, dx) / dx + 1);
        z_idx = int16(x_grid_table_idx(5) / dz + myCeil(b, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(6) ];
        elseif abs(x_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 2, x_grid_table_idx(6) ];
        end
    end
end

for idx = 1: 1: 2 * myFloor(b, dz) / dz + 1
    z_grid_table_idx = z_grid_table{idx};
    if z_grid_table_idx(3) ~= 0
        x_idx = int16(z_grid_table_idx(1) / dx + myCeil(a, dx) / dx + 1);
        z_idx = int16(z_grid_table_idx(2) / dz + myCeil(b, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(3) ];
        elseif abs(z_grid_table_idx(3)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(3) ];
        end
    end

    if z_grid_table_idx(6) ~= 0
        x_idx = int16(z_grid_table_idx(4) / dx + myCeil(a, dx) / dx + 1);
        z_idx = int16(z_grid_table_idx(5) / dz + myCeil(b, dz) / dz + 1);
        tmp_GridShiftTable = GridShiftTable{ x_idx, z_idx };
        if isempty(tmp_GridShiftTable)
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(6) ];
        elseif abs(z_grid_table_idx(6)) < abs(tmp_GridShiftTable(2))
            GridShiftTable{ x_idx, z_idx } = [ 1, z_grid_table_idx(6) ];
        end
    end
end

end