function plotYZ_Grid( h_torso, air_z, dy, dz )
    y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);
    z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);
    [ Y_grid, Z_grid ] = meshgrid(y_grid, z_grid);
    for idx = 1: 1: size(Z_grid, 1)
        scatter( y_grid, Z_grid(idx, :), 10 );
        hold on;
    end
end