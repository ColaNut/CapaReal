% % 1 mm interval
% h_torso = 4.8 / 100;
% air_x = 4.8 / 100; % width: 50 cm
% air_z = 4.8 / 100; % height: 40 cm
% bolus_a = 3.2 / 200; % diameter of cervical tumor
% bolus_c = 2.8 / 200;
% skin_a = 0.6 / 200; % diameter of electrode 
% skin_c = 0.6 / 200; 
% muscle_a = 0.8 / 200; % diameter of bolus
% muscle_c = 0.8 / 200;
% l_lung_x = 0 / 100;
% l_lung_z = 0 / 100; 
% l_lung_a = 0 / 200;
% l_lung_b = 0 / 200;
% l_lung_c = 0 / 200;
% r_lung_x = 0 / 100;
% r_lung_z = 0 / 100;
% r_lung_a = 0 / 200;
% r_lung_b = 0 / 200;
% r_lung_c = 0 / 200;
% tumor_x = l_lung_x;
% tumor_y = 0 / 100;
% tumor_z = 0 / 100;
% tumor_r = 0 / 200;
% dx = 0.1 / 100;
% dy = 0.1 / 100;
% dz = 0.1 / 100;

% % 2 mm interval
% h_torso = 4.8 / 100;
% air_x = 4.8 / 100; % width: 50 cm
% air_z = 4.8 / 100; % height: 40 cm
% bolus_a = 3.2 / 200; % diameter of cervical tumor
% bolus_c = 2.8 / 200;
% skin_a = 0.4 / 200; % diameter of electrode 
% skin_c = 0.4 / 200; 
% muscle_a = 0.8 / 200; % diameter of bolus
% muscle_c = 0.8 / 200;
% l_lung_x = 0 / 100;
% l_lung_z = 0 / 100; 
% l_lung_a = 0 / 200;
% l_lung_b = 0 / 200;
% l_lung_c = 0 / 200;
% r_lung_x = 0 / 100;
% r_lung_z = 0 / 100;
% r_lung_a = 0 / 200;
% r_lung_b = 0 / 200;
% r_lung_c = 0 / 200;
% tumor_x = l_lung_x;
% tumor_y = 0 / 100;
% tumor_z = 0 / 100;
% tumor_r = 0 / 200;
% dx = 0.2 / 100;
% dy = 0.2 / 100;
% dz = 0.2 / 100;

% dilation of cervix
h_torso = 4.8 / 100;
air_x = 4.8 / 100; % width: 50 cm
air_z = 4.8 / 100; % height: 40 cm
bolus_a = 3.2 / 200; % diameter of cervical tumor
bolus_c = 2.8 / 200;
skin_a = 1.6 / 200; % diameter of electrode 
skin_c = 1.6 / 200; 
muscle_a = 2.0 / 200; % diameter of bolus
muscle_c = 2.0 / 200;
l_lung_x = 0 / 100;
l_lung_z = 0 / 100; 
l_lung_a = 0 / 200;
l_lung_b = 0 / 200;
l_lung_c = 0 / 200;
r_lung_x = 0 / 100;
r_lung_z = 0 / 100;
r_lung_a = 0 / 200;
r_lung_b = 0 / 200;
r_lung_c = 0 / 200;
tumor_x = l_lung_x;
tumor_y = 0 / 100;
tumor_z = 0 / 100;
tumor_r = 0 / 200;
dx = 0.2 / 100;
dy = 0.2 / 100;
dz = 0.2 / 100;

paras = [ h_torso, air_x, air_z, ...
        bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
        l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
        r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
        tumor_x, tumor_y, tumor_z, tumor_r ];