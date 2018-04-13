T_0 = 36; 
T_blood = T_0;
T_bolus = 5;
T_air = 25;
alpha = 111;

rho_b          = 1000;
cap_b          = 4180;
% unknown version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436,   0.22 ]';

% % submitted version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 8.65/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.6,     0.44,     0.39,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % previous version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % 0.14 zeta version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 8.65/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.6,     0.44,     0.14,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % 1.92 xi version
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.6,     0.44,     0.39,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % version (08/16)
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3886,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 6.68/1e6, 2.53/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.6,     0.11,     0.39,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % latest version (2017/11/03)
%                % air, bolus,    muscle,     lung,    tumor,      bone,      fat
% cap            = [ 0,  4200,      3500,     3886,     3886,      1300,     2300 ]';
% xi             = [ 0,     0, 0.612/1e6, 6.68/1e6, 2.53/1e6, 0.167/1e6, 0.54/1e6 ]';
% zeta           = [ 0,     0,       0.5,      0.4,     0.39,     0.436,     0.34 ]';
% Q_met          = [ 0,     0,      4200,     1700,     8000,         0,        5 ]';

% % test version ( [ 0.44 or 0.11 ] for normal lung tissue in the latest version (08/09); [ 1.23 or 2.53 ] for \xi in tumor )
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3886,    1300,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 6.68/1e6, 1.23/1e6, 4.2/1e7,  5/1e7 ]';
% zeta           = [ 0,     0,     0.6,     0.44,     0.39,   0.436,   0.22 ]';
%               %  air,  bolus, muscle, lung, tumor, bone, fat
% Q_met          = [ 0,      0,   4200,     1700,     8000,       0,      5 ]';

% % MuscleBone Case:
% cap            = [ 0,  4200,    3500,     3886,     3795,    3500,   2300 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 8.3/1e6,  5/1e7 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,     0.5,   0.22 ]';

% % 3 cm bolus, no fat, bolus sigma modification case 1 and case 2
%                % air, bolus,  muscle,     lung,    tumor,    bone,    fat
% cap            = [ 0,  4200,    3500,     3886,     3795,    1300,    3500 ]';
% xi             = [ 0,     0, 8.3/1e6, 3.71/1e5, 1.92/1e6, 4.2/1e7, 8.3/1e6 ]';
% zeta           = [ 0,     0,     0.5,     0.45,     0.14,   0.436,     0.5 ]';

% % "non-linear v.s. constant" version (2018/01/30)
%                % air, bolus,    muscle,     lung,    tumor,      bone,      fat
% cap            = [ 0,  4200,      3500,     3886,     3886,      1300,     2300 ]';
% xi             = [ 0,     0,   8.3/1e6, 6.68/1e6, 2.53/1e6, 0.167/1e6,  0.6/1e6 ]';
% zeta           = [ 0,     0,       0.5,      0.4,     0.39,     0.436,     0.34 ]';
% Q_met          = [ 0,     0,      4200,     1700,     8000,         0,        5 ]';

% constant (2018/03/15)
               % air, bolus,    muscle,     lung,    tumor,      bone,      fat
cap            = [ 0,  4200,      3500,     3886,     3886,      1300,     2300 ]';
xi             = [ 0,     0,  2.18/1e6, 6.68/1e6, 2.53/1e6, 0.167/1e6,  0.6/1e6 ]';
zeta           = [ 0,     0,       0.5,      0.4,     0.39,     0.436,     0.34 ]';
Q_met          = [ 0,     0,      4200,     1700,     8000,         0,        5 ]';
