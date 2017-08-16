function [ mediumTableXZ ] = getRoughMed_Mag( mediumTableXZ, paras2dXZ_mag )

% paras2dXZ_mag = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_y, r_c, dx, dy, dz, sample_valid ];

w_x          = paras2dXZ_mag(1);
w_y          = paras2dXZ_mag(2);
w_z          = paras2dXZ_mag(3);

h_x          = paras2dXZ_mag(4);
h_y          = paras2dXZ_mag(5);
h_z          = paras2dXZ_mag(6);
ell_y        = paras2dXZ_mag(7);
r_c          = paras2dXZ_mag(8);
dx           = paras2dXZ_mag(9);
dy           = paras2dXZ_mag(10);
dz           = paras2dXZ_mag(11);
sample_valid = paras2dXZ_mag(12);

x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);

z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

mediumTableXZ = medFill( mediumTableXZ, 0, 0, r_c, r_c, dx, dz, 2, w_x, w_z );

if sample_valid
    mediumTableXZ(x_idx_left: x_idx_rght, z_idx_down: z_idx_up) = uint8(3);
end

end