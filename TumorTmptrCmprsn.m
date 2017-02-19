clc;
clear;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0213Test';
CaseName = 'Case0213Test';
load( strcat(fname, '\', CaseName, '.mat') );
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
figure(8); 
clf;
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', 'k', 'LineWidth', 2.5);
hold on;

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0216Test';
CaseName = 'Case0216Test';
load( strcat(fname, '\', CaseName, '.mat') );
figure(8); 
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% CaseName = 'Case0212Qmet8000';
% load( strcat(fname, '\', CaseName, '.mat') );
% figure(8); 
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', 'k', 'LineWidth', 2.5);

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0213_3cmBolus';
% CaseName = 'Case0213_3cmBolus';
% load( strcat(fname, '\', CaseName, '.mat') );
% figure(8); 
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'Color', 'b', 'LineWidth', 2.5);

% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
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
legend('0 cm fat', '1 cm fat', 'literature', 'Location', 'northwest');

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0216Test';
saveas(figure(8), fullfile(fname, 'Fat0cmAND1cmCmp'), 'jpg');

% legend('0 cm', '1 cm', '2 cm', '3 cm', 'literature', 'Location', 'southeast');


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