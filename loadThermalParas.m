T_0 = 36; 
T_blood = T_0;
T_bolus = 5;
T_air = 25;
alpha = 111;

rho_b          = 1060;
cap_b          = 3960;
               % air, bolus,  muscle,     lung,    tumor,    bone
cap            = [ 0,  4200,    3500,     3886,     3795,    1300 ]';
xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7 ]';
% xi             = [ 0,     0, 8.3/1e6, 23.8/1e6, 1.92/1e6 ]';
zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436 ]';