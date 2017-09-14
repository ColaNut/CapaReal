T_0 = 36; 
T_blood = T_0;
T_bolus = T_0;
% T_bolus = 5;
T_air = 25;
alpha = 0;
% alpha = 111;

rho_b          = 1000;
cap_b          = 4180;
% latest version (08/16)
             % [ air, bolus,  muscle, cervical tumor ]';
cap            = [ 0,  4200,    3500,           3639 ]';
xi             = [ 0,     0, 8.3/1e6,       1.71/1e6 ]';
% xi             = [ 0,     0, 8.3/1e6, 23.8/1e6, 1.92/1e6 ]';
zeta           = [ 0,     0,     0.6,           0.56 ]';
Q_met          = [ 0,      0,   4200,           8000 ]';
