clc; clear;
digits;

Mu_0            = 4 * pi * 10^(-7);
Epsilon_0       = 10^(-9) / (36 * pi);
Omega_0         = 2 * pi * 10 * 10^6; % 2 * pi * 10 MHz
V_0             = 126; 

% There 'must' be a grid point at the origin.
% parameterss
air_x = 30 / 100; % width: 30 cm
air_z = 30 / 100; % height: 30 cm
bolus_a = 14 / 100;
bolus_b = 14 / 100;
skin_a = 12 / 100;
skin_b = 12 / 100;
muscle_a = 11 / 100;
muscle_b = 11 / 100;
l_lung_x = - 4 / 100;
l_lung_z = 0 / 100;
l_lung_a = 3 / 100;
l_lung_b = 3 / 100;
r_lung_x = 4 / 100;
r_lung_z = 0 / 100;
r_lung_a = 3 / 100;
r_lung_b = 3 / 100;
tumor_x = 4 / 100;
tumor_z = 0 / 100;
tumor_r = 1 / 100;
dx = 1 / 100;
dz = 1 / 100;

paras = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
        l_lung_x, l_lung_z, l_lung_a, l_lung_b, r_lung_x, r_lung_z, r_lung_a, r_lung_b, ...
        tumor_x, tumor_z, tumor_r ];

figure(1);
plotMap( paras, dx, dz );

% modify the following functions with (x_0, y_0) as inputs
% enclose all fx in another script: constructCoordinateXZ_all.m
shiftedCoordinate = constructCoordinateXZ_all( paras, dx, dz );
plotShiftedCordinateXZ_all( shiftedCoordinate );
% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% % xy_grid_table: [ x_coordonate, y_coordonate, difference ]

% GridShiftTable = constructGridShiftTable( x_grid_table, y_grid_table, a, b, dx, dz );
% shiftedCoordinate = constructCoordinate( GridShiftTable, a, b, dx, dz );
% plotShiftedCordinate( shiftedCoordinate, a, b );
% % Start from here, plot the shifted grid points.