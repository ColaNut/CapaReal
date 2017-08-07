function [ mediumTableXZ ] = getRoughMed_liver( mediumTableXZ, paras2dXZ, y, dx, dz, varargin )

% paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, skin_a, skin_c, muscle_a, muscle_c, ...
%     liver_x, liver_z, liver_x_0, liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, ...
%     tumor_x, tumor_y, tumor_z, tumor_r_prime ];

% m -> cm
air_x = paras2dXZ(1);
air_z = paras2dXZ(2);
bolus_a = paras2dXZ(3);
bolus_c = paras2dXZ(4);
skin_a = paras2dXZ(5);
skin_c = paras2dXZ(6);
muscle_a = paras2dXZ(7);
muscle_c = paras2dXZ(8);
liver_x = paras2dXZ(9);
liver_z = paras2dXZ(10);
liver_x_0 = paras2dXZ(11);
liver_z_0 = paras2dXZ(12);
liver_a_prime = paras2dXZ(13);
liver_c_prime = paras2dXZ(14);
liver_rotate = paras2dXZ(15);
m_1 = paras2dXZ(16);
m_2 = paras2dXZ(17);
tumor_x   = paras2dXZ(18);
tumor_y   = paras2dXZ(19);
tumor_z = paras2dXZ(20);
tumor_r_prime = paras2dXZ(21);

mediumTableXZ = medFill( mediumTableXZ, 0, 0, bolus_a, bolus_c, dx, dz, 2, air_x, air_z );

nVarargs = length(varargin);
if nVarargs == 1
    fatFlag = varargin{1};
    if strcmp(fatFlag, 'no_fat')
        mediumTableXZ = medFill( mediumTableXZ, 0, 0, muscle_a, muscle_c, dx, dz, 3, air_x, air_z );
        % mediumTableXZ = medFill( mediumTableXZ, 0, 0, fat_a, fat_c, dx, dz, 3, air_x, air_z );
    else
        error('check the input text');
    end
else
    mediumTableXZ = medFill( mediumTableXZ, 0, 0, muscle_a, muscle_c, dx, dz, 7, air_x, air_z );
    mediumTableXZ = medFill( mediumTableXZ, 0, 0, fat_a, fat_c, dx, dz, 3, air_x, air_z );
end

if liver_a_prime > 0
    mediumTableXZ = medFill_liver( mediumTableXZ, liver_x + liver_x_0, liver_z + liver_z_0, liver_a_prime, liver_c_prime, liver_rotate, m_1, m_2, dx, dz, 4, air_x, air_z );
end

if isreal(tumor_r_prime)
    mediumTableXZ = medFill( mediumTableXZ, tumor_x, tumor_z, tumor_r_prime, tumor_r_prime, dx, dz, 5, air_x, air_z );
end

end