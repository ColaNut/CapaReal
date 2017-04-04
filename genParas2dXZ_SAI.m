function [ paras2dXZ_sai ] = genParas2dXZ_SAI( y, paras_SAI )

% Paras_SAI = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

w_x      = paras_SAI(1);
w_y      = paras_SAI(2);
if y < - w_y / 2 || y > w_y / 2
    warning('invalid y');
end
w_z      = paras_SAI(3);

h_x      = paras_SAI(4);
h_y      = paras_SAI(5);
h_z      = paras_SAI(6);

dx       = paras_SAI(7);
dy       = paras_SAI(8);
dz       = paras_SAI(9);

sample_valid = false;
y_idx        = int64(    y / dy       + w_y / (2 * dy) + 1);
y_idx_near   = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
y_idx_back   = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);
if y_idx >= y_idx_near && y_idx <= y_idx_back
    sample_valid = true;
end

paras2dXZ_sai = [ w_x, w_y, w_z, h_x, h_y, h_z, dx, dy, dz, sample_valid ];

end