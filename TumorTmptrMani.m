clc; clear;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
CaseName = 'Case1226';
load( strcat(fname, '\', CaseName, '\', 'Power300Tmprtr.mat') );

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\TotalQmetTumorTmprtr.fig', 'reuse');
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\Power250TumorTmprtr.fig', 'reuse');
figure(4); 
clf;
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
% axis( [ 0, T_end / 60, min(min(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))), max(max(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))) ] );

set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
box on;
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
axis( [ 0, 50, 35, 50 ] );
box off;
ax1 = gca;
hold on;
time_clnl = 0: 5: 50;
T_clnl    = [ 36.01, 39.37, 42.15, 43.98, 44.24, 44.36, 44.13, 44.43, 44.93, 44.94, 45.08 ];
plot(time_clnl, T_clnl, 'k--', 'LineWidth', 2.5);

time_clnl2 = [      0,      5,      5,     10,     15,     20,     25,     30,     35,     40,     40,     45,     50 ];
power      = [ 249.85, 249.85, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 279.84, 299.83, 299.83, 299.83 ];
% plot(time_clnl, power, 'LineWidth', 2.5);
ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k', 'XTickLabel',[] );
line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', '--', 'Marker', 'o');
% plot(ax2,   time_clnl2, power, 'ko');
% line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', 'o');
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
axis( [ 0, 50, 200, 500 ]);
ylabel('$W$ (watt)','Interpreter','LaTex', 'FontSize', 18);
linkaxes([ax1 ax2],'x');
saveas(figure(4), fullfile(fname, 'TotalQmetTumorTmprtr'), 'fig');
saveas(figure(4), fullfile(fname, 'TotalQmetTumorTmprtr'), 'jpg');

[ M, I ] = max( squeeze( TmprtrTau(tumor_m, tumor_n, tumor_ell, :) ) )