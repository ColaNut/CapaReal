function mediumTableXZ = getRoughMed_Cervix_amend( mediumTableXZ, paras2dXZ, dx, dz, varargin )

% paras2dXZ = [ air_x, air_z, bolus_a, bolus_c, fat_a, fat_c, muscle_a, muscle_c, ...
%     l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
%     r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
%     tumor_x, tumor_z, tumor_r_prime ];
% 0
air_x = paras2dXZ(1);
air_z = paras2dXZ(2);

% 1
bolus_a = paras2dXZ(3); % radius of cervical tumor
bolus_c = paras2dXZ(4);

% 2
fat_a = paras2dXZ(5); % radius of electrode 
fat_c = paras2dXZ(6);

% 3
muscle_a = paras2dXZ(7); % radius of bolus
muscle_c = paras2dXZ(8);

% 4
l_lung_x = paras2dXZ(9);
l_lung_z = paras2dXZ(10);
l_lung_a = paras2dXZ(11);
l_lung_c = paras2dXZ(12);

% 5
r_lung_x = paras2dXZ(13);
r_lung_z = paras2dXZ(14);
r_lung_a = paras2dXZ(15);
r_lung_c = paras2dXZ(16);

% 6
tumor_x = paras2dXZ(17);
tumor_z = paras2dXZ(18);
tumor_r = paras2dXZ(19);

mediumTableXZ = medFill( mediumTableXZ, 0, 0, bolus_a, bolus_c, dx, dz, 11, air_x, air_z );

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
    mediumTableXZ = medFill( mediumTableXZ, 0, 0, muscle_a, muscle_c, dx, dz, 13, air_x, air_z );
    mediumTableXZ = medFill( mediumTableXZ, 0, 0, fat_a, fat_c, dx, dz, 12, air_x, air_z );
end

if isreal(l_lung_c)
    mediumTableXZ = medFill( mediumTableXZ, l_lung_x, l_lung_z, l_lung_a, l_lung_c, dx, dz, 4, air_x, air_z );
end
if isreal(r_lung_c)
    mediumTableXZ = medFill( mediumTableXZ, r_lung_x, r_lung_z, r_lung_a, r_lung_c, dx, dz, 4, air_x, air_z );
end
if isreal(tumor_r)
    mediumTableXZ = medFill( mediumTableXZ, tumor_x, tumor_z, tumor_r, tumor_r, dx, dz, 5, air_x, air_z );
end

end