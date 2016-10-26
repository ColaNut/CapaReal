function [ Xtable, Ztable ] = fillTradlElctrd( a, c, dx, dz )

% a = myFloor(a, dx);
% c = myFloor(c, dz);

lenX = length( [ myCeil(0 - a, dx): dx: myFloor(0 + a, dx) ] );
lenZ = length( [ myCeil(0 - c, dz): dz: myFloor(0 + c, dz) ] );
Xtable = zeros( lenX, 4 );
Ztable = zeros( lenZ, 4 );

% int64 may not be sufficient

% fill the x table as x is an integer
for idx = 1: 1: lenX
    % shifting function for different shape
    int_grid_x = myCeil(0 - a, dx) + ( idx - 1 ) * dx;

    [ z1, z1_diff ] = nearestIntGrid( 0 + c * sqrt( abs(1 - ( (int_grid_x - 0) / a )^2) ), dz );
    [ z2, z2_diff ] = nearestIntGrid( 0 - c * sqrt( abs(1 - ( (int_grid_x - 0) / a )^2) ), dz );

    Xtable(idx, :) = [ int_grid_x, z1, int_grid_x, z2 ];
end

% fill z table
for idx = 1: 1: lenZ
    int_grid_z = myCeil(0 - c, dz) + ( idx - 1 ) * dz;

    [ x1, x1_diff ] = nearestIntGrid( 0 + a * sqrt( abs(1 - ( (int_grid_z - 0) / c )^2) ), dx );
    [ x2, x2_diff ] = nearestIntGrid( 0 - a * sqrt( abs(1 - ( (int_grid_z - 0) / c )^2) ), dx );

    Ztable(idx, :) = [ x1, int_grid_z, x2, int_grid_z ];
end

end