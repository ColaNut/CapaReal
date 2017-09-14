function [ sparseS_1, B_phi, BndryTable ] = PutOnElctrd_cervixThinBls( sparseS_1, B_phi, V_0, mediumTableXZ, tumor_x, tumor_y, dx, dy, dz, ...
                                        air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos, CervixY )

% % tmp code for the cervix
% for y = 0 - CervixY / 4: dy: 0 + CervixY / 4
%     m = int64(dx/ dx + air_x / (2 * dx) + 1);
%     n = int64(y / dy + h_torso / (2 * dy) + 1);
%     ell = int64(0 / dz + air_z / (2 * dz) + 1);

%     m_v = 2 * m - 1;
%     n_v = 2 * n - 1;
%     ell_v = 2 * ell - 1;
%     p0       = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
%     p0_back  = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;
%     p0_lu    = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1;
%     p0_ld    = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1;

%     % p0
%     S_row = zeros(1, 2); S_row(1) = p0; S_row(2) = 1;
%     sparseS_1{ p0 } = S_row;
%     B_phi( p0 ) = V_0;

%     % p0_back
%     S_row = zeros(1, 2); S_row(1) = p0_back; S_row(2) = 1;
%     sparseS_1{ p0_back } = S_row;
%     B_phi( p0_back ) = V_0;

%     % p0_lu
%     S_row = zeros(1, 2); S_row(1) = p0_lu; S_row(2) = 1;
%     sparseS_1{ p0_lu } = S_row;
%     B_phi( p0_lu ) = V_0;

%     % p0_ld
%     S_row = zeros(1, 2); S_row(1) = p0_ld; S_row(2) = 1;
%     sparseS_1{ p0_ld } = S_row;
%     B_phi( p0_ld ) = V_0;

% end


z_0 = 0;
y_0 = 0;
% h_x_half = 0.2 / 100;
% % sweep over x_table
% for x = z_0 - h_x_half: dx: z_0 + h_x_half
%     for y = 0 - CervixY / 4: dy: 0 + CervixY / 4
%         m = int64(x / dx + air_x / (2 * dx) + 1);
%         n = int64(y / dy + h_torso / (2 * dy) + 1);
%         ell = find(mediumTableXZ(m, :) == 12, 1, 'last');
        
%         m_v = 2 * m - 1;
%         n_v = 2 * n - 1;
%         ell_v = 2 * ell - 1;
%         p0      = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
%         p0_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;

%         S_row = zeros(1, 2);
%         S_row(1) = p0;
%         S_row(2) = 1;
%         sparseS_1{ p0 } = S_row;
%         [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
%         BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
%         B_phi( p0 ) = V_0;

%         if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%             S_row = zeros(1, 2);
%             S_row(1) = p0_back;
%             S_row(2) = 1;
%             sparseS_1{ p0_back } = S_row;
%             [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
%             BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
%             B_phi( p0_back ) = V_0;
%         end

%         arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell + 1), mediumTableXZ(m, ell + 1), ...
%                 mediumTableXZ(m - 1, ell + 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell - 1), ... 
%                 mediumTableXZ(m    , ell - 1), mediumTableXZ(m + 1, ell - 1) ];
%         flag = find(arr == 12, 1, 'first');
%         % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%         switch flag
%             case 1
%                 % right
%                 p_adjacent = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
%                 p_adj_back = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
%             case 2
%                 % up-right
%                 p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
%                 p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1;
%             case 3
%                 % up
%                 p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v    ;
%                 p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v    ;
%             otherwise
%                 error('check');
%         end

