function [ GridShiftTable, mediumTable ] = UpdateLoop( x_grid_table, z_grid_table, GridShiftTable, mediumTable, loopNum, air_x, air_z, dx, dz, varargin )

x_grid = myFloor(- air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = myFloor(- air_z / 2, dz): dz: myCeil(air_z / 2, dz);

nVarargs = length(varargin);
if nVarargs == 1
    ExceptionColissionMedNum = varargin{1};
end

% shift the grid point to the curve.
lx = length(x_grid_table);
for idx = 1: 1: lx
    % if loopNum ~= 12
        x_grid_table_idx = x_grid_table{idx};
        x_idx1 = int64(x_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx2 = int64(x_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        x_idx4 = int64(x_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx5 = int64(x_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

        if nVarargs == 1
            if mediumTable( x_idx1, z_idx2 ) ~= ExceptionColissionMedNum
                mediumTable( x_idx1, z_idx2 ) = loopNum;
            end
            if mediumTable( x_idx4, z_idx5 ) ~= ExceptionColissionMedNum
                mediumTable( x_idx4, z_idx5 ) = loopNum;
            end
        else
            mediumTable( x_idx1, z_idx2 ) = loopNum;
            mediumTable( x_idx4, z_idx5 ) = loopNum;
        end

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
for idx = 1: 1: lz
    % if loopNum ~= 12
        z_grid_table_idx = z_grid_table{idx};
        x_idx1 = int16(z_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx2 = int16(z_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
        x_idx4 = int16(z_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
        z_idx5 = int16(z_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

        if nVarargs == 1
            if mediumTable( x_idx1, z_idx2 ) ~= ExceptionColissionMedNum
                mediumTable( x_idx1, z_idx2 ) = loopNum;
            end
            if mediumTable( x_idx4, z_idx5 ) ~= ExceptionColissionMedNum
                mediumTable( x_idx4, z_idx5 ) = loopNum;
            end
        else
            mediumTable( x_idx1, z_idx2 ) = loopNum;
            mediumTable( x_idx4, z_idx5 ) = loopNum;
        end

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