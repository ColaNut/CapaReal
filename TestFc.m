% Data=magic(100);
% c=[1 10/3 10 100/3 100 1000/3 1000 10000/3 10^4];
% contourf(log(Data(:,:)),log(c));
% colormap(bone);  %Color palate named "bone"
% caxis(log([c(1) c(length(c))]));
% colorbar('FontSize',11,'YTick',log(c),'YTickLabel',c);

% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\Power250TumorTmprtr.fig', 'reuse');

% %Say I have some data:
% x=linspace(-.005, .005, 100);
% [X,Y] = meshgrid(x,x);
% data = 1./sqrt(X.^2 + Y.^2);

% myRange = [ 1e2 1e4 ];
% caxis(myRange);
% cbar = colorbar('peer', gca, 'Yscale', 'log');
% log_axes = axes('Position', get(gca, 'Position'));
% pcolor(log_axes, X, Y, log10(data));
% % caxis(log10(myRange));

% x = 10.^(1:10);
% plot(x,x)
% g = gca;
% tick2text(g,'axis','x')
% h = getappdata(g,'XTickText')
% for i=1:numel(h), set(h(i),'String',num2str(i,'10^%d')); 
% end
 % %Say I have some data:
% x=linspace(-.005, .005, 100);
% [X,Y] = meshgrid(x,x);
% data = 1./sqrt(X.^2 + Y.^2);

% figure('units', 'normalized', 'outerposition', [0.1 0.1 0.8 0.8]);
% % Plot the data on a log scale
% log_axes = subplot(2,1,1);
% log_plot = pcolor(log_axes, X, Y, log10(data));
% set(gca, 'Xtick', linspace(-.005, .005, 17)), grid on

% % Apply a logarithmic colorbar
% colormap(jet(1024))
% colorbar_log([1e2 1e4])

% %For example, say I have some data:
% x = linspace(-.005, .005, 100);
% [X,Y] = meshgrid(x,x);
% data = 1./sqrt(X.^2 + Y.^2);

% % Define the range of the data that we wish to plot
% my_clim = [1e2 1e4];

% figure('units', 'normalized', 'outerposition', [0.1 0.1 0.8 0.8]);
% % Create a "junk" axes to get the appropriate colorbar
% linear_axes = subplot(1,1,1);
% linear_plot = pcolor(linear_axes, X ,Y, data);
% colormap(jet(1024)), caxis(my_clim)
% cbar = colorbar('peer', linear_axes, 'Yscale', 'log');

% clc; clear;
% CaseName = 'Power250';
% V_0 = 81.43;
% Shift2d;
% save( strcat(CaseName, '.mat') );
% CurrentEst;

% clc; clear;
% CaseName = 'Power280';
% V_0 = 86.18;
% Shift2d;
% save( strcat(CaseName, '.mat') );
% CurrentEst;

% clc; clear;
% CaseName = 'Power300';
% V_0 = 89.2;
% Shift2d;
% save( strcat(CaseName, '.mat') );
% CurrentEst;

% figure(3);
% paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
% plotYZ( paras2dYZ, dy, dz );
    % plotYZ( shiftedCoordinateXYZ, air_x, h_torso, air_z, x, paras2dYZ, dx, dy, dz );

openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\Power250TumorTmprtr.fig', 'reuse');
% shading interp

% function [ AxA ] = TestFc( a, b, c )

% AxA = ones(9, 1);

% end
% AxA = cell(2, 1);
% AxA{1} = 30;
% AxA{2} = 60;

% % CxC = horzcat( cell(2, 1), AxA )

% % BxB = 0;
% x = 1;
% AxA = x;
% BxB = x + 1;

% end

% a = 1;
% try
%     if a == 1
%         a = 9
%         error('testing catch funtion');
%     end
% catch a
%     ;% a = 3
% end
% b = 6
% % xAx = complex(a,0);

% idx = 4320;
%     tmp_m = mod( idx, x_idx_max );
%     if tmp_m == 0
%         m = x_idx_max;
%     else
%         m = tmp_m;
%     end

%     if mod( idx, x_idx_max * y_idx_max ) == 0
%         n = y_idx_max;
%     else
%         n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
%     end
    
%     ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

%     [ m, n, ell ]

% x2 = [2 5; 2 5; 8 8];
% y2 = [4 0; 8 2; 4 0];
% patch(x2,y2,'green')

% v2 = [2 4; 2 8; 8 4; 5 0; 5 2; 8 0];
% f2 = [1 2 3 5;
%       4 5 6 NaN];
% c  = [0; 1];
% patch('Faces', f2,'Vertices', v2, 'FaceColor', c)
% figure(8);
% v = [2 4 1; 2 8 1; 8 4 1; 5 0 1; 5 2 1; 8 0 1];
% f = [1 2 3; 4 5 6];
% col = [0; - Inf];
% patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% colorbar

