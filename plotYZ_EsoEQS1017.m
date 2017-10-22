function plotYZ_EsoEQS1017( paras2dYZ, dy, dz )

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

loadParas_Eso0924;
% loadAmendParas_Esophagus
es_x = 100 * es_x;
es_z = 100 * es_z;
es_r = 100 * es_r;

tumor_x_es = 100 * tumor_x_es;
tumor_y_es = 100 * tumor_y_es;
tumor_z_es = 100 * tumor_z_es;
tumor_r_es = 100 * tumor_r_es;
tumor_hy_es = 100 * tumor_hy_es; % lenght of 4 cm

if isreal(l_lung_c)
    plotEllipse( l_lung_b, l_lung_z, - l_lung_b, l_lung_z, l_lung_c, dy, dz );
end
if isreal(r_lung_c)
    plotEllipse( r_lung_b, r_lung_z, - r_lung_b, r_lung_z, r_lung_c, dy, dz );
end
% plotEllipse( tumor_y_es + 2 * tumor_r_es, tumor_z_es + tumor_r_es / 2, tumor_y_es - 2 *tumor_r_es, tumor_z_es + tumor_r_es / 2, tumor_r_es / 2, dy, dz );
% plotEllipse( tumor_y_es + tumor_r_es, tumor_z_es + tumor_r_es, tumor_y_es - tumor_r_es, tumor_z_es + tumor_r_es, tumor_r_es, dy, dz );

y_idx = - h_torso / 2: dy: h_torso / 2;
bolusUpL = bolusHghtZ * ones(size(y_idx));
bolusDnL = - bolusHghtZ * ones(size(y_idx));
muscleUpL = muscleHghtZ * ones(size(y_idx));
muscleDnL = - muscleHghtZ * ones(size(y_idx));
EsoUpL    = ( es_z + es_r ) * ones(size(y_idx));
EsoDnL    = ( es_z - es_r ) * ones(size(y_idx));

plot( y_idx, bolusUpL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, bolusDnL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, muscleUpL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, muscleDnL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, EsoUpL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( y_idx, EsoDnL, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

% plot far and near tumor region: 
z_idx = es_z - tumor_r_es / 4: 1 / 10: es_z + tumor_r_es;
y_near = 0 - tumor_hy_es / 2 * ones(size(z_idx));
y_far  = 0 + tumor_hy_es / 2 * ones(size(z_idx));

plot( y_far, z_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
plot( y_near, z_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

y_idx_EsoTumor = - tumor_hy_es / 2: 1 / 10: tumor_hy_es / 2;
plot( y_idx_EsoTumor, ( es_z - tumor_r_es / 4 ) * ones( size(y_idx_EsoTumor) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% plot the elecrtrode
plot( y_idx_EsoTumor, ( es_z + tumor_r_es / 4 ) * ones( size(y_idx_EsoTumor) ), 'Color', [0, 0, 0], 'LineWidth', 2.5);

% % plot electrode
% % The following parameters need to be synchronize with UpElecrode and DwnELectrode
% h_y_halfUp = 6;
% h_y_halfDwn = 10;
% ElectrodeY = tumor_y;
% Y_up = linspace( ElectrodeY - h_y_halfUp, ElectrodeY + h_y_halfUp, 100 );
% Z_up = bolusHghtZ * ones( size(Y_up) );
% Y_dn = linspace( ElectrodeY - h_y_halfDwn, ElectrodeY + h_y_halfDwn, 100 );
% Z_dn = - bolusHghtZ * ones( size(Y_dn) );
% plot(Y_up, Z_up, 'Color', [0, 0, 0], 'LineWidth', 4.0);
% hold on;
% plot(Y_dn, Z_dn, 'Color', [0, 0, 0], 'LineWidth', 4.5);
% hold on;
% % Phi: 2.8; 2.8
% % SAR: 4.0; 4.5

% % x_idx = x / dx + air_x / (2 * dx) + 1;

% % x_idx = int64(x_idx);

% % for z_idx = 1: 1: air_z / dz + 1
% %     scatter( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
% %         shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 10, 'k', 'filled' );
% %     plot( shiftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
% %         shiftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 'k', 'LineWidth', 0.5 );
% %     hold on;
% % end

% % for y_idx = 1: 1: h_torso / dy + 1
% %     plot( squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 2 )), ...
% %         squeeze(shiftedCoordinateXYZ( x_idx, y_idx, :, 3 )), 'k', 'LineWidth', 0.5 );
% %     hold on;
% % end

% % set(gca,'fontsize',18);
% y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);
% z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% % [ X_grid, Z_grid ] = meshgrid(y_grid, z_grid);
% % for idx = 1: 1: size(Z_grid, 1)
% %     scatter( y_grid, Z_grid(idx, :), 10 );
% %     hold on;
% % end

% % axis( [ - h_torso / 2, h_torso / 2, - air_z / 2, air_z / 2 ] );
% % xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18); 

end