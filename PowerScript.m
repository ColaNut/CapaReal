% === === === === === === === === ===  % ====== % === === === === === === === === === %
% === === === === === === === === ===  % S part % === === === === === === === === === %
% === === === === === === === === ===  % ====== % === === === === === === === === === %

% the testing function include: getRoughMed_Test, PutOnTopElctrd_TestCase and PutOnDwnElctrd_TestCase.

% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %
% clc; clear;
digits;
disp('Full Wave: EQS');

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
% V_0           = 86.26; 

% parameters
% rho           = [ 1,  1020,  1020,  1050, 1040 ]';
              % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
rho           = [   1,  1020,   1020, 242.6,  697,  1790,   900 ]';
% epsilon_r_pre = [ 1, 113.0,   184, 264.9,  402,    7.3]';
% sigma         = [ 0,  0.61, 0.685,  0.42, 0.68, 0.028 ]';
epsilon_r_pre = [   1, 113.0,    113, 264.9,   402,   7.3,    20 ]';
sigma         = [   0,  0.61,   0.61,  0.42,  0.68, 0.028, 0.047 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
loadParas;
% paras = [ h_torso, air_x, air_z, ...
%         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
%         l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
%         r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
%         tumor_x, tumor_y, tumor_z, tumor_r ];

% the top and bottom electrodes' size
top_x0  = - 1 / 100;
top_dx  = 1 / 100;
top_dy  = 4 / 100;
down_x0  = - 1 / 100;
down_dx = 1 / 100;
down_dy = 4 / 100;

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
% Normal Points: [ air, bolus, muscle, lung, tumor, ribs, spine, sternum ] -> [  1,  2,  3,  4,  5,  6,  7,  8 ]
% Interfaces:    [ air-bolus, bolus-muscle, muscle-lung, lung-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
% Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 
byndCD = 30;
% beyond computation: 30

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
% BoneGridShiftTableXZ = cell( h_torso / dy + 1, 1);

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

% % BlsBndryMsk = zeros(x_idx_max, z_idx_max);c  
% % BlsBndryMsk = get1cmBlsBndryMsk( bolus_a, bolus_c, muscle_a, muscle_c, dx, dz, x_idx_max, z_idx_max, air_x, air_z );

sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

% Mask the medium table
MskMedTab = mediumTable;
% normal point remains the same, the boundary point are forced to zero
MskMedTab( find(MskMedTab >= 10) ) = 0;

% the above process update the medium value and construct the shiftedCoordinateXYZ

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

% === % ================= % === %
% === % Filling time of S % === %
% === % ================= % === %

sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );

% Mask the medium table
MskMedTab = mediumTable;
% normal point remains the same, the boundary point are forced to zero
MskMedTab( find(MskMedTab >= 10) ) = 0;

disp('The fill up time of A: ');
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

% === % =================================== % === %
% === % Fill Up Time for sparseS and SegMed % === %
% === % =================================== % === % 

B_phi = zeros(N_v, 1);
sparseS = cell( N_v, 1 );
tic;
disp('The filling time of S phi = b_phi: ');
parfor idx = 1: 1: N_v
% for idx = x_max_vertex * y_max_vertex * 65: 1: x_max_vertex * y_max_vertex * 66
    [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
    if m >= 2  && m <= x_max_vertex - 1 && n >= 2 && n <= y_max_vertex - 1 && ell >= 2 && ell <= z_max_vertex - 1 
        flag = getMNL_flag(m, n, ell);
        % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
        % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
        SegMedIn = FetchSegMed( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        % ( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag )

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

% put on electrodes
y_mid = ( h_torso / ( 2 * dy ) ) + 1;
BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 19: position of top-electrode
TpElctrdPos = 19;
[ sparseS, B_phi, BndryTable ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                        dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
sparseS = PutOnDwnElctrd( sparseS, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                        dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% Normalize each rows
for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    tmp_vector = sparseS{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    sparseS{ idx } = tmp_vector;
    B_phi( idx ) = B_phi( idx ) ./ MAX_row_value;
end

% === % ============== % === %
% === % GMRES solution % === %
% === % ============== % === %

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(B_phi));
M_S = mySparse2MatlabSparse( sparseS, N_v, N_v, 'Row' );
tic;
disp('Calculation time of iLU: ')
[ L_S, U_S ] = ilu( M_S, struct('type', 'ilutp', 'droptol', 1e-2) );
toc;
tic;
disp('The gmres solutin of M_S x = B_phi: ');
bar_x_my_gmresPhi = gmres( M_S, B_phi, int_itr_num, tol, ext_itr_num, L_S, U_S );
toc;

% % === === === === === === === === % ========== % === === === === === === === === %
% % === === === === === === === === % K part (1) % === === === === === === === === %
% % === === === === === === === === % ========== % === === === === === === === === %

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

Bls_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 13: bolus-muscle boundary
BM_bndryNum = 13;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n >= n_near && n <= n_far && mediumTable(m, n, ell) == BM_bndryNum
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        Bls_bndry(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1) ...
            = getSheetPnts(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, ...
                Bls_bndry(m_v - 1: m_v + 1, n_v - 1: n_v + 1, ell_v - 1: ell_v + 1), BM_bndryNum );
    end
end
Bls_bndry(:, 1, :) = Bls_bndry(:, 2, :);
Bls_bndry(:, end, :) = Bls_bndry(:, end - 1, :);

% check if tetRow is valid in the filling of Bk ?
% the following code may be incorporated into getPntMedTetTable
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
Q_s    = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
tic;
disp('calclation time of SigmeE and Q_s');
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

% === % ========================================================== % === %
% === % Conducting Current Assignment and MedTetTable Construction % === %
% === % ========================================================== % === % 

tic;
disp('Assigning each tetrahdron with a conducting current');
J_xyz            = zeros(0, 3);
Q_s_Vector       = zeros(0, 1);
% MedTetTableCell  = cell(0, 1);
% rearrange SigmaE and Q_s; construct the MedTetTableCell
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
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );
    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
    % start from here: the temperature is getting lower, and the Q_s and J_xyz is in the order 0.35 and 0.002, respectively.
    Q_s_Vector   = vertcat(Q_s_Vector, PntQ_s(validTet));

    if V_0 == 83.59
        PntJ_xyz        = zeros(48, 3);
        tmp = zeros(8, 6);
        tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
        PntJ_xyz(:, 1) = tmp(:);
        tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
        PntJ_xyz(:, 2) = tmp(:);
        tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
        PntJ_xyz(:, 3) = tmp(:);
        J_xyz        = vertcat(J_xyz, PntJ_xyz(validTet, :));
    end
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(Q_s_Vector, 1) ~= validNum
    error('check the construction');
end

load('0710_2cmBolus_MedTetTableCell.mat');

MedTetTable = sparse(validNum, N_v);
tic;
disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
MedTetTable = mySparse2MatlabSparse( MedTetTableCell, validNum, N_v, 'Row' );
toc;

dt = 15; % 15 seconds
% timeNum_all = 60; % 1 minutes
% timeNum_all = 50 * 60; % 50 minutes
loadThermalParas;

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
            if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                error('check');
            end
            % check the validity of Q_s_Vector input.
            p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
            Pnt_d = filld( p1234, Bls_bndry, Pnt_d, ...
                            dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                            x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
        end
    end

    bar_d(vIdx) = Pnt_d;
end
toc;