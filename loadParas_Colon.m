% air-filling medium
w_y = 4.8 / 100; % depth: 4.8 cm
w_x = 4.8 / 100; % width: 4.8 cm
w_z = 4.8 / 100; % height: 4.8 cm

wall_a  = 2.4 / 200;
wall_c  = 2.4 / 200;
wall_h  = 2.8 / 100;

lumen_a  = 1.6 / 200;
lumen_c  = 1.6 / 200;
lumen_h  = 2.8 / 100;

bolus_x = - 3 / 100; 
bolus_a = 1.0 / 200; 
bolus_c = 1.0 / 200;

electrode_x = 0.3 / 100;
electrode_r = 0.5 / 200;

tumor_bndry = - lumen_a + 2 * electrode_r;

dx = 0.2 / 100;
dy = 0.2 / 100;
dz = 0.2 / 100;

paras = [ w_y, w_x, w_z, ...
        wall_a, wall_c, wall_h, ...
        lumen_a, lumen_c, lumen_h, ...
        bolus_x, bolus_a, bolus_c, ...
        electrode_x, electrode_r, ...
        tumor_bndry ];