function plotXY( paras2dXY, dx, dy )

% paras2dXY = [ h_torso, air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
%             l_lung_x, l_lung_y, l_lung_a_prime, l_lung_b_prime, ...
%             r_lung_x, r_lung_y, r_lung_a_prime, r_lung_b_prime, ...
%             tumor_x, tumor_y, tumor_r_prime ];

h_torso = paras2dXY(1) * 100;
air_x = paras2dXY(2) * 100;
air_z = paras2dXY(3) * 100;
bolus_a = paras2dXY(4) * 100;
bolus_b = paras2dXY(5) * 100;
skin_a = paras2dXY(6) * 100;
skin_b = paras2dXY(7) * 100;
muscle_a = paras2dXY(8) * 100;
muscle_b = paras2dXY(9) * 100;
l_lung_x = paras2dXY(10) * 100;
l_lung_y = paras2dXY(11) * 100;
l_lung_a = paras2dXY(12) * 100;
l_lung_b = paras2dXY(13) * 100;
r_lung_x = paras2dXY(14) * 100;
r_lung_y = paras2dXY(15) * 100;
r_lung_a = paras2dXY(16) * 100;
r_lung_b = paras2dXY(17) * 100;
tumor_x = paras2dXY(18) * 100;
tumor_y = paras2dXY(19) * 100;
tumor_r = paras2dXY(20) * 100;

dx = 100 * dx;
dy = 100 * dy;

% plotEllipse( bolus_a, 0, - bolus_a, 0, bolus_b, dx, dy );
% plotEllipse( skin_a, 0, - skin_a, 0, skin_b, dx, dy );
% plotEllipse( muscle_a, 0, - muscle_a, 0, muscle_b, dx, dy );
if isreal(l_lung_b)
    plotEllipse( l_lung_x + l_lung_a, l_lung_y, l_lung_x - l_lung_a, l_lung_y, l_lung_b, dx, dy );
end
if isreal(r_lung_b)
    plotEllipse( r_lung_x + r_lung_a, r_lung_y, r_lung_x - r_lung_a, r_lung_y, r_lung_b, dx, dy );
end
if isreal(tumor_r)
    plotEllipse( tumor_x + tumor_r, tumor_y, tumor_x - tumor_r, tumor_y, tumor_r, dx, dy );
end

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);

% [ X_grid, Y_grid ] = meshgrid(x_grid, y_grid);
% for idx = 1: 1: siye(y_grid, 1)
%     scatter( x_grid, y_grid(idx, :), 10 );
%     hold on;
% end
% axis( [ min(x_grid), max(x_grid), min(y_grid), max(y_grid) ] );

y_idx = - h_torso / 2: dy: h_torso / 2;
bolusRght  = bolus_a * ones(size(y_idx));
bolusLft   = - bolus_a * ones(size(y_idx));
muscleRght = muscle_a * ones(size(y_idx));
muscleLft  = - muscle_a * ones(size(y_idx));

plot( bolusRght, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( bolusLft, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( muscleRght, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( muscleLft, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

UpElectrodeSize = 12;
DwnElectrodeSize = 20;

x_axUp = tumor_x - UpElectrodeSize / 2: dx: tumor_x + UpElectrodeSize / 2;
plot( x_axUp, ( tumor_y - UpElectrodeSize / 2 ) * ones( size(x_axUp) ), 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);
plot( x_axUp, ( tumor_y + UpElectrodeSize / 2 ) * ones( size(x_axUp) ), 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);

y_axUp = tumor_y - UpElectrodeSize / 2: dy: tumor_y + UpElectrodeSize / 2;
plot( ( tumor_x + UpElectrodeSize / 2 ) * ones( size(y_axUp) ), y_axUp, 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);
plot( ( tumor_x - UpElectrodeSize / 2 ) * ones( size(y_axUp) ), y_axUp, 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);

x_axDwn = tumor_x - DwnElectrodeSize / 2: dx: tumor_x + DwnElectrodeSize / 2;
plot( x_axDwn, ( tumor_y - DwnElectrodeSize / 2 ) * ones( size(x_axDwn) ), 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);
plot( x_axDwn, ( tumor_y + DwnElectrodeSize / 2 ) * ones( size(x_axDwn) ), 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);

y_axDwn = tumor_y - DwnElectrodeSize / 2: dy: tumor_y + DwnElectrodeSize / 2;
plot( ( tumor_x + DwnElectrodeSize / 2 ) * ones( size(y_axDwn) ), y_axDwn, 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);
plot( ( tumor_x - DwnElectrodeSize / 2 ) * ones( size(y_axDwn) ), y_axDwn, 'LineStyle', '--', 'Color', [0.2, 0.2, 0.2], 'LineWidth', 3.0);

% Phi: 2.5 for all.
% SAR: 3.0 for all.

% y_idx = - h_torso / 2: dy: h_torso / 2;
% bolusUpL = bolusHghtZ * ones(size(y_idx));
% bolusDnL = - bolusHghtZ * ones(size(y_idx));
% muscleUpL = muscleHghtZ * ones(size(y_idx));
% muscleDnL = - muscleHghtZ * ones(size(y_idx));

end