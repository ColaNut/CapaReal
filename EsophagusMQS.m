% === === === === === === === === ===  % ========= % === === === === === === === === === %
% === === === === === === === === ===  % PreK part % === === === === === === === === === %
% === === === === === === === === ===  % ========= % === === === === === === === === === %
% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %
% to-do
% fetch the SegMed_B and Vertex_Crdnt_B from EsoEQS
clc; clear;
digits;
disp('Esophagus: MQS');
Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 1.2 * 10^6; % 2 * pi * 1.2 MHz

% parameters
              % [ air, bolus, muscle,  lung,  lung,    bone,    fat, reserved, esophageal tumor ]';
rho           = [   1,  1020,   1020,   394,   394,    1790,    900,        0,             1040 ]';
epsilon_r_pre = [   1,     1,   1387,  1102,  1102,    22.6,  20.31,        0,                1 ]'; % which is not used for MQS
sigma         = [   0,     0,   0.54,  0.33,  0.33, 0.00283, 0.0237,        0,             0.71 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
% to-do: 0922 - set the interval to 0.5 cm 
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
loadAmendParas_Esophagus;
tumor_m   = tumor_x_es / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y_es / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z_es / dz + air_z / (2 * dz) + 1;
tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;

GridShiftTableXZ = cell( h_torso / dy + 1, 1);
% GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.

mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% Normal Points: [ air, bolus, muscle, lung, lung, ribs, spine, sternum, esophageal tumor ] -> [  1,  2,  3,  4,  5,  6,  7,  8, 9 ]
% Interfaces:    [ air-bolus, bolus-muscle, muscle-lung, lung-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
% Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 
byndCD = 30; % beyond computation: 30
EsBndryNum = 31; % esophageal boundary number 
EsTumorNum = 9; % esophageal number

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
disp('Calculation of vertex coordinate');
Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
toc;

% === % ====================== % === %
% === % Filling time of SegMed % === %
% === % ====================== % === %
sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );

% Mask the medium table
MskMedTab = mediumTable;
% normal point remains the same, the boundary point are forced to zero
MskMedTab( find(MskMedTab >= 10) ) = 0;

disp('The fill up time of SegMed: ');
tic;
% for idx = 29 * x_idx_max * y_idx_max: 1: 30 * x_idx_max * y_idx_max 
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

% === % ========================================= % === %
% === % Fill the SegMed on the computation domain % === %
% === % ========================================= % === % 
% x- and z-direction.
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if m == 1 || m == x_idx_max || ell == 1 && ell == z_idx_max 
        SegMed(m, n, ell, :, :) = uint8(1);
    end
end 
% y-direction.
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

% === === % ============================================== % === === %
% === === % Amending SegMed of the esophagus and its tumor % === === %
% === === % ============================================== % === === %
% to-do: 0922
% update for the new configuration
loadAmendParas_Esophagus;
EsTumorBndryNum = 32;
mediumTable_Esphgs = mediumTable;
x_es_n = x_es / dx + air_x / (2 * dx) + 1;
y_es_n = 0 / dy + h_torso / (2 * dy) + 1;
z_es_n = z_es / dz + air_z / (2 * dz) + 1;
loadAmendParas_Esophagus_Math;

% updating the esophageal number
mediumTable_Esphgs(x_es_n    , :, z_es_n + 1) = EsBndryNum;
mediumTable_Esphgs(x_es_n - 1, :, z_es_n    ) = EsBndryNum;
mediumTable_Esphgs(x_es_n + 1, :, z_es_n    ) = EsBndryNum;
mediumTable_Esphgs(x_es_n - 1, :, z_es_n - 1) = EsBndryNum;
mediumTable_Esphgs(x_es_n + 1, :, z_es_n - 1) = EsBndryNum;
mediumTable_Esphgs(x_es_n    , :, z_es_n - 2) = EsBndryNum;
mediumTable_Esphgs(x_es_n    , :, z_es_n    ) = 1;
mediumTable_Esphgs(x_es_n    , :, z_es_n - 1) = 1;

% to-do
% updating SegMed for the esophagus
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable_Esphgs(m, n, ell) == 1
        SegMed(m, n, ell, :, :) = 1;
    elseif m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 && mediumTable_Esphgs(m, n, ell) == EsBndryNum
        SegMed( m, n, ell, :, : ) = fillBndrySegMed_Esophagus_v2( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable_Esphgs, squeeze(SegMed( m, n, ell, :, : )), EsBndryNum, EsTumorNum );
    end
end

% updating the tumor number
mediumTable_Esphgs(x_es_n - 1: x_es_n + 1, y_es_n - 1: y_es_n + 1, z_es_n - 1: z_es_n) = EsTumorBndryNum;
mediumTable_Esphgs(x_es_n, y_es_n, z_es_n + 1) = EsTumorBndryNum;
mediumTable_Esphgs(x_es_n, y_es_n, z_es_n    ) = EsTumorNum;

% to-do
% updating SegMed for the esophageal tumor 
SegMed(x_es_n, y_es_n, z_es_n, :, :) = EsTumorNum;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 && mediumTable_Esphgs(m, n, ell) == EsTumorBndryNum
        SegMed( m, n, ell, :, : ) = fillBndrySegMed_Esophagus_v2( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable_Esphgs, squeeze(SegMed( m, n, ell, :, : )), EsBndryNum, EsTumorNum );
    end
end
SegMed(x_es_n, y_es_n, z_es_n - 1, 1, :) = EsTumorNum;

% return;

% === === % =========================== % === === %
% === === % Extract the 10x10x10 volume % === === %
% === === % =========================== % === === %
% to-do
% inherent the SegMed

% apply the above boundary idx to the following code, namely, x_idx_max, tumor_m_v, N_v

% === === === === === === === === % ========== % === === === === === === === === %
% === === === === === === === === % K part (1) % === === === === === === === === %
% === === === === === === === === % ========== % === === === === === === === === %
% === % ==================== % === %
% === % Parameters used in K % === %
% === % ==================== % === %
load('0922EsoBeforeElctrd.mat')
tumor_m   = tumor_x_es / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y_es / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z_es / dz + air_z / (2 * dz) + 1;
tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;

Omega_0       = 2 * pi * 1.2 * 10^6; % 2 * pi * 1.2 MHz

% parameters
              % [ air, bolus, muscle,  lung,  lung,    bone,    fat, reserved, esophageal tumor ]';
rho           = [   1,  1020,   1020,   394,   394,    1790,    900,        0,             1040 ]';
epsilon_r_pre = [   1,     1,   1387,  1102,  1102,    22.6,  20.31,        0,                1 ]'; % which is not used for MQS
sigma         = [   0,     0,   0.54,  0.33,  0.33, 0.00283, 0.0237,        0,             0.71 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

              %     1      2       3      4      5      6      7         8                 9
              % [ air, bolus, muscle,  lung,  lung,  bone,   fat, reserved, esophageal tumor ]';
mu_prime      = [   1,     1,      1,     1,     1,     1,     1,        0,                1 ]';
mu_db_prime   = [   0,     0,      0,     0,     0,     0,     0,        0,              0.3 ]';
mu_r          = mu_prime - i * mu_db_prime;

% === % ==================================== % === %
% === % Trimming: Invalid set to 30 (byndCD) % === %
% === % ==================================== % === % 
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
end

% === === % ======================= % === === %
% === === % Getting MedTetTableCell % === === %
% === === % ======================= % === === %
% to-do: modify after the EQS case.
load('0922EsophagusEQS.mat', 'MedTetTableCell');
% tic;
% disp('Getting MedTetTableCell: ');
% MedTetTableCell  = cell(0, 1);
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;
%     PntMedTetTableCell  = cell(48, 1);
%     % rearrange (6, 8, 3) to (48, 3);
%     PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );

%     % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
%     MedTetTableCell  = vertcat(MedTetTableCell, PntMedTetTableCell(validTet));
% end
% toc;
validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(MedTetTableCell, 1) ~= validNum
    error('check the construction');
end

MedTetTable = sparse(validNum, N_v);
tic;
disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
MedTetTable = mySparse2MatlabSparse( MedTetTableCell, validNum, N_v, 'Row' );
toc;

% === % =============================== % === %
% === % Constructing The Directed Graph % === %
% === % =============================== % === %
load('0920EsoMQS_T.mat', 'G')
% starts = [];
% ends = [];
% vals = [];
% borderFlag = false(1, 6);
% disp('Constructing the directed graph');
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
%     if strcmp(flag, '000') && ~mod(ell_v, 2)
%         [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
%     end
% end
% G = sparse(ends, starts, vals, N_v, N_v);
% toc;
[ P2, P1, Vals ] = find(G);
[ Vals, idxSet ] = sort(Vals);
P1 = P1(idxSet);
P2 = P2(idxSet);
l_G = length(P1);
% undirected graph
uG = G + G';

Vrtx_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
%  2: computational domain boundary
n_far  = y_idx_max - 1;
n_near = 2;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    if my_F(borderFlag, 1)
        Vrtx_bndry(m_v, n_v, ell_v) = 2;
    end
end

save('0922EsoMQS_preK.mat');
return;
% grid shift error of circular current sheet
% === % ========================== % === %
% === % Unite Eight Octant K value % === %
% === % ========================== % === %
% to-do
% getting K1 matrix and b_k vector.

% get previous K value
% total_B_k = zeros(N_e, 1);
total_m_K1 = cell(N_e, 1);
% total_m_K2 = cell(N_e, 1);
% total_m_KEV = cell(N_e, 1);
% total_m_KVE = cell(1, N_e);
load('E:\Kevin\CapaReal\0721\0721K_Q1.mat', 'm_K1');
% load('E:\Kevin\CapaReal\0721\0721K_Q1.mat', 'm_K1', 'm_K2', 'm_KEV', 'm_KVE');
% total_B_k(1: l_G / 4) = B_k(1: l_G / 4);
total_m_K1(1: l_G / 4) = m_K1(1: l_G / 4);
% total_m_K2(1: l_G / 4) = m_K2(1: l_G / 4);
% total_m_KEV(1: l_G / 4) = m_KEV(1: l_G / 4);
% total_m_KVE(1: l_G / 4) = m_KVE(1: l_G / 4);
load('E:\Kevin\CapaReal\0721\0721K_Q2.mat', 'm_K1');
% load('E:\Kevin\CapaReal\0721\0721K_Q2.mat', 'm_K1', 'm_K2', 'm_KEV', 'm_KVE');
% total_B_k(l_G / 4 + 1: l_G / 2) = B_k(l_G / 4 + 1: l_G / 2);
total_m_K1(l_G / 4 + 1: l_G / 2) = m_K1(l_G / 4 + 1: l_G / 2);
% total_m_K2(l_G / 4 + 1: l_G / 2) = m_K2(l_G / 4 + 1: l_G / 2);
% total_m_KEV(l_G / 4 + 1: l_G / 2) = m_KEV(l_G / 4 + 1: l_G / 2);
% total_m_KVE(l_G / 4 + 1: l_G / 2) = m_KVE(l_G / 4 + 1: l_G / 2);
load('E:\Kevin\CapaReal\0721\0721K_Q3.mat', 'm_K1');
% load('E:\Kevin\CapaReal\0721\0721K_Q3.mat', 'm_K1', 'm_K2', 'm_KEV', 'm_KVE');
% total_B_k(l_G / 2 + 1: 3 * l_G / 4) = B_k(l_G / 2 + 1: 3 * l_G / 4);
total_m_K1(l_G / 2 + 1: 3 * l_G / 4) = m_K1(l_G / 2 + 1: 3 * l_G / 4);
% total_m_K2(l_G / 2 + 1: 3 * l_G / 4) = m_K2(l_G / 2 + 1: 3 * l_G / 4);
% total_m_KEV(l_G / 2 + 1: 3 * l_G / 4) = m_KEV(l_G / 2 + 1: 3 * l_G / 4);
% total_m_KVE(l_G / 2 + 1: 3 * l_G / 4) = m_KVE(l_G / 2 + 1: 3 * l_G / 4);
load('E:\Kevin\CapaReal\0721\0721K_Q4.mat', 'm_K1');
% load('E:\Kevin\CapaReal\0721\0721K_Q4.mat', 'm_K1', 'm_K2', 'm_KEV', 'm_KVE');
% total_B_k(3 * l_G / 4 + 1: l_G) = B_k(3 * l_G / 4 + 1: l_G);
total_m_K1(3 * l_G / 4 + 1: l_G) = m_K1(3 * l_G / 4 + 1: l_G);
% total_m_K2(3 * l_G / 4 + 1: l_G) = m_K2(3 * l_G / 4 + 1: l_G);
% total_m_KEV(3 * l_G / 4 + 1: l_G) = m_KEV(3 * l_G / 4 + 1: l_G);
% total_m_KVE(3 * l_G / 4 + 1: l_G) = m_KVE(3 * l_G / 4 + 1: l_G);

% to-do
% amending code for mu'' in esophageal cancer region
load('0922EsoMQS_K1_Amend.mat', 'm_K1');
ne_m_K1 = find(~cellfun(@isempty,m_K1));
total_m_K1(ne_m_K1) = m_K1(ne_m_K1);

M_K1 = sparse(N_e, N_e);
% M_K2 = sparse(N_e, N_e);
% M_KEV = sparse(N_e, N_v);
% M_KVE = sparse(N_v, N_e);
tic;
disp('Transfroming M_K1');
M_K1 = mySparse2MatlabSparse( total_m_K1, N_e, N_e, 'Row' );
% M_K2 = mySparse2MatlabSparse( total_m_K2, N_e, N_e, 'Row' );
% M_KEV = mySparse2MatlabSparse( total_m_KEV, N_e, N_v, 'Row' );
% M_KVE = mySparse2MatlabSparse( total_m_KVE, N_v, N_e, 'Col' );
toc;

% to-do
% Amending for B_k: 2 cm version.
EsphgsMQS_Bk_amend;

M_K = sparse(N_e, N_e);
M_K = M_K1;
% M_K = M_K1 - Epsilon_0 * Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

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
ext_itr_num = 10;
int_itr_num = 50;

tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
toc;
bar_x_my_gmres1 = bar_x_my_gmres;

w_y = h_torso;
w_x = air_x;
w_z = air_z;
Fname = '0921';
AFigsScript_Eso;
save('0922EsoMQS_1cmCoil.mat');
% save('0920EsoMQS_2cmCoil.mat');
% return;

A = bar_x_my_gmres;
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
Q_s0 = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
tic;
disp('calclation time of E_0');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    % try to extend to the whole region
    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        % get 27 Pnts
        PntsIdx = zeros( 3, 9 ); 
        PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
        PntsIdx_t = PntsIdx';
        G_27cols = sparse(N_v, 27);
        G_27cols = G(:, PntsIdx_t(:));
        % where \mu_0 is amended for a dropped scaling in the GMRES procedure.
        PntE_0 = zeros(6, 8, 3);
        PntE_0 = - j * Omega_0 * Mu_0 * getEfromA( PntsIdx, Vertex_Crdnt, A, G_27cols, mu_r, squeeze(SegMed(m, n, ell, :, :)), x_max_vertex, y_max_vertex, z_max_vertex );
        SigmaE(m, n, ell, :, :, : ) = sigma( repmat( squeeze(SegMed(m, n, ell, :, :)), [1, 1, 3] ) ) .* PntE_0;
        % implement get48_E0_sqr.m
        Q_s0(m, n, ell, :, :) = 0.5 * sigma( squeeze(SegMed(m, n, ell, :, :)) ) .* get48_E0_sqr( PntE_0 );
    end
end
toc;

tic;
disp('Assigning each tetrahdron with a conducting current');
J_xyz            = zeros(0, 3);
Q_s_Vector       = zeros(0, 1);
% rearrange SigmaE and Q_s; construct the MedTetTableCell
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntJ_xyz        = zeros(48, 3);
    PntMedTetTableCell  = cell(48, 1);
    PntQ_s          = zeros(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
    PntJ_xyz(:, 1) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
    PntJ_xyz(:, 2) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
    PntJ_xyz(:, 3) = tmp(:);
    tmp = squeeze(Q_s0(m, n, ell, :, :))';
    PntQ_s = tmp(:);

    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );
    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
    J_xyz        = vertcat(J_xyz, PntJ_xyz(validTet, :));
    Q_s_Vector   = vertcat(Q_s_Vector, PntQ_s(validTet));
end
toc;

BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 13: bolus-muscle boundary
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

% === === % =========== % === === %
% === === % MNP heating % === === %
% === === % =========== % === === %
bar_x_my_gmres1 = bar_x_my_gmres;
muPrmPrm_MNP = mu_db_prime(EsTumorNum);
Q_s_MNP = zeros(validNum, 1);
for vIdx = 1: 1: validNum
    tmpRow = MedTetTableCell{ vIdx };
    SegNum = tmpRow(5);
    if SegNum == 9
        % feed in the vIdx1, vIdx2, vIdx3, vIdx4, G1, G234 and A, respectively.
        Q_s_MNP(vIdx) = 0.5 * Omega_0 * Mu_0 * muPrmPrm_MNP * norm( calH_2( tmpRow(1), tmpRow(2), tmpRow(3), tmpRow(4), ...
                        G(:, tmpRow(1)), horzcat(G(:, tmpRow(2)), G(:, tmpRow(3)), G(:, tmpRow(4))), bar_x_my_gmres1, Vertex_Crdnt, mu_r, SegNum, x_max_vertex, y_max_vertex, z_max_vertex, 'H') )^2;
    end
end

Q_s_MNP_mod = Q_s_MNP;
% Q_s_MNP_mod = Q_s_MNP * ( 1500 / 400 )^2;
Q_s_Vector_mod = Q_s_Vector;
% Q_s_Vector_mod = Q_s_Vector * ( 1500 / 400 )^2;

return;
% === === === === === === % ================ % === === === === === === === %
% === === === === === === % Temperature part % === === === === === === === %
% === === === === === === % ================ % === === === === === === === %
dt = 15; % 20 seconds
% timeNum_all = 60; % 1 minutes
timeNum_all = 50 * 60; % 50 minutes
loadThermalParas_Esophagus;

% === % =================== % === %
% === % Filling of m_U, m_V % === %
% === % =================== % === %
load('0920EsoEQS.mat', 'm_U', 'm_V')
% m_U   = cell(N_v, 1);
% m_V   = cell(N_v, 1);
% bar_d = zeros(N_v, 1);
% disp('The filling time of m_U, m_V and d_m: ');
% tic;
% parfor vIdx = 1: 1: N_v
%     bioValid = false;
%     U_row = zeros(1, N_v);
%     V_row = zeros(1, N_v);
%     Pnt_d = 0;
%     CandiTet = find( MedTetTable(:, vIdx));
%     for itr = 1: 1: length(CandiTet)
%         % v is un-ordered vertices; while p is ordered vertices.
%         % fix the problem in the determination of v1234 here .
%         TetRow = MedTetTableCell{ CandiTet(itr) };
%         v1234 = TetRow(1: 4);
%         if length(v1234) ~= 4
%             error('check');
%         end
%         MedVal = TetRow(5);
%         % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
%         % this judgement below is based on the current test case
%         if MedVal >= 3 && MedVal <= 9
%             bioValid = true;
%             if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
%                 error('check');
%             end
%             % check the validity of Q_s_Vector input.
%             p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
%             [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
%                         dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal) + Q_s_MNP_mod(CandiTet(itr)), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
%                         x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
%         end
%     end

%     if bioValid
%         m_U{vIdx} = Mrow2myRow(U_row);
%         m_V{vIdx} = Mrow2myRow(V_row);
%         bar_d(vIdx) = Pnt_d;
%     else
%         m_U{vIdx} = [vIdx, 1];
%         m_V{vIdx} = [vIdx, 1];
%     end
% end
% toc;

M_U   = sparse(N_v, N_v);
M_V   = sparse(N_v, N_v);
tic;
disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
M_U = mySparse2MatlabSparse( m_U, N_v, N_v, 'Row' );
M_V = mySparse2MatlabSparse( m_V, N_v, N_v, 'Row' );
toc;

% === === % ===================== % === === %
% === === % Amending Part for d_k % === === %
% === === % ===================== % === === %
bar_d = zeros(N_v, 1);
disp('The filling time d_m: ');
tic;
parfor vIdx = 1: 1: N_v
    Pnt_d = 0;
    CandiTet = find( MedTetTable(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        % v is un-ordered vertices; while p is ordered vertices.
        % fix the problem in the determination of v1234 here .
        TetRow = MedTetTableCell{ CandiTet(itr) };
        v1234 = TetRow(1: 4);
        if length(v1234) ~= 4
            error('check');
        end
        MedVal = TetRow(5);
        % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
        % this judgement below is based on the current test case
        if MedVal >= 3 && MedVal <= 9
            %               %  air,  bolus, muscle, lung, tumor, bone, fat
            % Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5 ]';
            if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                error('check');
            end
            % check the validity of Q_s_Vector input.
            p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
            Pnt_d = filld( p1234, BndryTable, Pnt_d, ...
                            dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal) + Q_s_MNP_mod(CandiTet(itr)), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                            x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
        end
    end
    bar_d(vIdx) = Pnt_d;
end
toc;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %
tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
TetNum = size(MedTetTable, 1);
bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %
% implement the updating function 
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
T_plot_Esophagus;
return;

% === === % ===================== % === === %
% === === % Amending Part for d_k % === === %
% === === % ===================== % === === %
bar_d = zeros(N_v, 1);
disp('The filling time d_m: ');
tic;
parfor vIdx = 1: 1: N_v
    Pnt_d = 0;
    CandiTet = find( MedTetTable(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        % v is un-ordered vertices; while p is ordered vertices.
        % fix the problem in the determination of v1234 here .
        TetRow = MedTetTableCell{ CandiTet(itr) };
        v1234 = TetRow(1: 4);
        if length(v1234) ~= 4
            error('check');
        end
        MedVal = TetRow(5);
        % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
        % this judgement below is based on the current test case
        if MedVal >= 3 && MedVal <= 9
            %               %  air,  bolus, muscle, lung, tumor, bone, fat
            % Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5 ]';
            if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                error('check');
            end
            % check the validity of Q_s_Vector input.
            p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
            Pnt_d = filld( p1234, BndryTable, Pnt_d, ...
                            dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal) + Q_s_MNP_mod(CandiTet(itr)), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                            x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
        end
    end
    bar_d(vIdx) = Pnt_d;
end
toc;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %

tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
TetNum = size(MedTetTable, 1);
bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %

% implement the updating function 
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

T_plot_Esophagus;