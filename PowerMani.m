clc; clear;
timeNum_1   = 4 * 5;
timeNum_2   = 4 * 30;
timeNum_3   = 4 * 15;
timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

fname = 'e:\Kevin\CapaReal\Case1221';

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
            TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
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
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
axis( [ 0, T_end / 60, min(min(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))), max(max(TmprtrTau(tumor_m, tumor_n, tumor_ell, :))) ] );
set(gca,'fontsize',20);
set(gca,'LineWidth',2.0);
box on;
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
hold on;
saveas(figure(4), fullfile(fname, strcat('TotalQmet', 'TumorTmprtr')), 'fig');
saveas(figure(4), fullfile(fname, strcat('TotalQmet', 'TumorTmprtr')), 'jpg');

% save('Case1221.mat');
