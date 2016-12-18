% clc; clear;
% load('TestCase2.mat');
% fname = 'e:\Kevin\CapaReal';
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

dt = 15;
timeNum = 4 * 25;
TmprtrDis;

figure(4); 
clf;
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
axis( [ 0, T_end / 60, 37, max(max(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))) ] );
set(gca,'fontsize',20);
set(gca,'LineWidth',2.0);
box on;
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
hold on;
saveas(figure(4), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'fig');
saveas(figure(4), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'jpg');

% fname = 'e:\Kevin\CapaReal';
% figure(1);
% y = tumor_y;
% paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );
% box on
% set(gca,'LineWidth',2.0);
% saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase2'), 'fig');
% saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase2'), 'jpg');

% figure(2);
% axis( [ 0, T_end / 60, 37, 38.5 ] );
% box on
% set(gca,'LineWidth',2.0);
% saveas(figure(2), fullfile(fname, 'TestTmprtrXZCase2'), 'fig');
% saveas(figure(2), fullfile(fname, 'TestTmprtrXZCase2'), 'jpg');
% dt = 40;
% timeNum = 20;
% TmprtrDis;
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', [0.6, 0.6, 0.6], 'LineWidth', 2.5);
% hold on;

% dt = 60;
% timeNum = 10;
% TmprtrDis;
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', [0.6, 0.6, 0.6], 'LineWidth', 2.5);
% hold on;