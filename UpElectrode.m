function [ sparseA, B, UpElecTb ] = UpElectrode( sparseA, B, Xtable, Ztable, paras, V_0, x_idx_max, y_idx_max, dx, dy, dz, z_idx_max )

% Xtable(1, :) = [ int_grid_x, z1, int_grid_x, z2 ];
% Ztable(1, :) = [ x1, int_grid_z, x2, int_grid_z ];
h_torso = paras(1);
air_x   = paras(2);
air_z   = paras(3);
tumor_x = paras(20);
tumor_y = paras(21);

ElectrodeX = tumor_x;
ElectrodeY = tumor_y;
ElectrodeZ = 12 / 100;
h_x_half = 6 / 100;
h_y_half = 6 / 100;

lenX = size(Xtable, 1);
lenZ = size(Ztable, 1);

UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );

% A_rowsUp = zeros( length(ElectrodeY - h_y_half: dy: ElectrodeY + h_y_half), 2 );

for idx = 1: 1: lenX
    x  = Xtable(idx, 1); 
    z1 = Xtable(idx, 2); 
    % z2 = Xtable(idx, 4); 
    if Xtable(idx, 1) ~= Xtable(idx, 3)
        error('check Xtable');
    end 
    m = int64( x / dx + air_x / (2 * dx) + 1 );
    ell_1 = int64( z1 / dz + air_z / (2 * dz) + 1 );
    % ell_2 = int64( z2 / dz + air_z / (2 * dz) + 1 );

    tmp_y_shift = h_torso / (2 * dy) + 1;

    if x >= ElectrodeX - h_x_half - dx / 2 && x <= ElectrodeX + h_x_half + dx / 2
        for y = ElectrodeY - h_y_half: dy: ElectrodeY + h_y_half
            n = int64(y / dy + tmp_y_shift);
            % note especially for n
            UpElecTb( m, n, ell_1 ) = true;

            p0_1   = ( ell_1 - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
            A_row_1 = zeros(1, 2);
            A_row_1(1) = p0_1;
            A_row_1(2) = 1;
            sparseA{ p0_1 } = A_row_1;
            B( p0_1 ) = V_0;
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
        if x2 >= ElectrodeX - h_x_half - dx / 2
            for y = ElectrodeY - h_y_half: dy: ElectrodeY + h_y_half
                n = int64(y / dy + tmp_y_shift);

                UpElecTb( m_2, n, ell ) = true;
                p0_2   = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_2;
                A_row_2 = zeros(1, 2);
                A_row_2(1) = p0_2;
                A_row_2(2) = 1;
                sparseA{ p0_2 } = A_row_2;
                B( p0_2 ) = V_0;
            end
        end

        if x1 <= ElectrodeX + h_x_half + dx / 2
            for y = ElectrodeY - h_y_half: dy: ElectrodeY + h_y_half
                n = int64(y / dy + tmp_y_shift);

                UpElecTb( m_1, n, ell ) = true;
                p0_1   = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m_1;
                A_row_1 = zeros(1, 2);
                A_row_1(1) = p0_1;
                A_row_1(2) = 1;
                sparseA{ p0_1 } = A_row_1;
                B( p0_1 ) = V_0;
            end
        end
    end
end

end