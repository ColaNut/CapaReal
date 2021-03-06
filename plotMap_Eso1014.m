function plotMap_Eso1014( paras, dx, dz, varargin )

% m -> cm
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

loadParas_Eso0924;
% loadAmendParas_Esophagus
es_x = 100 * es_x;
es_z = 100 * es_z;
es_r = 100 * es_r;

tumor_x_es = 100 * tumor_x_es;
tumor_y_es = 100 * tumor_y_es;
tumor_z_es = 100 * tumor_z_es;
tumor_r_es = 100 * tumor_r_es;

% plot the esophagus
% plotEllipse( x_es + r_es, z_es, x_es - r_es, z_es, r_es, dx, dz );
plotEllipse_Eso( es_x + es_r, es_z, es_x - es_r, es_z, es_r, dx, dz );
% % plot the tumor
% plotEllipse( tumor_x_es + tumor_r_es, tumor_z_es + tumor_r_es / 2, tumor_x_es - tumor_r_es, tumor_z_es + tumor_r_es / 2, tumor_r_es / 2, dx, dz );
% plot two non-continuous line
x_horz1 = es_x - dx: dx / 10: es_x - dx / 2;
plot( x_horz1, ( es_z - dz / 4 ) * ones( size(x_horz1) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
x_horz2 = es_x + dx / 2: dx / 10: es_x + dx;
plot( x_horz2, ( es_z - dz / 4 ) * ones( size(x_horz2) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

x_axUp = es_x - dx / 2: dx: es_x + dx / 2;
plot( x_axUp, ( es_z - dz / 2 ) * ones( size(x_axUp) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
% plot( x_axUp, ( es_z + dz / 2 ) * ones( size(x_axUp) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% the tumor boundary
x_axUp2 = es_x - dx / 2: dx / 10: es_x + dx / 2;
plot( x_axUp2, ( es_z + dz / 4 ) * ones( size(x_axUp2) ), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% x_axO1 = es_x - dx / 2: dx / 20: es_x - dx / 4;
% plot( x_axO1, - x_axO1 + es_z, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
% x_axO2 = es_x + dx / 4: dx / 20: es_x + dx / 2;
% plot( x_axO2, x_axO2 + es_z, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

y_axUp = es_z - dz / 2: dz / 4: es_z + dz / 4;
plot( ( es_x + dx / 2 ) * ones( size(y_axUp) ), y_axUp, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
plot( ( es_x - dx / 2 ) * ones( size(y_axUp) ), y_axUp, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% % plot electrode
% t = linspace( 0, 2 * pi, 400 );
% X = bolus_a * cos(t);
% Z = bolus_b * sin(t);
% % The below parameters need to be synchronize with UpElecrode and DwnELectrode

% nVarargs = length(varargin);
% if nVarargs == 3
%     ElectrodeX    = 100 * varargin{1};
%     h_x_halfUp    = 100 * varargin{2};
%     h_x_halfDwn   = 100 * varargin{3};
% else
%     ElectrodeX = tumor_x;
%     h_x_halfUp = 6;
%     h_x_halfDwn = 10;
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