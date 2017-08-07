function [ paras2dYZ ] = genParas2dYZ_liver( x, paras, dy, dz )

% paras = [ h_torso, air_x, air_z, ...
%         bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
%         liver_x, liver_z, liver_a, liver_b, liver_c, liverTheta, liverPhi, liverPsi, ...
%         tumor_x, tumor_y, tumor_z, tumor_r ];

% m -> cm
h_torso = paras(1);
air_x = paras(2);
air_z = paras(3);
bolus_a = paras(4);
bolus_c = paras(5);
skin_a = paras(6);
skin_c = paras(7);
muscle_a = paras(8);
muscle_c = paras(9);
liver_x = paras(10);
liver_z = paras(11);
liver_a = paras(12);
liver_b = paras(13);
liver_c = paras(14);
liverTheta = paras(15);
liverPhi   = paras(16);
liverPsi   = paras(17);
tumor_x = paras(18);
tumor_y = paras(19);
tumor_z = paras(20);
tumor_r = paras(21);

bolusHghtZ = bolus_c * sqrt( 1 - ( x / bolus_a )^2 );
muscleHghtZ = muscle_c * sqrt( 1 - ( x / muscle_a )^2 );

ThetaMat = [ cos(liverTheta)  , 0, - sin(liverTheta); 
             0,                 1,               0; 
             sin(liverTheta),   0,   cos(liverTheta) ];
PhiMat = [   cos(liverPhi), sin(liverPhi), 0; 
           - sin(liverPhi), cos(liverPhi), 0;
                       0,               0, 1 ];
PsiMat = [ 1,             0,               0; 
           0,   cos(liverPsi), sin(liverPsi);
           0, - sin(liverPsi), cos(liverPsi) ];

Product = PhiMat * ThetaMat * PsiMat;

Product(:, 1) = ( x - liver_x ) * Product(:, 1);

Cont = zeros(3, 6);
Cont(1, :) = getSqrCoeff( Product(1, 2), Product(1, 3), Product(1, 1) ) / liver_a^2;
Cont(2, :) = getSqrCoeff( Product(2, 2), Product(2, 3), Product(2, 1) ) / liver_b^2;
Cont(3, :) = getSqrCoeff( Product(3, 2), Product(3, 3), Product(3, 1) ) / liver_c^2;

[ liver_y_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate ] = plotQuaEllipse( sum(Cont) + [0, 0, 0, 0, 0, - 1] );

% plot the line: z = m x + b
line_x = - 15: 0.5: 15;
% plot the line: z = m_1 x + m_2
m_1 = - Product(3, 2) / Product(3, 3);
m_2 = - Product(3, 1) / Product(3, 3) + liver_z;
% plot( line_x, m_1 * ( line_x - liver_x ) + m_2 )
% l_lung_b_prime = l_lung_b * sqrt( 1 - ( ( x - l_lung_x ) / l_lung_a )^2 );
% l_lung_c_prime = l_lung_c * sqrt( 1 - ( ( x - l_lung_x ) / l_lung_a )^2 );

% r_lung_b_prime = r_lung_b * sqrt( 1 - ( ( x - r_lung_x ) / r_lung_a )^2 );
% r_lung_c_prime = r_lung_c * sqrt( 1 - ( ( x - r_lung_x ) / r_lung_a )^2 );

tumor_r_prime = sqrt( tumor_r^2 - ( x - tumor_x )^2 );

paras2dYZ = [ h_torso, air_x, air_z, ...
        bolus_a, bolusHghtZ, skin_a, skin_c, muscle_a, muscleHghtZ, ...
        liver_z, liver_y_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
        tumor_y, tumor_z, tumor_r_prime ];

end