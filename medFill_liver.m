function mediumTableXZ = medFill_liver( mediumTableXZ, liver_x, liver_z, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, dx, dz, medValue, air_x, air_z )

% if c == 0
%     return;
% end

% get the variable: max_a
t = linspace( 0, 2 * pi );
X = liver_a_prime * cos(t);
Z = liver_c_prime * sin(t);
max_a = max( X * cos(liver_rotate) - Z * sin(liver_rotate) );

lx = length( [ myCeil(liver_x - max_a, dx): dx: myFloor(liver_x + max_a, dx) ] );
% z_grid_table = cell( size([ myCeil(z_0 - c, dz): dz: myFloor(z_0 + c, dz) ]') );

% fill the x table as x is an integer
for idx1 = 1: 1: lx
    % shifting function for different shape
    int_grid_x = myCeil(liver_x - max_a, dx) + ( idx1 - 1 ) * dx;

    % get z_top and z_down
    % get the second order equation of x;
    % use matlab to solve for it.
    RotatMat = [   cos(liver_rotate), sin(liver_rotate); 
                 - sin(liver_rotate), cos(liver_rotate) ];
    RotatMat(:, 1) = RotatMat(:, 1) * ( int_grid_x - liver_x ) - RotatMat(:, 2) * liver_z;
    SqrRoots = roots( sum([ [ RotatMat(1, 2)^2, 2 * RotatMat(1, 1) * RotatMat(1, 2), RotatMat(1, 1)^2 ] / liver_a_prime^2; ...
                 [ RotatMat(2, 2)^2, 2 * RotatMat(2, 1) * RotatMat(2, 2), RotatMat(2, 1)^2 ] / liver_c_prime^2 ]) - [0, 0, 1] );

    if m_1 * int_grid_x + m_2 < max( SqrRoots )
        z_top = max( SqrRoots );
        z_down = max( min( SqrRoots ), m_1 * int_grid_x + m_2 ); 
        % z_top = z_0 + c * sqrt( abs(1 - ( (int_grid_x - x_0) / a )^2) );
        % z_down = z_0 - c * sqrt( abs(1 - ( (int_grid_x - x_0) / a )^2) );

        x_idx = int_grid_x / dx + air_x / (2 * dx) + 1;

        lz = length( [ myCeil(z_down, dz): dz: myFloor(z_top, dz) ] );
        for idx2 = 1: 1: lz
            int_grid_z =  myCeil(z_down, dz) + ( idx2 - 1 ) * dz;
            z_idx = int_grid_z / dz + air_z / (2 * dz) + 1;
            mediumTableXZ( int64(x_idx), int64(z_idx) ) = uint8(medValue);
        end
    end
end

end