% figure(4);
% loadParas;

% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
% [tumor_m, tumor_n, tumor_ell]

% figure(1);
% loadParas;
% paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );

% load('Power250currentEst.mat');
% W
% Current
% % abs(W)

% load('Power280currentEst.mat');
% W
% Current
% % abs(W)

% load('Power300currentEst.mat');
% W
% Current
% % abs(W)

% [ PntsIdx, PntsCrdnt ]  = get27Pnts( 17, 9, 25, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
% PntsMed                 = get27PntsMed( PntsIdx, mediumTable )

% figure(1); 
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', [0, 0, 0], 'LineWidth', 2.5);
% set(gca,'fontsize',20);
% xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);

% tmpm = 49;
% tmpn = 15; 
% tmpell = 58;

% tmpx = ( tmpm - 1 ) * dx - air_x / 2;
% tmpy = ( tmpn - 1 ) * dy - h_torso / 2;
% tmpz = ( tmpell - 1 ) * dz - air_z / 2;
% [tmpx, tmpy, tmpz]* 100

% % x = ( m - 1 ) * dx - air_x / 2;
% % y = ( n - 1 ) * dy - h_torso / 2;
% % z = ( ell - 1 ) * dz - air_z / 2;
% paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );
% % paras2d = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
% %         l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
% %         r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
% %         tumor_x, tumor_z, tumor_r_prime ];
% % [x, z] * 100;

% % x_idx_max = air_x / dx + 1;
% % y_idx_max = h_torso / dy + 1;
% % z_idx_max = air_z / dz + 1;

% x = ( paras2dXZ(13) + paras2dXZ(15) );
% z = ( paras2dXZ(14) + paras2dXZ(16) );
% m = ( x / dx ) + air_x / ( 2 * dx ) + 1;
% ell = ( z / dz ) + air_z / ( 2 * dz ) + 1;
% [m, ell]
% fname = 'e:\Kevin\CapaReal';
% % saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase1'), 'fig');
% saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase1'), 'jpg');

% a=rand(100, 10000);
% b=rand(100, 10000)';
% tic
% c=a*b;
% fprintf('CPU time = %g sec\n', toc);
% A=gpuArray(a);      % Put a to GPU's memory
% B=gpuArray(b);      % Put b to GPU's memory
% tic
% C=A*B;              % Multiplication via GPU
% fprintf('GPU time = %g sec\n', toc);
% c2=gather(C);       % Put C to MATLAB's workspace
% fprintf('isequal(c, c2) = %g\n', isequal(c, c2));
% fprintf('Mean deviation = %g\n', mean(mean(abs(c-c2))));

% fname = 'e:\Kevin\CapaReal\Case1128';
% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
% CaseName = 'Sigma61';

% % extract temperature in the XZ plane
% T_XZ = zeros( x_idx_max, z_idx_max );
% x_mesh = squeeze(shiftedCoordinateXYZ( :, y_idx, :, 1))';
% z_mesh = squeeze(shiftedCoordinateXYZ( :, y_idx, :, 3))';
% paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% t = T_end;
% % for t = 0: dt: T_end
%     t_idx = t / dt + 1;
%     y = tumor_y;
%     y_idx = y / dy + h_torso / ( 2 * dy ) + 1;
    
%     T_XZ = squeeze( TmprtrTau( :, y_idx, :, uint8(t_idx) ) );
    
%     % figure(uint8(t_idx + 2));
%     figure(21);
%     clf;
%     pcolor(x_mesh * 100, z_mesh * 100, T_XZ');
%     shading flat
%     % shading interp
%     colorbar;
%     colormap jet;
%     set(gca,'fontsize',20);
%     set(gca,'LineWidth',2.0);
%     box on;
%     xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
%     ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
%     view(2);
%     hold on;
%     plotMap( paras2dXZ, dx, dz );
% % end
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TemperatureXZ')), 'fig');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TemperatureXZ')), 'jpg');

% save(strcat(CaseName, 'Temperature.mat'));

% CaseName = 'Tmp1';
% tmppx = 0:pi/100:2*pi;
% tmppy = sin(tmppx);
% figure(1);
% plot(tmppx, tmppy);

% saveas(figure(1), fullfile(fname, strcat(CaseName, 'OaO')), 'fig');

% load(strcat(CaseName, 'Temperature.mat'));
% figure(1);
% paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );