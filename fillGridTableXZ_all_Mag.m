function [ x_grid_table, z_grid_table ] = fillGridTableXZ_all_Mag( paras_Mag )

w_x          = paras_Mag(1);
w_y          = paras_Mag(2);
w_z          = paras_Mag(3);

h_x          = paras_Mag(4);
h_y          = paras_Mag(5);
h_z          = paras_Mag(6);
ell_y        = paras_Mag(7);
r_c          = paras_Mag(8);
dx           = paras_Mag(9);
dy           = paras_Mag(10);
dz           = paras_Mag(11);
sample_valid = paras_Mag(12);

% z_grid_table = cell( size([ myCeil(- ell_z / 2, dz): dz: myFloor(ell_z / 2, dz) ]') );

x_grid_table = [];
z_grid_table = [];

x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;

% n_far  =   ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% n_near = - ell_y / (2 * dy) + ( y_idx_max + 1 ) / 2;
% if n >= n_near && n <= n_far
    [ x_grid_table, z_grid_table ] = fillGridTable( 0, 0, r_c, r_c, dx, dz );
% end
% lgth = length([ myCeil(- ell_z / 2, dz): dz: myFloor(ell_z / 2, dz) ]');
% z_grid_table = [];

% if isreal(circle_x)
%     % fill z table
%     for idx = 1: 1: lgth
%         int_grid_z = myCeil(- ell_z / 2, dz) + ( idx - 1 ) * dz;

%         [ x1, x1_diff ] = nearestIntGrid( circle_x, dx );
%         [ x2, x2_diff ] = nearestIntGrid( - circle_x, dx );
        
%         z_grid_table = vertcat(z_grid_table, [ x1, int_grid_z, x1_diff, x2, int_grid_z, x2_diff ]);
%     end
% end

end