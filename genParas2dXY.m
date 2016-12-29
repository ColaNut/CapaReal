function [ paras2dXY ] = genParas2dXY( z, paras, dx, dy, dz )

h_torso     = paras(1);
air_x       = paras(2);
air_z       = paras(3);
if z < - air_z / 2 || z > air_z / 2
    warning('invalid z');
end
bolus_a     = paras(4);
bolus_c     = paras(5);
skin_a      = paras(6);
skin_b      = paras(7);
muscle_a    = paras(8);
muscle_c    = paras(9);
l_lung_x    = paras(10);
l_lung_z    = paras(11);
l_lung_a    = paras(12);
l_lung_b    = paras(13);
l_lung_c    = paras(14);
r_lung_x    = paras(15);
r_lung_z    = paras(16);
r_lung_a    = paras(17);
r_lung_b    = paras(18);
r_lung_c    = paras(19);
tumor_x     = paras(20);
tumor_y     = paras(21);
tumor_z     = paras(22);
tumor_r     = paras(23);

l_lung_a_prime = l_lung_a * sqrt( 1 - ( z / l_lung_c )^2 );
l_lung_b_prime = l_lung_b * sqrt( 1 - ( z / l_lung_c )^2 );

r_lung_a_prime = r_lung_a * sqrt( 1 - ( z / r_lung_c )^2 );
r_lung_b_prime = r_lung_b * sqrt( 1 - ( z / r_lung_c )^2 );

bolus_a_prime = bolus_a * sqrt( 1 - (z / bolus_c)^2 );

muscle_a_prime = muscle_a * sqrt( 1 - (z / muscle_c)^2 );

tumor_r_prime = sqrt( tumor_r^2 - ( z - tumor_z )^2 );

paras2dXY = [ h_torso, air_x, air_z, bolus_a_prime, bolus_c, skin_a, skin_b, muscle_a_prime, muscle_c, ...
        l_lung_x, 0, l_lung_a_prime, l_lung_b_prime, ...
        r_lung_x, 0, r_lung_a_prime, r_lung_b_prime, ...
        tumor_x, tumor_y, tumor_r_prime ];

end