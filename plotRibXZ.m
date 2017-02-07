function plotRibXZ(Ribs, SSBone, dx, dz)

% Ribs = [ rib_hr, rib_wy, rib_rad, ...
%           l_rib_x, l_rib_y, l_rib_z, ...
%           r_rib_x, r_rib_y, r_rib_z ];
% SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, ...
%            sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

    rib_hr = Ribs(1, 1) * 100;
    l_rib_x = Ribs(1, 4) * 100;
    l_rib_z = Ribs(1, 6) * 100;
    r_rib_x = Ribs(1, 7) * 100;
    r_rib_z = Ribs(1, 9) * 100;

    h_x_sp = SSBone(1) * 100;
    h_z_sp = SSBone(2) * 100;
    x_sp = SSBone(4) * 100;
    z_sp = SSBone(5) * 100;

    h_x_st = SSBone(6) * 100;
    h_z_st = SSBone(7) * 100;
    x_st = SSBone(9) * 100;
    z_st   = SSBone(10) * 100;
    
    rib_rad = Ribs(1, 3) * 100;

    % plotEllipse( x1, z1, x2, z2, b, dx, dz );
    % left rib
    t = linspace( 0, 2 * pi, 400 );
    L_InnX = l_rib_x + rib_rad * cos(t);
    L_InnZ = l_rib_z + rib_rad * sin(t);
    L_InnIdx = find( L_InnX <= - h_x_sp / 2 );
    plot(L_InnX(L_InnIdx), L_InnZ(L_InnIdx), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    L_ExtX = l_rib_x + ( rib_rad + rib_hr ) * cos(t);
    L_ExtZ = l_rib_z + ( rib_rad + rib_hr ) * sin(t);
    L_ExtIdx = find( L_ExtX <= - h_x_sp / 2 | (L_ExtX < h_x_sp & L_ExtZ < z_st - 0.5) );
    plot(L_ExtX(L_ExtIdx), L_ExtZ(L_ExtIdx), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    t2 = linspace( pi, 3 * pi, 400 );
    R_InnX = r_rib_x + rib_rad * cos(t2);
    R_InnZ = r_rib_z + rib_rad * sin(t2);
    R_InnIdx = find( R_InnX >= h_x_sp / 2 );
    plot(R_InnX(R_InnIdx), R_InnZ(R_InnIdx), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    R_ExtX = r_rib_x + ( rib_rad + rib_hr ) * cos(t2);
    R_ExtZ = r_rib_z + ( rib_rad + rib_hr ) * sin(t2);
    R_ExtIdx = find( R_ExtX >= h_x_sp / 2 | (R_ExtX < h_x_sp & R_ExtZ < z_st - 0.5) );
    plot(R_ExtX(R_ExtIdx), R_ExtZ(R_ExtIdx), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    % plot spine
    RunningIdx = linspace( x_sp - h_x_sp / 2, x_sp + h_x_sp / 2 );
    SpineTop = (z_sp + h_z_sp / 2) * ones(size(RunningIdx));
    SpineDwn = (z_sp - h_z_sp / 2) * ones(size(RunningIdx));
    plot(RunningIdx, SpineTop, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
    plot(RunningIdx, SpineDwn, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    RunningIdx = linspace( z_sp - h_z_sp / 2, z_sp + h_z_sp / 2 );
    SpineLft = (x_sp + h_x_sp / 2) * ones(size(RunningIdx));
    SpineRght = (x_sp - h_x_sp / 2) * ones(size(RunningIdx));
    plot(SpineLft, RunningIdx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
    plot(SpineRght, RunningIdx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
    
    % plot sternum
    RunningIdx = linspace( x_st - h_x_st / 2, x_st + h_x_sp / 2 );
    StTop = (z_st + h_z_st / 2) * ones(size(RunningIdx));
    StDwn = (z_st - h_z_st / 2) * ones(size(RunningIdx));
    plot(RunningIdx, StTop, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
    plot(RunningIdx, StDwn, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    RunningIdx = linspace( z_st - h_z_st / 2, z_st + h_z_st / 2 );
    StLft = (x_st + h_x_st / 2) * ones(size(RunningIdx));
    StRght = (x_st - h_x_st / 2) * ones(size(RunningIdx));
    plot(StLft, RunningIdx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
    plot(StRght, RunningIdx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

    % plotEllipse( l_rib_x - rib_rad, l_rib_z, l_rib_x + rib_rad, l_rib_z, rib_rad, dx, dz );
    % plotEllipse( l_rib_x - rib_rad - rib_hr, l_rib_z, l_rib_x + rib_rad + rib_hr, l_rib_z, rib_rad + rib_hr, dx, dz );

    % % right rib
    % plotEllipse( r_rib_x - rib_rad, r_rib_z, r_rib_x + rib_rad, r_rib_z, rib_rad, dx, dz );
    % plotEllipse( r_rib_x - rib_rad - rib_hr, r_rib_z, r_rib_x + rib_rad + rib_hr, l_rib_z, rib_rad + rib_hr, dx, dz );

end