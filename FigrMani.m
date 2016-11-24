% clc; clear;
load('TestCase2.mat');
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

dt = 15;
timeNum = 4 * 50;
T_end  = timeNum * dt; % 300s
% TmprtrDis;

% figure(2); 
% clf;
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
% set(gca,'fontsize',20);
% xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
% hold on;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';

openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\TestTumorTmprtrCase2.fig');
y = tumor_y;
paras2dXZ = genParas2d( y, paras, dx, dy, dz );
plotMap( paras2dXZ, dx, dz );
box on
set(gca,'LineWidth',2.0);
saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase2'), 'jpg');

openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\TestTmprtrXZCase2.fig')
axis( [ 0, T_end / 60, 37, 38.5 ] );
box on
set(gca,'LineWidth',2.0);
saveas(figure(2), fullfile(fname, 'TestTmprtrXZCase2'), 'jpg');

% fname = 'e:\Kevin\CapaReal';
% saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase2'), 'fig');
% saveas(figure(1), fullfile(fname, 'TestTumorTmprtrCase2'), 'jpg');
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