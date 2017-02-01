function [ GridShiftTableXZ, BoneMediumTableXZ ] = UpdateTab_rib( lr_text, x_grid_table, z_grid_table, ...
                                        air_x, air_z, dx, dz, GridShiftTableXZ, BoneMediumTableXZ, Ribs, SSBone )

% Ribs = [ rib_hr, rib_wy, rib_rad, 
%       l_rib_x, l_rib_y, l_rib_z, 
%       r_rib_x, r_rib_y, r_rib_z ];
% SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, 
%        sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

rib_hr     = Ribs(1, 1);
rib_rad    = Ribs(1, 3);
l_rib_x    = Ribs(1, 4);
l_rib_z    = Ribs(1, 6);
r_rib_x    = Ribs(1, 7);
r_rib_z    = Ribs(1, 9);
spine_hx   = SSBone(1);
spine_hz   = SSBone(2);
spine_wy   = SSBone(3);
spine_x    = SSBone(4);
spine_z    = SSBone(5);
sternum_hx = SSBone(6);
if sternum_hx ~= spine_hx
    error('check');
end
sternum_hz = SSBone(7);
sternum_wy = SSBone(8);
if sternum_wy ~= spine_wy
    error('check');
end
sternum_x  = SSBone(9);
sternum_z  = SSBone(10);

if strcmp(lr_text, 'left')
    rib_x = l_rib_x;
    rib_z = l_rib_z;
elseif strcmp(lr_text, 'right')
    rib_x = r_rib_x;
    rib_z = r_rib_z;
else
    error('check');
end

