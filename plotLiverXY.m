function plotLiverXY( paras, z, dx, dy )

% paras = [ h_torso, air_x, air_z, ...
%         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
%         liver_x, liver_z, liver_a, liver_b, liver_c, liverTheta, liverPhi, liverPsi, ...
%         tumor_x, tumor_y, tumor_z, tumor_r ];

% m -> cm
h_torso = paras(1) * 100;
air_x = paras(2) * 100;
air_z = paras(3) * 100;
bolus_a = paras(4) * 100;
bolus_c = paras(5) * 100;
skin_a = paras(6) * 100;
skin_c = paras(7) * 100;
muscle_a = paras(8) * 100;
muscle_c = paras(9) * 100;
liver_x = paras(10) * 100;
liver_z = paras(11) * 100;
liver_a = paras(12) * 100;
liver_b = paras(13) * 100;
liver_c = paras(14) * 100;
liverTheta = paras(15);
liverPhi   = paras(16);
liverPsi   = paras(17);
tumor_x = paras(18) * 100;
tumor_y = paras(19) * 100;
tumor_z = paras(20) * 100;
tumor_r = paras(21) * 100;

dx = 100 * dx;
dy = 100 * dy;
z = 100 * z;

% plotQuaEllipse( A, B, C, D, E, F)
ThetaMat = [ cos(liverTheta)  , 0, - sin(liverTheta); 
             0,                 1,               0; 
             sin(liverTheta),   0,   cos(liverTheta) ];
PhiMat = [   cos(liverPhi), sin(liverPhi), 0; 
           - sin(liverPhi), cos(liverPhi), 0;
                       0,               0, 1 ];
PsiMat = [ 1,             0,               0; 
           0,   cos(liverPsi), sin(liverPsi);
           0, - sin(liverPsi), cos(liverPsi) ];

Product = PhiMat * ThetaMat * PsiMat;

Product(:, 3) = ( z - liver_z ) * Product(:, 3);

Cont = zeros(3, 6);
Cont(1, :) = getSqrCoeff( Product(1, 1), Product(1, 2), Product(1, 3) ) / liver_a^2;
Cont(2, :) = getSqrCoeff( Product(2, 1), Product(2, 2), Product(2, 3) ) / liver_b^2;
Cont(3, :) = getSqrCoeff( Product(3, 1), Product(3, 2), Product(3, 3) ) / liver_c^2;

[ x_0, y_0, a, c, t ] = plotQuaEllipse( sum(Cont) + [0, 0, 0, 0, 0, - 1] );
if a > 0 && c > 0
    plotEllipse( liver_x + x_0 + a * cos(t), y_0 + a * sin(t), liver_x + x_0 - a * cos(t), y_0 - a * sin(t), c, dx, dy );
end
% if isreal(l_lung_c)
%     plotEllipse( l_lung_x + l_lung_a, l_lung_z, l_lung_x - l_lung_a, l_lung_z, l_lung_c, dx, dz );
% end
% if isreal(r_lung_c)
%     plotEllipse( r_lung_x + r_lung_a, r_lung_z, r_lung_x - r_lung_a, r_lung_z, r_lung_c, dx, dz );
% end
tumor_r_prime = sqrt( tumor_r^2 - ( z - tumor_z )^2 );
if isreal(tumor_r_prime)
    plotEllipse( tumor_x + tumor_r_prime, tumor_y, tumor_x - tumor_r_prime, tumor_y, tumor_r_prime, dx, dy );
end

% plot the line: z = m x + b
line_x = -15: 0.5: 15;
% plot the line: z = m_1 x + m_2
m_1 = - Product(3, 1) / Product(3, 2);
m_2 = - Product(3, 3) / Product(3, 2) + liver_x * Product(3, 1) / Product(3, 2);
plot( line_x, m_1 * line_x + m_2, 'k', 'LineWidth', 2.0);

