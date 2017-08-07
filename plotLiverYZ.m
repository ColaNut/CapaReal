function plotLiverYZ( paras, x, dy, dz )

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

dy = 100 * dy;
dz = 100 * dz;

x = 100 * x;
bolusHghtZ = bolus_c * sqrt( 1 - ( x / bolus_a )^2 );
muscleHghtZ = muscle_c * sqrt( 1 - ( x / muscle_a )^2 );
% if isreal(l_lung_c)
%     plotEllipse( l_lung_b, l_lung_z, - l_lung_b, l_lung_z, l_lung_c, dy, dz );
% end
% if isreal(r_lung_c)
%     plotEllipse( r_lung_b, r_lung_z, - r_lung_b, r_lung_z, r_lung_c, dy, dz );
% end
% if isreal(tumor_r)
%     plotEllipse( tumor_y + tumor_r, tumor_z, tumor_y - tumor_r, tumor_z, tumor_r, dy, dz );
% end
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

Product(:, 1) = ( x - liver_x ) * Product(:, 1);

Cont = zeros(3, 6);
Cont(1, :) = getSqrCoeff( Product(1, 2), Product(1, 3), Product(1, 1) ) / liver_a^2;
Cont(2, :) = getSqrCoeff( Product(2, 2), Product(2, 3), Product(2, 1) ) / liver_b^2;
Cont(3, :) = getSqrCoeff( Product(3, 2), Product(3, 3), Product(3, 1) ) / liver_c^2;

[ y_0, z_0, a, c, t ] = plotQuaEllipse( sum(Cont) + [0, 0, 0, 0, 0, - 1] );
if a > 0 && c > 0
    plotEllipse( y_0 + a * cos(t), liver_z + z_0 + a * sin(t), y_0 - a * cos(t), liver_z + z_0 - a * sin(t), c, dy, dz );
end
% if isreal(l_lung_c)
%     plotEllipse( l_lung_x + l_lung_a, l_lung_z, l_lung_x - l_lung_a, l_lung_z, l_lung_c, dx, dz );
% end
% if isreal(r_lung_c)
%     plotEllipse( r_lung_x + r_lung_a, r_lung_z, r_lung_x - r_lung_a, r_lung_z, r_lung_c, dx, dz );
% end

tumor_r_prime = sqrt( tumor_r^2 - ( x - tumor_x )^2 );
if isreal(tumor_r_prime)
    plotEllipse( tumor_y + tumor_r_prime, tumor_z, tumor_y - tumor_r_prime, tumor_z, tumor_r_prime, dy, dz );
end

% plot the line: z = m x + b
line_y = - 10: 0.5: 10;
% plot the line: z = m_1 x + m_2
m_1 = - Product(3, 2) / Product(3, 3);
m_2 = - Product(3, 1) / Product(3, 3) + liver_z;

plot( line_y, m_1 * line_y + m_2, 'k', 'LineWidth', 2.0);

% plot torso border
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

% plot electrode
% The following parameters need to be synchronize with UpElecrode and DwnELectrode
h_y_halfUp = 6;
h_y_halfDwn = 10;
ElectrodeY = tumor_y;
Y_up = linspace( ElectrodeY - h_y_halfUp, ElectrodeY + h_y_halfUp, 100 );
Z_up = bolusHghtZ * ones( size(Y_up) );
Y_dn = linspace( ElectrodeY - h_y_halfDwn, ElectrodeY + h_y_halfDwn, 100 );
Z_dn = - bolusHghtZ * ones( size(Y_dn) );
plot(Y_up, Z_up, 'Color', [0, 0, 0], 'LineWidth', 4.0);
hold on;
plot(Y_dn, Z_dn, 'Color', [0, 0, 0], 'LineWidth', 4.5);
hold on;
% Phi: 2.8; 2.8
% SAR: 4.0; 4.5

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
y_grid = - myCeil(h_torso / 2, dy): dy: myCeil(h_torso / 2, dy);
z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% [ X_grid, Z_grid ] = meshgrid(y_grid, z_grid);
% for idx = 1: 1: size(Z_grid, 1)
%     scatter( y_grid, Z_grid(idx, :), 10 );
%     hold on;
% end

axis( [ - 15, 15, - 15, 15 ] );
% axis( [ - h_torso / 2, h_torso / 2, - air_z / 2, air_z / 2 ] );
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18); 

end