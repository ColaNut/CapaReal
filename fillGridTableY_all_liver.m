function y_grid_table = fillGridTableY_all_liver( paras2dYZ, dy, dz )
% paras2dYZ = [ h_torso, air_x, air_z, ...
%         bolus_a, bolusHghtZ, skin_a, skin_c, muscle_a, muscleHghtZ, ...
%         liver_z, liver_y_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
%         tumor_y, tumor_z, tumor_r_prime ];

liver_z = paras2dYZ(10);
liver_y_0 = paras2dYZ(11);
liver_z_0 = paras2dYZ(12);
liver_a_prime = paras2dYZ(13);
liver_c_prime = paras2dYZ(14);
liver_rotate = paras2dYZ(15);

m_1 = paras2dYZ(16);
m_2 = paras2dYZ(17);

tumor_y = paras2dYZ(18);
tumor_z = paras2dYZ(19);
tumor_r_prime = paras2dYZ(20);

NumOfPart = 2;
tmp_y_grid_table = cell(NumOfPart, 1);
RedTmp = cell(1);
y_grid_table = [];

% if isreal(l_lung_c)
%     [ RedTmp, tmp_y_grid_table{1} ] = fillGridTable( 0, l_lung_z, l_lung_b, l_lung_c, dy, dz );
% end
if liver_a_prime > 0 && liver_c_prime > 0
    [ RedTmp, tmp_y_grid_table{1} ] = fillGridTable_liver( liver_y_0, liver_z + liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, dy, dz, 'YZ' );
end
if isreal(tumor_r_prime)
    [ RedTmp, tmp_y_grid_table{2} ] = fillGridTable( tumor_y, tumor_z, tumor_r_prime, tumor_r_prime, dy, dz );
end

for idx = 1: 1: NumOfPart
    y_grid_table = vertcat(y_grid_table, tmp_y_grid_table{idx});
end

end