%         if x ~= z_0 + h_x_half
%             S_row_adj = zeros(1, 2);
%             S_row_adj(1) = p_adjacent;
%             S_row_adj(2) = 1;
%             sparseS_1{ p_adjacent } = S_row_adj;
%             [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
%             BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
%             B_phi( p_adjacent ) = V_0;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row_adj = zeros(1, 2);
%                 S_row_adj(1) = p_adj_back;
%                 S_row_adj(2) = 1;
%                 sparseS_1{ p_adj_back } = S_row_adj;
%                 [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
%                 BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
%                 B_phi( p_adj_back ) = V_0;
%             end
%         end
%     end
% end

% sweep over z_table
for z = - 2 * dz: dz: 2 * dz
    ell = int64(z / dz + air_z / (2 * dz) + 1);
    % right point
    m_1 = find(mediumTableXZ(:, ell) == 12, 1, 'last');
    x_1 = (m_1 - 1) * dx - air_x / 2;
    % left point
    m_2 = find(mediumTableXZ(:, ell) == 12, 1, 'first');
    x_2 = (m_2 - 1) * dx - air_x / 2;

    if x_2 > 0 || x_1 < 0
        error('check');
    end

    % left electrode
    for y = 0 - CervixY / 4: dy: 0 + CervixY / 4
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
        % B_phi( p0 ) = V_0;

        if n ~= int64((0 + CervixY / 4) / dy + h_torso / (2 * dy) + 1);
            S_row = zeros(1, 2);
            S_row(1) = p0_back;
            S_row(2) = 1;
            sparseS_1{ p0_back } = S_row;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            % B_phi( p0_back ) = V_0;
        end

        arr = [ mediumTableXZ(m_2 + 1, ell    ), mediumTableXZ(m_2 + 1, ell + 1), mediumTableXZ(m_2, ell + 1), ...
                mediumTableXZ(m_2 - 1, ell + 1), mediumTableXZ(m_2 - 1, ell    ), mediumTableXZ(m_2 - 1, ell - 1), ... 
                mediumTableXZ(m_2    , ell - 1), mediumTableXZ(m_2 + 1, ell - 1) ];
        flag = find(arr == 12, 1, 'first');
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
            case 4
                % left-up
                p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1;
                p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v - 1;
            otherwise
                error('check');
        end
        if z ~= 2 * dz
            S_row_adj = zeros(1, 2);
            S_row_adj(1) = p_adjacent;
            S_row_adj(2) = 1;
            sparseS_1{ p_adjacent } = S_row_adj;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            % B_phi( p_adjacent ) = V_0;

            if n ~= int64((0 + CervixY / 4) / dy + h_torso / (2 * dy) + 1);
                S_row_adj = zeros(1, 2);
                S_row_adj(1) = p_adj_back;
                S_row_adj(2) = 1;
                sparseS_1{ p_adj_back } = S_row_adj;
                [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
                BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
                % B_phi( p_adj_back ) = V_0;
            end
        end
    end

    for y = 0 - CervixY / 4: dy: 0 + CervixY / 4
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

        if n ~= int64((0 + CervixY / 4) / dy + h_torso / (2 * dy) + 1);
            S_row = zeros(1, 2);
            S_row(1) = p0_back;
            S_row(2) = 1;
            sparseS_1{ p0_back } = S_row;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p0_back ) = V_0;
        end

        arr = [ mediumTableXZ(m_1 + 1, ell    ), mediumTableXZ(m_1 + 1, ell + 1), mediumTableXZ(m_1, ell + 1), ...
                mediumTableXZ(m_1 - 1, ell + 1), mediumTableXZ(m_1 - 1, ell    ), mediumTableXZ(m_1 - 1, ell - 1), ... 
                mediumTableXZ(m_1    , ell - 1), mediumTableXZ(m_1 + 1, ell - 1) ];
        flag = find(arr == 12, 1, 'first');
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
            case 4
                % left-up
                p_adjacent = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1;
                p_adj_back = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v - 1;
            otherwise
                error('check');
        end

        if z ~= 2 * dz
            S_row_adj = zeros(1, 2);
            S_row_adj(1) = p_adjacent;
            S_row_adj(2) = 1;
            sparseS_1{ p_adjacent } = S_row_adj;
            [ m_v_tmp, n_v_tmp, ell_v_tmp ] = getMNL(S_row_adj(1), x_max_vertex, y_max_vertex, z_max_vertex);
            BndryTable(m_v_tmp, n_v_tmp, ell_v_tmp) = TpElctrdPos;
            B_phi( p_adjacent ) = V_0;

            if n ~= int64((0 + CervixY / 4) / dy + h_torso / (2 * dy) + 1);
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
