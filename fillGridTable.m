function [ x_grid_table, z_grid_table ] = fillGridTable( x_0, z_0, a, c, dx, dz )

a_ori = a;
c_ori = c;

% a = myFloor(a, dx);
% c = myFloor(c, dz);

if c == 0
    x_grid_table = cell(1);
    z_grid_table = cell(1);
    x_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
    z_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
    return;
end

x_grid_table = cell( size([ myCeil(x_0 - a, dx): dx: myFloor(x_0 + a, dx) ] ) );
z_grid_table = cell( size([ myCeil(z_0 - c, dz): dz: myFloor(z_0 + c, dz) ]') );

% int64 may not be sufficient

% fill the x table as x is an integer
for idx = 1: 1: length(x_grid_table)
    % shifting function for different shape
    int_grid_x = myCeil(x_0 - a, dx) + ( idx - 1 ) * dx;

    [ z1, z1_diff ] = nearestIntGrid( z_0 + c_ori * sqrt( abs(1 - ( (int_grid_x - x_0) / a_ori )^2) ), dz );
    [ z2, z2_diff ] = nearestIntGrid( z_0 - c_ori * sqrt( abs(1 - ( (int_grid_x - x_0) / a_ori )^2) ), dz );

    x_grid_table{ idx } = [ int_grid_x, z1, z1_diff, int_grid_x, z2, z2_diff ];
end

% fill z table
for idx = 1: 1: length(z_grid_table)
    int_grid_z = myCeil(z_0 - c, dz) + ( idx - 1 ) * dz;

    [ x1, x1_diff ] = nearestIntGrid( x_0 + a_ori * sqrt( abs(1 - ( (int_grid_z - z_0) / c_ori )^2) ), dx );
    [ x2, x2_diff ] = nearestIntGrid( x_0 - a_ori * sqrt( abs(1 - ( (int_grid_z - z_0) / c_ori )^2) ), dx );

    z_grid_table{ idx } = [ x1, int_grid_z, x1_diff, x2, int_grid_z, x2_diff ];
end

end