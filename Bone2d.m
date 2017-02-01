function [ RibValid, SSBoneValid ] = Bone2d(y, Ribs, SSBone, dy, h_torso)
    % Ribs = [ rib_hr, rib_wy, rib_rad, 
    %           l_rib_x, l_rib_y, l_rib_z, 
    %           r_rib_x, r_rib_y, r_rib_z ];
    % SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, 
    %            sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

    RibValid = 0;
    SSBoneValid = false;

    l_rib_y = squeeze(Ribs(:, 5));
    rib_wy = Ribs(1, 2);
    spine_wy = SSBone(3);

    y_idx    = int64(y / dy + h_torso / (2 * dy) + 1);
    RibLow   = zeros(7, 1, 'int64');
    RibUp    = zeros(7, 1, 'int64');
    RibLow   = int64(( l_rib_y - rib_wy / 2 ) / dy + h_torso / (2 * dy) + 1);
    RibUp    = int64(( l_rib_y + rib_wy / 2 ) / dy + h_torso / (2 * dy) + 1);
    spineLow  = int64( - (spine_wy + 1 / 100) / ( 2 * dy ) + h_torso / (2 * dy) + 1 );
    spineUp  = int64( (spine_wy - 1 / 100) / ( 2 * dy ) + h_torso / (2 * dy) + 1 );

    
    if ( y_idx >= RibLow(1) && y_idx <= RibUp(1) )
        RibValid = 1;
    elseif ( y_idx >= RibLow(2) && y_idx <= RibUp(2) ) 
        RibValid = 2;
    elseif ( y_idx >= RibLow(3) && y_idx <= RibUp(3) ) 
        RibValid = 3;
    elseif ( y_idx >= RibLow(4) && y_idx <= RibUp(4) ) 
        RibValid = 4;
    elseif ( y_idx >= RibLow(5) && y_idx <= RibUp(5) ) 
        RibValid = 5;
    elseif ( y_idx >= RibLow(6) && y_idx <= RibUp(6) ) 
        RibValid = 6;
    elseif ( y_idx >= RibLow(7) && y_idx <= RibUp(7) ) 
        RibValid = 7;
    end

    if ( y_idx >= spineLow && y_idx <= spineUp )
        SSBoneValid = true;
    end
end