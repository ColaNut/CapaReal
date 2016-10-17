% use the CT image to cal l_lung_a, l_lung_c, r_lung_a, r_lung_c
% use the length of the spinal cord to estimate the l_lung_b and r_lung_b
h_torso = 12 / 100;
air_x = 30 / 100; % width: 30 cm
air_z = 20 / 100; % height: 30 cm
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

paras = [ h_torso, air_x, air_z, ...
        bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
        l_lung_x, l_lung_z, l_lung_a, l_lung_b, l_lung_c, ...
        r_lung_x, r_lung_z, r_lung_a, r_lung_b, l_lung_c, ...
        tumor_x, tumor_y, tumor_z, tumor_r ];