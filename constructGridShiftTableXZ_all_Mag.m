function [ GridShiftTable, mediumTable ] = constructGridShiftTableXZ_all_Mag( x_grid_table, z_grid_table, mediumTable, paras2dXZ_Mag );

% paras2dXZ_Mag = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_y, r_c, dx, dy, dz, sample_valid, circle_x ];
    
w_x          = paras2dXZ_Mag(1);
w_y          = paras2dXZ_Mag(2);
w_z          = paras2dXZ_Mag(3);

h_x          = paras2dXZ_Mag(4);
h_y          = paras2dXZ_Mag(5);
h_z          = paras2dXZ_Mag(6);
ell_y        = paras2dXZ_Mag(7);
r_c          = paras2dXZ_Mag(8);
dx           = paras2dXZ_Mag(9);
dy           = paras2dXZ_Mag(10);
dz           = paras2dXZ_Mag(11);
sample_valid = paras2dXZ_Mag(12);

x_grid = myFloor(- w_x / 2, dx): dx: myCeil(w_x / 2, dx);
z_grid = myFloor(- w_z / 2, dz): dz: myCeil(w_z / 2, dz);

GridShiftTable = cell( length(x_grid), length(z_grid) );
% mediumTable = ones( w_x / dx + 1, w_z / dz  + 1, 'uint8' );
% mediumTable = false(size(GridShiftTable));

% shift the grid point to the curve.
lx = length(x_grid_table);
for idx = 1: 1: lx
    
    BndryNum = 11;

    x_grid_table_idx = x_grid_table{idx};
    x_idx1 = int64(x_grid_table_idx(1) / dx + myCeil(w_x / 2, dx) / dx + 1);
    z_idx2 = int64(x_grid_table_idx(2) / dz + myCeil(w_z / 2, dz) / dz + 1);
    x_idx4 = int64(x_grid_table_idx(4) / dx + myCeil(w_x / 2, dx) / dx + 1);
    z_idx5 = int64(x_grid_table_idx(5) / dz + myCeil(w_z / 2, dz) / dz + 1);

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
end

lz = length(z_grid_table);
for idx = 1: 1: lz

    BndryNum = 11;

    % if BndryNum ~= 12
        z_grid_table_idx = z_grid_table{idx};
        x_idx1 = int16(z_grid_table_idx(1) / dx + myCeil(w_x / 2, dx) / dx + 1);
        z_idx2 = int16(z_grid_table_idx(2) / dz + myCeil(w_z / 2, dz) / dz + 1);
        x_idx4 = int16(z_grid_table_idx(4) / dx + myCeil(w_x / 2, dx) / dx + 1);
        z_idx5 = int16(z_grid_table_idx(5) / dz + myCeil(w_z / 2, dz) / dz + 1);

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