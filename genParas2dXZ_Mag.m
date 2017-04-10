function [ paras2dXZ_mag ] = genParas2dXZ_Mag( y, paras_Mag )

% Paras_Mag = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_y, r_c, dx, dy, dz ];

w_x      = paras_Mag(1);
w_y      = paras_Mag(2);
if y < - w_y / 2 || y > w_y / 2
    warning('invalid y');
end
w_z      = paras_Mag(3);

h_x      = paras_Mag(4);
h_y      = paras_Mag(5);
h_z      = paras_Mag(6);
ell_y    = paras_Mag(7);
r_c      = paras_Mag(8);
dx       = paras_Mag(9);
dy       = paras_Mag(10);
dz       = paras_Mag(11);

sample_valid = false;
y_idx        = int64(    y / dy       + w_y / (2 * dy) + 1);
y_idx_near   = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
y_idx_back   = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);
if y_idx >= y_idx_near && y_idx <= y_idx_back
    sample_valid = true;
end

paras2dXZ_mag = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_y, r_c, dx, dy, dz, sample_valid ];

end