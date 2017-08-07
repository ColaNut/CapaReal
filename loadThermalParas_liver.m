T_0 = 36; 
T_blood = T_0;
T_bolus = 5;
T_air = 25;
alpha = 111;

rho_b          = 1000;
cap_b          = 4180;

% test version
               % air, bolus,  muscle,    liver,    tumor,    bone,    fat
cap            = [ 0,  4200,    3500,     3690,     3960,    1300,   2300 ]';
xi             = [ 0,     0, 8.3/1e6, 15.03/1e6, 0.583/1e6, 4.2/1e7,  5/1e7 ]';
% xi             = [ 0,     0, 8.3/1e6, 23.8/1e6, 1.92/1e6 ]';
zeta           = [ 0,     0,     0.6,     0.48,     0.57,   0.436,   0.22 ]';
              %  air,  bolus, muscle, lung, tumor, bone, fat
Q_met          = [ 0,      0,   4200,   9231.3,     7079,       0,      5 ]';
