% === === % =========================================================== % === === %
% === === % Title: Liver EQS with adipose and temperature-dependendt xi % === === %
% === === % Date : 1221                                                 % === === %
% === === % =========================================================== % === === %

% === === === === === === === === ===  % ====== % === === === === === === === === === %
% === === === === === === === === ===  % S part % === === === === === === === === === %
% === === === === === === === === ===  % ====== % === === === === === === === === === %

% === % ========================================== % === %
% === % Construction of Coordinates and Grid Shift % === %
% === % ========================================== % === %
clc; clear;
digits;
disp('EQS liver with adipose tissue, temperature-dependendt xi and no ribs');

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
V_0           = 85; 

% liver cirrhosis 
              % [ air, bolus, muscle, cirrhosis, tumor ]';
rho           = [   1,  1020,   1020,      1000,  1080 ]';
epsilon_r_pre = [   1,   172,    172,       338,   338 ]';
sigma         = [   0,  0.69,   0.69,      0.42,  0.42 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
loadParas_liverEQS;
% paras = [ h_torso, air_x, air_z, ...
%         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
%         liver_x, liver_z, liver_a, liver_b, liver_c, liverTheta, liverPhi, liverPsi, ...
%         tumor_x, tumor_y, tumor_z, tumor_r ];

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

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
% Normal Points: [ air, bolus, muscle, liver, tumor, ribs, spine, sternum ] -> [  1,  2,  3,  4,  5,  6,  7,  8 ]
% Interfaces:    [ air-bolus, bolus-muscle, muscle-liver, liver-tumor ]      -> [ 11, 13, 12*, 14, 15 ] % temperarily set to 12
% Bone Interfaces: [ Ribs-others, spine-others, sternum-others ]           -> [ 16, 17, 18 ] 
byndCD = 30;
% beyond computation: 30

% reconstruct the paras2dXZ_liver.m
for y = - h_torso / 2: dy: h_torso / 2
    paras2dXZ_liver = genParas2d_liver( y, paras, dx, dy, dz );
    % paras2dXZ_liver = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
    %     liver_x, liver_z, liver_x_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
    %     tumor_x, tumor_y, tumor_z, tumor_r_prime ];
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    mediumTable(:, int64(y_idx), :) = getRoughMed_liver( mediumTable(:, int64(y_idx), :), paras2dXZ_liver, y, dx, dz, 'no_fat' );
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all_liver( paras2dXZ_liver, dx, dz, mediumTable(:, int64(y_idx), :) );
end

% return;

% RibValid = 0; 
% SSBoneValid = false;
BoneMediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');

