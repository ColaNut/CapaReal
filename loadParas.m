% Testing case:
h_torso = 12 / 100;
air_x = 30 / 100; % width: 30 cm
air_z = 24 / 100; % height: 30 cm
bolus_a = 22 / 200;
bolus_b = 18 / 200;
skin_a = 0 / 100;
skin_b = 0 / 100;
muscle_a = 18 / 200;
muscle_b = 14 / 200;
l_lung_x = 4 / 100;
l_lung_z = 0 / 100; 
l_lung_a = 4 / 200;
l_lung_b = 8 / 200;
l_lung_c = 10 / 200;
r_lung_x = - 4 / 100;
r_lung_z = 0 / 100;
r_lung_a = 4 / 200;
r_lung_b = 8 / 200;
r_lung_c = 10 / 200;
tumor_x = r_lung_x;
tumor_y = 2 / 100;
tumor_z = 0 / 100;
tumor_r = 2 / 200;
dx = 1 / 100;
dy = 1 / 100;
dz = 1 / 100;

% % Real Case: 
% h_torso = 36 / 100;
% air_x = 50 / 100; % width: 50 cm
% air_z = 40 / 100; % height: 40 cm
% bolus_a = 34 / 200;
% bolus_b = 26 / 200;
% skin_a = 0 / 100;
% skin_b = 0 / 100;
% muscle_a = 30 / 200;
% muscle_b = 22 / 200;
% l_lung_x = 6.5 / 100;
% l_lung_z = 0 / 100; 
% l_lung_a = 7.5 / 200;
% l_lung_b = 34 / 200;
% l_lung_c = 18 / 200;
% r_lung_x = - 5 / 100;
% r_lung_z = 0 / 100;
% r_lung_a = 9.5 / 200;
% r_lung_b = 34 / 200;
% r_lung_c = 19 / 200;
% tumor_x = r_lung_x;
% tumor_y = 9 / 100;
% tumor_z = 0 / 100;
% tumor_r = 5 / 200;
% dx = 0.25 / 100;
% dy = 0.5 / 100;
% dz = 0.5 / 100;

paras = [ h_torso, air_x, air_z, ...
        bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
        l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
        r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
        tumor_x, tumor_y, tumor_z, tumor_r ];