function [ x_grid_table, z_grid_table ] = fillGridTable( a, b, dx, dz )

a_ori = a;
b_ori = b;

a = myFloor(a, dx);
b = myFloor(b, dz);

x_grid_table = cell(size([ - a: dx: a ] ));
z_grid_table = cell(size([ - b: dz: b ]'));

% int64 may not be sufficient

% fill the x table as x is an integer
for idx = 1: 1: 2 * int64( a / dx ) + 1
    % shifting function for different shape
    x = double(idx) * dx - a - dx;

    [ z1, z1_diff ] = nearestIntGrid( b_ori * sqrt( 1 - (x / a_ori)^2 ), dz );
    [ z2, z2_diff ] = nearestIntGrid( - b_ori * sqrt( 1 - (x / a_ori)^2 ), dz );

    x_grid_table{ idx } = [ x, z1, z1_diff, x, z2, z2_diff ];
end

% fill z table
for idx = 1: 1: 2 * int64( b / dz ) + 1
    z = double(idx) * dz - b - dz;

    [ x1, x1_diff ] = nearestIntGrid( a_ori * sqrt( 1 - (z / b_ori)^2 ), dx );
    [ x2, x2_diff ] = nearestIntGrid( - a_ori * sqrt( 1 - (z / b_ori)^2 ), dx );

    z_grid_table{ idx } = [ x1, z, x1_diff, x2, z, x2_diff ];
end

end