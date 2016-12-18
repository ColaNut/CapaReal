% clc; clear; 
% % case 1: sigma = 0.61
% CaseName = 'Sigma61';
% V_0 = 126;
% sigma         = [ 0,  0.61, 0.685,  0.42, 0.68 ]';
% epsilon_r_pre = [ 1, 113.0,   184, 264.9,  402 ]';
% Shift2d;
% PhiDstrbtn;
% TmprtrMani;
% % CurrentEst;

clc; clear;
% case 2: sigma = 0.1
CaseName = 'Sigma001';
V_0 = 126;
sigma         = [ 0,  0.01, 0.685,  0.42, 0.68 ]';
epsilon_r_pre = [ 1,    81,   184, 264.9,  402 ]';
Shift2d;
% PhiDstrbtn;
TmprtrMani;
save(strcat(CaseName, 'Temperature.mat'));
% CurrentEst;


clc; clear;
% case 3: sigma = 0.0002
CaseName = 'Sigma00002';
V_0 = 126;
sigma         = [ 0,  0.0002, 0.685,  0.42, 0.68 ]';
epsilon_r_pre = [ 1,      81,   184, 264.9,  402 ]';
Shift2d;
% PhiDstrbtn;
TmprtrMani;
save(strcat(CaseName, 'Temperature.mat'));
% CurrentEst;

