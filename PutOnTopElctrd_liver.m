function [ sparseS_1, B_phi, BndryTable ] = PutOnTopElctrd_liver( sparseS_1, B_phi, V_0, mediumTableXZ, tumor_x, tumor_y, dx, dy, dz, ...
                                        air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos )

x_0 = 0;
y_0 = tumor_y;
h_x_half = 11 / 100;
h_y_half = 11 / 100;

% sweep over x_table
for x = x_0 - h_x_half: dx: x_0 + h_x_half
    for y = y_0 - h_y_half: dy: y_0 + h_y_half
        m = int64(x / dx + air_x / (2 * dx) + 1);
        n = int64(y / dy + h_torso / (2 * dy) + 1);
        ell = find(mediumTableXZ(m, :) == 11, 1, 'last');
        
        m_v = 2 * m - 1;
        n_v = 2 * n - 1;
        ell_v = 2 * ell - 1;
        p0      = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        p0_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;

        S_row = zeros(1, 2);
        S_row(1) = p0;
        S_row(2) = 1;
        sparseS_1{ p0 } = S_row;
        [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
        BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
        B_phi( p0 ) = V_0;

        if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
            S_row = zeros(1, 2);
            S_row(1) = p0_back;
            S_row(2) = 1;
            sparseS_1{ p0_back } = S_row;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p0_back ) = V_0;
        end

        if x <= 0
            arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell + 1), mediumTableXZ(m, ell + 1), ...
                    mediumTableXZ(m - 1, ell + 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell - 1), ... 
                    mediumTableXZ(m    , ell - 1), mediumTableXZ(m + 1, ell - 1) ];
            flag = find(arr == 11, 1, 'first');
            % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
            switch flag
                case 1
                    % right
                    p_adjacent = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 2
                    % up-right
                    p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 3
                    % up
                    p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v    ;
                    p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v    ;
                otherwise
                    error('check');
            end
        else % x >= 0
            arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell - 1), mediumTableXZ(m, ell - 1), ...
                    mediumTableXZ(m - 1, ell - 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell + 1), ... 
                    mediumTableXZ(m    , ell + 1), mediumTableXZ(m + 1, ell + 1) ];
            flag = find(arr == 11, 1, 'first');
            % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
            switch flag
                case 1
                    % right
                    p_adjacent = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 2
                    % down-right
                    p_adjacent = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 3
                    % down
                    p_adjacent = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v    ;
                    p_adj_back = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v    ;
                otherwise
                    flag
                    error('check');
            end
        end

        if x ~= x_0 + h_x_half
            S_row_adj = zeros(1, 2);
            S_row_adj(1) = p_adjacent;
            S_row_adj(2) = 1;
            sparseS_1{ p_adjacent } = S_row_adj;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p_adjacent ) = V_0;

            if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
                S_row_adj = zeros(1, 2);
                S_row_adj(1) = p_adj_back;
                S_row_adj(2) = 1;
                sparseS_1{ p_adj_back } = S_row_adj;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                B_phi( p_adj_back ) = V_0;
            end
        end
    end
end

% sweep over z_table
for z = 0: dz: air_z / 2
    ell = int64(z / dz + air_z / (2 * dz) + 1);
    % right point
    m_1 = find(mediumTableXZ(:, ell) == 11, 1, 'last');
    x_1 = (m_1 - 1) * dx - air_x / 2;
    % left point
    m_2 = find(mediumTableXZ(:, ell) == 11, 1, 'first');
    x_2 = (m_2 - 1) * dx - air_x / 2;

    if x_2 >= x_0 - h_x_half - dx / 2 
        for y = y_0 - h_y_half: dy: y_0 + h_y_half
            n = int64(y / dy + h_torso / (2 * dy) + 1);
            m_v = 2 * m_2 - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            p0      = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
            p0_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;

            S_row = zeros(1, 2);
            S_row(1) = p0;
            S_row(2) = 1;
            sparseS_1{ p0 } = S_row;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p0 ) = V_0;

            if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
                S_row = zeros(1, 2);
                S_row(1) = p0_back;
                S_row(2) = 1;
                sparseS_1{ p0_back } = S_row;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                B_phi( p0_back ) = V_0;
            end

            arr = [ mediumTableXZ(m_2 + 1, ell    ), mediumTableXZ(m_2 + 1, ell + 1), mediumTableXZ(m_2, ell + 1), ...
                    mediumTableXZ(m_2 - 1, ell + 1), mediumTableXZ(m_2 - 1, ell    ), mediumTableXZ(m_2 - 1, ell - 1), ... 
                    mediumTableXZ(m_2    , ell - 1), mediumTableXZ(m_2 + 1, ell - 1) ];
            flag = find(arr == 11, 1, 'first');
            % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
            switch flag
                case 1
                    % right
                    p_adjacent = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 2
                    % up-right
                    p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 3
                    % up
                    p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v    ;
                    p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v    ;
                otherwise
                    error('check');
            end

            S_row_adj = zeros(1, 2);
            S_row_adj(1) = p_adjacent;
            S_row_adj(2) = 1;
            sparseS_1{ p_adjacent } = S_row_adj;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p_adjacent ) = V_0;

            if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
                S_row_adj = zeros(1, 2);
                S_row_adj(1) = p_adj_back;
                S_row_adj(2) = 1;
                sparseS_1{ p_adj_back } = S_row_adj;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                B_phi( p_adj_back ) = V_0;
            end
        end
    end

    if x_1 <= x_0 + h_x_half + dx / 2 
        for y = y_0 - h_y_half: dy: y_0 + h_y_half
            n = int64(y / dy + h_torso / (2 * dy) + 1);
            m_v = 2 * m_1 - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            p0      = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
            p0_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;

            S_row = zeros(1, 2);
            S_row(1) = p0;
            S_row(2) = 1;
            sparseS_1{ p0 } = S_row;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p0 ) = V_0;

            if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
                S_row = zeros(1, 2);
                S_row(1) = p0_back;
                S_row(2) = 1;
                sparseS_1{ p0_back } = S_row;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                B_phi( p0_back ) = V_0;
            end

            arr = [ mediumTableXZ(m_1 + 1, ell    ), mediumTableXZ(m_1 + 1, ell - 1), mediumTableXZ(m_1, ell - 1), ...
                    mediumTableXZ(m_1 - 1, ell - 1), mediumTableXZ(m_1 - 1, ell    ), mediumTableXZ(m_1 - 1, ell + 1), ... 
                    mediumTableXZ(m_1    , ell + 1), mediumTableXZ(m_1 + 1, ell + 1) ];
            flag = find(arr == 11, 1, 'first');
            % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
            switch flag
                case 1
                    % right
                    p_adjacent = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 2
                    % down-right
                    p_adjacent = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
                    p_adj_back = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
                case 3
                    % down
                    p_adjacent = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v    ;
                    p_adj_back = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v    ;
                otherwise
                    error('check');
            end

            if x_1 ~= x_0 + h_x_half
                S_row_adj = zeros(1, 2);
                S_row_adj(1) = p_adjacent;
                S_row_adj(2) = 1;
                sparseS_1{ p_adjacent } = S_row_adj;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                B_phi( p_adjacent ) = V_0;

                if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
                    S_row_adj = zeros(1, 2);
                    S_row_adj(1) = p_adj_back;
                    S_row_adj(2) = 1;
                    sparseS_1{ p_adj_back } = S_row_adj;
                    [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
                    BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                    B_phi( p_adj_back ) = V_0;
                end
            end
        end
    end
end

end
