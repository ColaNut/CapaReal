function [ x_grid_table, z_grid_table ] = fillGridTableXZ_all_Eso( dx, dz )

loadParas_Eso0924;
tmp_x_grid_table = cell(2, 1);
tmp_z_grid_table = cell(1, 2);
x_grid_table = [];
z_grid_table = [];
% esophagus 
[ tmp_x_grid_table{1}, tmp_z_grid_table{1} ] = fillGridTable( es_x, es_z, es_r, es_r, dx, dz );
% endocopy
[ tmp_x_grid_table{2}, tmp_z_grid_table{2} ] = fillGridTable( endo_x, endo_z, endo_r, endo_r, dx, dz );

for idx = 1: 1: 2
    x_grid_table = horzcat(x_grid_table, tmp_x_grid_table{idx});
    z_grid_table = vertcat(z_grid_table, tmp_z_grid_table{idx});
end

end