% === === === === === === === === ===  % ====== % === === === === === === === === === %
% === === === === === === === === ===  % S part % === === === === === === === === === %
% === === === === === === === === ===  % ====== % === === === === === === === === === %

% the testing function include: getRoughMed_Test, PutOnTopElctrd_TestCase and PutOnDwnElctrd_TestCase.

% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %
clc; clear;
digits;
disp('Full Wave: smaller case, without bone');

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
V_0           = 89; 

% parameters
% rho           = [ 1,  1020,  1020,  1050, 1040 ]';
              % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
rho           = [   1,  1020,   1020, 242.6,  1040,  1790,   900 ]';
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
byndCD = 30;
% beyond computation: 30

for y = - h_torso / 2: dy: h_torso / 2
    paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    % paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
    %     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
    %     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
    %     tumor_x, tumor_z, tumor_r_prime ];
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    mediumTable(:, int64(y_idx), :) = getRoughMed_Test( mediumTable(:, int64(y_idx), :), paras2dXZ, dx, dz );
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all( paras2dXZ, dx, dz, mediumTable(:, int64(y_idx), :) );
end

% % 1 to 7, corresponding to 1-st to 7-th rib.
% RibValid = 0; 
% SSBoneValid = false;
BoneMediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% BoneGridShiftTableXZ = cell( h_torso / dy + 1, 1);

% for y = - h_torso / 2: dy: h_torso / 2
%     [ RibValid, SSBoneValid ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
%     y_idx = y / dy + h_torso / (2 * dy) + 1;
%     [ GridShiftTableXZ{ int64(y_idx) }, BoneMediumTable(:, int64(y_idx), :) ] ...
%         = UpdateBoneMed( y, mediumTable(:, int64(y_idx), :), Ribs, SSBone, RibValid, SSBoneValid, ...
%                             dx, dz, air_x, air_z, x_idx_max, z_idx_max, GridShiftTableXZ{ int64(y_idx) } );
% end

% need to recover after resumming the original case.
% for x = - air_x / 2: dx: air_x / 2
%     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
%     y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
%     x_idx = x / dx + air_x / (2 * dx) + 1;
%     [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ );
% end

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

% === % =========================================== % === %
% === % Refine the SegMed on the computation domain % === %
% === % =========================================== % === % 

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
for idx = 1: 1: N_v
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
[ sparseS, B_phi ] = PutOnTopElctrd_TestCase( sparseS, B_phi, V_0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                                    dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );
sparseS = PutOnDwnElctrd_TestCase( sparseS, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
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
ext_itr_num = 5;
int_itr_num = 20;

bar_x_my_gmres = zeros(size(B_phi));
M_S = mySparse2MatlabSparse( sparseS, N_v, N_v, 'Row' );
tic;
disp('Calculation time of iLU: ')
[ L_S, U_S ] = ilu( M_S, struct('type', 'ilutp', 'droptol', 1e-2) );
toc;
tic;
disp('The gmres solutin of M_S x = B_phi: ');
bar_x_my_gmres = gmres( M_S, B_phi, int_itr_num, tol, ext_itr_num, L_S, U_S );
% bar_x_my_gmres = my_gmres( sparseS, B_phi, int_itr_num, tol, ext_itr_num );
toc;

bar_x_my_gmresPhi = zeros(size(B_phi));
bar_x_my_gmresPhi = bar_x_my_gmres;

% === === === === === === === === ===  % ====== % === === === === === === === === === %
% === === === === === === === === ===  % K part % === === === === === === === === === %
% === === === === === === === === ===  % ====== % === === === === === === === === == %

% check if tetRow is valid in the filling of Bk ?
% the following code may be incorporated into getPntMedTetTable
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
tic;
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

    SigmaE(m, n, ell, :, :, :) = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), sigma );
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
J_xyz = zeros(0, 3);
MedTetTable = sparse(0, N_v);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntJ_xyz       = sparse(48, 3);
    PntMedTetTable = sparse(48, N_v);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
    PntJ_xyz(:, 1) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
    PntJ_xyz(:, 2) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
    PntJ_xyz(:, 3) = tmp(:);
    PntMedTetTable = getPntMedTetTable( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );

    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz

    J_xyz       = vertcat(J_xyz, PntJ_xyz(validTet, :));
    MedTetTable = vertcat(MedTetTable, PntMedTetTable(validTet, :));
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

if size(MedTetTable, 1) ~= validNum
    error('check the construction');
end

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
G = sparse(starts, ends, vals, N_v, N_v);
toc;
[ P1, P2 ] = find(G);
l_G = length(find(G));

% undirected graph
uG = G + G';

CD_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
% BndryPoints is set to be 2
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    if my_F(borderFlag, 1)
        CD_bndry(m_v, n_v, ell_v) = 2;
    end
end

% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %

B_k = zeros(N_e, 1);
M_K1 = sparse(N_e, N_e);
M_K2 = sparse(N_e, N_e);
M_KEV = sparse(N_e, N_v);
M_KVE = sparse(N_v, N_e);
edgeChecker = false(l_G, 1);
cFlagChecker = false(l_G, 1);
BioFlag = true(N_v, 1);

tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
for lGidx = 1: 1: l_G
    eIdx = full( G(P1(lGidx), P2(lGidx)) );
    Candi = [];
    % get candidate points
    P1_cand = uG(P1(lGidx), :);
    P2_cand = uG(P2(lGidx), :);
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
    Kev_4 = sparse(1, N_v);
    Kve_4 = sparse(N_v, 1);
    B_k_Pnt = 0;
    cFlag = false;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                MedVal = MedTetTable( tetRow, v1234(1) );
                % use tetRow to check the accordance of SigmaE and J_xyz
                [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
                    G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
                    CD_bndry( P1(lGidx) ), CD_bndry( P2(lGidx) ), CD_bndry( Candi(itr) ), CD_bndry( Candi(TetFinder) ), ...
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
    M_K1(eIdx, :)  = K1_6;
    M_K2(eIdx, :)  = K2_6;
    M_KEV(eIdx, :) = Kev_4;
    M_KVE(:, eIdx) = Kve_4;
    B_k(eIdx) = B_k_Pnt;
end
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
ext_itr_num = 10;
int_itr_num = 50;

bar_x_my_gmres = zeros(size(nrmlB_k));
tic; 
disp('Computational time for solving Ax = b: ')
bar_x_my_gmres = nrmlM_K\nrmlB_k;
toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num );
% toc;

w_y = h_torso;
w_x = air_x;
w_z = air_z;
AFigsScript;

% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;