clc; clear;
digits;

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 100 * 10^3; % 2 * pi * 100 kHz
J_0           = 300000;
% V_0           = 89; 

% Note, the corresponding 

% paras: 
rho           = [ 1, 4600 ]';
epsilon_r_pre = [ 1,    1,    1 ]';
sigma         = [ 0,    0, 10^9 ]';
epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );
mu_prime      = [ 1,    1,    1 ]';
mu_db_prime   = [ 0,  0.6,    0 ]';
mu_r          = mu_prime - i * mu_db_prime;

% There 'must' be a grid point at the origin.
loadParas_Mag;
% paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;

GridShiftTableXZ = cell( y_idx_max, 1);
% GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.

mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% medium1            : 1 
% magnetic particle  : 2
% conductor          : 3
% current sheet bndry: 11

for y = - w_y / 2: dy: w_y / 2
    paras2dXZ_Mag = genParas2dXZ_Mag( y, Paras_Mag );
    y_idx = y / dy + w_y / (2 * dy) + 1;
    sample_valid = paras2dXZ_Mag(12);
    if sample_valid
        mediumTable(:, int64(y_idx), :) = getRoughMed_Mag( mediumTable(:, int64(y_idx), :), paras2dXZ_Mag );
    end
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all_Mag( paras2dXZ_Mag, mediumTable(:, int64(y_idx), :) );
end

% re-organize the GridShiftTable
GridShiftTable = cell( w_x / dx + 1, w_y / dy + 1, w_z / dz + 1 );
for y_idx = 1: 1: w_y / dy + 1
    tmp_table = GridShiftTableXZ{ y_idx };
    for x_idx = 1: 1: w_x / dx + 1
        for z_idx = 1: 1: w_z / dz + 1
            GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
        end
    end
end

tmpParas = [ w_y, w_x, w_z ];
shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, tmpParas, dx, dy, dz );

% figure(1);
% hold on;
% plotGridLineXZ( shiftedCoordinateXYZ, uint64(0.01 / dy + w_y / (2 * dy) + 1) );
% plotGridLineYZ( shiftedCoordinateXYZ, uint64(0.02 / dx + w_x / (2 * dx) + 1) );

% sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
% B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable(m, n, ell) == uint8(2)
        SegMed(m, n, ell, :, :) = uint8(2);

        x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
        x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

        y_idx_near = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
        y_idx_far  = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);

        z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
        z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

        if ell == z_idx_up
            SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if ell == z_idx_down
            SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if m   == x_idx_left
            SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if m   == x_idx_rght
            SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if n   == y_idx_far
            SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
        if n   == y_idx_near
            SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), 1 );
        end
    end
end

% start from here: check the correctness of the above SegMed.
% The currently putOnCurrent.m has a zigzag boundary
n_far  =   ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
n_near = - ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
CurrentTable = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
% SegMedXZ = squeeze( SegMed(:, int64( (y_idx_max + 1) / 2 ), :, :, :) );
% mediumXZ = squeeze( mediumTable(:, int64( (y_idx_max + 1) / 2 ), :) );
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if n >= n_near && n <= n_far && mediumTable(m, n, ell) == 11
        [ SegMed(m, n, ell, :, :), CurrentTable(m, n, ell, :, :, :) ] ...
            = putOnCurrent(m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ, mediumTable, J_0 );
    end
end

% the above process update the medium value and construct the shiftedCoordinateXYZ

x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
N_v = x_max_vertex * y_max_vertex * z_max_vertex;
N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
    + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
    + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
% tic;
% Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
% toc;
% save('FEM_A.mat', 'Vertex_Crdnt', 'SegMed');
load('FEM_A.mat');
% load('FEM_fullwave.mat');

% flag = '000';
% load('Case0317.mat');
% clearvars sparseS B_phi;
% sparseS = cell( N_v, 1 );
% B_phi = zeros(N_v, 1);
B_k = zeros(N_e, 1);
sparseK1 = cell( N_e, 1 );

% load('TMP0407.mat');

% start from here: 
% rewrite the [m, n, ell] to [m_v, n_v, ell_v] or [m_v_prm, n_v_prm, ell_v_prm] or [m_e, n_e, ell_e]

