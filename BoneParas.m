function [ Ribs, SSBone ] = BoneParas
% parameters of ribs, spine and sternum

% a 7 \times 1 matrix
rib_hr = 1 * ones(7, 1) / 100;
rib_wy = 1 * ones(7, 1) / 100;
rib_rad = 8 * ones(7, 1) / 100;
l_rib_x = - 6 * ones(7, 1) / 100;
l_rib_y = [ 8.5, 5.5, 2.5, -0.5, -3.5, -6.5, -9.5 ]' / 100;
l_rib_z = 0 * ones(7, 1) / 100;
r_rib_x = 6 * ones(7, 1) / 100;
r_rib_y = [ 8.5, 5.5, 2.5, -0.5, -3.5, -6.5, -9.5 ]' / 100;
r_rib_z = 0 * ones(7, 1) / 100;

spine_hx = 2 / 100;
spine_hz = 2 / 100;
spine_wy = 19 / 100;
spine_x = 0 / 100;
spine_z = 7 / 100;

sternum_hx = 2 / 100;
sternum_hz = 1 / 100;
sternum_wy = spine_wy;
sternum_x = 0 / 100;
sternum_z = - 6.5 / 100;

Ribs = [ rib_hr, rib_wy, rib_rad, ...
          l_rib_x, l_rib_y, l_rib_z, ...
          r_rib_x, r_rib_y, r_rib_z ];
SSBone = [ spine_hx, spine_hz, spine_wy, spine_x, spine_z, ...
           sternum_hx, sternum_hz, sternum_wy, sternum_x, sternum_z ];

end