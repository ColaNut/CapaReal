function [ mediumTableXZ ] = medFill_Eso( mediumTableXZ, x_0, z_0, a, c, dx, dz, medValue, air_x, air_z )

% a = myFloor(a, dx);
% c = myFloor(c, dz);

if c == 0
    return;
end

loadParas_Eso0924

lx = length( [ myCeil(x_0 - a, dx): dx: myFloor(x_0 + a, dx) ] );
% z_grid_table = cell( size([ myCeil(z_0 - c, dz): dz: myFloor(z_0 + c, dz) ]') );

% fill the x table as x is an integer
for idx1 = 1: 1: lx
    % shifting function for different shape
    int_grid_x = myCeil(x_0 - a, dx) + ( idx1 - 1 ) * dx;

    z_top = z_0 + c * sqrt( abs(1 - ( (int_grid_x - x_0) / a )^2) );
    z_down = z_0 - c * sqrt( abs(1 - ( (int_grid_x - x_0) / a )^2) );

    x_idx = ( int_grid_x - es_x ) / dx + air_x / (2 * dx) + 1;

    lz = length( [ myCeil(z_down, dz): dz: myFloor(z_top, dz) ] );
    for idx2 = 1: 1: lz
        int_grid_z =  myCeil(z_down, dz) + ( idx2 - 1 ) * dz;
        z_idx = ( int_grid_z - es_z ) / dz + air_z / (2 * dz) + 1;
        mediumTableXZ( int64(x_idx), int64(z_idx) ) = uint8(medValue);
    end
end

end