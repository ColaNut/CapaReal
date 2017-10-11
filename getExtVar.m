function [ mediumTable, SegMed, GridShiftTable ] = getExtVar(dx_ori, dy_ori, dz_ori)
    
    % === % ========================================================== % === %
    % === % Topic: Capacitive hyperthermia With Intraluminal Electrode % === %
    % === % Starting Dates: 0922                                       % === %
    % === % ========================================================== % === %

    % === % ========================================= % === %
    % === % Construction of coordinate and grid shift % === %
    % === % ========================================= % === %
    digits;
    Mu_0          = 4 * pi * 10^(-7);
    Epsilon_0     = 10^(-9) / (36 * pi);
    Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
    V_0           = 10; 

    % parameters
                  %     1      2       3      4      5      6      7         8                 9
                  % [ air, bolus, muscle,  lung,  lung,  bone,   fat, reserved, esophageal tumor ]';
    rho           = [   1,  1020,   1020,   394,   394,  1790,   900,        0,             1040 ]';
    epsilon_r_pre = [   1, 113.0,    113, 264.9, 264.9,   7.3,    20,        0,               60 ]';
    sigma         = [   0,  0.61,   0.61,  0.42,  0.42, 0.028, 0.047,        0,              0.8 ]';
    epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

    % There 'must' be a grid point at the origin.
    loadParas;
    if dx ~= dx_ori && dy ~= dy_ori && dz ~= dz_ori
        error('check');
    end
    dx = dx_ori / 2;
    dy = dy_ori / 2;
    dz = dz_ori / 2;
    % paras = [ h_torso, air_x, air_z, ...
    %         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
    %         l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
    %         r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
    %         tumor_x, tumor_y, tumor_z, tumor_r ];

    Ribs = zeros(7, 9);
    SSBone = zeros(1, 8);
    [ Ribs, SSBone ] = BoneParas;
    % Ribs = [ rib_hr, rib_wy, rib_rad, 
    %           l_rib_x, l_rib_y, l_rib_z, 
    %           r_rib_x, r_rib_y, r_rib_z ];
    % SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, 
    %            sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

    x_idx_max = air_x / dx + 1;
    y_idx_max = h_torso / dy + 1;
    z_idx_max = air_z / dz + 1;

    GridShiftTableXZ = cell( h_torso / dy + 1, 1);
    % GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.

    mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
    % check the 6, 7, 8 number in the mediumTable; not accord with size(rho) ?
    % Normal Points: [ air, bolus, muscle, lung, tumor, ribs, spine, sternum, esophageal tumor ] -> [  1,  2,  3,  4,  5,  6,  7,  8, 9 ]
    % Interfaces:    [ air-bolus, bolus-muscle, muscle-lung, lung-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
    % Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 
    byndCD = 30; % beyond computation: 30
    EsBndryNum = 31;
    EsTumorNum = 9;

    % to-do
    for y = - h_torso / 2: dy: h_torso / 2
        paras2dXZ = genParas2d( y, paras, dx, dy, dz );
        % paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
        %     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
        %     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
        %     tumor_x, tumor_z, tumor_r_prime ];
        y_idx = y / dy + h_torso / (2 * dy) + 1;
        mediumTable(:, int64(y_idx), :) = getRoughMed( mediumTable(:, int64(y_idx), :), paras2dXZ, dx, dz, 'no_fat' );
        [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all( paras2dXZ, dx, dz, mediumTable(:, int64(y_idx), :) );
    end
    % 1 to 7, corresponding to 1-st to 7-th rib.
    RibValid = 0; 
    SSBoneValid = false;
    BoneMediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
    for y = - h_torso / 2: dy: h_torso / 2
        [ RibValid, SSBoneValid ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
        y_idx = y / dy + h_torso / (2 * dy) + 1;
        [ GridShiftTableXZ{ int64(y_idx) }, BoneMediumTable(:, int64(y_idx), :) ] ...
            = UpdateBoneMed( y, mediumTable(:, int64(y_idx), :), Ribs, SSBone, RibValid, SSBoneValid, ...
                                dx, dz, air_x, air_z, x_idx_max, z_idx_max, GridShiftTableXZ{ int64(y_idx) } );
    end
    for x = - air_x / 2: dx: air_x / 2
        paras2dYZ = genParas2dYZ( x, paras, dy, dz );
        y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
        x_idx = x / dx + air_x / (2 * dx) + 1;
        [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ );
    end
    % re-organize the GridShiftTable
    GridShiftTable = cell( air_x / dx + 1, h_torso / dy + 1, air_z / dz + 1 );
    for y_idx = 1: 1: h_torso / dy + 1
        tmp_table = GridShiftTableXZ{ y_idx };
        for x_idx = 1: 1: air_x / dx + 1
            for z_idx = 1: 1: air_z / dz + 1
                GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
            end
        end
    end
    shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, paras, dx, dy, dz );

    sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
    B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
    SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

    x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
    y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
    z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
    N_v = x_max_vertex * y_max_vertex * z_max_vertex;
    N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
        + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
        + ( (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1) );
    Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
    tic;
    disp('Calculation of vertex coordinate in extended vertex coordinate');
    Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
    toc;

    % === % ============================ % === %
    % === % Filling time of Rough SegMed % === %
    % === % ============================ % === %
    sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
    B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
    MskMedTab = mediumTable; 
    % normal point remains the same, the boundary point are forced to zero
    MskMedTab( find(MskMedTab >= 10) ) = 0;

    disp('The fill up time of SegMed in extended vertex coordinate: ');
    tic;
    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        p0 = idx;
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            if MskMedTab(p0) ~= 0 && BoneMediumTable(p0) == 1 % normal normal point
            % if mediumTable(p0) == 1 || mediumTable(p0) == 2 || mediumTable(p0) == 3 || mediumTable(p0) == 4 || mediumTable(p0) == 5 
                [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
                                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
            elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 1 % normal bondary point
                [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                    shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
                    epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
            elseif MskMedTab(p0) ~= 0 && BoneMediumTable(p0) >= 16 && BoneMediumTable(p0) <= 18 % rib normal point
                [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
                    shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                        MskMedTab, BoneMediumTable, epsilon_r );
            elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 16  % rib boundary point
                [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
                    shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                        MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
            else
                error('check');
            end
        elseif ell == z_idx_max
            sparseA{ p0 } = fillTop_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        elseif ell == 1
            sparseA{ p0 } = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
            sparseA{ p0 } = fillRight_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
            sparseA{ p0 } = fillLeft_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            sparseA{ p0 } = fillFront_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            sparseA{ p0 } = fillBack_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
        end
    end
    toc;
    % warning messages occurr in the above determination of SegMed; ammended by the below SegMed determination process
    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        p0 = idx;
        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
            if mediumTable(p0) == 11 % air-bolus boundary pnt
                % check the validity of the LHS accepance.
                % update the bolus
                SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
                                                squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'inner' );

                [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                    shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
                    epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
            elseif mediumTable(p0) == 13 % bolus-muscle pnt
                % update the bolus
                SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
                                                squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'outer' );
                % update the fat tissue
                SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
                                                squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'inner' );

                if BoneMediumTable(p0) == 1 % normal bondary point
                    [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                        shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
                        epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
                elseif BoneMediumTable(p0) == 16  % rib boundary point
                    [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
                        shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                            MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
                else
                    error('check');
                end
            % if fat is incorporated, the following code is needed.
            % elseif mediumTable(p0) == 12 % fat-muscle
            %     % update the fat tissue
            %     SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
            %                                     squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'outer' );
            %     if MskMedTab(p0) ~= 0
            %         error('check');
            %     end
            %     if BoneMediumTable(p0) == 1 % normal bondary point
            %         [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
            %             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
            %             epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
            %     elseif BoneMediumTable(p0) == 16  % rib boundary point
            %         [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
            %             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
            %                 MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
            %     else
            %         error('check');
            %     end
            end
        end
    end

end