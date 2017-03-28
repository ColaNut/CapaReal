% clc; clear;
digits;

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
% V_0           = 89; 

% Note, the corresponding 

% paras1
% rho           = [ 1,  1020,  1020,  1050, 1040 ]';
              % air, bolus, muscle, lung  tumor , bone,   fat
rho           = [ 1,  1020,  1020, 242.6,  1040,  1790,   900 ]';
% epsilon_r_pre = [ 1, 113.0,   184, 264.9,  402,    7.3]';
% sigma         = [ 0,  0.61, 0.685,  0.42, 0.68, 0.028 ]';
epsilon_r_pre = [ 1, 113.0,   113, 264.9,   402,   7.3,    20 ]';
sigma         = [ 0,  0.61,  0.61,  0.42,  0.68, 0.028, 0.047 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % paras2: 100 kHz, the bone are left unchanged.
% rho           = [ 1,  1020,  1020, 242.6,  1040,  1020,  1020 ]';
% epsilon_r_pre = [ 1,   357,  9658,  7175,  8952,  9658, 48.94 ]';
% sigma         = [ 0,  0.88,  0.21,  0.23, 0.402,  0.21, 0.0237 ]';
% epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % paras3: 1 MHz, the bone are left unchanged.
% rho           = [ 1, 1020,  1020, 242.6,  1040,  1020,  1020 ]';
% epsilon_r_pre = [ 1,    1,  1781,  1239,  1775,  1781, 20.31 ]';
% sigma         = [ 0,  0.7,  0.59,  0.31,  0.51,  0.59, 0.0237 ]';
% epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % 3 cm bolus, no fat, bolus sigma modification case 1 
% rho           = [ 1,  1020,  1020, 242.6,  1040,  1790,  1020 ]';
% epsilon_r_pre = [ 1, 113.0,   113, 264.9,   402,   7.3,   113 ]';
% sigma         = [ 0,  0.61,  0.61,  0.42,  0.68, 0.028,  0.61 ]';
% epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % 3 cm bolus, no fat, bolus sigma modification case 2 
% rho           = [ 1,  1020,  1020, 242.6,  1040,  1790,  1020 ]';
% epsilon_r_pre = [ 1,  76.5,   113, 264.9,   402,   7.3,   113 ]';
% sigma         = [ 0,  0.85,  0.61,  0.42,  0.68, 0.028,  0.61 ]';
% epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% % paras set: 
%               % air, bolus, muscle, lung  tumor , bone,   fat
% rho           = [ 1,  1020,  1020, 242.6,  1040,  1790,   900 ]';
% epsilon_r_pre = [ 1, 113.0,   113, 264.9,   402,   7.3,    20 ]';
% sigma         = [ 0,  0.61,  0.61,  0.42,  0.68, 0.028, 0.047 ]';

% f = Omega_0 / ( 2 * pi );
% T = 5;
% % S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% EPSILON_R = zeros(size(S));
% SIGMA = zeros(size(S));
% for idx = 1: 1: length(S)
%     [ EPSILON_R(idx), SIGMA(idx) ] = getEpsSig(f, S(idx), T);
% end
% DiProp = [ EPSILON_R, SIGMA ];
% % Conc = 0;
% switch Conc
%     case 0
%         epsilon_r_pre(2) = DiProp(1, 1);
%         sigma(2) = DiProp(1, 2);
%     case 1
%         epsilon_r_pre(2) = DiProp(2, 1);
%         sigma(2) = DiProp(2, 2);
%     case 2
%         epsilon_r_pre(2) = DiProp(3, 1);
%         sigma(2) = DiProp(3, 2);
%     case 3
%         epsilon_r_pre(2) = DiProp(4, 1);
%         sigma(2) = DiProp(4, 2);
%     case 4
%         epsilon_r_pre(2) = DiProp(5, 1);
%         sigma(2) = DiProp(5, 2);
%     case 5
%         epsilon_r_pre(2) = DiProp(6, 1);
%         sigma(2) = DiProp(6, 2);
%     case 6
%         epsilon_r_pre(2) = DiProp(7, 1);
%         sigma(2) = DiProp(7, 2);
%     case 7
%         epsilon_r_pre(2) = DiProp(8, 1);
%         sigma(2) = DiProp(8, 2);
%     case 8
%         epsilon_r_pre(2) = DiProp(9, 1);
%         sigma(2) = DiProp(9, 2);
%     case 9
%         epsilon_r_pre(2) = DiProp(10, 1);
%         sigma(2) = DiProp(10, 2);
%     case 10
%         epsilon_r_pre(2) = DiProp(11, 1);
%         sigma(2) = DiProp(11, 2);
%     otherwise
%         error('chcek');
% end

% epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
loadParas;
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
% Normal Points: [ air, bolus, muscle, lung, tumor, ribs, spine, sternum ] -> [  1,  2,  3,  4,  5,  6,  7,  8 ]
% Interfaces:    [ air-bolus, bolus-muscle, muscle-lung, lung-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
% Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 

for y = - h_torso / 2: dy: h_torso / 2
    paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    % paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
    %     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
    %     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
    %     tumor_x, tumor_z, tumor_r_prime ];
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    mediumTable(:, int64(y_idx), :) = getRoughMed( mediumTable(:, int64(y_idx), :), paras2dXZ, dx, dz );
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all( paras2dXZ, dx, dz, mediumTable(:, int64(y_idx), :) );
end

% 1 to 7, corresponding to 1-st to 7-th rib.
RibValid = 0; 
SSBoneValid = false;
BoneMediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
BoneGridShiftTableXZ = cell( h_torso / dy + 1, 1);

for y = - h_torso / 2: dy: h_torso / 2
    [ RibValid, SSBoneValid ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    [ GridShiftTableXZ{ int64(y_idx) }, BoneMediumTable(:, int64(y_idx), :) ] ...
        = UpdateBoneMed( y, mediumTable(:, int64(y_idx), :), Ribs, SSBone, RibValid, SSBoneValid, ...
                            dx, dz, air_x, air_z, x_idx_max, z_idx_max, GridShiftTableXZ{ int64(y_idx) } );
end

for x = - air_x / 2: dx: air_x / 2
    paras2dYZ = genParas2dYZ( x, paras, dy, dz );
    % paras2dYZ = [ h_torso, air_x, air_z, bolus_a, bolusHghtZ, skin_a, skin_c, muscle_a, muscleHghtZ, ...
    %     l_lung_y, l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
    %     r_lung_y, r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
    %     tumor_y, tumor_z, tumor_r_prime ];
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

% for x = tumor_x: dx: r_lung_x + r_lung_a
%     x_idx = x / dx + air_x / (2 * dx) + 1;
%     The following function: plotYZ has been changed.
%     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
%     figure(int64(x_idx));
%     plotYZ_Grid( h_torso, air_z, dy, dz );
%     plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz );
% end

% % BlsBndryMsk = zeros(x_idx_max, z_idx_max);c  
% % BlsBndryMsk = get1cmBlsBndryMsk( bolus_a, bolus_c, muscle_a, muscle_c, dx, dz, x_idx_max, z_idx_max, air_x, air_z );

sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');
% % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Mask the medium table
MskMedTab = mediumTable;
% normal point remains the same, the boundary point are forced to zero
MskMedTab( find(MskMedTab >= 10) ) = 0;

% disp('The fill up time of A: ');
% tic;
% % for idx = 29 * x_idx_max * y_idx_max: 1: 30 * x_idx_max * y_idx_max 
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     p0 = idx;
%     if m == 18 && n == 2 && ell == 30
%         ;
%     end

%     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         if MskMedTab(p0) ~= 0 && BoneMediumTable(p0) == 1 % normal normal point
%         % if mediumTable(p0) == 1 || mediumTable(p0) == 2 || mediumTable(p0) == 3 || mediumTable(p0) == 4 || mediumTable(p0) == 5 
%             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
%                             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
%         elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 1 % normal bondary point
%             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
%                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
%                 epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%         elseif MskMedTab(p0) ~= 0 && BoneMediumTable(p0) >= 16 && BoneMediumTable(p0) <= 18 % rib normal point
%             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
%                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
%                     MskMedTab, BoneMediumTable, epsilon_r );
%         elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 16  % rib boundary point
%             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
%                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
%                     MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%         else
%             error('check');
%         end
%         % elseif MskMedTab(p0) ~= 0 && BoneMediumTable == 16
%         %     [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
%         %                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, BoneMediumTable );
%         % elseif MskMedTab(p0) == 0 && BoneMediumTable == 16
%         % else 
%         %     % spine and sternum
%         % end
%     elseif ell == z_idx_max
%         sparseA{ p0 } = fillTop_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif ell == 1
%         sparseA{ p0 } = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
%         sparseA{ p0 } = fillRight_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
%         sparseA{ p0 } = fillLeft_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         sparseA{ p0 } = fillFront_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         sparseA{ p0 } = fillBack_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
%     end
% end
% toc;

