T_0 = 36; 
T_blood = T_0;
T_bolus = 5;
T_air = 25;
alpha = 111;

rho_b          = 1060;
cap_b          = 3960;
% unknown version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7,  5/1e7 ]';
% % xi             = [ 0,     0, 8.3/1e6, 23.8/1e6, 1.92/1e6 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436,   0.22 ]';

% submitted version
               % air, bolus,  muscle,     lung,    tumor,    bone,    fat
cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 8.65/1e6, 4.2/1e7,  5/1e7 ]';
% xi             = [ 0,     0, 8.3/1e6, 23.8/1e6, 1.92/1e6 ]';
zeta           = [ 0,     0,     0.6,     0.44,     0.39,   0.436,   0.22 ]';
              %  air,  bolus, muscle, lung, tumor, bone, fat
Q_met          = [ 0,      0,   4200, 1700,  8000,     0,       5 ]';
% % MuscleBone Case:
% cap            = [ 0,  4200,    3500,     3886,     3795,    3500,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 8.3/1e6,  5/1e7 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,     0.5,   0.22 ]';

% % 3 cm bolus, no fat, bolus sigma modification case 1 and case 2
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,    3500 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7, 8.3/1e6 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436,     0.5 ]';
