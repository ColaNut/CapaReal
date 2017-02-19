function [ GridShiftTableXZ, BoneMediumTableXZ ] = UpdateBoneMed( y, mediumTableXZ, Ribs, SSBone, ...
                            RibValid, SSBoneValid, dx, dz, air_x, air_z, x_idx_max, z_idx_max, GridShiftTableXZ )
    
    BoneMediumTableXZ = ones( x_idx_max, z_idx_max, 'uint8');
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

    if SSBoneValid 
        Sp_x_idx = spine_x / dx + air_x / (2 * dx) + 1;
        Sp_z_idx = spine_z / dx + air_z / (2 * dz) + 1;
        BoneMediumTableXZ(Sp_x_idx - spine_hx / (2 * dx): Sp_x_idx + spine_hx / (2 * dx), ...
                            Sp_z_idx - spine_hz / (2 * dz): Sp_z_idx + spine_hz / (2 * dz)) = uint8(17);

        St_x_idx = sternum_x / dx + air_x / (2 * dx) + 1;
        St_z_idx = sternum_z / dx + air_z / (2 * dz) + 1;
        BoneMediumTableXZ(St_x_idx - sternum_hx / (2 * dx): St_x_idx + sternum_hx / (2 * dx), ...
                            St_z_idx - sternum_hz / (2 * dz): St_z_idx + sternum_hz / (2 * dz)) = uint8(18);

        % if y ~= - (spine_wy + 1 / 100) / 2 && y ~= (spine_wy - 1 / 100) / 2
        %     BoneMediumTableXZ(Sp_x_idx, Sp_z_idx) = uint8(7);
        % end
    end

    if RibValid 
        x_grid_tableL = [];
        z_grid_tableL = [];
        x_grid_tableR = [];
        z_grid_tableR = [];

        [ x_grid_tableL, z_grid_tableL ] = fill_Rib_GridTab(l_rib_x, l_rib_z, rib_hr, rib_rad, dx, dz);
        [ x_grid_tableR, z_grid_tableR ] = fill_Rib_GridTab(r_rib_x, r_rib_z, rib_hr, rib_rad, dx, dz);
        % unwrap the grid table 
        % compare the grid table with 
        [ GridShiftTableXZ, BoneMediumTableXZ ] = UpdateTab_rib( 'left', x_grid_tableL, z_grid_tableL, ...
                                        air_x, air_z, dx, dz, GridShiftTableXZ, BoneMediumTableXZ, Ribs, SSBone );
        [ GridShiftTableXZ, BoneMediumTableXZ ] = UpdateTab_rib( 'right', x_grid_tableR, z_grid_tableR, ...
                                        air_x, air_z, dx, dz, GridShiftTableXZ, BoneMediumTableXZ, Ribs, SSBone );
        % special cases 
        BoneMediumTableXZ(17, 12) = 16;
        BoneMediumTableXZ(17, 30) = 16;
        BoneMediumTableXZ(35, 12) = 16;
        BoneMediumTableXZ(35, 30) = 16;
    end
end