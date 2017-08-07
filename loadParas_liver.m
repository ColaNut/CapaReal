% First test case: 2 cm bolus, no-fat
h_torso = 26 / 100;
air_x = 50 / 100; % width: 50 cm
air_z = 40 / 100; % height: 40 cm
bolus_a = 34 / 200;
bolus_c = 26 / 200;
skin_a = 0 / 200; % fat
skin_c = 0 / 200; 
muscle_a = 30 / 200;
muscle_c = 22 / 200;
liver_x = - 3 / 100;
liver_z = 1 / 100; 
liver_a = 20 / 200;
liver_b = 16 / 200;
liver_c = 14 / 200;
% liverTheta = 0;
% liverPhi   = 0;
% liverPsi   = 0;
liverTheta = - pi / 8;
liverPhi   = pi / 4;
liverPsi   = - 3 * pi / 8;
tumor_x = liver_x - 3 / 100;
tumor_y = 1 / 100;
tumor_z = 5 / 100;
tumor_r = 4 / 200;
dx = 1 / 100;
dy = 1 / 100;
dz = 1 / 100;

paras = [ h_torso, air_x, air_z, ...
        bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
        liver_x, liver_z, liver_a, liver_b, liver_c, liverTheta, liverPhi, liverPsi, ...
        tumor_x, tumor_y, tumor_z, tumor_r ];