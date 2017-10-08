T_0 = 36; 
T_blood = T_0;
T_bolus = 25;
T_air = 25;
alpha = 111;

rho_b          = 1000;
cap_b          = 4180;
% latest version (09/18)
               %   1      2        3         4         5        6       7         8                 9 
               % air, bolus,  muscle,     lung,    tumor,    bone,    fat, reserved, esophageal tumor
cap            = [ 0,  4200,    3500,     3886,     3886,    1300,   2300,        0,             3900 ]';
xi             = [ 0,     0, 8.3/1e6, 6.68/1e6, 6.68/1e6, 4.2/1e7,  5/1e7,        0,         1.67/1e6 ]';
zeta           = [ 0,     0,     0.6,     0.11,     0.11,   0.436,   0.22,        0,             0.57 ]';
Q_met          = [ 0,      0,   4200,     1700,     1700,       0,      5,        0,             8000 ]';