% plotEllipse( bolus_a, 0, - bolus_a, 0, bolus_b, dx, dy );
% plotEllipse( skin_a, 0, - skin_a, 0, skin_b, dx, dy );
% plotEllipse( muscle_a, 0, - muscle_a, 0, muscle_b, dx, dy );
% if isreal(l_lung_b)
%     plotEllipse( l_lung_x + l_lung_a, l_lung_y, l_lung_x - l_lung_a, l_lung_y, l_lung_b, dx, dy );
% end
% if isreal(r_lung_b)
%     plotEllipse( r_lung_x + r_lung_a, r_lung_y, r_lung_x - r_lung_a, r_lung_y, r_lung_b, dx, dy );
% end
% if isreal(tumor_r)
%     plotEllipse( tumor_x + tumor_r, tumor_y, tumor_x - tumor_r, tumor_y, tumor_r, dx, dy );
% end

x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);

% [ X_grid, Y_grid ] = meshgrid(x_grid, y_grid);
% for idx = 1: 1: siye(y_grid, 1)
%     scatter( x_grid, y_grid(idx, :), 10 );
%     hold on;
% end
% axis( [ min(x_grid), max(x_grid), min(y_grid), max(y_grid) ] );

y_idx = - h_torso / 2: dy: h_torso / 2;
bolusRght  = bolus_a * sqrt( 1 - ( z / bolus_c )^2 ) * ones(size(y_idx));
bolusLft   = - bolus_a * sqrt( 1 - ( z / bolus_c )^2 ) * ones(size(y_idx));
muscleRght = muscle_a * sqrt( 1 - ( z / muscle_c )^2 ) * ones(size(y_idx));
muscleLft  = - muscle_a * sqrt( 1 - ( z / muscle_c )^2 ) * ones(size(y_idx));

plot( bolusRght, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( bolusLft, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( muscleRght, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

plot( muscleLft, y_idx, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
hold on;

% % plotting electrodes
% UpElectrodeSize = 12;
% DwnElectrodeSize = 20;

% x_axUp = tumor_x - UpElectrodeSize / 2: dx: tumor_x + UpElectrodeSize / 2;
% plot( x_axUp, ( tumor_y - UpElectrodeSize / 2 ) * ones( size(x_axUp) ), 'k--', 'LineWidth', 3.0);
% plot( x_axUp, ( tumor_y + UpElectrodeSize / 2 ) * ones( size(x_axUp) ), 'k--', 'LineWidth', 3.0);

% y_axUp = tumor_y - UpElectrodeSize / 2: dy: tumor_y + UpElectrodeSize / 2;
% plot( ( tumor_x + UpElectrodeSize / 2 ) * ones( size(y_axUp) ), y_axUp, 'k--', 'LineWidth', 3.0);
% plot( ( tumor_x - UpElectrodeSize / 2 ) * ones( size(y_axUp) ), y_axUp, 'k--', 'LineWidth', 3.0);

% x_axDwn = tumor_x - DwnElectrodeSize / 2: dx: tumor_x + DwnElectrodeSize / 2;
% plot( x_axDwn, ( tumor_y - DwnElectrodeSize / 2 ) * ones( size(x_axDwn) ), 'k--', 'LineWidth', 3.0);
% plot( x_axDwn, ( tumor_y + DwnElectrodeSize / 2 ) * ones( size(x_axDwn) ), 'k--', 'LineWidth', 3.0);

% y_axDwn = tumor_y - DwnElectrodeSize / 2: dy: tumor_y + DwnElectrodeSize / 2;
% plot( ( tumor_x + DwnElectrodeSize / 2 ) * ones( size(y_axDwn) ), y_axDwn, 'k--', 'LineWidth', 3.0);
% plot( ( tumor_x - DwnElectrodeSize / 2 ) * ones( size(y_axDwn) ), y_axDwn, 'k--', 'LineWidth', 3.0);

% % Phi: 2.5 for all.
% % SAR: 3.0 for all.

% % y_idx = - h_torso / 2: dy: h_torso / 2;
% % bolusUpL = bolusHghtZ * ones(size(y_idx));
% % bolusDnL = - bolusHghtZ * ones(size(y_idx));
% % muscleUpL = muscleHghtZ * ones(size(y_idx));
% % muscleDnL = - muscleHghtZ * ones(size(y_idx));

end