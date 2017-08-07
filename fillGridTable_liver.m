function [ x_grid_table, z_grid_table ] = fillGridTable_liver( x_0, z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, dx, dz, XZ_YZ );

% get the variable: max_a
t = linspace( 0, 2 * pi );
X = liver_a_prime * cos(t);
Z = liver_c_prime * sin(t);
max_a = max( X * cos(liver_rotate) - Z * sin(liver_rotate) );
max_c = max( X * sin(liver_rotate) + Z * cos(liver_rotate) );

if liver_c_prime <= 0
    x_grid_table = cell(1);
    z_grid_table = cell(1);
    x_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
    z_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
    return;
end

x_grid_table = cell( size([ myCeil(x_0 - max_a, dx): dx: myFloor(x_0 + max_a, dx) ] ) );
z_grid_table = cell( size([ myCeil(z_0 - max_c, dz): dz: myFloor(z_0 + max_c, dz) ]') );

% fill the x table as x is an integer
for idx = 1: 1: length(x_grid_table)
    % shifting function for different shape
    int_grid_x = myCeil(x_0 - max_a, dx) + ( idx - 1 ) * dx;

    % On the ellipse, find the z-value for the corresponding int_grid_x
    RotatMat = [   cos(liver_rotate), sin(liver_rotate); 
                 - sin(liver_rotate), cos(liver_rotate) ];
    RotatMat(:, 1) = RotatMat(:, 1) * (int_grid_x - x_0) - RotatMat(:, 2) * z_0;
    % RotatMat(:, 1) = RotatMat(:, 1) * int_grid_x;
    SqrRoots = roots( sum([ [ RotatMat(1, 2)^2, 2 * RotatMat(1, 1) * RotatMat(1, 2), RotatMat(1, 1)^2 ] / liver_a_prime^2; ...
                            [ RotatMat(2, 2)^2, 2 * RotatMat(2, 1) * RotatMat(2, 2), RotatMat(2, 1)^2 ] / liver_c_prime^2 ]) - [0, 0, 1] );

    if m_1 * int_grid_x + m_2 < max( SqrRoots )
        [ z1, z1_diff ] = nearestIntGrid( max( SqrRoots ), dz );
        [ z2, z2_diff ] = nearestIntGrid( max( min( SqrRoots ), m_1 * int_grid_x + m_2 ), dz );
        x_grid_table{ idx } = [ int_grid_x, z1, z1_diff, int_grid_x, z2, z2_diff ];
    else
        x_grid_table{idx} = [ 0, 0, 0, 0, 0, 0 ];
    end
end

% fill z table
for idx = 1: 1: length(z_grid_table)
    int_grid_z = myCeil(z_0 - max_c, dz) + ( idx - 1 ) * dz;

    % On the ellipse, find the z-value for the corresponding int_grid_x
    RotatMat = [   cos(liver_rotate), sin(liver_rotate); 
                 - sin(liver_rotate), cos(liver_rotate) ];
    RotatMat(:, 2) = RotatMat(:, 2) * ( int_grid_z - z_0 ) - RotatMat(:, 1) * x_0;
    % RotatMat(:, 2) = RotatMat(:, 2) * int_grid_z;
    SqrRoots = roots( sum([ [ RotatMat(1, 1)^2, 2 * RotatMat(1, 1) * RotatMat(1, 2), RotatMat(1, 2)^2 ] / liver_a_prime^2; ...
                 [ RotatMat(2, 1)^2, 2 * RotatMat(2, 1) * RotatMat(2, 2), RotatMat(2, 2)^2 ] / liver_c_prime^2 ]) - [0, 0, 1] );

    switch XZ_YZ
    case 'XZ'
        if int_grid_z / m_1 - m_2 / m_1 > min( SqrRoots )
            [ x1, x1_diff  ] = nearestIntGrid( min( max( SqrRoots ), int_grid_z / m_1 - m_2 / m_1 ), dz );
            [ x2, x2_diff  ] = nearestIntGrid( min( SqrRoots ), dz );
            z_grid_table{ idx } = [ x1, int_grid_z, x1_diff, x2, int_grid_z, x2_diff ];
        else
            % z_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
            z_grid_table{ idx } = [ 0, 0, 0, 0, 0, 0 ];
        end
    case 'YZ'
        if int_grid_z / m_1 - m_2 / m_1 < max( SqrRoots )
            [ x1, x1_diff  ] = nearestIntGrid( max( SqrRoots ), dz );
            [ x2, x2_diff  ] = nearestIntGrid( max( min( SqrRoots ), int_grid_z / m_1 - m_2 / m_1 ), dz );
            z_grid_table{ idx } = [ x1, int_grid_z, x1_diff, x2, int_grid_z, x2_diff ];
        else
            % z_grid_table{1} = [ x_0, z_0, 0, x_0, z_0, 0 ];
            z_grid_table{ idx } = [ 0, 0, 0, 0, 0, 0 ];
        end
    end

end

end