for x = - air_x / 2: dx: air_x / 2
    % implement genParas2dYZ_liver.m
    paras2dYZ_liver = genParas2dYZ_liver( x, paras, dy, dz );
    % paras2dYZ = [ h_torso, air_x, air_z, ...
    %     bolus_a, bolusHghtZ, skin_a, skin_c, muscle_a, muscleHghtZ, ...
    %     liver_z, liver_y_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
    %     tumor_y, tumor_z, tumor_r_prime ];
    % implement fillGridTableY_all
    y_grid_table = fillGridTableY_all_liver( paras2dYZ_liver, dy, dz );
    x_idx = x / dx + air_x / (2 * dx) + 1;
    [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ_liver( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable, paras2dYZ_liver );
end

% parameters-oriented model.
mediumTable(18, 11 + 5, 30) = 13;
mediumTable(18, 12 + 5, 30) = 13;
mediumTable(18, 13 + 5, 30) = 13;
mediumTable(21, 12 + 5, 31) = 13;

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

% Mask the medium table: normal point remains the same, the boundary point are forced to zero
MskMedTab = mediumTable;
MskMedTab( find(MskMedTab >= 10) ) = 0;

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

disp('Filling SegMed: ');
tic;
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

% === % ====================================== % === %
% === % Amend SegMed on the computation domain % === %
% === % ====================================== % === % 

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
parfor vIdx = 1: 1: N_v
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    if m_v >= 2  && m_v <= x_max_vertex - 1 && n_v >= 2 && n_v <= y_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        flag = getMNL_flag(m_v, n_v, ell_v);
        % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
        % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
        SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        % ( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag )

        sparseS{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, ...
            Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, epsilon_r, Omega_0 );
    elseif ell_v == z_max_vertex
        sparseS{ vIdx } = fillTop_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif ell_v == 1
        sparseS{ vIdx } = fillBttm_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif m_v == x_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        sparseS{ vIdx } = fillRight_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif m_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        sparseS{ vIdx } = fillLeft_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif n_v == y_max_vertex && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        sparseS{ vIdx } = fillFront_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    elseif n_v == 1 && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        sparseS{ vIdx } = fillBack_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
end
toc;

% put on electrodes
y_mid = ( h_torso / ( 2 * dy ) ) + 1;
BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 19: position of top-electrode
TpElctrdPos = 19;
% update the PutOnTopElctrd and PutOnDwnElctrd.m
[ sparseS, B_phi, BndryTable ] = PutOnTopElctrd_liver( sparseS, B_phi, V_0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                        dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
sparseS = PutOnDwnElctrd_liver( sparseS, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                        dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% % extend the BndryTable
tumor_m   = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;
tumor_v = ( tumor_ell_v - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v;

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
bar_x_my_gmresPhi = gmres( M_S, B_phi, int_itr_num, tol, ext_itr_num, L_S, U_S );
% bar_x_my_gmres = my_gmres( sparseS, B_phi, int_itr_num, tol, ext_itr_num );
toc;

save('0110LiverEQS.mat');
% FigsScriptLiverEQS

% return;
% % clc; clear;
% % load('0729.mat');

% load('0906LiverCirrhoticEQS.mat');

% === % ======================== % === %
% === % Amend for invalid SegMed % === %
% === % ======================== % === % 
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 1 );
    end
end

% === === === === === === % ================================= % === === === === === === %
% === === === === === === % Prepare Vrtx_bndry and BndryTable % === === === === === === %
% === === === === === === % ================================= % === === === === === === %
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

% === % ============================================================= % === %
% === % Conducting Current Assignment and Construction of MedTetTable % === %
% === % ============================================================= % === % 
tic;
disp('Assigning each tetrahdron with a conducting current');
J_xyz_pre            = zeros(48 * x_idx_max * y_idx_max * z_idx_max, 3);
Q_s_Vector_pre       = zeros(48 * x_idx_max * y_idx_max * z_idx_max, 1);
MedTetTableCell_pre  = cell(48 * x_idx_max * y_idx_max * z_idx_max, 1);
% rearrange SigmaE and Q_s; construct the MedTetTableCell
validTetTable        = false( 48 * x_idx_max * y_idx_max * z_idx_max, 1 );
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntJ_xyz        = zeros(48, 3);
    PntMedTetTableCell  = cell(48, 1);
    PntQ_s          = zeros(48, 1);
    % validTet        = false(48, 1);
    PntValidTet = false(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 1) )';
    PntJ_xyz(:, 1) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 2) )';
    PntJ_xyz(:, 2) = tmp(:);
    tmp = squeeze( SigmaE(m, n, ell, :, :, 3) )';
    PntJ_xyz(:, 3) = tmp(:);
    % to-do
    tmp = squeeze(Q_s(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    % validTet = find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD );
    PntValidTet( find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD ) ) = true;

    % set a inf and nan checker for PntTetTable_Ix, PntTetTable_Iy and PntTetTable_Iz
    % start from here: the temperature is getting lower, and the Q_s and J_xyz is in the order 0.35 and 0.002, respectively.
    J_xyz_pre(48 * (idx - 1) + 1: 48 * idx, :) = PntJ_xyz;
    MedTetTableCell_pre(48 * (idx - 1) + 1: 48 * idx) = PntMedTetTableCell;
    Q_s_Vector_pre(48 * (idx - 1) + 1: 48 * idx) = PntQ_s;
    validTetTable(48 * (idx - 1) + 1: 48 * idx) = PntValidTet;
