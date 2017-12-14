% clc; clear;
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
% % CaseName = 'Case0322';
% loadThermalParas;
% load( strcat(fname, '\BasicParameters.mat') );
tumor_m   = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;
vIdx_tumor = ( tumor_ell_v - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v;
dt = 15;
Duration1 = 5 * 60;
trans1 = Duration1 / dt;
Duration2 = 30 * 60;
trans2 = trans1 + Duration2 / dt;
Duration3 = 20 * 60;
trans3 = trans2 + Duration3 / dt;
timeNum_all = Duration1 + Duration2 + Duration3;

figure(8); 
clf;
time_clnl = 0: 5: 50;
T_clnl    = [ 36.01, 39.37, 42.15, 43.98, 44.24, 44.36, 44.13, 44.43, 44.93, 44.94, 45.08 ];
p_lit = plot(time_clnl, T_clnl, 'k--', 'LineWidth', 2.5);
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
hold on;

% disp('Maximum temperature for two-fold of Q: ');
% bar_b(vIdx_tumor, end)

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
load( strcat( fname, '\0809EQS_lung_test\Set1_lowXi_lowZeta\0810set1.mat' ), 'bar_b');
p_set1 = plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0, 0, 0], 'LineWidth', 2.5);

load( strcat( fname, '\0809EQS_lung_test\Set2_lowXi_highZeta\0810set2.mat' ), 'bar_b');
figure(8); 
p_set2 = plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0.4, 0.4, 0.4], 'LineWidth', 2.5);

load( strcat( fname, '\0809EQS_lung_test\Set3_highXi_lowZeta\0810set3.mat' ), 'bar_b');
figure(8); 
p_set3 = plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0.6, 0.6, 0.6], 'LineWidth', 2.5);

load( strcat( fname, '\0809EQS_lung_test\Set4_highXi_highZeta\0810set4.mat' ), 'bar_b');
figure(8); 
p_set4 = plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0.8, 0.8, 0.8], 'LineWidth', 2.5);

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0220_1cmFat';
% CaseName = 'Case0220_1cmFat';
% load( strcat(fname, '\', CaseName, '.mat') );

box on;
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
axis( [ 0, 50, 35, 50 ] );
ax1 = gca;
hold on;
% legend('Full-wave Phi', 'My EQS', 'literature', 'Location', 'northwest');

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';

time_clnl2 = [   0,   5,   5,  10,  15,  20,  25,  30,  35,  35,  40,  45,  50 ];
power      = [ 250, 250, 280, 280, 280, 280, 280, 280, 280, 300, 300, 300, 300 ];
% plot(time_clnl, power, 'LineWidth', 2.5);
ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k', 'XTickLabel',[] );
p_power = line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', '--', 'Marker', 'o');
% plot(ax2,   time_clnl2, power, 'ko');
% line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', 'o');
legend([p_lit, p_set1, p_set2, p_set3, p_set4, p_power], 'literature', 'set 1', 'set 2', 'set 3', 'set 4', 'power', 'Location', 'northwest');
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
axis( [ 0, 50, 200, 500 ]);
ylabel('$W$ (watt)','Interpreter','LaTex', 'FontSize', 18);
linkaxes([ax1 ax2],'x');

saveas(figure(8), strcat( fname, '\0809EQS_lung_test\1102XiZetaCmprsn.jpg' ));