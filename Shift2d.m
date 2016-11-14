clc; clear;
digits;

Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 10 * 10^6; % 2 * pi * 10 MHz
V_0           = 126; 
              % air, bolus, muscle, lung, tumor
rho           = [ 1,  1020,  1020, 1,050, 1040 ]';
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
    paras2dYZ = genParas2dYZ( x, paras, dy, dz );
    % paras2d = [ h_torso, air_x, air_z, bolus_a, bolusHghtZ, skin_a, skin_b, muscle_a, muscleHghtZ, ...
    %     l_lung_y, l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
    %     r_lung_y, r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
    %     tumor_y, tumor_z, tumor_r_prime ];
    y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
    x_idx = x / dx + air_x / (2 * dx) + 1;
    [ GridShiftTableXZ, mediumTable ] = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz, mediumTable );
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

sparseA = cell( x_idx_max * y_idx_max * z_idx_max, 1 );
B = zeros( x_idx_max * y_idx_max * z_idx_max, 1 );
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

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

    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        if mediumTable(p0) ~= 0
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
                            shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable );
        else
            [ sparseA{ p0 }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable, epsilon_r );
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
%     if m >= mid_x_idx - 3 && m <= mid_x_idx + 3 && n >= mid_y_idx - 1 && n <= mid_y_idx + 1 ...
%         && ell >= z_idx_max - 3 && ell <= z_idx_max - 2 
%         A_row = zeros(1, 2);
%         A_row(1) = p0;
%         A_row(2) = 1;
%         sparseA{ p0 } = A_row;
%         B( p0 ) = V_0;
%     elseif m >= mid_x_idx - 3 && m <= mid_x_idx + 3 && n >= mid_y_idx - 1 && n <= mid_y_idx + 1 ...
%         && ell <= 4 && ell >= 3 
%         A_row = zeros(1, 2);
%         A_row(1) = p0;
%         A_row(2) = 1;
%         sparseA{ p0 } = A_row;  
%     end
% end

% put on electrode
[ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_b, dx, dz );
lenX = size(Xtable, 1);
lenZ = size(Ztable, 1);

for idx = 1: 1: lenX
    x  = Xtable(idx, 1); 
    z1 = Xtable(idx, 2); 
    z2 = Xtable(idx, 4);
    if Xtable(idx, 1) ~= Xtable(idx, 3)
        error('check Xtable');
    end 
    m = int64( x / dx + air_x / (2 * dx) + 1 );
    ell_1 = int64( z1 / dz + air_z / (2 * dz) + 1 );
    ell_2 = int64( z2 / dz + air_z / (2 * dz) + 1 );

    if x >= - 13 / 100 && x <= 13 / 100
        for n = 4 / ( 100 * dy ): 1: 33 / ( 100 * dy )
            p0_1   = ( ell_1 - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
            % p0_1up = ( ell_1     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
            A_row_1 = zeros(1, 2);
            A_row_1(1) = p0_1;
            A_row_1(2) = 1;
            sparseA{ p0_1 } = A_row_1;
            B( p0_1 ) = V_0;
            % A_row_1up = zeros(1, 2);
            % A_row_1up(1) = p0_1up;
            % A_row_1up(2) = 1;
            % sparseA{ p0_1up } = A_row_1up;
            % B( p0_1up ) = V_0;

            p0_2   = ( ell_2 - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
            % p0_2dn = ( ell_2 - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
            A_row_2 = zeros(1, 2);
            A_row_2(1) = p0_2;
            A_row_2(2) = 1;
            sparseA{ p0_2 } = A_row_2;
            % A_row_2dn = zeros(1, 2);
            % A_row_2dn(1) = p0_2dn;
            % A_row_2dn(2) = 1;
            % sparseA{ p0_2dn } = A_row_2dn;
        end
    end
end

for idx = 1: 1: lenZ
    x1 = Ztable(idx, 1); 
    z  = Ztable(idx, 2); 
    x2 = Ztable(idx, 3); 
    if Ztable(idx, 2) ~= Ztable(idx, 4)
        error('check Z table');
    end 
    m_1 = int64( x1 / dx + air_x / (2 * dx) + 1 );
    m_2 = int64( x2 / dx + air_x / (2 * dx) + 1 );
    ell = int64( z / dz + air_z / (2 * dz) + 1 );

    if x2 >= - 13 / 100 && x1 <= 13 / 100
        for n = 4 / ( 100 * dy ): 1: 33 / ( 100 * dy )
            p0_1   = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_1;
            A_row_1 = zeros(1, 2);
            A_row_1(1) = p0_1;
            A_row_1(2) = 1;
            sparseA{ p0_1 } = A_row_1;

            p0_2   = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_2;
            A_row_2 = zeros(1, 2);
            A_row_2(1) = p0_2;
            A_row_2(2) = 1;
            sparseA{ p0_2 } = A_row_2;

            if z > 0
                % p0_1up = ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_1;
                % A_row_1up = zeros(1, 2);
                % A_row_1up(1) = p0_1up;
                % A_row_1up(2) = 1;
                % sparseA{ p0_1up } = A_row_1up;

                % p0_2up = ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_2;
                % A_row_2up = zeros(1, 2);
                % A_row_2up(1) = p0_2up;
                % A_row_2up(2) = 1;
                % sparseA{ p0_2up } = A_row_2up;

                B( p0_1 ) = V_0;
                B( p0_2 ) = V_0;
            % else
            %     p0_1dn = ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_1;
            %     A_row_1dn = zeros(1, 2);
            %     A_row_1dn(1) = p0_1dn;
            %     A_row_1dn(2) = 1;
            %     sparseA{ p0_1dn } = A_row_1dn;

            %     p0_2dn = ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_2;
            %     A_row_2dn = zeros(1, 2);
            %     A_row_2dn(1) = p0_2dn;
            %     A_row_2dn(2) = 1;
            %     sparseA{ p0_2dn } = A_row_2dn;
            end
        end
    end
end

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

save('RealCase4.mat');

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