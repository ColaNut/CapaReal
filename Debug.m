% clc;
% clear; 
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0208BonePowerMod';
% % fname = 'e:\Kevin\CapaReal\Case0207BoneDebug';

% % % Period 1
% CaseName = 'Case0208BonePowerMod';
% load( strcat(fname, '\', CaseName, '.mat') );

% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
% figure(8); 
% clf;
% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
% hold on;

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% CaseName = 'Case0212Qmet8000';
% load( strcat(fname, '\', CaseName, '.mat') );
% figure(8); 
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
% box on;
% xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
% axis( [ 0, 50, 35, 50 ] );
% box off;
% ax1 = gca;
% hold on;
% time_clnl = 0: 5: 50;
% T_clnl    = [ 36.01, 39.37, 42.15, 43.98, 44.24, 44.36, 44.13, 44.43, 44.93, 44.94, 45.08 ];
% plot(time_clnl, T_clnl, 'k--', 'LineWidth', 2.5);

% time_clnl2 = [      0,      5,      5,     10,     15,     20,     25,     30,     35,     40,     40,     45,     50 ];
% power      = [ 249.85, 249.85, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 299.83, 299.83, 299.83 ];
% % plot(time_clnl, power, 'LineWidth', 2.5);
% ax2 = axes('Position',get(ax1,'Position'),...
%        'XAxisLocation','top',...
%        'YAxisLocation','right',...
%        'Color','none',...
%        'XColor','k','YColor','k', 'XTickLabel',[] );
% line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', '--', 'Marker', 'o');
% % plot(ax2,   time_clnl2, power, 'ko');
% % line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', 'o');
% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
% axis( [ 0, 50, 200, 500 ]);
% ylabel('$W$ (watt)','Interpreter','LaTex', 'FontSize', 18);
% linkaxes([ax1 ax2],'x');

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% openfig(strcat(fname, '\', CaseName, 'PhiXZ', '.fig'));
openfig(strcat(fname, '\', CaseName, 'SARXZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'PhiXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'SARXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'PhiYZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'SARYZ', '.fig'));
% openfig(strcat(fname, '\', 'TotalQmet42000TumorTmprtr', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrXZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrYZ', '.fig'));

% % m = 15;
% % n = 14; 
% % ell = 28;

% % idxmnell = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% CaseName = 'Power300';
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
