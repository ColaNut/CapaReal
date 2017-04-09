function SegMedIn = FetchSegMed( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag )

    if (m == x_max_vertex) || (n == y_max_vertex) || (ell == z_max_vertex)
        switch flag 
            case { '111', '000' }
                SegMedIn = ones(6, 8, 'uint8');
            case { '100', '011', '101', '010', '110', '001' }
                SegMedIn = ones(2, 8, 'uint8');
            otherwise
                error('check');
        end
        return;
    end
    switch flag
        case '111'
            SegMedIn = zeros(6, 8, 'uint8');
            SegMedIn = squeeze( SegMed( (m + 1) / 2, (n + 1) / 2, (ell + 1) / 2, :, : ) );
        case '000'
            SegMedIn = zeros(6, 8, 'uint8');
            % up-right-front  1: SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, , );
            % up-left-front   2: SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, , );
            % up-left-back    3: SegMed(m / 2    , n / 2    , ell / 2 + 1, , );
            % up-right-back   4: SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, , );
            % dwn-right-front 5: SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , , );
            % dwn-left-front  6: SegMed(m / 2    , n / 2 + 1, ell / 2    , , );
            % dwn-left-back   7: SegMed(m / 2    , n / 2    , ell / 2    , , );
            % dwn-right-back  8: SegMed(m / 2 + 1, n / 2    , ell / 2    , , );

            % 1
            SegMedIn(1, 1) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 6, 5);
            SegMedIn(1, 2) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 2, 8);
            % 2
            SegMedIn(1, 3) = SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, 4, 5);
            SegMedIn(1, 4) = SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, 6, 8);
            % 3
            SegMedIn(1, 5) = SegMed(m / 2    , n / 2    , ell / 2 + 1, 5, 5);
            SegMedIn(1, 6) = SegMed(m / 2    , n / 2    , ell / 2 + 1, 4, 8);
            % 4
            SegMedIn(1, 7) = SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, 2, 3);
            SegMedIn(1, 8) = SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, 1, 3);

            % 3
            SegMedIn(2, 1) = SegMed(m / 2, n / 2    , ell / 2 + 1, 3, 3);
            SegMedIn(2, 2) = SegMed(m / 2, n / 2    , ell / 2 + 1, 5, 5);
            % 2
            SegMedIn(2, 3) = SegMed(m / 2, n / 2 + 1, ell / 2 + 1, 6, 7);
            SegMedIn(2, 4) = SegMed(m / 2, n / 2 + 1, ell / 2 + 1, 3, 6);
            % 7
            SegMedIn(2, 5) = SegMed(m / 2, n / 2 + 1, ell / 2    , 1, 7);
            SegMedIn(2, 6) = SegMed(m / 2, n / 2 + 1, ell / 2    , 6, 2);
            % 6
            SegMedIn(2, 7) = SegMed(m / 2, n / 2    , ell / 2    , 5, 3);
            SegMedIn(2, 8) = SegMed(m / 2, n / 2    , ell / 2    , 1, 2);

            % 6
            SegMedIn(3, 1) = SegMed(m / 2    , n / 2 + 1, ell / 2, 6, 1);
            SegMedIn(3, 2) = SegMed(m / 2    , n / 2 + 1, ell / 2, 4, 1);
            % 5
            SegMedIn(3, 3) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2, 2, 1);
            SegMedIn(3, 4) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2, 6, 4);
            % 7
            SegMedIn(3, 5) = SegMed(m / 2 + 1, n / 2    , ell / 2, 5, 1);
            SegMedIn(3, 6) = SegMed(m / 2 + 1, n / 2    , ell / 2, 2, 4);
            % 8
            SegMedIn(3, 7) = SegMed(m / 2    , n / 2    , ell / 2, 4, 1);
            SegMedIn(3, 8) = SegMed(m / 2    , n / 2    , ell / 2, 5, 4);

            % 1
            SegMedIn(4, 1) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 3, 7);
            SegMedIn(4, 2) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 6, 6);
            % 4
            SegMedIn(4, 3) = SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, 5, 7);
            SegMedIn(4, 4) = SegMed(m / 2 + 1, n / 2    , ell / 2 + 1, 3, 2);
            % 8
            SegMedIn(4, 5) = SegMed(m / 2 + 1, n / 2    , ell / 2    , 1, 3);
            SegMedIn(4, 6) = SegMed(m / 2 + 1, n / 2    , ell / 2    , 5, 2);
            % 5
            SegMedIn(4, 7) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , 6, 3);
            SegMedIn(4, 8) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , 1, 6);

            % 2
            SegMedIn(5, 1) = SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, 3, 5);
            SegMedIn(5, 2) = SegMed(m / 2    , n / 2 + 1, ell / 2 + 1, 4, 6);
            % 1
            SegMedIn(5, 3) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 2, 7);
            SegMedIn(5, 4) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2 + 1, 3, 8);
            % 6
            SegMedIn(5, 5) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , 1, 5);
            SegMedIn(5, 6) = SegMed(m / 2 + 1, n / 2 + 1, ell / 2    , 2, 2);
            % 5
            SegMedIn(5, 7) = SegMed(m / 2    , n / 2 + 1, ell / 2    , 4, 3);
            SegMedIn(5, 8) = SegMed(m / 2    , n / 2 + 1, ell / 2    , 1, 8);

            % 4
            SegMedIn(6, 1) = SegMed(m / 2 + 1, n / 2, ell / 2 + 1, 3, 1);
            SegMedIn(6, 2) = SegMed(m / 2 + 1, n / 2, ell / 2 + 1, 2, 3);
            % 3
            SegMedIn(6, 3) = SegMed(m / 2    , n / 2, ell / 2 + 1, 4, 7);
            SegMedIn(6, 4) = SegMed(m / 2    , n / 2, ell / 2 + 1, 3, 4);
            % 7
            SegMedIn(6, 5) = SegMed(m / 2    , n / 2, ell / 2    , 1, 1);
            SegMedIn(6, 6) = SegMed(m / 2    , n / 2, ell / 2    , 4, 2);
            % 8
            SegMedIn(6, 7) = SegMed(m / 2 + 1, n / 2, ell / 2    , 2, 3);
            SegMedIn(6, 8) = SegMed(m / 2 + 1, n / 2, ell / 2    , 1, 4);

        case '110'
            % z_directin shift from '111'
            SegMedIn = zeros(2, 8, 'uint8');
            SegMedIn(1, :) = SegMed( (m + 1) / 2, (n + 1) / 2, ell / 2    , 1, : );
            SegMedIn(2, :) = SegMed( (m + 1) / 2, (n + 1) / 2, ell / 2 + 1, 3, : );
        case '001'
            % z_directin shift from '000'
            SegMedIn = zeros(2, 8, 'uint8');

            SegMedInUp  = FetchSegMed( m, n, ell - 1, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(1, :) = SegMedInUp( 1, : );
            SegMedInDwn = FetchSegMed( m, n, ell + 1, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(2, :) = SegMedInDwn( 3, : );
        case '011'
            % x_directin shift from '111'
            SegMedIn = zeros(2, 8, 'uint8');
            SegMedIn(1, :) = SegMed(m / 2    , (n + 1) / 2, (ell + 1) / 2, 4, : );
            SegMedIn(2, :) = SegMed(m / 2 + 1, (n + 1) / 2, (ell + 1) / 2, 2, : );
        case '100'
            % x_directin shift from '000'
            SegMedIn = zeros(2, 8, 'uint8');

            SegMedInL = FetchSegMed( m - 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(1, :) = SegMedInL( 4, : );
            SegMedInR = FetchSegMed( m + 1, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(2, :) = SegMedInR( 2, : );
        case '101'
            % y_directin shift from '111'
            SegMedIn = zeros(2, 8, 'uint8');
            SegMedIn(1, :) = SegMed((m + 1) / 2, n / 2    , (ell + 1) / 2, 5, : );
            SegMedIn(2, :) = SegMed((m + 1) / 2, n / 2 + 1, (ell + 1) / 2, 6, : );
        case '010'
            % y_directin shift from '000'
            SegMedIn = zeros(2, 8, 'uint8');

            SegMedInNear  = FetchSegMed( m, n - 1, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(1, :) = SegMedInNear( 5, : );
            SegMedInFar = FetchSegMed( m, n + 1, ell, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, '000' );
            SegMedIn(2, :) = SegMedInFar( 6, : );
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