% x_grid_table = cell( size([ myCeil(x_0 - a, dx): dx: myFloor(x_0 + a, dx) ] ) );
% z_grid_table = cell( size([ myCeil(z_0 - c, dz): dz: myFloor(z_0 + c, dz) ]') );

lengthXArray = zeros(2, 1);
lengthXArray(1) = length([ myCeil(rib_x - (rib_rad + rib_hr), dx): dx: myFloor(rib_x + (rib_rad + rib_hr), dx) ]);
lengthXArray(2) = length([ myCeil(rib_x - rib_rad, dx): dx: myFloor(rib_x + rib_rad, dx) ]);

lx = length(x_grid_table);
for idx = 1: 1: lx
        
    x_grid_table_idx = x_grid_table{idx};
    x_idx1 = int64(x_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
    z_idx2 = int64(x_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
    x_idx4 = int64(x_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
    z_idx5 = int64(x_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);
    if x_idx1 ~= x_idx4
        error('check');
    end

    l_sp_hx_idx = int64(- spine_hx / ( 2 * dx ) + myCeil(air_x / 2, dx) / dx + 1);
    r_sp_hx_idx = int64(  spine_hx / ( 2 * dx ) + myCeil(air_x / 2, dx) / dx + 1);

    if strcmp(lr_text, 'left')
        if x_idx1 < l_sp_hx_idx
            % update the medium
            if idx <= lengthXArray(1)  
                BoneMediumTableXZ(x_idx1, z_idx5: z_idx2) = 16;
            else
                if (z_idx2 - z_idx5) >= 2
                    BoneMediumTableXZ(x_idx1, z_idx5 + 1: z_idx2 - 1) = 1;
                end
            end

            if x_grid_table_idx(3) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx1, z_idx2 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx1, z_idx2 } = [ 2, x_grid_table_idx(3) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx1, z_idx2 ];
                end
            end

            if x_grid_table_idx(6) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx4, z_idx5 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx4, z_idx5 } = [ 2, x_grid_table_idx(6) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx4, z_idx5 ];
                end
            end
        end
    elseif strcmp(lr_text, 'right')
        if x_idx1 > r_sp_hx_idx
            % update the medium
            if idx <= lengthXArray(1)  
                BoneMediumTableXZ(x_idx1, z_idx5: z_idx2) = 16;
            else
                if (z_idx2 - z_idx5) >= 2
                    BoneMediumTableXZ(x_idx1, z_idx5 + 1: z_idx2 - 1) = 1;
                end
            end

            if x_grid_table_idx(3) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx1, z_idx2 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx1, z_idx2 } = [ 2, x_grid_table_idx(3) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx1, z_idx2 ];
                end
            end

            if x_grid_table_idx(6) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx4, z_idx5 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx4, z_idx5 } = [ 2, x_grid_table_idx(6) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx4, z_idx5 ];
                end
            end
        end
    else
        error('check');
    end

end

% x_grid_table = cell( size([ myCeil(x_0 - a, dx): dx: myFloor(x_0 + a, dx) ] ) );
% z_grid_table = cell( size([ myCeil(z_0 - c, dz): dz: myFloor(z_0 + c, dz) ]') );

lengthZArray = zeros(2, 1);
lengthZArray(1) = length([ myCeil(rib_z - (rib_rad + rib_hr), dz): dz: myFloor(rib_z + (rib_rad + rib_hr), dz) ]);
lengthZArray(2) = length([ myCeil(rib_z - rib_rad, dz): dz: myFloor(rib_z + rib_rad, dz) ]);

lz = length(z_grid_table);
for idx = 1: 1: lz

    z_grid_table_idx = z_grid_table{idx};
    x_idx1 = int16(z_grid_table_idx(1) / dx + myCeil(air_x / 2, dx) / dx + 1);
    z_idx2 = int16(z_grid_table_idx(2) / dz + myCeil(air_z / 2, dz) / dz + 1);
    x_idx4 = int16(z_grid_table_idx(4) / dx + myCeil(air_x / 2, dx) / dx + 1);
    z_idx5 = int16(z_grid_table_idx(5) / dz + myCeil(air_z / 2, dz) / dz + 1);

    if z_idx2 ~= z_idx5
        error('check');
    end

    % update the medium
    if strcmp(lr_text, 'left')
        spineLx = - spine_hx / ( 2 * dx ) + air_x / (2 * dx) + 1;
        if idx <= lengthZArray(1)
            if idx <= ( (lengthZArray(1) + 1) / 2) + 3 && idx >= ( (lengthZArray(1) + 1) / 2) - 3
                if spineLx > x_idx1
                    BoneMediumTableXZ(x_idx4: x_idx1, z_idx2) = 16;
                else
                    BoneMediumTableXZ(x_idx4: spineLx - 1, z_idx2) = 16;
                end
            end
        else
            if idx <= lengthZArray(1) + ( (lengthZArray(2) + 1) / 2) + 3 && idx >= lengthZArray(1) + ( (lengthZArray(2) + 1) / 2) - 3
                if spineLx < x_idx1
                    BoneMediumTableXZ(x_idx4 + 1: spineLx - 1, z_idx2) = 1;
                elseif (x_idx1 - x_idx4) >= 2
                    BoneMediumTableXZ(x_idx4 + 1: x_idx1 - 1, z_idx2) = 1;
                end
            end
        end
    elseif strcmp(lr_text, 'right')
        spineRx = spine_hx / ( 2 * dx ) + air_x / (2 * dx) + 1;
        if idx <= lengthZArray(1)
            if idx <= ( (lengthZArray(1) + 1) / 2) + 3 && idx >= ( (lengthZArray(1) + 1) / 2) - 3
                if spineRx < x_idx4
                    BoneMediumTableXZ(x_idx4: x_idx1, z_idx2) = 16;
                else
                    BoneMediumTableXZ(spineRx + 1: x_idx1, z_idx2) = 16;
                end
            end
        else
            if idx <= lengthZArray(1) + ( (lengthZArray(2) + 1) / 2) + 3 && idx >= lengthZArray(1) + ( (lengthZArray(2) + 1) / 2) - 3
                if spineRx < x_idx4
                    BoneMediumTableXZ(spineRx + 1: x_idx1 - 1, z_idx2) = 1;
                elseif (x_idx1 - x_idx4) >= 2
                    BoneMediumTableXZ(x_idx4 + 1: x_idx1 - 1, z_idx2) = 1;
                end
            end
        end
    else
        error('check');
    end

    l_sp_hx_idx = int64(- spine_hx / ( 2 * dx ) + myCeil(air_x / 2, dx) / dx + 1);
    r_sp_hx_idx = int64(  spine_hx / ( 2 * dx ) + myCeil(air_x / 2, dx) / dx + 1);

    if strcmp(lr_text, 'left')
        if x_idx1 < l_sp_hx_idx
            if z_grid_table_idx(3) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx1, z_idx2 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx1, z_idx2 } = [ 1, z_grid_table_idx(3) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx1, z_idx2 ];
                end
            end
        end

        if z_grid_table_idx(6) ~= 0
            tmp_GridShiftTable = GridShiftTableXZ{ x_idx4, z_idx5 };
            if isempty(tmp_GridShiftTable)
                GridShiftTableXZ{ x_idx4, z_idx5 } = [ 1, z_grid_table_idx(6) ];
            else
                % disp('The boundary of ribs and other overlayed at: ');
                [ x_idx4, z_idx5 ];
            end
        end
    elseif strcmp(lr_text, 'right')
        if z_grid_table_idx(3) ~= 0
            tmp_GridShiftTable = GridShiftTableXZ{ x_idx1, z_idx2 };
            if isempty(tmp_GridShiftTable)
                GridShiftTableXZ{ x_idx1, z_idx2 } = [ 1, z_grid_table_idx(3) ];
            else
                % disp('The boundary of ribs and other overlayed at: ');
                [ x_idx1, z_idx2 ];
            end
        end

        if x_idx4 > r_sp_hx_idx
            if z_grid_table_idx(6) ~= 0
                tmp_GridShiftTable = GridShiftTableXZ{ x_idx4, z_idx5 };
                if isempty(tmp_GridShiftTable)
                    GridShiftTableXZ{ x_idx4, z_idx5 } = [ 1, z_grid_table_idx(6) ];
                else
                    % disp('The boundary of ribs and other overlayed at: ');
                    [ x_idx4, z_idx5 ];
                end
            end
        end
    else
        error('check');
    end
end

end