tic;
disp('The filling time of K_1 a = b_k: ');
% for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
for idx_v = x_max_vertex * y_max_vertex * 13: 1: x_max_vertex * y_max_vertex * 14
    [ m_v, n_v, ell_v ] = getMNL(idx_v, x_max_vertex, y_max_vertex, z_max_vertex);
    % volume
    if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex 
        if m_v == 5 && n_v == 17 && ell_v == 14
            ;
        end

        if m_v == 17 && n_v == 17 && ell_v == 14
            ;
        end
        flag = getMNL_flag(m_v, n_v, ell_v);
        % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
        % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
        SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        idx_prm = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        % start from here: modify the CurrentTable to point version and feed it into fillNrml_K1_Type1.m

        % check the assignment index in Type1, Type2, Type3 and Type4.
        % check the equality of the two fourTet types.
        switch flag
            case { '111', '000' }
                [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 2}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 4}, sparseK1{7 * ( idx_prm - 1 ) + 5}, sparseK1{7 * ( idx_prm - 1 ) + 6}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 7}, B_k ] = fillNrml_K1_Type1( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, epsilon_r, mu_r, Omega_0, ...
                        B_k, J_0 );
            case { '100', '011' }
                % x-shift
                auxiSegMed = zeros(6, 8, 'uint8');
                auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
                [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 2}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 4}, sparseK1{7 * ( idx_prm - 1 ) + 5}, sparseK1{7 * ( idx_prm - 1 ) + 6}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 7}, B_k ] = fillNrml_K1_Type2( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, J_0 );
            case { '101', '010' }
                % y-shift
                auxiSegMed = zeros(6, 8, 'uint8');
                auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
                [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 2}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 4}, sparseK1{7 * ( idx_prm - 1 ) + 5}, sparseK1{7 * ( idx_prm - 1 ) + 6}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 7}, B_k ] = fillNrml_K1_Type3( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, J_0 );
            case { '110', '001' }
                % z-shift
                auxiSegMed = zeros(6, 8, 'uint8');
                auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
                [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 2}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 4}, sparseK1{7 * ( idx_prm - 1 ) + 5}, sparseK1{7 * ( idx_prm - 1 ) + 6}, ...
                    sparseK1{7 * ( idx_prm - 1 ) + 7}, B_k ] = fillNrml_K1_Type4( m_v, n_v, ell_v, flag, ...
                        Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
                        B_k, J_0 );
            otherwise
                error('check');
        end
    end

    % check wheher x \le x_max_vertex or not
    % the three top-right-far faces
    if m_v >= 2 && n_v >= 2 && ell_v == z_max_vertex
        idx_prm = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 2}, ...
            sparseK1{7 * ( idx_prm - 1 ) + 4} ] = fillTop_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == x_max_vertex && n_v >= 2 && ell_v >= 2
        idx_prm = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{7 * ( idx_prm - 1 ) + 2}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
            sparseK1{7 * ( idx_prm - 1 ) + 5} ] = fillRght_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v >= 2 && n_v == y_max_vertex && ell_v >= 2
        idx_prm = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{7 * ( idx_prm - 1 ) + 1}, sparseK1{7 * ( idx_prm - 1 ) + 3}, ...
            sparseK1{7 * ( idx_prm - 1 ) + 6} ] = fillFar_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

    % the three bottom-left-near faces
    if m_v >= 2 && n_v == 1 && ell_v >= 2
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{ vIdx2eIdx(vIdx, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillNear_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v >= 2 && ell_v >= 2
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{ vIdx2eIdx(vIdx, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillLeft_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v >= 2 && n_v >= 2 && ell_v == 1
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        [ sparseK1{ vIdx2eIdx(vIdx, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
            sparseK1{ vIdx2eIdx(vIdx, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
            = fillBttm_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

    % three lines
    if m_v >= 2 && n_v == 1 && ell_v == 1
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        sparseK1{ vIdx2eIdx(vIdx, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine1_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v == 1 && ell_v >= 2
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        sparseK1{ vIdx2eIdx(vIdx, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine2_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end
    if m_v == 1 && n_v >= 2 && ell_v == 1
        vIdx = get_idx_prm(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
        sparseK1{ vIdx2eIdx(vIdx, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ...
            = fillLine3_K1( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    end

end
toc;
% save('TMP0411.mat');

% update the idx on the three face, three lines and one point stored in the first several part of sparseK1.

% save('beforeElctrd_S2.mat', 'sparseS');
% load('beforeElctrd_S2.mat');
% save('TMP0407.mat');

% % clc; clear;
% % load('Case0319.mat');
% % put on electrodes
% [ sparseS, B_phi ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
%                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );
% sparseS = PutOnDwnElctrd( sparseS, squeeze(mediumTable(:, 19, :)), tumor_x, tumor_y, ...
%                                     dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex );

% [ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_c, dx, dz );
% % Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
% % Ztable = [ x1, int_grid_z, x2, int_grid_z ];
% UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );

% [ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max );
% [ sparseA, B ] = DwnElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz );
% load('TMP0410.mat');

% % check empty rows
counter = 0;
for idx = 1: 1: N_e
    if isempty( sparseK1( idx ) )
        counter = counter + 1;
        [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
        [m, n, ell]
    end
end
counter

% load('TMP0410.mat');
% check NaN
for idx = 1: 1: N_e
    tmp_vector = sparseK1{ idx };
    lgth = length(tmp_vector);
    for idx2 = 1: 1: lgth
        if isnan( tmp_vector(idx2) )
            [idx, idx2]
        end
    end
end

% % load('TMP0410.mat');
% Normalize each rows
for idx = 1: 1: N_e
    tmp_vector = sparseK1{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    sparseK1{ idx } = tmp_vector;
    B_k( idx ) = B_k( idx ) ./ MAX_row_value;
end

tol = 1e-6;
ext_itr_num = 10;
int_itr_num = 40;

% note for the Mu_0 term in the ``K_1 a = b_k'' system
bar_x_my_gmres = zeros(size(B_k));
tic;
disp('The gmres solutin of Ax = B: ');
bar_x_my_gmres = my_gmres( sparseK1, Mu_0 * B_k, int_itr_num, tol, ext_itr_num );
toc;

% save('TMP0411.mat');
% save( strcat(fname, CaseName, '.mat') );
% save('Case0321_S2.mat');
% load('Case0321_S2.mat');

% ADstrbtn;
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