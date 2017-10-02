% % % % % === % ========================================================== % === %
% % % % % === % Topic: Capacitive hyperthermia With Intraluminal Electrode % === %
% % % % % === % Starting Dates: 0922                                       % === %
% % % % % === % ========================================================== % === %
% % % % % === % ========================================= % === %
% % % % % === % Construction of coordinate and grid shift % === %
% % % % % === % ========================================= % === %
% % % % clc; clear;
% % % % digits;
% % % % disp('Esophagus: EQS, 0922');
% % % % Mu_0          = 4 * pi * 10^(-7);
% % % % Epsilon_0     = 10^(-9) / (36 * pi);
% % % % Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
% % % % V_0           = 10; 

% % % % % parameters
% % % %               %     1      2       3      4      5      6      7         8                 9
% % % %               % [ air, bolus, muscle,  lung,  lung,  bone,   fat, reserved, esophageal tumor ]';
% % % % rho           = [   1,  1020,   1020,   394,   394,  1790,   900,        0,             1040 ]';
% % % % epsilon_r_pre = [   1, 113.0,    113, 264.9, 264.9,   7.3,    20,        0,               60 ]';
% % % % sigma         = [   0,  0.61,   0.61,  0.42,  0.42, 0.028, 0.047,        0,              0.8 ]';
% % % % epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % % % % There 'must' be a grid point at the origin.
% % % % loadParas;
% % % % % paras = [ h_torso, air_x, air_z, ...
% % % % %         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
% % % % %         l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
% % % % %         r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
% % % % %         tumor_x, tumor_y, tumor_z, tumor_r ];

% % % % Ribs = zeros(7, 9);
% % % % SSBone = zeros(1, 8);
% % % % [ Ribs, SSBone ] = BoneParas;
% % % % % Ribs = [ rib_hr, rib_wy, rib_rad, 
% % % % %           l_rib_x, l_rib_y, l_rib_z, 
% % % % %           r_rib_x, r_rib_y, r_rib_z ];
% % % % % SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, 
% % % % %            sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

% % % % x_idx_max = air_x / dx + 1;
% % % % y_idx_max = h_torso / dy + 1;
% % % % z_idx_max = air_z / dz + 1;

% % % % GridShiftTableXZ = cell( h_torso / dy + 1, 1);
% % % % % GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.

% % % % mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% % % % % check the 6, 7, 8 number in the mediumTable; not accord with size(rho) ?
% % % % % Normal Points: [ air, bolus, muscle, lung, tumor, ribs, spine, sternum, esophageal tumor ] -> [  1,  2,  3,  4,  5,  6,  7,  8, 9 ]
% % % % % Interfaces:    [ air-bolus, bolus-muscle, muscle-lung, lung-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
% % % % % Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 
% % % % byndCD = 30; % beyond computation: 30
% % % % EsBndryNum = 31;
% % % % EsTumorNum = 9;

% % % % % to-do
% % % % for y = - h_torso / 2: dy: h_torso / 2
% % % %     paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% % % %     % paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
% % % %     %     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
% % % %     %     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
% % % %     %     tumor_x, tumor_z, tumor_r_prime ];
% % % %     y_idx = y / dy + h_torso / (2 * dy) + 1;
% % % %     mediumTable(:, int64(y_idx), :) = getRoughMed( mediumTable(:, int64(y_idx), :), paras2dXZ, dx, dz, 'no_fat' );
% % % %     [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all( paras2dXZ, dx, dz, mediumTable(:, int64(y_idx), :) );
% % % % end
% % % % % 1 to 7, corresponding to 1-st to 7-th rib.
% % % % RibValid = 0; 
% % % % SSBoneValid = false;
% % % % BoneMediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% % % % for y = - h_torso / 2: dy: h_torso / 2
% % % %     [ RibValid, SSBoneValid ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
% % % %     y_idx = y / dy + h_torso / (2 * dy) + 1;
% % % %     [ GridShiftTableXZ{ int64(y_idx) }, BoneMediumTable(:, int64(y_idx), :) ] ...
% % % %         = UpdateBoneMed( y, mediumTable(:, int64(y_idx), :), Ribs, SSBone, RibValid, SSBoneValid, ...
% % % %                             dx, dz, air_x, air_z, x_idx_max, z_idx_max, GridShiftTableXZ{ int64(y_idx) } );
% % % % end
% % % % for x = - air_x / 2: dx: air_x / 2
% % % %     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
% % % %     y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
% % % %     x_idx = x / dx + air_x / (2 * dx) + 1;
% % % %     [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ );
% % % % end
% % % % % re-organize the GridShiftTable
% % % % GridShiftTable = cell( air_x / dx + 1, h_torso / dy + 1, air_z / dz + 1 );
% % % % for y_idx = 1: 1: h_torso / dy + 1
% % % %     tmp_table = GridShiftTableXZ{ y_idx };
% % % %     for x_idx = 1: 1: air_x / dx + 1
% % % %         for z_idx = 1: 1: air_z / dz + 1
% % % %             GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
% % % %         end
% % % %     end
% % % % end
% % % % shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, paras, dx, dy, dz );

% % % % sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
% % % % B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
% % % % SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

% % % % x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% % % % y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% % % % z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
% % % % N_v = x_max_vertex * y_max_vertex * z_max_vertex;
% % % % N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
% % % %     + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
% % % %     + ( (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1) );
% % % % Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
% % % % tic;
% % % % disp('Calculation of vertex coordinate');
% % % % Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% % % % toc;

% % % % % figure(1);
% % % % % clf;
% % % % % paras2dXZ = genParas2d( 0, paras, dx, dy, dz );
% % % % % plotMap_Eso( paras2dXZ, dx, dz );
% % % % % plotRibXZ(Ribs, SSBone, dx, dz);
% % % % % plotGridLineXZ( shiftedCoordinateXYZ, uint64(0 / dy + h_torso / (2 * dy) + 1) );
% % % % % axis( [- 5, 5, 0, 10] );
% % % % % return;

% % % % % === % ============================ % === %
% % % % % === % Filling time of Rough SegMed % === %
% % % % % === % ============================ % === %
% % % % sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
% % % % B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
% % % % MskMedTab = mediumTable; 
% % % % % normal point remains the same, the boundary point are forced to zero
% % % % MskMedTab( find(MskMedTab >= 10) ) = 0;

% % % % disp('The fill up time of SegMed: ');
% % % % tic;
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     p0 = idx;
% % % %     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         if MskMedTab(p0) ~= 0 && BoneMediumTable(p0) == 1 % normal normal point
% % % %         % if mediumTable(p0) == 1 || mediumTable(p0) == 2 || mediumTable(p0) == 3 || mediumTable(p0) == 4 || mediumTable(p0) == 5 
% % % %             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
% % % %                             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
% % % %         elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 1 % normal bondary point
% % % %             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
% % % %                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
% % % %                 epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %         elseif MskMedTab(p0) ~= 0 && BoneMediumTable(p0) >= 16 && BoneMediumTable(p0) <= 18 % rib normal point
% % % %             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
% % % %                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
% % % %                     MskMedTab, BoneMediumTable, epsilon_r );
% % % %         elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 16  % rib boundary point
% % % %             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
% % % %                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
% % % %                     MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %         else
% % % %             error('check');
% % % %         end
% % % %     elseif ell == z_idx_max
% % % %         sparseA{ p0 } = fillTop_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     elseif ell == 1
% % % %         sparseA{ p0 } = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
% % % %         sparseA{ p0 } = fillRight_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         sparseA{ p0 } = fillLeft_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         sparseA{ p0 } = fillFront_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         sparseA{ p0 } = fillBack_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
% % % %     end
% % % % end
% % % % toc;
% % % % % warning messages occurr in the above determination of SegMed; ammended by the below SegMed determination process
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     p0 = idx;
% % % %     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         if mediumTable(p0) == 11 % air-bolus boundary pnt
% % % %             % check the validity of the LHS accepance.
% % % %             % update the bolus
% % % %             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
% % % %                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'inner' );

