% function [ AxA, BxB ] = TestFc()

% AxA = cell(2, 1);
% AxA{1} = 30;
% AxA{2} = 60;

% CxC = horzcat( cell(2, 1), AxA )

% BxB = 0;
x = tumor_x + dx;
y = -0.04;
z = 0;
x_idx = x / dx + air_x / (2 * dx) + 1;
y_idx = y / dy + h_torso / (2 * dy) + 1;
z_idx = z / dz + air_z / (2 * dz) + 1;
[ x_idx, y_idx, z_idx ]

% end