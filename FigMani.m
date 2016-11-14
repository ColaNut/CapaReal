fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case4';
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

figure(1);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);
figure(2);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);

figure(3);
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);
figure(4);
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);

figure(5);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);
figure(6);
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 20);
box on
set(gca,'LineWidth',2.0);

saveas(figure(1), fullfile(fname, 'Case4PhiXZ'), 'jpg');
saveas(figure(2), fullfile(fname, 'Case4SARXZ'), 'jpg');
saveas(figure(3), fullfile(fname, 'Case4PhiYZ'), 'jpg');
saveas(figure(4), fullfile(fname, 'Case4SARYZ'), 'jpg');
saveas(figure(5), fullfile(fname, 'Case4PhiXY'), 'jpg');
saveas(figure(6), fullfile(fname, 'Case4SARXY'), 'jpg');