% % % %             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
% % % %                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
% % % %                 epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %         elseif mediumTable(p0) == 13 % bolus-muscle pnt
% % % %             % update the bolus
% % % %             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
% % % %                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'outer' );
% % % %             % update the fat tissue
% % % %             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
% % % %                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'inner' );

% % % %             if BoneMediumTable(p0) == 1 % normal bondary point
% % % %                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
% % % %                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
% % % %                     epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %             elseif BoneMediumTable(p0) == 16  % rib boundary point
% % % %                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
% % % %                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
% % % %                         MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %             else
% % % %                 error('check');
% % % %             end
% % % %         % if fat is incorporated, the following code is needed.
% % % %         % elseif mediumTable(p0) == 12 % fat-muscle
% % % %         %     % update the fat tissue
% % % %         %     SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
% % % %         %                                     squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'outer' );
% % % %         %     if MskMedTab(p0) ~= 0
% % % %         %         error('check');
% % % %         %     end
% % % %         %     if BoneMediumTable(p0) == 1 % normal bondary point
% % % %         %         [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
% % % %         %             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
% % % %         %             epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %         %     elseif BoneMediumTable(p0) == 16  % rib boundary point
% % % %         %         [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
% % % %         %             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
% % % %         %                 MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
% % % %         %     else
% % % %         %         error('check');
% % % %         %     end
% % % %         end
% % % %     end
% % % % end

% % % % % === % ========================================= % === %
% % % % % === % Fill the SegMed on the computation domain % === %
% % % % % === % ========================================= % === % 
% % % % % x- and z-direction.
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     if m == 1 || m == x_idx_max || ell == 1 && ell == z_idx_max 
% % % %         SegMed(m, n, ell, :, :) = uint8(1);
% % % %     end
% % % % end 
% % % % % y-direction.
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     if n == 1 || n == y_idx_max
% % % %         tmpSeg = zeros(6, 8, 'uint8');
% % % %         SegCopy = zeros(8, 1, 'uint8');
% % % %         SegCopy(1) = SegMed(m, 2, ell, 4, 1);
% % % %         SegCopy(2) = SegMed(m, 2, ell, 1, 1);
% % % %         SegCopy(3) = SegMed(m, 2, ell, 1, 3);
% % % %         SegCopy(4) = SegMed(m, 2, ell, 2, 1);
% % % %         SegCopy(5) = SegMed(m, 2, ell, 2, 5);
% % % %         SegCopy(6) = SegMed(m, 2, ell, 3, 1);
% % % %         SegCopy(7) = SegMed(m, 2, ell, 3, 3);
% % % %         SegCopy(8) = SegMed(m, 2, ell, 4, 5);

% % % %         tmpSeg(4, 1) = SegCopy(1); tmpSeg(4, 2) = SegCopy(1); tmpSeg(4, 3) = SegCopy(1); tmpSeg(4, 4) = SegCopy(1); tmpSeg(5, 4) = SegCopy(1); tmpSeg(6, 1) = SegCopy(1);
% % % %         tmpSeg(1, 1) = SegCopy(2); tmpSeg(1, 2) = SegCopy(2); tmpSeg(1, 7) = SegCopy(2); tmpSeg(1, 8) = SegCopy(2); tmpSeg(5, 3) = SegCopy(2); tmpSeg(6, 2) = SegCopy(2); 
% % % %         tmpSeg(1, 3) = SegCopy(3); tmpSeg(1, 4) = SegCopy(3); tmpSeg(1, 5) = SegCopy(3); tmpSeg(1, 6) = SegCopy(3); tmpSeg(5, 2) = SegCopy(3); tmpSeg(6, 3) = SegCopy(3); 
% % % %         tmpSeg(2, 1) = SegCopy(4); tmpSeg(2, 2) = SegCopy(4); tmpSeg(2, 3) = SegCopy(4); tmpSeg(2, 4) = SegCopy(4); tmpSeg(5, 1) = SegCopy(4); tmpSeg(6, 4) = SegCopy(4); 
% % % %         tmpSeg(2, 5) = SegCopy(5); tmpSeg(2, 6) = SegCopy(5); tmpSeg(2, 7) = SegCopy(5); tmpSeg(2, 8) = SegCopy(5); tmpSeg(5, 8) = SegCopy(5); tmpSeg(6, 5) = SegCopy(5); 
% % % %         tmpSeg(3, 1) = SegCopy(6); tmpSeg(3, 2) = SegCopy(6); tmpSeg(3, 7) = SegCopy(6); tmpSeg(3, 8) = SegCopy(6); tmpSeg(5, 7) = SegCopy(6); tmpSeg(6, 6) = SegCopy(6); 
% % % %         tmpSeg(3, 3) = SegCopy(7); tmpSeg(3, 4) = SegCopy(7); tmpSeg(3, 5) = SegCopy(7); tmpSeg(3, 6) = SegCopy(7); tmpSeg(5, 6) = SegCopy(7); tmpSeg(6, 7) = SegCopy(7); 
% % % %         tmpSeg(4, 5) = SegCopy(8); tmpSeg(4, 6) = SegCopy(8); tmpSeg(4, 7) = SegCopy(8); tmpSeg(4, 8) = SegCopy(8); tmpSeg(5, 5) = SegCopy(8); tmpSeg(6, 8) = SegCopy(8); 
% % % %         SegMed(m, n, ell, :, :) = tmpSeg;
% % % %     end
% % % % end 

% % % % % load('0925PreB.mat');
% % % % % === === % ======================================== % === === %
% % % % % === === % Draw The Second Rectangular Box Naming B % === === %
% % % % % === === % ======================================== % === === %
% % % % % region B: [-3, 3, 2, 8]
% % % % % region C: [-1, 1, 4, 6]
% % % % % domain B has actual size of [ w_x_B + dx, w_y_B + dy, w_z_B + dz ]
% % % % w_x_B = 10 / 100;
% % % % w_y_B = 10 / 100;
% % % % w_z_B = 10 / 100; % w_x_B, w_y_B and w_z_B must be on the grid of domain A
% % % % dx_B = dx / 2;
% % % % dy_B = dy / 2;
% % % % dz_B = dz / 2;
% % % % % Domain B
% % % % x_idx_max_B = ( w_x_B + dx ) / dx_B + 1;
% % % % y_idx_max_B = ( w_y_B + dy ) / dy_B + 1;
% % % % z_idx_max_B = ( w_z_B + dz ) / dz_B + 1;
% % % % x_max_vertex_B = 2 * x_idx_max_B - 1;
% % % % y_max_vertex_B = 2 * y_idx_max_B - 1;
% % % % z_max_vertex_B = 2 * z_idx_max_B - 1;
% % % % % Larger Grid on Domain B; 
% % % % % check the usage of x_max_vertex_AinB
% % % % x_idx_max_AinB = w_x_B / ( 2 * dx_B ) + 1; % dx_A = 2 * dx_B
% % % % y_idx_max_AinB = w_y_B / ( 2 * dy_B ) + 1; % dy_A = 2 * dy_B
% % % % z_idx_max_AinB = w_z_B / ( 2 * dz_B ) + 1; % dz_A = 2 * dz_B
% % % % x_max_vertex_AinB = 2 * x_idx_max_AinB + 1;
% % % % y_max_vertex_AinB = 2 * y_idx_max_AinB + 1;
% % % % z_max_vertex_AinB = 2 * z_idx_max_AinB + 1;

% % % % % to-do
% % % % % The prolonged part of esophagus is not incorporated in the nest
% % % % % implement grid shift for esophagus and tumor
% % % % mediumTable_B = 3 * ones( x_idx_max_B, y_idx_max_B, z_idx_max_B, 'uint8');
% % % % GridShiftTableXZ_B = cell( ( w_y_B + dy ) / dy_B + 1, 1);
% % % % for y = - ( w_y_B + dy ) / 2 : dy_B: ( w_y_B + dy ) / 2
% % % %     y_idx = y / dy_B + ( w_x_B + dy ) / (2 * dy_B) + 1;
% % % %     loadParas_Eso0924; % a script
% % % %     mediumTable_B(:, int64(y_idx), :) = getRoughMed_Eso_B( mediumTable_B(:, int64(y_idx), :), y_idx, w_x_B + dx, w_y_B + dy, w_z_B + dz, dx_B, dy_B, dz_B );
% % % %     [ GridShiftTableXZ_B{ int64(y_idx) }, mediumTable_B(:, int64(y_idx), :) ] = constructCoordinateXZ_all_Eso0924( w_x_B + dx, w_z_B + dz, dx_B, dz_B, mediumTable_B(:, int64(y_idx), :) );
% % % % end
% % % % GridShiftTable_B = cell( ( w_x_B + dx ) / dx_B + 1, ( w_y_B + dy ) / dy_B + 1, ( w_z_B + dz ) / dz_B + 1 );
% % % % for y_idx = 1: 1: ( w_y_B + dy ) / dy_B + 1
% % % %     tmp_table = GridShiftTableXZ_B{ y_idx };
% % % %     for x_idx = 1: 1: ( w_x_B + dx ) / dx_B + 1
% % % %         for z_idx = 1: 1: ( w_z_B + dz ) / dz_B + 1
% % % %             GridShiftTable_B{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
% % % %         end
% % % %     end
% % % % end
% % % % % to-do
% % % % % inherent the GridShift from the main node
% % % % shiftedCoordinateXYZ_B = constructCoordinateXYZ( GridShiftTable_B, [w_y_B + dx, w_x_B + dy, w_z_B + dz], dx_B, dy_B, dz_B );

% % % % % Get vertex coordinate in domain B
% % % % Vertex_Crdnt_B = zeros( x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, 3 );
% % % % tic;
% % % % disp('Calculation of vertex coordinate');
% % % % Vertex_Crdnt_B = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ_B );
% % % % toc;

% % % % figure(1);
% % % % clf;
% % % % hold on;
% % % % plotGridLineXZ( shiftedCoordinateXYZ_B, ( y_idx_max_B + 1 ) / 2 );
% % % % figure(2)
% % % % clf;
% % % % hold on;
% % % % plotGridLineYZ( shiftedCoordinateXYZ, ( x_idx_max_B + 1 ) / 2 );
% % % % % return;

% % % % % need to shift shiftedCoordinateXYZ_B and Vertex_Crdnt_B by [0, 0, 5].
% % % % shiftedCoordinateXYZ_B(:, :, :, 3) = shiftedCoordinateXYZ_B(:, :, :, 3) + 5 / 100;

% % % % % to-do
% % % % % SegMed determination in domain B
% % % % SegMed_B = ones( x_idx_max_B, y_idx_max_B, z_idx_max_B, 6, 8, 'uint8');
% % % % % unvalid SegMed_B is also set to 30; 
% % % % % no need to store the surrounding modified SegMed; since they are the same as their mother-tetrahedra

% % % % % to-do
% % % % % inherent the SegMed from the main node

% % % % % using math to determine the SegMed
% % % % % === % =========================== % === %
% % % % % === % Fill The SegMed In Domain B % === %
% % % % % === % =========================== % === %
% % % % % SegMed determination may be wrong in the junction point of esophagus and spine
% % % % for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
% % % %     if mediumTable_B(m, n, ell) < 10
% % % %         SegMed_B(m, n, ell, :, :) = mediumTable_B(m, n, ell);
% % % %     elseif m >= 2 && m <= x_idx_max_B - 1 && n >= 2 && n <= y_idx_max_B - 1 && ell >= 2 && ell <= z_idx_max_B - 1 
% % % %         SegMed_B( m, n, ell, :, : ) = fillBndrySegMed( m, n, ell, ...
% % % %                 shiftedCoordinateXYZ_B, x_idx_max_B, y_idx_max_B, z_idx_max_B, mediumTable_B, 'Eso' );
% % % %     end
% % % % end

% % % % % return;

% % % % % === % ==================================== % === %
% % % % % === % Trimming: Invalid set to 30 (byndCD) % === %
% % % % % === % ==================================== % === % 
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     if ell == z_idx_max
% % % %         SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if ell == 1
% % % %         SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if m   == 1
% % % %         SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if m   == x_idx_max
% % % %         SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if n   == y_idx_max
% % % %         SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if n   == 1
% % % %         SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % % end
% % % % for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
% % % %     if ell == z_idx_max_B
% % % %         SegMed_B(m, n, ell, :, :) = trimUp( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if ell == 1
% % % %         SegMed_B(m, n, ell, :, :) = trimDown( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if m   == 1
% % % %         SegMed_B(m, n, ell, :, :) = trimLeft( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if m   == x_idx_max_B
% % % %         SegMed_B(m, n, ell, :, :) = trimRight( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if n   == y_idx_max_B
% % % %         SegMed_B(m, n, ell, :, :) = trimFar( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % %     if n   == 1
% % % %         SegMed_B(m, n, ell, :, :) = trimNear( squeeze( SegMed_B(m, n, ell, :, :) ), byndCD );
% % % %     end
% % % % end

% % % % % to-do 
% % % % % the line Cases is discard temporarily
% % % % validNum = getValidNum(x_idx_max, y_idx_max, z_idx_max);
% % % % validNum_AplusB = validNum - 48 * x_idx_max_AinB * y_idx_max_AinB * z_idx_max_AinB ...
% % % %                 + getValidNum(x_idx_max_B, y_idx_max_B, z_idx_max_B) ... % volume
% % % %                 + ( (4 - 1) + (2 - 1) )* 8 * (x_idx_max_AinB * y_idx_max_AinB + y_idx_max_AinB * z_idx_max_AinB + x_idx_max_AinB * z_idx_max_AinB) * 2 ... % 6 facets
% % % %                 ; % + (2 - 1) * 4 * (x_idx_max + y_idx_max + z_idx_max) * 4; % 12 lines
% % % % ExpandedNum = 48 * (x_idx_max * y_idx_max * z_idx_max + x_idx_max_B * y_idx_max_B * z_idx_max_B) ...
% % % %                 + ( 4 + 2 ) * 8 * (x_idx_max_AinB * y_idx_max_AinB + y_idx_max_AinB * z_idx_max_AinB + x_idx_max_AinB * z_idx_max_AinB) * 2 ... % 6 facets
% % % %                 ; % + 2 * 4 * (x_idx_max + y_idx_max + z_idx_max) * 4; % 12 lines
% % % % MedTetTableCell_AplusB_tmp = cell(ExpandedNum, 1); % each row consists the indices of the four vertices and is medium value.
% % % % validTetTable              = false(ExpandedNum, 1); 

% % % % % return;

% % % % tic;
% % % % disp('Getting MedTetTableCell_AplusB -- Domain A: ');
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     m_v = 2 * m - 1;
% % % %     n_v = 2 * n - 1;
% % % %     ell_v = 2 * ell - 1;
% % % %     PntMedTetTableCell  = cell(48, 1);
% % % %     PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %     MedTetTableCell_AplusB_tmp( 48 * (idx - 1) + 1: 48 * idx ) = PntMedTetTableCell;
% % % %     % to-do
% % % %     % cuting domain B our of domain A
% % % %     PntValidTet = false(48, 1);
% % % %     PntValidTet( find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD ) ) = true;
% % % %     validTetTable( 48 * (idx - 1) + 1: 48 * idx ) = PntValidTet;
% % % % end
% % % % toc;

% % % % % % return;
% % % % tic;
% % % % disp('Getting MedTetTableCell_AplusB -- Domain B: ');
% % % % BaseIdx = 48 * x_idx_max * y_idx_max * z_idx_max;
% % % % for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
% % % %     m_v = 2 * m - 1;
% % % %     n_v = 2 * n - 1;
% % % %     ell_v = 2 * ell - 1;
% % % %     PntMedTetTableCell  = cell(48, 1);
% % % %     PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed_B(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );
% % % %     MedTetTableCell_AplusB_tmp( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntMedTetTableCell;
% % % %     PntValidTet = false(48, 1);
% % % %     PntValidTet( find( squeeze( SegMed_B(m, n, ell, :, :) )' ~= byndCD ) ) = true;
% % % %     validTetTable( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntValidTet;
% % % % end
% % % % toc;

% % % % % modify the PntMedTetTableCell in the range of [ BaseIdx + 1, BaseIdx + 48 * x_idx_max_B * y_idx_max_B * z_idx_max_B ]
% % % % for idx = BaseIdx + 1: 1: BaseIdx + 48 * x_idx_max_B * y_idx_max_B * z_idx_max_B
% % % %     TmpTet = MedTetTableCell_AplusB_tmp{ idx };
% % % %     TmpTet(1: 4) = TmpTet(1: 4) + N_v;
% % % %     MedTetTableCell_AplusB_tmp{ idx } = TmpTet;
% % % % end

% % % % % to-do
% % % % RegionB = false(x_idx_max, y_idx_max, z_idx_max);
% % % % m_Rght  = ( es_x + w_x_B / 2 ) / dx + air_x / (2 * dx) + 1;
% % % % m_Lft   = ( es_x - w_x_B / 2 ) / dx + air_x / (2 * dx) + 1;
% % % % n_Far   = ( 0    + w_y_B / 2 ) / dy + h_torso / (2 * dy) + 1;
% % % % n_Near  = ( 0    - w_y_B / 2 ) / dy + h_torso / (2 * dy) + 1;
% % % % ell_Top = ( es_z + w_z_B / 2 ) / dz + air_z / (2 * dz) + 1;
% % % % ell_Dwn = ( es_z - w_z_B / 2 ) / dz + air_z / (2 * dz) + 1;
% % % % RegionB(m_Lft: m_Rght, n_Near: n_Far, ell_Dwn: ell_Top) = true;

% % % % % clc; clear;
% % % % % load('PreSurrounding.mat');
% % % % % the line Case is abandomed in the first simulation
% % % % tic;
% % % % disp('Getting MedTetTableCell_AplusB -- Surrounding Part of Domain B: ');
% % % % BaseIdx = 48 * ( x_idx_max * y_idx_max * z_idx_max + x_idx_max_B * y_idx_max_B * z_idx_max_B );
% % % % TetCounter = BaseIdx;
% % % % TetCounter2 = 0;
% % % % TetCounter3 = 0;
% % % % for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
% % % %     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
% % % %     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
% % % %         Med27Value = zeros(3, 9);
% % % %         Med27Value = get27MedValue( m, n, ell, RegionB );
% % % %         if ~isempty(find(Med27Value)) && RegionB(m, n, ell) == false
% % % %             m_v = 2 * m - 1;
% % % %             n_v = 2 * n - 1;
% % % %             ell_v = 2 * ell - 1;
% % % %             p0_v = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
% % % %             % to-do (to be amended for the line case)
% % % %             [ PntMedTetTableCell, InvalidTetIdcs ] = getPntMedTetTable_B_arnd( squeeze( SegMed(m, n, ell, :, :) )', Med27Value, ...
% % % %                                     idx, p0_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
% % % %                                     x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B );

% % % %             MedTetTableCell_AplusB_tmp( TetCounter + 1: TetCounter + length(PntMedTetTableCell) ) = PntMedTetTableCell;
% % % %             validTetTable( TetCounter + 1: TetCounter + length(PntMedTetTableCell) ) = true;
% % % %             TetCounter = TetCounter + length(PntMedTetTableCell);
% % % %             % eliminate the exisinting large tetrahedra
% % % %             if ~isempty(InvalidTetIdcs)
% % % %                 if validTetTable(InvalidTetIdcs) ~= true(length(InvalidTetIdcs), 1)
% % % %                     [m, n, ell]
% % % %                     idx
% % % %                 end
% % % %                 TetCounter3 = TetCounter3 + length(InvalidTetIdcs);
% % % %             end
% % % %             validTetTable(InvalidTetIdcs) = false;
% % % %         end
% % % %         if RegionB(m, n, ell)
% % % %             if length( find(validTetTable(48 * (idx - 1) + 1: 48 * idx)) ) ~= 48
% % % %                 error('check');
% % % %             end
% % % %             TetCounter2 = TetCounter2 + 48;
% % % %             validTetTable(48 * (idx - 1) + 1: 48 * idx) = false;
% % % %         end
% % % %     end
% % % % end
% % % % toc;

% % % % MedTetTableCell_AplusB = MedTetTableCell_AplusB_tmp;
% % % % MedTetTableCell_AplusB(~validTetTable) = [];

% % % % if size(MedTetTableCell_AplusB, 1) ~= validNum_AplusB
% % % %     error('check the construction');
% % % % end

% % % % % to-do -- done
% % % % % the total vertex in regin A (original) + B (newly-imposed domain)
% % % % N_v_B = N_v + x_max_vertex_B * y_max_vertex_B * z_max_vertex_B ...
% % % %             - x_max_vertex_AinB * y_max_vertex_AinB * z_max_vertex_AinB; % actual number in column of MedTetTable_B
% % % % total_N_v = N_v + x_max_vertex_B * y_max_vertex_B * z_max_vertex_B;
% % % % MedTetTable_B = sparse(validNum_AplusB, total_N_v);
% % % % tic;
% % % % disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
% % % % MedTetTable_B = mySparse2MatlabSparse( MedTetTableCell_AplusB, validNum_AplusB, total_N_v, 'Row' );
% % % % toc;

% % % % % return;
% % % % % load('PostSurrounding.mat');

% % % % % to-do 
% % % % % Use the following code as an amend for sparseS
% % % % sparseS = cell(total_N_v, 1);
% % % % B_phi = zeros(total_N_v, 1);
% % % % tic;
% % % % disp('The Filling Time of S \cdot Phi = b_phi in Finner grid Coordinate: ');
% % % % % note for the boudary point, i.e., fillTop_A, fillBttm_A, fillRight_A, fillLeft_A, fillFront_A, fillBack_A
% % % % tic;
% % % % for vIdx = 1: 1: total_N_v
% % % %     % vFlag = 0, 1 and 2 correspond to invalid AinB, valid A, valid A boundary and valid B, respectively.
% % % %     vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz );
% % % %     if vFlag == 0
% % % %         sparseS{ vIdx } = [ vIdx, 1 ];
% % % %         B_phi{ vIdx } = 1;
% % % %     else
% % % %         if vFlag == 2
% % % %             [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% % % %             if ell_v == z_max_vertex
% % % %                 sparseS{ vIdx } = fillTop_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             elseif ell_v == 1
% % % %                 sparseS{ vIdx } = fillBttm_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             elseif m_v == x_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex - 1 
% % % %                 sparseS{ vIdx } = fillRight_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             elseif m_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
% % % %                 sparseS{ vIdx } = fillLeft_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             elseif n_v == y_max_vertex && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
% % % %                 sparseS{ vIdx } = fillFront_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             elseif n_v == 1 && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
% % % %                 sparseS{ vIdx } = fillBack_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
% % % %             end
% % % %         else % vFlag == 1 || vFlag == 3 ( valid A || valid B )
% % % %             S1_row = zeros(1, total_N_v);
% % % %             CandiTet = find( MedTetTable_B(:, vIdx));
% % % %             for itr = 1: 1: length(CandiTet)
% % % %                 % v is un-ordered vertices; while p is ordered vertices.
% % % %                 % fix the problem in the determination of v1234 here .
% % % %                 TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
% % % %                 v1234 = TetRow(1: 4);
% % % %                 if length(v1234) ~= 4
% % % %                     error('check');
% % % %                 end
% % % %                 MedVal = TetRow(5);
% % % %                 % this judgement below is based on the current test case
% % % %                 if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
% % % %                     error('check');
% % % %                 end
% % % %                 p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
% % % %                 S1_row = fillS1_Eso( p1234, S1_row, epsilon_r(MedVal), ...
% % % %                             N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
% % % %                             w_x_B, w_y_B, w_z_B, dx, dy, dz, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
% % % %                             Vertex_Crdnt, Vertex_Crdnt_B );
% % % %             end
% % % %             sparseS{vIdx} = Mrow2myRow(S1_row);
% % % %         end
% % % %     end
% % % % end
% % % % toc;

% % % % return;
% % % clc; clear;
% % % % this version is actually effected by the PutOnTopElctrd_liver fx.
% % % load('0929PreElectrode.mat');
% % % Vertex_Crdnt_B(:, :, :, 3) = Vertex_Crdnt_B(:, :, :, 3) + es_z;
% % % B_phi = zeros(total_N_v, 1);
% % % y_mid = ( h_torso / ( 2 * dy ) ) + 1;
% % % BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% % % % 19: position of top-electrode
% % % TpElctrdPos = 19;
% % % % % save('0924EsoBeforeElctrd_v2.mat')
% % % % % return;
% % % % % endowment of electrode, where the upper electrode is set to be zero
% % % [ sparseS, B_phi, BndryTable ] = PutOnTopElctrd_liver( sparseS, B_phi, 0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
% % %                         dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
% % % % to-do
% % % % put on down electrode
% % % % [ sparseS, B_phi, BndryTable ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
% % % %                         dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
% % % [ sparseS, B_phi ] = PutOnDwnElctrd_Esophagus_Fine( sparseS, B_phi, N_v, V_0, x_max_vertex_B, y_max_vertex_B, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B );

% % % % tumor_m   = tumor_x_es / dx + air_x / (2 * dx) + 1;
% % % % tumor_n   = tumor_y_es / dy + h_torso / (2 * dy) + 1;
% % % % tumor_ell = tumor_z_es / dz + air_z / (2 * dz) + 1;
% % % % tumor_m_v    = 2 * tumor_m - 1;
% % % % tumor_n_v    = 2 * tumor_n - 1;
% % % % tumor_ell_v  = 2 * tumor_ell - 1;

% % % Nrml_sparseS = cell(total_N_v, 1);
% % % Nrml_B_phi = zeros(total_N_v, 1);
% % % % Normalize each rows
% % % for idx = 1: 1: total_N_v
% % %     tmp_vector = sparseS{ idx };
% % %     num = uint8(size(tmp_vector, 2)) / 2;
% % %     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
% % %     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
% % %     Nrml_sparseS{ idx } = tmp_vector;
% % %     Nrml_B_phi( idx ) = B_phi( idx ) ./ MAX_row_value;
% % % end

% % % % === % ============== % === %
% % % % === % GMRES solution % === %
% % % % === % ============== % === %
% % % tol = 1e-6;
% % % ext_itr_num = 5;
% % % int_itr_num = 20;

% % % bar_x_my_gmres = zeros(size(B_phi));
% % % M_S = mySparse2MatlabSparse( Nrml_sparseS, total_N_v, total_N_v, 'Row' );
% % % tic;
% % % disp('Calculation time of iLU: ')
% % % [ L_S, U_S ] = ilu( M_S, struct('type', 'ilutp', 'droptol', 1e-2) );
% % % toc;
% % % tic;
% % % disp('The gmres solutin of M_S x = B_phi: ');
% % % bar_x_my_gmresPhi = gmres( M_S, Nrml_B_phi, int_itr_num, tol, ext_itr_num, L_S, U_S );
% % % % bar_x_my_gmres = my_gmres( sparseS, B_phi, int_itr_num, tol, ext_itr_num );
% % % toc;

% % % % to-do
% % % % implement the plotting function
% % % FigsScriptEsophagusEQS_Fine;
% % % save('1001EsophagusEQS.mat');
% % % return;

% === === === === === === === === % ============================ % === === === === === === === === %
% === === === === === === === === % Preparing Q_s and BndryTable % === === === === === === === === %
% === === === === === === === === % ============================ % === === === === === === === === %
% filling BndryTable in domain A
BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 13: bolus-muscle boundary
n_far  = y_idx_max - 1;
n_near = 2;
BM_bndryNum = 13;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n >= n_near && n <= n_far && mediumTable(m, n, ell) == BM_bndryNum
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        BndryTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
            = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, ...
                BndryTable(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1), BM_bndryNum );
    end
end
BndryTable(:, 1, :) = BndryTable(:, 2, :);
BndryTable(:, end, :) = BndryTable(:, end - 1, :);

% Extract from BndryTable to mediumTable_B 
m_v_Lft = (2 * m_Lft - 1) - 1;
n_v_Near = (2 * n_Near - 1) - 1;
ell_v_Dwn = (2 * ell_Dwn - 1) - 1;

% top-right-far
m_v_Rght = (2 * m_Rght - 1) + 1;
n_v_Far = (2 * n_Far - 1) + 1;
ell_v_Top = (2 * ell_Top - 1) + 1;

% start from here.
% check the two function A_MNEllv_2_B_MNEll.m and A_MNEllv_2_B_MNEllv.m
tic;
disp('mediumTable_B Inherent The BndryTable In Domain A');
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    if BndryTable( m_v, n_v, ell_v ) && m_v <= m_v_Rght && m_v >= m_v_Lft ...
            && n_v <= n_v_Far && n_v >= n_v_Near && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn
        [ m_B, n_B, ell_B ] = A_MNEllv_2_B_MNEll(m_v, n_v, ell_v, w_x_B, w_y_B, w_z_B);
        mediumTable_B( m_B, n_B, ell_B ) = BndryTable( m_v, n_v, ell_v );
    end
end
toc;

EsoTumorBndry = 42;
% filling BndryTable_B in domain B
BndryTable_B = zeros( x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );
for idx_B = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m_B, n_B, ell_B ] = getMNL(idx_B, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    if mediumTable_B(m_B, n_B, ell_B) == BM_bndryNum && m_B >= 2 && m_B <= x_idx_max_B - 1 ...
            && n_B >= 2 && n_B <= y_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1 
        m_v_B = 2 * m_B - 1;
        n_v_B = 2 * n_B - 1;
        ell_v_B = 2 * ell_B - 1;
        BndryTable_B(m_v_B - 1: m_v_B + 1, n_v_B - 1: n_v_B + 1, ell_v_B - 1: ell_v_B + 1) ...
            = getSheetPnts(m_B, n_B, ell_B, x_idx_max_B, y_idx_max_B, shiftedCoordinateXYZ_B, mediumTable_B, ...
                BndryTable_B(m_v_B - 1: m_v_B + 1, n_v_B - 1: n_v_B + 1, ell_v_B - 1: ell_v_B + 1), BM_bndryNum );
    end
end

BndryTable_B(21, :, 21) = EsoTumorBndry;
BndryTable_B(22, :, 22) = EsoTumorBndry;
BndryTable_B(23, :, 23) = EsoTumorBndry;
BndryTable_B(24, :, 22) = EsoTumorBndry;
BndryTable_B(25, :, 21) = EsoTumorBndry;
BndryTable_B(24, :, 20) = EsoTumorBndry;
BndryTable_B(23, :, 19) = EsoTumorBndry;
BndryTable_B(22, :, 20) = EsoTumorBndry;

% if mediumTable_B(m_B, n_B, ell_B) == EsoTumorBndry && m_B >= 2 && m_B <= x_idx_max_B - 1 ...
%             && n_B >= 2 && n_B <= y_idx_max_B - 1 && ell_B >= 2 && ell_B <= z_idx_max_B - 1
%     m_v_B = 2 * m_B - 1;
%     n_v_B = 2 * n_B - 1;
%     ell_v_B = 2 * ell_B - 1;
%     BndryTable_B(m_v_B - 1: m_v_B + 1, n_v_B - 1: n_v_B + 1, ell_v_B - 1: ell_v_B + 1) ...
%         = getSheetPnts(m_B, n_B, ell_B, x_idx_max_B, y_idx_max_B, shiftedCoordinateXYZ_B, mediumTable_B, ...
%             BndryTable_B(m_v_B - 1: m_v_B + 1, n_v_B - 1: n_v_B + 1, ell_v_B - 1: ell_v_B + 1), EsoTumorBndry );
% end

% mask EsoTumorBndry as BM_bndryNum
BndryTable_B(find(BndryTable_B == EsoTumorBndry)) = BM_bndryNum;

% % return;
% Set boundary SegMed back to an valid medium number, i.e. 1
SegMed = setBndrySegMed(SegMed, 1, x_idx_max, y_idx_max, z_idx_max);
SegMed_B = setBndrySegMed(SegMed_B, 1, x_idx_max_B, y_idx_max_B, z_idx_max_B);

bar_x_my_gmres1 = bar_x_my_gmresPhi;
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
Q_s    = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
tic;
disp('Calclation Time Of SigmeE And Q_s In Domain A');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    Phi27 = zeros(3, 9);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
    [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    Phi27 = bar_x_my_gmresPhi(PntsIdx);

    [ SigmaE(m, n, ell, :, :, :), Q_s(m, n, ell, :, :) ] = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), sigma, j * Omega_0 * Epsilon_0 * epsilon_r_pre );
end
toc;

SigmaE_B = zeros(x_idx_max_B, y_idx_max_B, z_idx_max_B, 6, 8, 3);
Q_s_B    = zeros(x_idx_max_B, y_idx_max_B, z_idx_max_B, 6, 8);
tic;
disp('Calclation Time Of SigmeE And Q_s In Domain B');
for idx_B = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m_B, n_B, ell_B ] = getMNL(idx_B, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v_B = 2 * m_B - 1;
    n_v_B = 2 * n_B - 1;
    ell_v_B = 2 * ell_B - 1;
    Phi27        = zeros(3, 9);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
    [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt_B );
    PntsIdx = get27Pnts_KEV( m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt_B );
    Phi27 = bar_x_my_gmresPhi(PntsIdx + N_v);

    % the SigmaE_B cannot be used in the following code !!!
    [ SigmaE_B(m_B, n_B, ell_B, :, :, :), Q_s_B(m_B, n_B, ell_B, :, :) ] = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m_B, n_B, ell_B, :, :) ), sigma, j * Omega_0 * Epsilon_0 * epsilon_r_pre );
end
toc;
% Set boundary SegMed to byndCD
SegMed = setBndrySegMed(SegMed, byndCD, x_idx_max, y_idx_max, z_idx_max);
SegMed_B = setBndrySegMed(SegMed_B, byndCD, x_idx_max_B, y_idx_max_B, z_idx_max_B);

% === % =========== % === %
% === % Getting Q_s % === %
% === % =========== % === % 
Q_s_Vector       = zeros(ExpandedNum, 1);
% to-do
% the facets and line boundary tetrahdron are ignored
tic;
disp('Rearranging Q_s In Domain A:');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntQ_s          = zeros(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze(Q_s(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    Q_s_Vector( 48 * (idx - 1) + 1: 48 * idx ) = PntQ_s;
end
toc;

tic;
disp('Rearrangement of Q_s_B In Domain B: ');
BaseIdx = 48 * x_idx_max * y_idx_max * z_idx_max;
for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntQ_s          = zeros(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze(Q_s_B(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    Q_s_Vector( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntQ_s;
end
toc;

Q_s_Vector(~validTetTable) = [];

% return;
% === === === === === === === === % ================ % === === === === === === === === %
% === === === === === === === === % Temperature part % === === === === === === === === %
% === === === === === === === === % ================ % === === === === === === === === %
dt = 15; % 20 seconds
loadThermalParas_Esophagus;
Q_s_Vector_mod = Q_s_Vector;

% m_U   = cell(total_N_v, 1);
% m_V   = cell(total_N_v, 1);
% bar_d = zeros(total_N_v, 1);
% tic;
% disp('The Filling Time of m_U, m_V and d in Finner Grid Coordinate: ');
% % note for the boudary point, i.e., fillTop_A, fillBttm_A, fillRight_A, fillLeft_A, fillFront_A, fillBack_A
% tic;
% parfor vIdx = 1: 1: total_N_v
%     bioValid = false;
%     % vFlag = 0, 1, 2 and 3 correspond to invalid AinB, valid A, valid A boundary and valid B, respectively.
%     vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz );
%     if vFlag == 0 || vFlag == 2 % invalid AinB || valid A boundary
%         m_U{ vIdx } = [ vIdx, 1 ];
%         m_V{ vIdx } = [ vIdx, 1 ];
%     else % vFlag == 1 || vFlag == 3 ( valid A || valid B )
%         U_row = zeros(1, total_N_v);
%         V_row = zeros(1, total_N_v);
%         Pnt_d = 0;
%         CandiTet = find( MedTetTable_B(:, vIdx));
%         for itr = 1: 1: length(CandiTet)
%             % v is un-ordered vertices; while p is ordered vertices.
%             TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
%             v1234 = TetRow(1: 4);
%             if length(v1234) ~= 4
%                 error('check');
%             end
%             MedVal = TetRow(5);
%             % this judgement below is based on the current test case
%             if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
%                 error('check');
%             end
%             if MedVal >= 3 && MedVal <= 9
%                 bioValid = true;
%                 p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
%                 [ U_row, V_row, Pnt_d ] = fillUVd_B( p1234, N_v, U_row, V_row, Pnt_d, ...
%                             dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
%                             x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
%                             w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
%                             Vertex_Crdnt, Vertex_Crdnt_B, BndryTable, BndryTable_B, BM_bndryNum );
%             end
%         end
%         if bioValid
%             m_U{vIdx} = Mrow2myRow(U_row);
%             m_V{vIdx} = Mrow2myRow(V_row);
%             bar_d(vIdx) = Pnt_d;
%         else
%             m_U{vIdx} = [vIdx, 1];
%             m_V{vIdx} = [vIdx, 1];
%         end
%     end
% end
% toc;

% M_U   = sparse(total_N_v, total_N_v);
% M_V   = sparse(total_N_v, total_N_v);
% tic;
% disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
% M_U = mySparse2MatlabSparse( m_U, total_N_v, total_N_v, 'Row' );
% M_V = mySparse2MatlabSparse( m_V, total_N_v, total_N_v, 'Row' );
% toc;

bar_d = zeros(total_N_v, 1);
disp('The filling time d_m: ');
tic;
parfor vIdx = 1: 1: total_N_v
    Pnt_d = 0;
    vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz );
    if vFlag == 1 || vFlag == 3 % valid A || valid B )
        CandiTet = find( MedTetTable_B(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            % v is un-ordered vertices; while p is ordered vertices.
            % fix the problem in the determination of v1234 here .
            TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            if length(v1234) ~= 4
                error('check');
            end
            MedVal = TetRow(5);
            % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
            % this judgement below is based on the current test case
            % if MedVal == 5 
            if MedVal >= 3 && MedVal <= 9
                %               %  air,  bolus, muscle, lung, tumor, bone, fat
                % Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5 ]';
                if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
                    error('check');
                end
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx))); 
                Pnt_d = filld_Fine( p1234, N_v, Pnt_d, ...
                                dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                                w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                Vertex_Crdnt, Vertex_Crdnt_B, ...
                                BndryTable, BndryTable_B, BM_bndryNum );
            end
        end
        bar_d(vIdx) = Pnt_d;
    end
end
toc;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %
tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(total_N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
timeNum_all = 50 * 60; % 50 minutes
bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %
tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

flagX  = zeros(1, timeNum_all / dt + 1);
relres = zeros(1, timeNum_all / dt + 1);
tic;
for idx = 2: 1: size(bar_b, 2)
    [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
    % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %
T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;
% to-do
% implement the plotting function 
T_plot_Esophagus;
% save('0922EsophagusEQS_v2.mat');
return;

% === === === === === === === === % ========== % === === === === === === === === %
% === === === === === === === === % K part (2) % === === === === === === === === %
% === === === === === === === === % ========== % === === === === === === === === %

% === % ==================== % === %
% === % Parameters used in K % === %
% === % ==================== % === %

              % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
mu_prime      = [   1,     1,      1,     1,     1,     1,     1 ]';
mu_db_prime   = [   0,     0,      0,     0,     0,     0,     0 ]';
% mu_db_prime   = [ 0,    0.62 ]';
mu_r          = mu_prime - i * mu_db_prime;

% === % =============================== % === %
% === % Constructing The Directed Graph % === %
% === % =============================== % === %

starts = [];
ends = [];
vals = [];
borderFlag = false(1, 6);
disp('Constructing the directed graph');
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
    if strcmp(flag, '000') && ~mod(ell_v, 2)
        [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
    end
end
G = sparse(ends, starts, vals, N_v, N_v);
toc;
[ P2, P1, Vals ] = find(G);
[ Vals, idxSet ] = sort(Vals);
P1 = P1(idxSet);
P2 = P2(idxSet);
l_G = length(P1);

% undirected graph
uG = G + G';

% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %

B_k = zeros(N_e, 1);
m_K1 = cell(N_e, 1);
m_K2 = cell(N_e, 1);
m_KEV = cell(N_e, 1);
m_KVE = cell(1, N_e);
edgeChecker = false(l_G, 1);
cFlagChecker = false(l_G, 1);
BioFlag = true(N_v, 1);

tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
for eIdx = 1: 1: l_G
    % eIdx = full( G(P2(lGidx), P1(lGidx)) );
    Candi = [];
    % get candidate points
    P1_cand = uG(:, P1(eIdx));
    P2_cand = uG(:, P2(eIdx));
    P1_nz = find(P1_cand);
    P2_nz = find(P2_cand);
    for CandiFinder = 1: 1: length(P1_nz)
        if find(P2_nz == P1_nz(CandiFinder))
            Candi = horzcat(Candi, P1_nz(CandiFinder));
        end
    end
    % get adjacent tetrahdron
    K1_6 = sparse(1, N_e); 
    K2_6 = sparse(1, N_e); 
    Kev_4 = sparse(1, N_e); 
    Kve_4 = sparse(N_e, 1); 
    B_k_Pnt = 0;
    cFlag = false;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                % MedVal = MedTetTable( tetRow, v1234(1) );
                % use tetRow to check the accordance of SigmaE and J_xyz
                % start from fix Vrtx_bndry Pb2
                [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                    G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), ...
                    Vrtx_bndry( P1(eIdx) ), Vrtx_bndry( P2(eIdx) ), Vrtx_bndry( Candi(itr) ), Vrtx_bndry( Candi(TetFinder) ), ...
                    K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt, J_xyz(tetRow, :), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
            end
        end
    end

    if isempty(K1_6) || isempty(K2_6) || isempty(Kev_4)
        disp('K1, K2 or KEV: empty');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if isnan(K1_6) | isinf(K1_6) | isnan(K2_6) | isinf(K2_6)
        disp('K1 or K2: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if isnan(Kev_4) | isinf(Kev_4)
        disp('Kev: NaN or Inf');
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
    end
    if edgeChecker(eIdx) == true
        lGidx
        [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        [ m_v, n_v, ell_v, edgeNum ]
        error('check')
    end

    edgeChecker(eIdx) = true;
    
    m_K1{eIdx} = Mrow2myRow(K1_6);
    m_K2{eIdx}  = Mrow2myRow(K2_6);
    m_KEV{eIdx} = Mrow2myRow(Kev_4);
    m_KVE{eIdx} = Mrow2myRow(Kve_4')';
    B_k(eIdx) = B_k_Pnt;
end
toc;

M_K1 = sparse(N_e, N_e);
M_K2 = sparse(N_e, N_e);
M_KEV = sparse(N_e, N_v);
M_KVE = sparse(N_v, N_e);
tic;
disp('Transfroming M_K1, M_K2, M_KEV and M_KVE')
M_K1 = mySparse2MatlabSparse( m_K1, N_e, N_e, 'Row' );
M_K2 = mySparse2MatlabSparse( m_K2, N_e, N_e, 'Row' );
M_KEV = mySparse2MatlabSparse( m_KEV, N_e, N_v, 'Row' );
M_KVE = mySparse2MatlabSparse( m_KVE, N_v, N_e, 'Col' );
toc;

% === % ========== % === %
% === % GVV matrix % === %
% === % ========== % === %

% modify according to Regular Tetrahedra version.
sparseGVV = cell(1, N_v);
disp('The filling time of G_VV: ');
tic;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    flag = getMNL_flag(m_v, n_v, ell_v);
    GVV_SideFlag = false(1, 6);
    GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
    if isempty( find( GVV_SideFlag ) )
        sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                                            z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
    else
        sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    end
end
toc;

% === % =================== % === %
% === % Calculation of SPAI % === %
% === % =================== % === %

TEX = 'Right';
CaseTEX = 'Case1';
Tol = 0.2;
GVV_test; % a script
% load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

% === % ========================= % === %
% === % Matrices product to get K % === %
% === % ========================= % === %

M_K = sparse(N_e, N_e);
M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% === % ============================ % === %
% === % Sparse Normalization Process % === %
% === % ============================ % === %

tic;
disp('Time for normalization');
sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
nrmlM_K = sptmp * M_K;
nrmlB_k = sptmp * B_k;
toc;

% === % ============================================================ % === %
% === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% === % ============================================================ % === %

tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

bar_x_my_gmres = zeros(size(nrmlB_k));
tic;
disp('Calculation time of iLU: ')
[ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
toc;
% tic; 
% disp('Computational time for solving Ax = b: ')
% bar_x_my_gmres = nrmlM_K\nrmlB_k;
% toc;
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
toc;

w_y = h_torso;
w_x = air_x;
w_z = air_z;
AFigsScript;

% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;