end
toc;

validNum = 48 * x_idx_max * y_idx_max * z_idx_max - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ...
                + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 - 48;

J_xyz                = J_xyz_pre;
Q_s_Vector           = Q_s_Vector_pre;
MedTetTableCell      = MedTetTableCell_pre;
J_xyz(~validTetTable, :) = [];
Q_s_Vector(~validTetTable) = [];
MedTetTableCell(~validTetTable) = [];
if size(MedTetTableCell, 1) ~= validNum
    error('check the construction');
end

MedTetTable = sparse(validNum, N_v);
tic;
disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
MedTetTable = mySparse2MatlabSparse( MedTetTableCell, validNum, N_v, 'Row' );
toc;

CurrentEstFEM

% save('0905_CirrhoticLiverEQS.mat');
% save('0818CirrhoticLiverEQS.mat');

% return;

% === === === === === === === === % ================ % === === === === === === === === %
% === === === === === === === === % Temperature part % === === === === === === === === %
% === === === === === === === === % ================ % === === === === === === === === %

% === % ================================================= % === %
% === % Initialization of Temperature and Other Parameter % === %
% === % ================================================= % === %
dt = 15; % 15 seconds
% timeNum_all = 60; % 1 minutes
timeNum_all = 50 * 60; % 50 minutes
loadThermalParas_liver;

tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

flagX  = zeros(1, timeNum_all / dt + 1);
relres = zeros(1, timeNum_all / dt + 1);
% in the first 20 minutes, the time is segmented every 2 minutes
TimeSeg = 120 / dt; % eight interval = 8 * 15 = 120 seconds = 2 minutes 
ItrEnd = 10; % ten timeSeg(2 minutes) after, stop updating m_U and m_V

Ini_bar_b = zeros(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);

% the process (calculation of temperature)-(get m_U, m_V) is repeated every 2 minutes
m_U   = cell(N_v, 1);
m_V   = cell(N_v, 1);
bar_d = zeros(N_v, 1);

% to-do
% the xi of muscle is a function of temperature in the erange of 36 ^\circ C to 45 ^\circ C
% test for non-linear xi of muscle

% === === % ========================================== % === === %
% === === % Get m_U and m_V; Calculate The Temperature % === === %
% === === % ========================================== % === === %  
Itr = 1;
constantXiFlag = true;
variableTmprtrFlag = true;
if constantXiFlag
    Get_m_U_m_V_and_T;
else
    % The script Get_m_U_m_V_and_T update m_U and m_V
    for Itr = 1: 1: ItrEnd
        Get_m_U_m_V_and_T;
    end
    variableTmprtrFlag = false;
    Get_m_U_m_V_and_T;
end

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot_liverEQS;

save('0110CirrhoticLiverEQS.mat');

return;

% % === % ================================================= % === %
% % === % Initialization of Temperature and Other Parameter % === %
% % === % ================================================= % === %
% dt = 15; % 15 seconds
% % timeNum_all = 60; % 1 minutes
% timeNum_all = 50 * 60; % 50 minutes
% loadThermalParas_liver;

% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 20;

% flagX  = zeros(1, timeNum_all / dt + 1);
% relres = zeros(1, timeNum_all / dt + 1);
% % in the first 20 minutes, the time is segmented every 2 minutes
% TimeSeg = 120 / dt; % eight interval = 8 * 15 = 120 seconds = 2 minutes 
% ItrEnd = 10; % ten timeSeg(2 minutes) after, stop updating m_U and m_V

% Ini_bar_b = zeros(N_v, 1);
% % The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
% bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);

% % the process (calculation of temperature)-(get m_U, m_V) is repeated every 2 minutes
% m_U   = cell(N_v, 1);
% m_V   = cell(N_v, 1);
% bar_d = zeros(N_v, 1);

