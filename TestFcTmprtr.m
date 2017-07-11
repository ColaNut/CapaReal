load('Tmprtr2cm.mat', 'dt');
% load('Tmprtr2cm.mat', 'bar_b');
% load('Tmprtr2cm.mat', 'Duration1', 'Duration2', 'Duration3');
% load('Tmprtr2cm.mat', 'bar_d');
% load('Tmprtr2cm.mat', 'Q_s');
% loadParas;

% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% m_v = 2 * tumor_m - 1;
% n_v = 2 * tumor_n - 1;
% ell_v = 2 * tumor_ell - 1;

% squeeze( Q_s(tumor_m, tumor_n, tumor_ell, :, :) )

% x_idx_max = air_x / dx + 1;
% y_idx_max = h_torso / dy + 1;
% z_idx_max = air_z / dz + 1;

% x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
% y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
% z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;

% load('Tmprtr2cm.mat', 'm_V');

% idx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v