function [ paras2dXZ ] = genParas2d( y, paras, dx, dy, dz )

h_torso     = paras(1);
if y < - h_torso / 2 || y > h_torso / 2
    warning('invalid y');
end
air_x       = paras(2);
air_z       = paras(3);
bolus_a     = paras(4);
bolus_b     = paras(5);
skin_a      = paras(6);
skin_b      = paras(7);
muscle_a    = paras(8);
muscle_b    = paras(9);
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

if l_lung_b == 0
    l_lung_a_prime = 0;
    l_lung_c_prime = 0;
else
    l_lung_a_prime = l_lung_a * sqrt( 1 - ( y / l_lung_b )^2 );
    l_lung_c_prime = l_lung_c * sqrt( 1 - ( y / l_lung_b )^2 );
end

if r_lung_b == 0
    r_lung_a_prime = 0;
    r_lung_c_prime = 0;
else
    r_lung_a_prime = r_lung_a * sqrt( 1 - ( y / r_lung_b )^2 );
    r_lung_c_prime = r_lung_c * sqrt( 1 - ( y / r_lung_b )^2 );
end

tumor_r_prime = sqrt( tumor_r^2 - ( y - tumor_y )^2 );

paras2dXZ = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
        l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
        r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
        tumor_x, tumor_z, tumor_r_prime ];

end