% % to-do
% % the xi of muscle is a function of temperature in the erange of 36 ^\circ C to 45 ^\circ C
% % test for non-linear xi of muscle
% xi_muscle_non_linear = xi(3) * (1: 0.1: 10);

% % === === % ========================================== % === === %
% % === === % Get m_U and m_V; Calculate The Temperature % === === %
% % === === % ========================================== % === === %  
% Itr = 1;
% variableFlag = true;
% % The script Get_m_U_m_V_and_T update m_U and m_V
% if Itr <= ItrEnd 
%     Get_m_U_m_V_and_T;
%     Itr = Itr + 1;
% else
%     variableFlag = false;
%     Get_m_U_m_V_and_T;
% end

% % === % ==================== % === %
% % === % Temperature Plotting % === %
% % === % ==================== % === %

% T_flagXZ = 1;
% T_flagXY = 1;
% T_flagYZ = 1;

% T_plot_liver;

% % % % === === === === === === === === % ================ % === === === === === === === === %
% % % % === === === === === === === === % Temperature part % === === === === === === === === %
% % % % === === === === === === === === % ================ % === === === === === === === === %

% % dt = 15; % 20 seconds
% % % timeNum_all = 60; % 1 minutes
% % timeNum_all = 50 * 60; % 50 minutes
% % loadThermalParas_liver;
% % % LiverRelatedVrtx = false(N_v, 1);

% % % disp('Getting liver related vIdx: ');
% % % tic;
% % % parfor vIdx = 1: 1: N_v
% % %     bioValid = false;
% % %     U_row = zeros(1, N_v);
% % %     V_row = zeros(1, N_v);
% % %     Pnt_d = 0;
% % %     CandiTet = find( MedTetTable(:, vIdx));
% % %     for itr = 1: 1: length(CandiTet)
% % %         % v is un-ordered vertices; while p is ordered vertices.
% % %         % fix the problem in the determination of v1234 here .
% % %         TetRow = MedTetTableCell{ CandiTet(itr) };
% % %         v1234 = TetRow(1: 4);
% % %         if length(v1234) ~= 4
% % %             error('check');
% % %         end
% % %         MedVal = TetRow(5);
% % %         % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
% % %         % this judgement below is based on the current test case
% % %         if MedVal >= 4 && MedVal <= 5
% % %             LiverRelatedVrtx(vIdx) = true;
% % %             break
% % %         end
% % %     end
% % % end
% % % toc;

