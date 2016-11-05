function plotYZ( paras2dYZ, dy, dz )

% paras2d = [ h_torso, air_x, air_z, bolus_a, bolusHghtZ, skin_a, skin_b, muscle_a, muscleHghtZ, ...
%         l_lung_y, l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
%         r_lung_y, r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
%         tumor_y, tumor_z, tumor_r_prime ];

h_torso = 100 * paras2dYZ(1); 
air_x = 100 * paras2dYZ(2); 
air_z = 100 * paras2dYZ(3); 
bolus_a = 100 * paras2dYZ(4); 
bolusHghtZ = 100 * paras2dYZ(5); 
skin_a = 100 * paras2dYZ(6); 
skin_b = 100 * paras2dYZ(7); 
muscle_a = 100 * paras2dYZ(8); 
muscleHghtZ = 100 * paras2dYZ(9); 

l_lung_y = 100 * paras2dYZ(10); 
l_lung_z = 100 * paras2dYZ(11); 
l_lung_b = 100 * paras2dYZ(12); 
l_lung_c = 100 * paras2dYZ(13); 

r_lung_y = 100 * paras2dYZ(14); 
r_lung_z = 100 * paras2dYZ(15); 
r_lung_b = 100 * paras2dYZ(16); 
r_lung_c = 100 * paras2dYZ(17); 

tumor_y = 100 * paras2dYZ(18); 
tumor_z = 100 * paras2dYZ(19); 
tumor_r = 100 * paras2dYZ(20);

dy = 100 * dy;
dz = 100 * dz;

if isreal(l_lung_c)
    plotEllipse( l_lung_b, l_lung_z, - l_lung_b, l_lung_z, l_lung_c, dy, dz );
end
if isreal(r_lung_c)
    plotEllipse( r_lung_b, r_lung_z, - r_lung_b, r_lung_z, r_lung_c, dy, dz );
end
if isreal(tumor_r)
    plotEllipse( tumor_y + tumor_r, tumor_z, tumor_y - tumor_r, tumor_z, tumor_r, dy, dz );
end

y_idx = - h_torso / 2: dy: h_torso / 2;
bolusUpL = bolusHghtZ * ones(size(y_idx));
bolusDnL = - bolusHghtZ * ones(size(y_idx));
muscleUpL = muscleHghtZ * ones(size(y_idx));
muscleDnL = - muscleHghtZ * ones(size(y_idx));

plot( y_idx, bolusUpL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, bolusDnL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, muscleUpL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, muscleDnL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

% x_idx = x / dx + air_x / (2 * dx) + 1;

% x_idx = int64(x_idx);

% for z_idx = 1: 1: air_z / dz + 1
%     scatter( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
%         shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 10, 'k', 'filled' );
%     plot( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
%         shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 'k', 'LineWidth', 0.5 );
%     hold on;
% end

% for y_idx = 1: 1: h_torso / dy + 1
%     plot( squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 2 )), ...
%         squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 3 )), 'k', 'LineWidth', 0.5 );
%     hold on;
% end

% set(gca,'fontsize',18);
axis( [ - h_torso / 2, h_torso / 2, - air_z / 2, air_z / 2 ] );
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18); 

end