% clc; clear;
digits;

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
% V_0           = 100; 
              % air, bolus, muscle, lung, tumor
% rho           = [ 1,  1020,  1020,  1050, 1040 ]';
rho           = [ 1,  1020,  1020, 242.6, 1040,  1790 ]';
epsilon_r_pre = [ 1, 113.0,   184, 264.9,  402,    7.3   ]';
sigma         = [ 0,  0.61, 0.685,  0.42, 0.68, 0.028 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

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
% Normal Points: [ air, bolus, muscle, lung, tumor, ribs, spine, sternum ]       -> [  1,  2,  3,  4,  5,  6,  7,  8 ]
% Interfaces:    [ air-bolus, bolus-skin, skin-muscle, muscle-lung, lung-tumor ] -> [ 11, 12, 13, 14, 15 ]
% Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]                 -> [ 16, 17, 18 ] 

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
    if y_idx == 19
        ;
    end
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
    if x_idx == 25
        ;
    end
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

% BlsBndryMsk = zeros(x_idx_max, z_idx_max);c  
% BlsBndryMsk = get1cmBlsBndryMsk( bolus_a, bolus_c, muscle_a, muscle_c, dx, dz, x_idx_max, z_idx_max, air_x, air_z );

sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

% Mask the medium table
MskMedTab = mediumTable;
% normal point remains the same, the boundary point are forced to zero
MskMedTab( find(MskMedTab >= 10) ) = 0;

disp('The fill up time of A: ');
tic;
% for idx = 26 * x_idx_max * y_idx_max: 1: 27 * x_idx_max * y_idx_max 
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    p0 = idx;

    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        if MskMedTab(p0) ~= 0 && BoneMediumTable(p0) == 1 % normal normal point
        % if mediumTable(p0) == 1 || mediumTable(p0) == 2 || mediumTable(p0) == 3 || mediumTable(p0) == 4 || mediumTable(p0) == 5 
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
                            shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
        elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 1 % normal bondary point
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, epsilon_r );
        elseif MskMedTab(p0) ~= 0 && BoneMediumTable(p0) >= 16 && BoneMediumTable(p0) <= 18 % rib normal point
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                    MskMedTab, BoneMediumTable, epsilon_r );
        elseif MskMedTab(p0) == 0 && BoneMediumTable(p0) == 16  % rib boundary point
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                    MskMedTab, BoneMediumTable, epsilon_r );
        end
        % elseif MskMedTab(p0) ~= 0 && BoneMediumTable == 16
        %     [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
        %                     shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, BoneMediumTable );
        % elseif MskMedTab(p0) == 0 && BoneMediumTable == 16
        % else 
        %     % spine and sternum
        % end
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

% % for idx = 26 * x_idx_max * y_idx_max: 1: 27 * x_idx_max * y_idx_max 
disp('The fill up time of rib A: ');
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    p0 = idx;

    if m == 16 && n == 19 && ell == 29
        ;
    end

    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        if BoneMediumTable(p0) >= 16 && BoneMediumTable(p0) <= 18 && MskMedTab(p0) ~= 0
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlRibPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                    MskMedTab, BoneMediumTable, epsilon_r );
        elseif BoneMediumTable(p0) == 16 && MskMedTab(p0) == 0
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrRibPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                    MskMedTab, BoneMediumTable, epsilon_r );
        end
    end
end
toc;

% put on electrodes
[ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_c, dx, dz );
% Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
% Ztable = [ x1, int_grid_z, x2, int_grid_z ];
UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );

[ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max );
[ sparseA, B ] = DwnElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz );

% Normalize each rows
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    tmp_vector = sparseA{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    sparseA{ idx } = tmp_vector;
    B( idx ) = B( idx ) ./ MAX_row_value;
end

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 40;

tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = my_gmres( sparseA, B, int_itr_num, tol, ext_itr_num );
toc;

% save( strcat(fname, CaseName, '.mat') );
% save('Case0103.mat');z

% PhiDstrbtn;

% CurrentEst;

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x = A \ B;
% toc;

% save('FirstTest.mat');
% PhiDstrbtn;

% count = 0;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     if A( idx, : ) == zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         count = count + 1;
%     end
% end
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]