% % % m_U   = cell(N_v, 1);
% % % m_V   = cell(N_v, 1);
% % % bar_d = zeros(N_v, 1);
% % disp('The filling time of m_U, m_V and d_m: ');
% % tic;
% % parfor vIdx = 1: 1: N_v
% %     if LiverRelatedVrtx(vIdx)
% %         bioValid = false;
% %         U_row = zeros(1, N_v);
% %         V_row = zeros(1, N_v);
% %         Pnt_d = 0;
% %         CandiTet = find( MedTetTable(:, vIdx));
% %         for itr = 1: 1: length(CandiTet)
% %             % v is un-ordered vertices; while p is ordered vertices.
% %             % fix the problem in the determination of v1234 here .
% %             TetRow = MedTetTableCell{ CandiTet(itr) };
% %             v1234 = TetRow(1: 4);
% %             if length(v1234) ~= 4
% %                 error('check');
% %             end
% %             MedVal = TetRow(5);
% %             % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
% %             % this judgement below is based on the current test case
% %             if MedVal >= 3 && MedVal <= 9
% %                 bioValid = true;
% %                 if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
% %                     error('check');
% %                 end
% %                 % check the validity of Q_s_Vector input.
% %                 p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
% %                 [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
% %                             dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
% %                             x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
% %             end
% %         end

% %         if bioValid
% %             m_U{vIdx} = Mrow2myRow(U_row);
% %             m_V{vIdx} = Mrow2myRow(V_row);
% %             bar_d(vIdx) = Pnt_d;
% %         else
% %             m_U{vIdx} = [vIdx, 1];
% %             m_V{vIdx} = [vIdx, 1];
% %         end
% %     end
% % end
% % toc;

% % M_U   = sparse(N_v, N_v);
% % M_V   = sparse(N_v, N_v);
% % tic;
% % disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
% % M_U = mySparse2MatlabSparse( m_U, N_v, N_v, 'Row' );
% % M_V = mySparse2MatlabSparse( m_V, N_v, N_v, 'Row' );
% % toc;

% % % === === % ================ % === === %
% % % === === % Amending for B_k % === === %
% % % === === % ================ % === === %

% % Q_s_Vector_mod = Q_s_Vector * 800 / abs(W);

% % bar_d = zeros(N_v, 1);
% % disp('The filling time d_m: ');
% % tic;
% % parfor vIdx = 1: 1: N_v
% %     Pnt_d = 0;
% %     CandiTet = find( MedTetTable(:, vIdx));
% %     for itr = 1: 1: length(CandiTet)
% %         % v is un-ordered vertices; while p is ordered vertices.
% %         % fix the problem in the determination of v1234 here .
% %         TetRow = MedTetTableCell{ CandiTet(itr) };
% %         v1234 = TetRow(1: 4);
% %         if length(v1234) ~= 4
% %             error('check');
% %         end
% %         MedVal = TetRow(5);
% %         % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
% %         % this judgement below is based on the current test case
% %         % if MedVal == 5 
% %         if MedVal >= 3 && MedVal <= 9
% %             %               %  air,  bolus, muscle, lung, tumor, bone, fat
% %             % Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5 ]';
% %             if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
% %                 error('check');
% %             end
% %             % check the validity of Q_s_Vector input.
% %             p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
% %             Pnt_d = filld( p1234, BndryTable, Pnt_d, ...
% %                             dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
% %                             x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
% %         end
% %     end
% %     bar_d(vIdx) = Pnt_d;
% % end
% % toc;

% % % % === % ============================= % === %
% % % % === % Initialization of Temperature % === %
% % % % === % ============================= % === %

% % tic;
% % disp('Initialization of Temperature');
% % % from 0 to timeNum_all / dt
% % Ini_bar_b = zeros(N_v, 1);
% % % Ini_bar_b = T_air * ones(N_v, 1);
% % % The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
% % TetNum = size(MedTetTable, 1);
% % % get rid of redundancy
% % bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
% % toc;

% % % === % ========================== % === %
% % % === % Calculation of Temperature % === %
% % % === % ========================== % === %
% % tol = 1e-6;
% % ext_itr_num = 5;
% % int_itr_num = 20;

% % flagX  = zeros(1, timeNum_all / dt + 1);
% % relres = zeros(1, timeNum_all / dt + 1);
% % % implement the updating function 
% % tic;
% % for idx = 2: 1: size(bar_b, 2)
% %     [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
% %     % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
% % end
% % toc;

% % % === % ==================== % === %
% % % === % Temperature Plotting % === %
% % % === % ==================== % === %

% % T_flagXZ = 1;
% % T_flagXY = 1;
% % T_flagYZ = 1;

% % T_plot_liver;

% % save('0912LiverEQS_XiMod.mat');

% % % save('0905_CirrhoticLiverEQS.mat');
% % % save('0818CirrhoticLiverEQS.mat');

% % return;

% % % === === === === === === === === % ========== % === === === === === === === === %
% % % === === === === === === === === % K part (2) % === === === === === === === === %
% % % === === === === === === === === % ========== % === === === === === === === === %

% % % === % ==================== % === %
% % % === % Parameters used in K % === %
% % % === % ==================== % === %

% %               % [ air, bolus, muscle, lung,  tumor,  bone,   fat ]';
% % mu_prime      = [   1,     1,      1,     1,     1,     1,     1 ]';
% % mu_db_prime   = [   0,     0,      0,     0,     0,     0,     0 ]';
% % % mu_db_prime   = [ 0,    0.62 ]';
% % mu_r          = mu_prime - i * mu_db_prime;

% % % === % =============================== % === %
% % % === % Constructing The Directed Graph % === %
% % % === % =============================== % === %

% % starts = [];
% % ends = [];
% % vals = [];
% % borderFlag = false(1, 6);
% % disp('Constructing the directed graph');
% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %     flag = getMNL_flag(m_v, n_v, ell_v);
% %     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
% %     % borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex)
% %     if strcmp(flag, '000') && ~mod(ell_v, 2)
% %         [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag );
% %     end
% % end
% % G = sparse(ends, starts, vals, N_v, N_v);
% % toc;
% % [ P2, P1, Vals ] = find(G);
% % [ Vals, idxSet ] = sort(Vals);
% % P1 = P1(idxSet);
% % P2 = P2(idxSet);
% % l_G = length(P1);

% % % undirected graph
% % uG = G + G';

% % % === % =================================== % === %
% % % === % Filling Time of K1, Kev, Kve and Bk % === %
% % % === % =================================== % === %

% % B_k = zeros(N_e, 1);
% % m_K1 = cell(N_e, 1);
% % m_K2 = cell(N_e, 1);
% % m_KEV = cell(N_e, 1);
% % m_KVE = cell(1, N_e);
% % edgeChecker = false(l_G, 1);
% % cFlagChecker = false(l_G, 1);
% % BioFlag = true(N_v, 1);

% % tic; 
% % disp('The filling time of K_1, K_EV, K_VE and B: ');
% % for eIdx = 1: 1: l_G
% %     % eIdx = full( G(P2(lGidx), P1(lGidx)) );
% %     Candi = [];
% %     % get candidate points
% %     P1_cand = uG(:, P1(eIdx));
% %     P2_cand = uG(:, P2(eIdx));
% %     P1_nz = find(P1_cand);
% %     P2_nz = find(P2_cand);
% %     for CandiFinder = 1: 1: length(P1_nz)
% %         if find(P2_nz == P1_nz(CandiFinder))
% %             Candi = horzcat(Candi, P1_nz(CandiFinder));
% %         end
% %     end
% %     % get adjacent tetrahdron
% %     K1_6 = zeros(1, N_e); 
% %     B_k_Pnt = 0;
% %     cFlag = false;
% %     for TetFinder = 1: 1: length(Candi) - 1
% %         for itr = TetFinder + 1: length(Candi)
% %             if uG( Candi(TetFinder), Candi(itr) )
% %                 % linked to become a tetrahedron
% %                 v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
% %                 tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
% %                 if length(tetRow) ~= 1
% %                     error('check te construction of MedTetTable');
% %                 end
% %                 % MedVal = MedTetTable( tetRow, v1234(1) );
% %                 % use tetRow to check the accordance of SigmaE and J_xyz
% %                 % start from fix Vrtx_bndry Pb2
% %                 [ K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt ] = fillK_FW( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
% %                     G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), ...
% %                     Vrtx_bndry( P1(eIdx) ), Vrtx_bndry( P2(eIdx) ), Vrtx_bndry( Candi(itr) ), Vrtx_bndry( Candi(TetFinder) ), ...
% %                     K1_6, K2_6, Kev_4, Kve_4, B_k_Pnt, J_xyz(tetRow, :), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
% %             end
% %         end
% %     end

% %     if isempty(K1_6) || isempty(K2_6) || isempty(Kev_4)
% %         disp('K1, K2 or KEV: empty');
% %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %         [ m_v, n_v, ell_v, edgeNum ]
% %     end
% %     if isnan(K1_6) | isinf(K1_6) | isnan(K2_6) | isinf(K2_6)
% %         disp('K1 or K2: NaN or Inf');
% %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %         [ m_v, n_v, ell_v, edgeNum ]
% %     end
% %     if isnan(Kev_4) | isinf(Kev_4)
% %         disp('Kev: NaN or Inf');
% %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %         [ m_v, n_v, ell_v, edgeNum ]
% %     end
% %     if edgeChecker(eIdx) == true
% %         lGidx
% %         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %         [ m_v, n_v, ell_v, edgeNum ]
% %         error('check')
% %     end

% %     edgeChecker(eIdx) = true;
    
% %     m_K1{eIdx} = Mrow2myRow(K1_6);
% %     m_K2{eIdx}  = Mrow2myRow(K2_6);
% %     m_KEV{eIdx} = Mrow2myRow(Kev_4);
% %     m_KVE{eIdx} = Mrow2myRow(Kve_4')';
% %     B_k(eIdx) = B_k_Pnt;
% % end
% % toc;

% % M_K1 = sparse(N_e, N_e);
% % M_K2 = sparse(N_e, N_e);
% % M_KEV = sparse(N_e, N_v);
% % M_KVE = sparse(N_v, N_e);
% % tic;
% % disp('Transfroming M_K1, M_K2, M_KEV and M_KVE')
% % M_K1 = mySparse2MatlabSparse( m_K1, N_e, N_e, 'Row' );
% % M_K2 = mySparse2MatlabSparse( m_K2, N_e, N_e, 'Row' );
% % M_KEV = mySparse2MatlabSparse( m_KEV, N_e, N_v, 'Row' );
% % M_KVE = mySparse2MatlabSparse( m_KVE, N_v, N_e, 'Col' );
% % toc;

% % % === % ========== % === %
% % % === % GVV matrix % === %
% % % === % ========== % === %

% % % modify according to Regular Tetrahedra version.
% % sparseGVV = cell(1, N_v);
% % disp('The filling time of G_VV: ');
% % tic;
% % for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
% %     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
% %     flag = getMNL_flag(m_v, n_v, ell_v);
% %     GVV_SideFlag = false(1, 6);
% %     GVV_SideFlag = getGVV_SideFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
% %     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
% %     if isempty( find( GVV_SideFlag ) )
% %         sparseGVV{ vIdx } = fillNrml_S( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
% %                                             z_max_vertex, SegMedIn, epsilon_r, Omega_0, 'GVV' );
% %     else
% %         sparseGVV{ vIdx } = fillBndry_GVV_tmp( m_v, n_v, ell_v, flag, GVV_SideFlag, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
% %     end
% % end
% % toc;

% % % === % =================== % === %
% % % === % Calculation of SPAI % === %
% % % === % =================== % === %

% % TEX = 'Right';
% % CaseTEX = 'Case1';
% % Tol = 0.6;
% % GVV_test; % a script
% % % load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

% % % === % ========================= % === %
% % % === % Matrices product to get K % === %
% % % === % ========================= % === %

% % M_K = sparse(N_e, N_e);
% % M_K = M_K1 - Mu_0 * Omega_0^2 * M_K2 - M_KEV * M_sparseGVV_inv_spai * M_KVE;

% % % === % ============================ % === %
% % % === % Sparse Normalization Process % === %
% % % === % ============================ % === %

% % tic;
% % disp('Time for normalization');
% % sptmp = spdiags( 1 ./ max(abs(M_K),[], 2), 0, N_e, N_e );
% % nrmlM_K = sptmp * M_K;
% % nrmlB_k = sptmp * B_k;
% % toc;

% % % === % ============================================================ % === %
% % % === % Direct solver and iteratve solver (iLU-preconditioned GMRES) % === %
% % % === % ============================================================ % === %

% % tol = 1e-6;
% % ext_itr_num = 5;
% % int_itr_num = 20;

% % bar_x_my_gmres = zeros(size(nrmlB_k));
% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % toc;
% % % tic; 
% % % disp('Computational time for solving Ax = b: ')
% % % bar_x_my_gmres = nrmlM_K\nrmlB_k;
% % % toc;
% % tic;
% % disp('The gmres solutin of Ax = B: ');
% % bar_x_my_gmres = gmres( nrmlM_K, nrmlB_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% % toc;

% % w_y = h_torso;
% % w_x = air_x;
% % w_z = air_z;
% % AFigsScript;

% % % tic;
% % % disp('Calculation time of iLU: ')
% % % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % % toc;