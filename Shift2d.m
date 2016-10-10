clc; clear;
digits;

Mu_0            = 4 * pi * 10^(-7);
Epsilon_0       = 10^(-9) / (36 * pi);
Omega_0         = 2 * pi * 10 * 10^6; % 2 * pi * 10 MHz
V_0             = 126; 

% There 'must' be a grid point at the origin.
% parameters
h_torso = 10 / 100;
air_x = 30 / 100; % width: 30 cm
air_z = 30 / 100; % height: 30 cm
bolus_a = 14 / 100;
bolus_b = 14 / 100;
skin_a = 0 / 100;
skin_b = 0 / 100;
muscle_a = 12 / 100;
muscle_b = 12 / 100;
l_lung_x = - 4 / 100;
l_lung_z = 0 / 100;
l_lung_a = 3 / 100;
l_lung_b = 4 / 100;
l_lung_c = 2 / 100;
r_lung_x = 4 / 100;
r_lung_z = 0 / 100;
r_lung_a = 3 / 100;
r_lung_b = 4 / 100;
r_lung_c = 2 / 100;
tumor_x = 4 / 100;
tumor_y = 1 / 100;
tumor_z = 0 / 100;
tumor_r = 1 / 100;
dx = 1 / 100;
dy = 1 / 100;
dz = 1 / 100;

paras = [ h_torso, air_x, air_z, ...
        bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
        l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
        r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
        tumor_x, tumor_y, tumor_z, tumor_r ];

% generate the 2d parameters
GridShiftTableXZ = cell( h_torso / dy + 1, 1);
for y = - h_torso / 2: dy: h_torso / 2
    paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    % paras2d = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
    %         l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
    %         r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
    %         tumor_x, tumor_z, tumor_r_prime ];
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    GridShiftTableXZ{ int64(y_idx) } = constructCoordinateXZ_all( paras2dXZ, dx, dz );
end

for x = - air_x / 2: dx: air_x / 2
% x = tumor_x + dx;
    paras2dYZ = genParas2dYZ( x, paras, dx, dy, dz );
    % paras2dYZ = [ l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
    %                 r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
    %                 tumor_y, tumor_z, tumor_r_prime ];
    y_grid_table = fillGridTableY_all( paras2dYZ, dy, dz );
    x_idx = x / dx + air_x / (2 * dx) + 1;
    GridShiftTableXZ = constructGridShiftTableXYZ( GridShiftTableXZ, int64(x_idx), y_grid_table, h_torso, air_z, dy, dz );
end

GridShiftTable = cell( air_x / dx + 1, h_torso / dy + 1, air_x / dx + 1 );
for y_idx = 1: 1: h_torso / dy + 1
    tmp_table = GridShiftTableXZ{ y_idx };
    for x_idx = 1: 1: air_x / dx + 1
        for z_idx = 1: 1: air_z / dz + 1
            GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
        end
    end
end

shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, paras, dx, dy, dz );
% x = tumor_x;

for x = tumor_x: dx: r_lung_x + r_lung_a
    x_idx = x / dx + air_x / (2 * dx) + 1;

    paras2dYZ = genParas2dYZ( x, paras, dx, dy, dz );
    figure(int64(x_idx));
    plotYZ_Grid( h_torso, air_z, dy, dz );
    plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz );
end

% figure(1);
% plot3ShiftedCoordinate( shiftedCoordinate, h_torso, dy );

% figure(1);
% plotMap( paras2d, dx, dz );
% plotShiftedCordinateXZ_all( shiftedCoordinateXZ );

% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]