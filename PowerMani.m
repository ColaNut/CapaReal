clc; clear;
dt = 15;
timeNum_1   = 4 * 5;
timeNum_2   = 4 * 30;
timeNum_3   = 4 * 15;
timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

fname = 'e:\Kevin\CapaReal\Case1229';

CaseName = 'Power250';
% V_0 = 81.43;
% Shift2d;
load( strcat(CaseName, '.mat') );

% temperature initialization
loadThermalParas;
TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum_all + 1 );
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable( m, n, ell ) == 2
        TmprtrTau( m, n, ell, :) = T_bolus;
    end
    if mediumTable( m, n, ell ) == 1
        TmprtrTau( m, n, ell, :) = T_air;
    end
    if mediumTable( m, n, ell ) == 0
        XZ9Med = getXZ9Med(m, n, ell, mediumTable);
        if checkAirAround( XZ9Med )
            % TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
            TmprtrTau( m, n, ell, :) = T_bolus;
        end
    end
end

T_bgn = 0;
timeNum = timeNum_1;
TmprtrMani;
% CurrentEst;

% clc; clear;
CaseName = 'Power280';
% V_0 = 86.18;
% Shift2d;
load( strcat(CaseName, '.mat') );
% PhiDstrbtn;
T_bgn = timeNum_1 * dt;
timeNum = timeNum_2;
TmprtrMani;
% CurrentEst;

% clc; clear;
CaseName = 'Power300';
% V_0 = 89.2;
% Shift2d;
load( strcat(CaseName, '.mat') );
% PhiDstrbtn;
T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
timeNum = timeNum_3;
TmprtrMani;
% CurrentEst;

figure(4); 
clf;
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

save('Case1229.mat');
