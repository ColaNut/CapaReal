function [ y_grid_table ] = fillGridTableY_all( paras2dYZ, dy, dz )

l_lung_z = paras2dYZ(11);
l_lung_b = paras2dYZ(12);
l_lung_c = paras2dYZ(13);

r_lung_z = paras2dYZ(15);
r_lung_b = paras2dYZ(16);
r_lung_c = paras2dYZ(17);

tumor_y = paras2dYZ(18);
tumor_z = paras2dYZ(19);
tumor_r = paras2dYZ(20);

% paras2dYZ = [ h_torso, air_x, air_z, bolus_a, bolusHghtZ, skin_a, skin_b, muscle_a, muscleHghtZ, ...
%         l_lung_y, l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
%         r_lung_y, r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
%         tumor_y, tumor_z, tumor_r_prime ];

tmp_y_grid_table = cell(3, 1);
RedTmp = cell(1);
y_grid_table = [];

if isreal(l_lung_c)
    [ RedTmp, tmp_y_grid_table{1} ] = fillGridTable( 0, l_lung_z, l_lung_b, l_lung_c, dy, dz );
end
if isreal(r_lung_c)
    [ RedTmp, tmp_y_grid_table{2} ] = fillGridTable( 0, r_lung_z, r_lung_b, r_lung_c, dy, dz );
end
if isreal(tumor_r)
    [ RedTmp, tmp_y_grid_table{3} ] = fillGridTable( tumor_y, tumor_z, tumor_r, tumor_r, dy, dz );
end

for idx = 1: 1: 3
    y_grid_table = vertcat(y_grid_table, tmp_y_grid_table{idx});
end

end