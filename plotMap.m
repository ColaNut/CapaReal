function plotMap( paras, dx, dz )

air_x = paras(1) * 100;
air_z = paras(2) * 100;
bolus_a = paras(3) * 100;
bolus_b = paras(4) * 100;
skin_a = paras(5) * 100;
skin_b = paras(6) * 100;
muscle_a = paras(7) * 100;
muscle_b = paras(8) * 100;
l_lung_x = paras(9) * 100;
l_lung_z = paras(10) * 100;
l_lung_a = paras(11) * 100;
l_lung_c = paras(12) * 100;
r_lung_x = paras(13) * 100;
r_lung_z = paras(14) * 100;
r_lung_a = paras(15) * 100;
r_lung_c = paras(16) * 100;
tumor_x = paras(17) * 100;
tumor_z = paras(18) * 100;
tumor_r = paras(19) * 100;

dx = 100 * dx;
dz = 100 * dz;

plotEllipse( bolus_a, 0, - bolus_a, 0, bolus_b, dx, dz );
plotEllipse( skin_a, 0, - skin_a, 0, skin_b, dx, dz );
plotEllipse( muscle_a, 0, - muscle_a, 0, muscle_b, dx, dz );
if isreal(l_lung_c)
    plotEllipse( l_lung_x + l_lung_a, l_lung_z, l_lung_x - l_lung_a, l_lung_z, l_lung_c, dx, dz );
end
if isreal(r_lung_c)
    plotEllipse( r_lung_x + r_lung_a, r_lung_z, r_lung_x - r_lung_a, r_lung_z, r_lung_c, dx, dz );
end
if isreal(tumor_r)
    plotEllipse( tumor_x + tumor_r, tumor_z, tumor_x - tumor_r, tumor_z, tumor_r, dx, dz );
end

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

[ X_grid, Z_grid ] = meshgrid(x_grid, z_grid);
for idx = 1: 1: size(Z_grid, 1)
    scatter( x_grid, Z_grid(idx, :), 10 );
    hold on;
end
axis( [ min(x_grid), max(x_grid), min(z_grid), max(z_grid) ] );

end