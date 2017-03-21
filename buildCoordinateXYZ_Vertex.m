function Vertex_Crdnt = buildCoordinateXYZ_Vertex( oriCrdnt )

    x_idx_max = 0;
    y_idx_max = 0;
    z_idx_max = 0;
    tmp = 0;
    [ x_idx_max, y_idx_max, z_idx_max, tmp ] = size(oriCrdnt);
    x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
    y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
    z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;

    Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
    for idx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
        [ m, n, ell ] = getMNL(idx, x_max_vertex, y_max_vertex, z_max_vertex);
        flag = '000';
        flag = getMNL_flag(m, n, ell);

        switch flag
            case '111'
                Vertex_Crdnt(m, n, ell, :) = oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ( ell + 1 ) / 2, :);                   
            case '110'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ell / 2 + 1, :) + oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ell / 2, :) ) / 2;
            case '101'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, n / 2 + 1, ( ell + 1 ) / 2, :) + oriCrdnt(( m + 1 ) / 2, n / 2, ( ell + 1 ) / 2, :) ) / 2;
            case '011'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2 + 1, ( n + 1 ) / 2, ( ell + 1 ) / 2, :) + oriCrdnt(m / 2, ( n + 1 ) / 2, ( ell + 1 ) / 2, :) ) / 2;
            case '010'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2 + 1, ( n + 1 ) / 2, ell / 2 + 1, :) + oriCrdnt(m / 2, ( n + 1 ) / 2, ell / 2 + 1, :) ...
                                            + oriCrdnt(m / 2, ( n + 1 ) / 2, ell / 2, :) + oriCrdnt(m / 2 + 1, ( n + 1 ) / 2, ell / 2, :) ) / 4;
            case '001'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2 + 1, n / 2 + 1, ( ell + 1 ) / 2, :) + oriCrdnt(m / 2, n / 2 + 1, ( ell + 1 ) / 2, :) ...
                                            + oriCrdnt(m / 2, n / 2, ( ell + 1 ) / 2, :) + oriCrdnt(m / 2 + 1, n / 2, ( ell + 1 ) / 2, :) ) / 4;
            case '100'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, n / 2 + 1, ell / 2 + 1, :) + oriCrdnt(( m + 1 ) / 2, n / 2, ell / 2 + 1, :) ...
                                            + oriCrdnt(( m + 1 ) / 2, n / 2, ell / 2, :) + oriCrdnt(( m + 1 ) / 2, n / 2 + 1, ell / 2, :) ) / 4;
            case '000'
                Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2 + 1, n / 2 + 1, ell / 2 + 1, :) + oriCrdnt(m / 2, n / 2 + 1, ell / 2 + 1, :) ...
                                            + oriCrdnt(m / 2, n / 2, ell / 2 + 1, :) + oriCrdnt(m / 2 + 1, n / 2, ell / 2 + 1, :) ...
                                            + oriCrdnt(m / 2 + 1, n / 2 + 1, ell / 2, :) + oriCrdnt(m / 2, n / 2 + 1, ell / 2, :) ...
                                            + oriCrdnt(m / 2, n / 2, ell / 2, :) + oriCrdnt(m / 2 + 1, n / 2, ell / 2, :) ) / 8;
            otherwise
                error('check');
        end
    end
end

                % Gamma included.
                % case '000'
                %     Vertex_Crdnt(m, n, ell, :) = oriCrdnt(m / 2, n / 2, ell / 2, :);
                % case '100'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, n / 2, ell / 2, :) + oriCrdnt(( m - 1 ) / 2, n / 2, ell / 2, :) ) / 2;
                % case '010'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2, ( n + 1 ) / 2, ell / 2, :) + oriCrdnt(m / 2, ( n - 1 ) / 2, ell, :) ) / 2;
                % case '001'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2, n / 2, ( ell + 1 ) / 2, :) + oriCrdnt(m / 2, n / 2, ( ell - 1 ) / 2, :) ) / 2;
                % case '110'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ell / 2, :) + oriCrdnt(( m - 1 ) / 2, ( n + 1 ) / 2, ell / 2, :) ...
                %                                 + oriCrdnt(( m - 1 ) / 2, ( n - 1 ) / 2, ell / 2, :) + oriCrdnt(( m + 1 ) / 2, ( n - 1 ) / 2, ell / 2, :) ) / 4;
                % case '011'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(m / 2, ( n + 1 ) / 2, ( ell + 1 ) / 2, :) + oriCrdnt(m / 2, ( n + 1 ) / 2, ( ell - 1 ) / 2, :) ...
                %                                 + oriCrdnt(m / 2, ( n - 1 ) / 2, ( ell - 1 ) / 2, :) + oriCrdnt(m / 2, ( n - 1 ) / 2, ( ell + 1 ) / 2, :) ) / 4;
                % case '101'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, n / 2, ( ell + 1 ) / 2, :) + oriCrdnt(( m - 1 ) / 2, n / 2, ( ell - 1 ) / 2, :) ...
                %                                 + oriCrdnt(( m - 1 ) / 2, n / 2, ( ell - 1 ) / 2, :) + oriCrdnt(( m + 1 ) / 2, n / 2, ( ell + 1 ) / 2, :) ) / 4;
                % case '111'
                %     Vertex_Crdnt(m, n, ell, :) = ( oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ( ell + 1 ) / 2, :) + oriCrdnt(( m - 1 ) / 2, ( n + 1 ) / 2, ( ell + 1 ) / 2, :) ...
                %                                 + oriCrdnt(( m - 1 ) / 2, ( n - 1 ) / 2, ( ell + 1 ) / 2, :) + oriCrdnt(( m + 1 ) / 2, ( n - 1 ) / 2, ( ell + 1 ) / 2, :) ...
                %                                 + oriCrdnt(( m + 1 ) / 2, ( n + 1 ) / 2, ( ell - 1 ) / 2, :) + oriCrdnt(( m - 1 ) / 2, ( n + 1 ) / 2, ( ell - 1 ) / 2, :) ...
                %                                 + oriCrdnt(( m - 1 ) / 2, ( n - 1 ) / 2, ( ell - 1 ) / 2, :) + oriCrdnt(( m + 1 ) / 2, ( n - 1 ) / 2, ( ell - 1 ) / 2, :) ) / 8;
                % otherwise
                %     error('check');