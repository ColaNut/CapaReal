function auxiSegMed = getAuxiSegMed( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag )

auxiSegMed = zeros(6, 8, 'uint8');
    switch flag
        case '110'
            % z_directin shift from '111'
            auxiSegMed = FetchSegMed( m, n, ell - 1, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '111' );
        case '001'
            % z_directin shift from '000'
            auxiSegMed = FetchSegMed( m, n, ell - 1, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
        case '011' 
            % x_directin shift from '111'
            auxiSegMed = FetchSegMed( m - 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '111' );
        case '100'
            % x_directin shift from '000'
            auxiSegMed = FetchSegMed( m - 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
        case '101'
            % y_directin shift from '111'
            auxiSegMed = FetchSegMed( m, n - 1, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '111' );
        case '010'
            % y_directin shift from '000'
            auxiSegMed = FetchSegMed( m, n - 1, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
        otherwise
            error('check');
    end
end
            % original         : SegMed((m + 1) / 2, (n + 1) / 2, (ell + 1) / 2, :, : )
            % up-right-front  1: SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, , );
            % up-left-front   2: SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, , );
            % up-left-back    3: SegMed(m / 2    , n / 2    , ell / 2 + 1, , );
            % up-right-back   4: SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, , );
            % dwn-right-front 5: SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , , );
            % dwn-left-front  6: SegMed(m / 2    , n / 2 + 1, ell / 2    , , );
            % dwn-left-back   7: SegMed(m / 2    , n / 2    , ell / 2    , , );
            % dwn-right-back  8: SegMed(m / 2 + 1, n / 2    , ell / 2    , , );