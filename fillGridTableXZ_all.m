function [ x_grid_table, z_grid_table ] = fillGridTableXZ_all( paras, dx, dz )

% 0
air_x = paras(1);
air_z = paras(2);

% 1
bolus_a = paras(3);
bolus_b = paras(4);

% 2
skin_a = paras(5);
skin_b = paras(6);

% 3
muscle_a = paras(7);
muscle_b = paras(8);

% 4
l_lung_x = paras(9);
l_lung_z = paras(10);
l_lung_a = paras(11);
l_lung_c = paras(12);

% 5
r_lung_x = paras(13);
r_lung_z = paras(14);
r_lung_a = paras(15);
r_lung_c = paras(16);

% 6
tumor_x = paras(17);
tumor_z = paras(18);
tumor_r = paras(19);

tmp_x_grid_table = cell(6, 1);
tmp_z_grid_table = cell(1, 6);
x_grid_table = [];
z_grid_table = [];

[ tmp_x_grid_table{1}, tmp_z_grid_table{1} ] = fillGridTable( 0, 0, bolus_a, bolus_b, dx, dz );
[ tmp_x_grid_table{2}, tmp_z_grid_table{2} ] = fillGridTable( 0, 0, skin_a, skin_b, dx, dz );
[ tmp_x_grid_table{3}, tmp_z_grid_table{3} ] = fillGridTable( 0, 0, muscle_a, muscle_b, dx, dz );
if isreal(l_lung_c)
    [ tmp_x_grid_table{4}, tmp_z_grid_table{4} ] = fillGridTable( l_lung_x, l_lung_z, l_lung_a, l_lung_c, dx, dz );
end
if isreal(r_lung_c)
    [ tmp_x_grid_table{5}, tmp_z_grid_table{5} ] = fillGridTable( r_lung_x, r_lung_z, r_lung_a, r_lung_c, dx, dz );
end
if isreal(tumor_r)
    [ tmp_x_grid_table{6}, tmp_z_grid_table{6} ] = fillGridTable( tumor_x, tumor_z, tumor_r, tumor_r, dx, dz );
end

for idx = 1: 1: 6
    x_grid_table = horzcat(x_grid_table, tmp_x_grid_table{idx});
    z_grid_table = vertcat(z_grid_table, tmp_z_grid_table{idx});
end

end