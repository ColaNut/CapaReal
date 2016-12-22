% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1218\Power300PhiXY.fig');
% caxis([0, 100]);
% axis( [ - 20, 20, - 20, 20 ] );
% % saveas(figure(2), fullfile(fname, 'Lala'), 'jpg');
% ylabel(colorbar, 'La')
% set(gca, 'fontsize', 20);
% set(gca, 'LineWidth', 2.0);
% box on;


fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\TotalQmetTumorTmprtr.fig', 'reuse');
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1221\Power250TumorTmprtr.fig', 'reuse');

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
line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', '-.');
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
axis( [ 0, 50, 200, 500 ]);
ylabel('$W$ (watt)','Interpreter','LaTex', 'FontSize', 20);
% linkaxes([ax1 ax2],'x');
saveas(figure(1), fullfile(fname, 'TotalQmetTumorTmprtr'), 'jpg');

% saveas(figure(2), fullfile(fname, 'Case4QemXZ'), 'fig');
% saveas(figure(2), fullfile(fname, 'Case4QemXZ'), 'jpg');
% saveas(figure(7), fullfile(fname, 'Case4QemYZ'), 'fig');
% saveas(figure(7), fullfile(fname, 'Case4QemYZ'), 'jpg');
% saveas(figure(12), fullfile(fname, 'Case4QemXY'), 'fig');
% saveas(figure(12), fullfile(fname, 'Case4QemXY'), 'jpg');
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4PhiXZ.fig')
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4SARXZ.fig')
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4PhiYZ.fig')
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4SARYZ.fig')
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4PhiXY.fig')
% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4\SAR\Case4SARXY.fig')

% figure(1);
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);
% figure(2);
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);

% figure(3);
% % xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);
% figure(4);
% % xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);

% figure(5);
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);
% figure(6);
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% % ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
% box on
% set(gca,'LineWidth',2.0);

% saveas(figure(1), fullfile(fname, 'Case4PhiXZ'), 'jpg');
% saveas(figure(2), fullfile(fname, 'Case4SARXZ'), 'jpg');
% saveas(figure(3), fullfile(fname, 'Case4PhiYZ'), 'jpg');
% saveas(figure(4), fullfile(fname, 'Case4SARYZ'), 'jpg');
% saveas(figure(5), fullfile(fname, 'Case4PhiXY'), 'jpg');
% saveas(figure(6), fullfile(fname, 'Case4SARXY'), 'jpg');
