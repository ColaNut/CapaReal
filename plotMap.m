function plotMap( paras, dx, dz )

air_x = paras(1);
air_z = paras(2);
bolus_a = paras(3);
bolus_b = paras(4);
skin_a = paras(5);
skin_b = paras(6);
muscle_a = paras(7);
muscle_b = paras(8);
l_lung_x = paras(9);
l_lung_z = paras(10);
l_lung_a = paras(11);
l_lung_b = paras(12);
r_lung_x = paras(13);
r_lung_z = paras(14);
r_lung_a = paras(15);
r_lung_b = paras(16);
tumor_x = paras(17);
tumor_z = paras(18);
tumor_r = paras(19);

plotEllipse( bolus_a, 0, - bolus_a, 0, bolus_b, dx, dz );
plotEllipse( skin_a, 0, - skin_a, 0, skin_b, dx, dz );
plotEllipse( muscle_a, 0, - muscle_a, 0, muscle_b, dx, dz );
plotEllipse( l_lung_x + l_lung_a, l_lung_z, l_lung_x - l_lung_a, l_lung_z, l_lung_b, dx, dz );
plotEllipse( r_lung_x + r_lung_a, r_lung_z, r_lung_x - r_lung_a, r_lung_z, r_lung_b, dx, dz );
plotEllipse( tumor_x + tumor_r, tumor_z, tumor_x - tumor_r, tumor_z, tumor_r, dx, dz );

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

[ X_grid, Z_grid ] = meshgrid(x_grid, z_grid);
for idx = 1: 1: size(Z_grid, 1)
    scatter( x_grid, Z_grid(idx, :) );
    hold on;
end
axis( [ min(x_grid), max(x_grid), min(z_grid), max(z_grid) ] );

end