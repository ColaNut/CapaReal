clc; clear;
digits;

Mu_0            = 4 * pi * 10^(-7);
Epsilon_0       = 10^(-9) / (36 * pi);
Omega_0         = 2 * pi * 10 * 10^6; % 2 * pi * 10 MHz

V_0             = 126;

figure(1);
% An ellipse with a = 8; b = 6;
a = 8;
b = 6;
dx = 0.5;
dz = 0.5;
plotEllipse( a, 0, - a, 0, b, dx, dz );

[ x_grid_table, y_grid_table ] = fillGridTable( a, b, dx, dz );
% Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table: [ x_coordonate, y_coordonate, difference ]

GridShiftTable = constructGridShiftTable( x_grid_table, y_grid_table, a, b, dx, dz );
shiftedCoordinate = constructCoordinate( GridShiftTable, a, b, dx, dz );
plotShiftedCordinate( shiftedCoordinate, a, b );
% Start from here, plot the shifted grid points.