% % for idx = 29 * x_idx_max * y_idx_max: 1: 30 * x_idx_max * y_idx_max 
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     p0 = idx;

%     if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
%         if mediumTable(p0) == 11 % air-bolus boundary pnt
%             % check the validity of the LHS accepance.
%             % update the bolus
%             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
%                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'inner' );

%             [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
%                 shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
%                 epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );

%         elseif mediumTable(p0) == 13 % bolus-muscle pnt
%             % update the bolus
%             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
%                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 2, 'outer' );
%             % update the fat tissue
%             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
%                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'inner' );

%             if BoneMediumTable(p0) == 1 % normal bondary point
%                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
%                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
%                     epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%             elseif BoneMediumTable(p0) == 16  % rib boundary point
%                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
%                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
%                         MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%             else
%                 error('check');
%             end
%         elseif mediumTable(p0) == 12 % fat-muscle
%             % update the fat tissue
%             SegMed(m, n, ell, :, :) = BndryUpdate( m, n, ell, shiftedCoordinateXYZ, ...
%                                             squeeze( SegMed(m, n, ell, :, :) ), mediumTable, 7, 'outer' );
%             if MskMedTab(p0) ~= 0
%                 error('check');
%             end
%             if BoneMediumTable(p0) == 1 % normal bondary point
%                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
%                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
%                     epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%             elseif BoneMediumTable(p0) == 16  % rib boundary point
%                 [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
%                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
%                         MskMedTab, BoneMediumTable, epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
%             else
%                 error('check');
%             end

%         end
%     end
% end

% the above process update the medium value and construct the shiftedCoordinateXYZ
x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
N_v = x_max_vertex * y_max_vertex * z_max_vertex;
N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
    + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
    - ( (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1) );

Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
% tic;
% Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% toc;
% save('FEM_fullwave.mat', 'Vertex_Crdnt', 'SegMed');
load('FEM_fullwave.mat');

% slightly modify the SegMed
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if m == 1 || m == x_idx_max || ell == 1 && ell == z_idx_max 
        SegMed(m, n, ell, :, :) = uint8(1);
    end
end 
toc;

tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n == 1 || n == y_idx_max
        tmpSeg = zeros(6, 8, 'uint8');
        SegCopy = zeros(8, 1, 'uint8');
        SegCopy(1) = SegMed(m, 2, ell, 4, 1);
        SegCopy(2) = SegMed(m, 2, ell, 1, 1);
        SegCopy(3) = SegMed(m, 2, ell, 1, 3);
        SegCopy(4) = SegMed(m, 2, ell, 2, 1);
        SegCopy(5) = SegMed(m, 2, ell, 2, 5);
        SegCopy(6) = SegMed(m, 2, ell, 3, 1);
        SegCopy(7) = SegMed(m, 2, ell, 3, 3);
        SegCopy(8) = SegMed(m, 2, ell, 4, 5);

        tmpSeg(4, 1) = SegCopy(1); tmpSeg(4, 2) = SegCopy(1); tmpSeg(4, 3) = SegCopy(1); tmpSeg(4, 4) = SegCopy(1); tmpSeg(5, 4) = SegCopy(1); tmpSeg(6, 1) = SegCopy(1);
        tmpSeg(1, 1) = SegCopy(2); tmpSeg(1, 2) = SegCopy(2); tmpSeg(1, 7) = SegCopy(2); tmpSeg(1, 8) = SegCopy(2); tmpSeg(5, 3) = SegCopy(2); tmpSeg(6, 2) = SegCopy(2); 
        tmpSeg(1, 3) = SegCopy(3); tmpSeg(1, 4) = SegCopy(3); tmpSeg(1, 5) = SegCopy(3); tmpSeg(1, 6) = SegCopy(3); tmpSeg(5, 2) = SegCopy(3); tmpSeg(6, 3) = SegCopy(3); 
        tmpSeg(2, 1) = SegCopy(4); tmpSeg(2, 2) = SegCopy(4); tmpSeg(2, 3) = SegCopy(4); tmpSeg(2, 4) = SegCopy(4); tmpSeg(5, 1) = SegCopy(4); tmpSeg(6, 4) = SegCopy(4); 
        tmpSeg(2, 5) = SegCopy(5); tmpSeg(2, 6) = SegCopy(5); tmpSeg(2, 7) = SegCopy(5); tmpSeg(2, 8) = SegCopy(5); tmpSeg(5, 8) = SegCopy(5); tmpSeg(6, 5) = SegCopy(5); 
        tmpSeg(3, 1) = SegCopy(6); tmpSeg(3, 2) = SegCopy(6); tmpSeg(3, 7) = SegCopy(6); tmpSeg(3, 8) = SegCopy(6); tmpSeg(5, 7) = SegCopy(6); tmpSeg(6, 6) = SegCopy(6); 
        tmpSeg(3, 3) = SegCopy(7); tmpSeg(3, 4) = SegCopy(7); tmpSeg(3, 5) = SegCopy(7); tmpSeg(3, 6) = SegCopy(7); tmpSeg(5, 6) = SegCopy(7); tmpSeg(6, 7) = SegCopy(7); 
        tmpSeg(4, 5) = SegCopy(8); tmpSeg(4, 6) = SegCopy(8); tmpSeg(4, 7) = SegCopy(8); tmpSeg(4, 8) = SegCopy(8); tmpSeg(5, 5) = SegCopy(8); tmpSeg(6, 8) = SegCopy(8); 
        SegMed(m, n, ell, :, :) = tmpSeg;
    end
end 
toc;

% flag = '000';
% load('Case0317.mat');
% clearvars sparseS B_phi;
% sparseS = cell( N_v, 1 );
% B_phi = zeros(N_v, 1);
B_phi = zeros(N_v, 1);
sparseS = cell( N_v, 1 );

tic;
disp('The filling time of S phi = b_phi: ');
for idx = 1: 1: N_v
% for idx = x_max_vertex * y_max_vertex * 65: 1: x_max_vertex * y_max_vertex * 66
    [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
    if m >= 2  && m <= x_max_vertex - 1 && n >= 2 && n <= y_max_vertex - 1 && ell >= 2 && ell <= z_max_vertex - 1 
        flag = getMNL_flag(m, n, ell);
        % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
        % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
        SegMedIn = FetchSegMed( m, n, ell, SegMed, flag );

        sparseS{ idx } = fillNrml_S( m, n, ell, flag, ...
            Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, epsilon_r, Omega_0 );
    elseif ell == z_max_vertex
        sparseS{ idx } = fillTop_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif ell == 1
        sparseS{ idx } = fillBttm_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif m == x_max_vertex && ell >= 2 && ell <= z_max_vertex - 1 
        sparseS{ idx } = fillRight_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif m == 1 && ell >= 2 && ell <= z_max_vertex - 1 
        sparseS{ idx } = fillLeft_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif n == y_max_vertex && m >= 2 && m <= x_max_vertex - 1 && ell >= 2 && ell <= z_max_vertex - 1 
        sparseS{ idx } = fillFront_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif n == 1 && m >= 2 && m <= x_max_vertex - 1 && ell >= 2 && ell <= z_max_vertex - 1 
        sparseS{ idx } = fillBack_A( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex );
    end
end
toc;
% save('beforeElctrd_S2.mat', 'sparseS');
% load('beforeElctrd_S2.mat');

% clc; clear;
% load('Case0319.mat');
% put on electrodes
[ sparseS, B_phi ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
                                    dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );
sparseS = PutOnDwnElctrd( sparseS, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
                                    dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% [ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_c, dx, dz );
% % Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
% % Ztable = [ x1, int_grid_z, x2, int_grid_z ];
% UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );

% [ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max );
% [ sparseA, B ] = DwnElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz );

% % check empty rows
% counter = 0;
% for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     if isempty( B_phi( idx ) )
%         counter = counter + 1;
%         [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
%         [m, n, ell]
%     end
% end
% counter

% Normalize each rows
for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    tmp_vector = sparseS{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    sparseS{ idx } = tmp_vector;
    B_phi( idx ) = B_phi( idx ) ./ MAX_row_value;
end

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 40;

bar_x_my_gmres = zeros(size(B_phi));
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = my_gmres( sparseS, B_phi, int_itr_num, tol, ext_itr_num );
toc;

% save( strcat(fname, CaseName, '.mat') );
% save('Case0321_S2.mat');
% load('Case0321_S2.mat');

% PhiDstrbtn;

% CurrentEst;

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x = A \ B;
% toc;

% save('FirstTest.mat');
% PhiDstrbtn;
% FigsScript;

% count = 0;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     if A( idx, : ) == zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         count = count + 1;
%     end
% end
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]