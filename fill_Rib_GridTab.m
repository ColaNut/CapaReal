function [ x_grid_table, z_grid_table ] = fill_Rib_GridTab(rib_x, rib_z, rib_hr, rib_rad, dx, dz)

    % x_grid_table = cell( size([ myCeil(rib_x - rib_rad, dx): dx: myFloor(- spine_hx / 2, dx) ] ) );
    % z_grid_table = cell( size([ myCeil(rib_z - rib_rad, dz): dz: myFloor(rib_z + rib_rad, dz) ]') );
    
    tmp_x_grid_table = cell(2, 1);
    tmp_z_grid_table = cell(1, 2);
    x_grid_table = [];
    z_grid_table = [];

    [ tmp_x_grid_table{1}, tmp_z_grid_table{1} ] = fillGridTable( rib_x, rib_z, rib_rad + rib_hr, rib_rad + rib_hr, dx, dz );
    [ tmp_x_grid_table{2}, tmp_z_grid_table{2} ] = fillGridTable( rib_x, rib_z, rib_rad, rib_rad, dx, dz );

    for idx = 1: 1: 2
        x_grid_table = horzcat(x_grid_table, tmp_x_grid_table{idx});
        z_grid_table = vertcat(z_grid_table, tmp_z_grid_table{idx});
    end

end