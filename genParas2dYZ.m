function [ paras2dYZ ] = genParas2dYZ( x, paras, dy, dz )

h_torso     = paras(1);
air_x       = paras(2);
if x < - air_x / 2 || x > air_x / 2
    warning('invalid x');
end
air_z       = paras(3);
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

bolusHghtZ = bolus_c * sqrt( 1 - ( x / bolus_a )^2 );
muscleHghtZ = muscle_c * sqrt( 1 - ( x / muscle_a )^2 );

l_lung_b_prime = l_lung_b * sqrt( 1 - ( ( x - l_lung_x ) / l_lung_a )^2 );
l_lung_c_prime = l_lung_c * sqrt( 1 - ( ( x - l_lung_x ) / l_lung_a )^2 );

r_lung_b_prime = r_lung_b * sqrt( 1 - ( ( x - r_lung_x ) / r_lung_a )^2 );
r_lung_c_prime = r_lung_c * sqrt( 1 - ( ( x - r_lung_x ) / r_lung_a )^2 );

tumor_r_prime = sqrt( tumor_r^2 - ( x - tumor_x )^2 );

l_lung_y = 0;
r_lung_y = 0;

paras2dYZ = [ h_torso, air_x, air_z, bolus_a, bolusHghtZ, skin_a, skin_b, muscle_a, muscleHghtZ, ...
        l_lung_y, l_lung_z, l_lung_b_prime, l_lung_c_prime, ...
        r_lung_y, r_lung_z, r_lung_b_prime, r_lung_c_prime, ...
        tumor_y, tumor_z, tumor_r_prime ];

end