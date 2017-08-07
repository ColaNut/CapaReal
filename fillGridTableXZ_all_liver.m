function [ x_grid_table, z_grid_table ] = fillGridTableXZ_all_liver( paras2dXZ, dx, dz )

% paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, fay_a, fat_c, muscle_a, muscle_c, ...
%     liver_x, liver_z, liver_x_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
%     tumor_x, tumor_y, tumor_z, tumor_r_prime ];

% m -> cm
air_x = paras2dXZ(1);
air_z = paras2dXZ(2);
bolus_a = paras2dXZ(3);
bolus_c = paras2dXZ(4);
fat_a = paras2dXZ(5);
fat_c = paras2dXZ(6);
muscle_a = paras2dXZ(7);
muscle_c = paras2dXZ(8);
liver_x = paras2dXZ(9);
liver_z = paras2dXZ(10);
liver_x_0 = paras2dXZ(11);
liver_z_0 = paras2dXZ(12);
liver_a_prime = paras2dXZ(13);
liver_c_prime = paras2dXZ(14);
liver_rotate = paras2dXZ(15);
m_1 = paras2dXZ(16);
m_2 = paras2dXZ(17);
tumor_x   = paras2dXZ(18);
tumor_y   = paras2dXZ(19);
tumor_z = paras2dXZ(20);
tumor_r_prime = paras2dXZ(21);

NumOfPart = 5;
tmp_x_grid_table = cell(NumOfPart, 1);
tmp_z_grid_table = cell(1, NumOfPart);
x_grid_table = [];
z_grid_table = [];

[ tmp_x_grid_table{1}, tmp_z_grid_table{1} ] = fillGridTable( 0, 0, bolus_a, bolus_c, dx, dz );
[ tmp_x_grid_table{2}, tmp_z_grid_table{2} ] = fillGridTable( 0, 0, fat_a, fat_c, dx, dz );
[ tmp_x_grid_table{3}, tmp_z_grid_table{3} ] = fillGridTable( 0, 0, muscle_a, muscle_c, dx, dz );
if liver_c_prime > 0
    % implement fillGridTable_liver.m
    [ tmp_x_grid_table{4}, tmp_z_grid_table{4} ] = fillGridTable_liver( liver_x + liver_x_0, liver_z + liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, dx, dz, 'XZ' );
end
if isreal(tumor_r_prime)
    [ tmp_x_grid_table{5}, tmp_z_grid_table{5} ] = fillGridTable( tumor_x, tumor_z, tumor_r_prime, tumor_r_prime, dx, dz );
end

for idx = 1: 1: NumOfPart
    x_grid_table = horzcat(x_grid_table, tmp_x_grid_table{idx});
    z_grid_table = vertcat(z_grid_table, tmp_z_grid_table{idx});
end

end