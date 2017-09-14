function plotLiverXZ( paras, y, dx, dz, varargin );

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
dz = 100 * dz;
y = y * 100;

plotEllipse( bolus_a, 0, - bolus_a, 0, bolus_c, dx, dz );
plotEllipse( skin_a, 0, - skin_a, 0, skin_c, dx, dz );
plotEllipse( muscle_a, 0, - muscle_a, 0, muscle_c, dx, dz );
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

Product(:, 2) = y * Product(:, 2);

Cont = zeros(3, 6);
Cont(1, :) = getSqrCoeff( Product(1, 1), Product(1, 3), Product(1, 2) ) / liver_a^2;
Cont(2, :) = getSqrCoeff( Product(2, 1), Product(2, 3), Product(2, 2) ) / liver_b^2;
Cont(3, :) = getSqrCoeff( Product(3, 1), Product(3, 3), Product(3, 2) ) / liver_c^2;

[ x_0, z_0, a, c, t ] = plotQuaEllipse( sum(Cont) + [0, 0, 0, 0, 0, - 1] );
if a > 0 && c > 0
    plotEllipse_liverXZ( liver_x + x_0 + a * cos(t), liver_z + z_0 + a * sin(t), liver_x + x_0 - a * cos(t), liver_z + z_0 - a * sin(t), c, dx, dz );
end
% if isreal(l_lung_c)
%     plotEllipse( l_lung_x + l_lung_a, l_lung_z, l_lung_x - l_lung_a, l_lung_z, l_lung_c, dx, dz );
% end
% if isreal(r_lung_c)
%     plotEllipse( r_lung_x + r_lung_a, r_lung_z, r_lung_x - r_lung_a, r_lung_z, r_lung_c, dx, dz );
% end
tumor_r_prime = sqrt( tumor_r^2 - ( y - tumor_y )^2 );
if isreal(tumor_r_prime)
    plotEllipse( tumor_x + tumor_r_prime, tumor_z, tumor_x - tumor_r_prime, tumor_z, tumor_r_prime, dx, dz );
end

% plot the line: z = m x + b
line_x = - 7: 0.5: 3.5;
% plot the line: z = m_1 x + m_2
m_1 = - Product(3, 1) / Product(3, 3);
m_2 = - Product(3, 2) / Product(3, 3) + liver_z + liver_x * Product(3, 1) / Product(3, 3);
plot( line_x, m_1 * line_x + m_2, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% % plot electrode
% t = linspace( 0, 2 * pi, 400 );
% X = bolus_a * cos(t);
% Z = bolus_c * sin(t);
% % The below parameters need to be synchronize with UpElecrode and DwnELectrode

% nVarargs = length(varargin);
% if nVarargs == 3
%     ElectrodeX    = 100 * varargin{1};
%     h_x_halfUp    = 100 * varargin{2};
%     h_x_halfDwn   = 100 * varargin{3};
% else
%     ElectrodeX = - 0;
%     h_x_halfUp = 11;
%     h_x_halfDwn = 11;
% end
% UpIdx = find( Z > 0 & X >= ElectrodeX - h_x_halfUp & X <= ElectrodeX + h_x_halfUp );
% DwnIdx = find( Z < 0 & X >= ElectrodeX - h_x_halfDwn & X <= ElectrodeX + h_x_halfDwn );
% plot(X(UpIdx), Z(UpIdx), 'Color', [0, 0, 0], 'LineWidth', 4.5);
% hold on;
% plot(X(DwnIdx), Z(DwnIdx), 'Color', [0, 0, 0], 'LineWidth', 4.5);
% hold on;
% % Phi: 2.7; 2.7
% % SAR: 4.5; 4.5

% x_grid = - myCeil(air_x / 2, dx): dx: myCeil(air_x / 2, dx);
% z_grid = - myCeil(air_z / 2, dz): dz: myCeil(air_z / 2, dz);

% [ X_grid, Z_grid ] = meshgrid(x_grid, z_grid);
% % for idx = 1: 1: size(Z_grid, 1)
% %     scatter( x_grid, Z_grid(idx, :), 10 );
% %     hold on;
% % end
% % axis( [ min(x_grid), max(x_grid), min(z_grid), max(z_grid) ] );

end