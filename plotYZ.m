function plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz )

l_lung_z = paras2dYZ(1);
l_lung_b = paras2dYZ(2);
l_lung_c = paras2dYZ(3);

r_lung_z = paras2dYZ(4);
r_lung_b = paras2dYZ(5);
r_lung_c = paras2dYZ(6);

tumor_y = paras2dYZ(7);
tumor_z = paras2dYZ(8);
tumor_r = paras2dYZ(9);

if isreal(l_lung_c)
    plotEllipse( l_lung_b, l_lung_z, - l_lung_b, l_lung_z, l_lung_c, dy, dz );
end
if isreal(r_lung_c)
    plotEllipse( r_lung_b, r_lung_z, - r_lung_b, r_lung_z, r_lung_c, dy, dz );
end
if isreal(tumor_r)
    plotEllipse( tumor_y + tumor_r, tumor_z, tumor_y - tumor_r, tumor_z, tumor_r, dy, dz );
end

x_idx = x / dx + air_x / (2 * dx) + 1;

x_idx = int64(x_idx);

for z_idx = 1: 1: air_z / dz + 1
    scatter( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
        shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 10, 'k', 'filled' );
    plot( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
        shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 'k', 'LineWidth', 0.5 );
    hold on;
end

for y_idx = 1: 1: h_torso / dy + 1
    plot( squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 2 )), ...
        squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 3 )), 'k', 'LineWidth', 0.5 );
    hold on;
end

set(gca,'fontsize',18);
axis( [ - h_torso / 2, h_torso / 2, - air_z / 2, air_z / 2 ] );
xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18); 

end