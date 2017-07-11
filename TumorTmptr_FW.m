% clc; clear;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
% CaseDate = 'Case0107';
% load( strcat(fname, '\', CaseDate, '\', 'Case0107.mat') );
% % load( strcat(fname, '\', CaseDate, '\', 'Case0107.mat'), 'TmprtrTau' );

tumor_m   = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;
vIdx_tumor = ( tumor_ell_v - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\TotalQmetTumorTmprtr.fig', 'reuse');
figure(8); 
clf;
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
timeNum_all = (Duration1 + Duration2 + Duration3);
stem(0: dt / 60: timeNum_all / 60, squeeze(bar_b(vIdx_tumor, :)), 'k', 'LineWidth', 2.5);
% axis( [ 0, T_end / 60, min(min(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))), max(max(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))) ] );

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
% % saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
% % saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');

% % [ M, I ] = max( squeeze( TmprtrTau(tumor_m, tumor_n, tumor_ell, :) ) )

% % openfig(strcat(fname, '\TotalQmetTumorTmprtr.fig'), 'reuse');
