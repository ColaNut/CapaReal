% this script can be used once
clc; clear; 
fname = 'd:\Kevin\CapaReal\0708';
CaseName = 'Power250';
load( strcat(fname, '\', CaseName, '.mat') );
% V_0 = 78.75;
AmendPowerScript;
save( strcat(fname, '\', CaseName, '.mat') );

clc; clear;
fname = 'd:\Kevin\CapaReal\0708';
CaseName = 'Power280';
load( strcat(fname, '\', CaseName, '.mat') );
% V_0 = 83.34;
AmendPowerScript;
save( strcat(fname, '\', CaseName, '.mat') );

clc; clear;
fname = 'd:\Kevin\CapaReal\0708';
CaseName = 'Power300';
load( strcat(fname, '\', CaseName, '.mat') );
% V_0 = 86.26;
AmendPowerScript;
save( strcat(fname, '\', CaseName, '.mat') );

% clc; clear;
% fname = 'd:\Kevin\CapaReal\0708';
% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% % S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% % for idx = 1: 1: length(S)
%     % Conc = S(idx);
%     CaseName = 'Power300';
%     V_0 = 89.09;
%     Shift2d;
%     save( strcat(fname, '\', CaseName, '.mat') );
%     % CurrentEst;
% % end

% load('EQS_Phi.mat');

clc; clear;
fname = 'd:\Kevin\CapaReal\0708';
CaseName = 'Power250';
load( strcat(fname, '\', CaseName, '.mat') );
dt = 20;
Duration1 = 5 * 60;
trans1 = Duration1 / dt;
Duration2 = 30 * 60;
trans2 = trans1 + Duration2 / dt;
Duration3 = 20 * 60;
trans3 = trans2 + Duration3 / dt;
timeNum_all = Duration1 + Duration2 + Duration3;
bar_b = zeros(N_v, (Duration1 + Duration2 + Duration3) / dt + 1);

load('M_U_M_V_bar_d.mat', 'M_U', 'M_V');
tic;
for idx = 2: 1: trans1
    bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

pre_bar_d = bar_d;
CaseName = 'Power280';
load( strcat(fname, '\', CaseName, '.mat') );
bar_b(:, trans1 + 1) = M_U\(M_V * bar_b(:, trans1) + (pre_bar_d + bar_d) / 2);
tic;
for idx = trans1 + 2: 1: trans2
    bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

pre_bar_d = bar_d;
CaseName = 'Power300';
load( strcat(fname, '\', CaseName, '.mat') );
bar_b(:, trans2 + 1) = M_U\(M_V * bar_b(:, trans2) + (pre_bar_d + bar_d) / 2);
tic;
for idx = trans2 + 2: 1: trans3 + 1
    bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot;

return;
% dt = 15;
% timeNum_1   = 4 * 5;
% timeNum_2   = 4 * 30;
% timeNum_3   = 4 * 15;
% timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
% fname = 'd:\Kevin\CapaReal\0708';

% % S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
% % for idx = 1: 1: length(S)
%     % Conc = S(idx);
%     % Period 1
%     CaseName = 'Power250';
%     load( strcat(fname, '\', CaseName, '.mat') );

%     % temperature initialization
%     loadThermalParas;
%     LungRatio = 1;
%     TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum_all + 1 );
%     for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%         [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%         if mediumTable( m, n, ell ) == 2
%             TmprtrTau( m, n, ell, :) = T_bolus;
%         end
%         if mediumTable( m, n, ell ) == 1
%             TmprtrTau( m, n, ell, :) = T_air;
%         end
%         if mediumTable( m, n, ell ) == 0
%             XZ9Med = getXZ9Med(m, n, ell, mediumTable);
%             if checkAirAround( XZ9Med )
%                 % TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
%                 TmprtrTau( m, n, ell, :) = T_bolus;
%             end
%         end
%     end

%     T_bgn = 0;
%     timeNum = timeNum_1;
%     TmprtrDis;

%     % Period 2
%     CaseName = 'Power280';
%     load( strcat(fname, '\', CaseName, '.mat') );
%     T_bgn = timeNum_1 * dt;
%     timeNum = timeNum_2;
%     TmprtrDis;

%     % Period 3
%     CaseName = 'Power300';
%     load( strcat(fname, '\', CaseName, '.mat') );
%     T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
%     timeNum = timeNum_3;
%     TmprtrDis;

%     % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0322';
%     fname = 'd:\Kevin\CapaReal\0708';
%     save( strcat(fname, '\Case0322.mat') );
% % end
