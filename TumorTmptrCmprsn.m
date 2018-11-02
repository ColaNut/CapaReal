% clc; clear;
% === === % =============== % === === %
% === === % Basic Parmeters % === === %
% === === % =============== % === === %
tumor_m   = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n   = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;
tumor_m_v    = 2 * tumor_m - 1;
tumor_n_v    = 2 * tumor_n - 1;
tumor_ell_v  = 2 * tumor_ell - 1;

dt = 15;
Duration1 = 5 * 60;
trans1 = Duration1 / dt;
Duration2 = 30 * 60;
trans2 = trans1 + Duration2 / dt;
Duration3 = 15 * 60;
trans3 = trans2 + Duration3 / dt;
timeNum_all = Duration1 + Duration2 + Duration3;

figure(8); 
clf;
time_clnl = 0: 5: 50;
T_clnl    = [ 36.01, 39.37, 42.15, 43.98, 44.24, 44.36, 44.13, 44.43, 44.93, 44.94, 45.08 ];
plot(time_clnl, T_clnl, 'k--', 'LineWidth', 2.5);
hold on;

load('E:\Kevin\20180811_case4_nonLinear\20180816_LungEQS_case4_nonlinear.mat', 'bar_b');
vIdx_tumor = ( tumor_ell_v + 3 - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v - 2;
plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'k', 'LineWidth', 2.5);

load('E:\Kevin\20180811_case3_nonLinear\20180816_LungEQS_case3_nonlinear.mat', 'bar_b');
figure(8); 
vIdx_tumor = ( tumor_ell_v + 3 - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v - 2;
plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);

load('E:\Kevin\20180811_case_unaffected_nonlinear\20180811_case_unaffected_nonlinear.mat', 'bar_b');
figure(8); 
vIdx_tumor = ( tumor_ell_v + 1 - 1 ) * x_max_vertex * y_max_vertex + ( tumor_n_v - 1 ) * x_max_vertex + tumor_m_v;
plot(0: dt / 60: timeNum_all / 60, T_0 + squeeze(bar_b(vIdx_tumor, :)), 'Color', [0.8, 0.8, 0.8], 'LineWidth', 2.5);

% an external library from 'columnlegend'
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
columnlegend(2, {'Clinical', 'Case 1', 'Case 2', 'Unaffected'}, 'location', 'southeast'); 
% legend('Clinical', 'Both','Location','northeast');
% legend('Upper Only', 'Unaffected','Location','northeast');
% legend({'Clinical', 'Both', 'Upper Only', 'Unaffected'},'Location','northeast','NumColumns',2);
box on;
axis( [ 0, 50, 35, 50 ] );
box off;
ax1 = gca;
hold on;

time_clnl2 = [   0,   5,   5,  10,  15,  20,  25,  30,  35,  35,  40,  45,  50 ];
power      = [ 250, 250, 280, 280, 280, 280, 280, 280, 280, 300, 300, 300, 300 ];
% plot(time_clnl, power, 'LineWidth', 2.5);
ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k', 'XTickLabel',[] );
line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', '--', 'Marker', 'o');
ylabel('Power (Watt)','Interpreter','LaTex', 'FontSize', 18);
legend('Power Line', 'Location', 'northwest');
legend('boxoff');
% plot(ax2,   time_clnl2, power, 'ko');
% line(time_clnl2, power, 'Parent', ax2, 'Color', 'k', 'LineWidth', 2.5, 'LineStyle', 'o');
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
axis( [ 0, 50, 200, 320 ]);
linkaxes([ax1 ax2],'x');

saveas(figure(8), 'ClinicalComparison.jpg');