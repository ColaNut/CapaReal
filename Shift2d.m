clc; clear;
digits;

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 10 * 10^6; % 2 * pi * 10 MHz
V_0           = 126; 
epsilon_r_pre = [ 1, 113.0,   184, 264.9,  402 ]';
sigma         = [ 0,  0.61, 0.685,  0.42, 0.68 ]';
epsilon_r     = epsilon_r_pre - i * sigma ./ ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
loadParas;
% paras = [ h_torso, air_x, air_z, ...
%         bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
%         l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
%         r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
%         tumor_x, tumor_y, tumor_z, tumor_r ];

x_idx_max = air_x / dx + 1;
y_idx_max = h_torso / dy + 1;
z_idx_max = air_z / dz + 1;

GridShiftTableXZ = cell( h_torso / dy + 1, 1);
mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');

for y = - h_torso / 2: dy: h_torso / 2
    paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    % paras2d = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
    %         l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
    %         r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
    %         tumor_x, tumor_z, tumor_r_prime ];
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    mediumTable(:, int64(y_idx), :) = getRoughMed( mediumTable(:, int64(y_idx), :), paras2dXZ, dx, dz );
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all( paras2dXZ, dx, dz, mediumTable(:, int64(y_idx), :) );
end

for x = - air_x / 2: dx: air_x / 2
    paras2dYZ = genParas2dYZ( x, paras, dx, dy, dz );
    % paras2dYZ = [ l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
    %                 r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
    %                 tumor_y, tumor_z, tumor_r_prime ];
    y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
    x_idx = x / dx + air_x / (2 * dx) + 1;
    [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable );
end

% reorganize the GridShiftTable
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

%     paras2dYZ = genParas2dYZ( x, paras, dx, dy, dz );
%     figure(int64(x_idx));
%     plotYZ_Grid( h_torso, air_z, dy, dz );
%     plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz );
% end

A = zeros( x_idx_max * y_idx_max * z_idx_max );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
disp('The fill up time of A: ');
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    if mod( idx, x_idx_max * y_idx_max ) == 0
        n = y_idx_max;
    else
        n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
    end
    
    ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

    p0 = idx;
    [ m, n, ell ];

    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        if mediumTable(p0) ~= 0
            A(p0, :) = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max );
        end
        if mediumTable(p0) == 0
            A(p0, :) = fillBndrPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                        mediumTable, epsilon_r );
        end
    elseif ell == z_idx_max
        A(p0, :) = fillTop_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif ell == 1
        A(p0, :) = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
        A(p0, :) = fillRight_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
        A(p0, :) = fillLeft_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        A(p0, :) = fillFront_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        A(p0, :) = fillBack_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    end
end
toc;

% % put on electrode
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
%     tmp_m = mod( idx, x_idx_max );
%     if tmp_m == 0
%         m = x_idx_max;
%     else
%         m = tmp_m;
%     end

%     if mod( idx, x_idx_max * y_idx_max ) == 0
%         n = y_idx_max;
%     else
%         n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
%     end
    
%     ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

%     p0 = idx;
%     mid_x_idx = ( x_idx_max + 1 ) / 2;
%     mid_y_idx = ( y_idx_max + 1 ) / 2;
%     if m >= mid_x_idx - 3 && m <= mid_x_idx + 3 && n >= mid_y_idx - 3 && n <= mid_y_idx + 3 && ell == z_idx_max - 1 
%         A_row = zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         A_row( p0 ) = 1;
%         A(p0, :) = A_row;
%         B(p0) = V_0;
%     elseif m >= mid_x_idx - 3 && m <= mid_x_idx + 3 && n >= mid_y_idx - 3 && n <= mid_y_idx + 3 && ell == 2 
%         A_row = zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         A_row( p0 ) = 1;
%         A(p0, :) = A_row;
%     end
% end

% % Normalize each rows
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     tmp_vector = A(idx, :);
%     maxVal = max( tmp_vector );
%     % num = uint8(size(tmp_vector, 2)) / 2;
%     % MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
%     % tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
%     A( idx, : ) = tmp_vector ./ abs(maxVal);
%     B( idx ) = B( idx ) ./ abs(maxVal);
% end
% % save('preFirstTest.mat');

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x = A \ B;
% toc;

% save('FirstTest.mat');

% PhiDstrbtn;


% paras2dXZ = genParas2d( 0, paras, dx, dy, dz );
% figure(1);
% plotMap( paras2dXZ, dx, dz );
% tmpCrdt = zeros( x_idx_max, z_idx_max, 2);
% tmpCrdt(:, :, 1) = shiftedCoordinateXYZ(:, 6, :, 1);
% tmpCrdt(:, :, 2) = shiftedCoordinateXYZ(:, 6, :, 3);
% plotShiftedCordinateXZ_all( tmpCrdt );

% count = 0;
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     if A( idx, : ) == zeros( 1, x_idx_max * y_idx_max * z_idx_max );
%         count = count + 1;
%     end
% end
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]