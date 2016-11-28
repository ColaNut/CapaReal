% get upper electrode (x, y, z) index.

X_width = 13 / 100;
Y_width = 11 / 100;
UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );
[ Xtable, Ztable ] = fillTradlElctrd( bolus_a, bolus_b, dx, dz );

lenX = size(Xtable, 1);
lenZ = size(Ztable, 1);

tmp_y_shift = h_torso / (2 * dy) + 1;

for idx = 1: 1: lenX
    x  = Xtable(idx, 1); 
    z1 = Xtable(idx, 2); 
    if Xtable(idx, 1) ~= Xtable(idx, 3)
        error('check Xtable');
    end 
    m = int64( x / dx + air_x / (2 * dx) + 1 );
    ell_1 = int64( z1 / dz + air_z / (2 * dz) + 1 );

    if x >= - X_width && x <= X_width
        for n = - Y_width / dy + tmp_y_shift: 1: Y_width / dy + tmp_y_shift
            if z1 > 0
                UpElecTb( m, n, ell_1 ) = true;
            end
        end
    end
end

for idx = 1: 1: lenZ
    x1 = Ztable(idx, 1); 
    z  = Ztable(idx, 2); 
    x2 = Ztable(idx, 3); 
    if Ztable(idx, 2) ~= Ztable(idx, 4)
        error('check Z table');
    end 
    m_1 = int64( x1 / dx + air_x / (2 * dx) + 1 );
    m_2 = int64( x2 / dx + air_x / (2 * dx) + 1 );
    ell = int64( z / dz + air_z / (2 * dz) + 1 );

    if z > 0
        if x2 >= - X_width && x1 <= X_width
            for n = - Y_width / dy + tmp_y_shift: 1: Y_width / dy + tmp_y_shift
                UpElecTb( m_1, n, ell ) = true;
                UpElecTb( m_2, n, ell ) = true;
            end
        end
    end
end