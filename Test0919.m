x_es_n = x_es / dx + air_x / (2 * dx) + 1;
y_es_n = 0 / dy + h_torso / (2 * dy) + 1;
z_es_n = z_es / dz + air_z / (2 * dz) + 1;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable_Esphgs(m, n, ell) == 1
        SegMed(m, n, ell, :, :) = 1;
    elseif m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 && mediumTable_Esphgs(m, n, ell) == 31
        SegMed( m, n, ell, :, : ) = fillBndrySegMed_Esophagus( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable_Esphgs, squeeze(SegMed( m, n, ell, :, : )), EsBndryNum, EsNum );
    end
    if m == x_es_n && n == y_es_n && ell == z_es_n
        SegMed(m, n, ell, 1, :) = EsNum;
    end
end