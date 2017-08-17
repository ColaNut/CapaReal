function sparseS_1 = PutOnDwnElctrd_Cervix( sparseS_1, mediumTableXZ, tumor_x, tumor_y, ...
                                    dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, CervixY );

% tmp code for the cervix
for y = 0 - CervixY / 2: dy: 0 + CervixY / 2
    m = int64(- dx/ dx + air_x / (2 * dx) + 1);
    n = int64(y / dy + h_torso / (2 * dy) + 1);
    ell = int64(0 / dz + air_z / (2 * dz) + 1);

    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    p0       = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
    p0_back  = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v;
    p0_ru    = ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;
    p0_rd    = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1;

    % p0
    S_row = zeros(1, 2); S_row(1) = p0; S_row(2) = 1;
    sparseS_1{ p0 } = S_row;
    % B_phi( p0 ) = V_0;

    % p0_back
    S_row = zeros(1, 2); S_row(1) = p0_back; S_row(2) = 1;
    sparseS_1{ p0_back } = S_row;
    % B_phi( p0_back ) = V_0;

    % p0_lu
    S_row = zeros(1, 2); S_row(1) = p0_ru; S_row(2) = 1;
    sparseS_1{ p0_ru } = S_row;
    % B_phi( p0_ru ) = V_0;

    % p0_rd
    S_row = zeros(1, 2); S_row(1) = p0_rd; S_row(2) = 1;
    sparseS_1{ p0_rd } = S_row;
    % B_phi( p0_rd ) = V_0;

end

% x_0 = tumor_x;
% y_0 = tumor_y;
% z_0 = 12 / 100;
% h_x_half = 10 / 100;
% h_y_half = 10 / 100;

% % sweep over x_table
% for x = x_0 - h_x_half: dx: x_0 + h_x_half
%     for y = y_0 - h_y_half: dy: y_0 + h_y_half
%         m = int64(x / dx + air_x / (2 * dx) + 1);
%         n = int64(y / dy + h_torso / (2 * dy) + 1);
%         ell = find(mediumTableXZ(m, :) == 11, 1, 'first');
        
%         if ~isempty(ell)
%             m_vertex = 2 * m - 1;
%             n_vertex = 2 * n - 1;
%             ell_vertex = 2 * ell - 1;
%             p0      = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
%             p0_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex;

%             S_row = zeros(1, 2);
%             S_row(1) = p0;
%             S_row(2) = 1;
%             sparseS_1{ p0 } = S_row;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row = zeros(1, 2);
%                 S_row(1) = p0_back;
%                 S_row(2) = 1;
%                 sparseS_1{ p0_back } = S_row;
%             end

%             if x <= 0
%                 arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell - 1), mediumTableXZ(m, ell - 1), ...
%                         mediumTableXZ(m - 1, ell - 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell + 1), ... 
%                         mediumTableXZ(m    , ell + 1), mediumTableXZ(m + 1, ell + 1) ];
%                 flag = find(arr == 11, 1, 'first');
%                 % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%                 switch flag
%                     case 1
%                         % right
%                         p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                         p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                     case 2
%                         % down-right
%                         p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                         p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                     case 3
%                         % down
%                         p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
%                         p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
%                     otherwise
%                         flag
%                         error('check');
%                 end
%             else % x >= 0
%                 arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell + 1), mediumTableXZ(m, ell + 1), ...
%                         mediumTableXZ(m - 1, ell + 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell - 1), ... 
%                         mediumTableXZ(m    , ell - 1), mediumTableXZ(m + 1, ell - 1) ];
%                 flag = find(arr == 11, 1, 'first');
%                 % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%                 switch flag
%                     case 1
%                         % right
%                         p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                         p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                     case 2
%                         % up-right
%                         p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                         p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                     case 3
%                         % up
%                         p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
%                         p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
%                     otherwise
%                         error('check');
%                 end
%             end

%             if x ~= x_0 + h_x_half
%                 S_row_adj = zeros(1, 2);
%                 S_row_adj(1) = p_adjacent;
%                 S_row_adj(2) = 1;
%                 sparseS_1{ p_adjacent } = S_row_adj;

%                 if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                     S_row_adj = zeros(1, 2);
%                     S_row_adj(1) = p_adj_back;
%                     S_row_adj(2) = 1;
%                     sparseS_1{ p_adj_back } = S_row_adj;
%                 end
%             end
%         end
%     end
% end

% % sweep over z_table
% for z = - air_z / 2: dz: 0
%     ell = int64(z / dz + air_z / (2 * dz) + 1);
%     % right point
%     m_1 = find(mediumTableXZ(:, ell) == 11, 1, 'last');
%     x_1 = (m_1 - 1) * dx - air_x / 2;
%     % left point
%     m_2 = find(mediumTableXZ(:, ell) == 11, 1, 'first');
%     x_2 = (m_2 - 1) * dx - air_x / 2;

%     if x_2 >= x_0 - h_x_half - dx / 2 
%         for y = y_0 - h_y_half: dy: y_0 + h_y_half
%             n = int64(y / dy + h_torso / (2 * dy) + 1);
%             m_vertex = 2 * m_2 - 1;
%             n_vertex = 2 * n - 1;
%             ell_vertex = 2 * ell - 1;
%             p0      = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
%             p0_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex;

%             S_row = zeros(1, 2);
%             S_row(1) = p0;
%             S_row(2) = 1;
%             sparseS_1{ p0 } = S_row;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row = zeros(1, 2);
%                 S_row(1) = p0_back;
%                 S_row(2) = 1;
%                 sparseS_1{ p0_back } = S_row;
%             end

%             arr = [ mediumTableXZ(m_2 + 1, ell    ), mediumTableXZ(m_2 + 1, ell - 1), mediumTableXZ(m_2, ell - 1), ...
%                     mediumTableXZ(m_2 - 1, ell - 1), mediumTableXZ(m_2 - 1, ell    ), mediumTableXZ(m_2 - 1, ell + 1), ... 
%                     mediumTableXZ(m_2    , ell + 1), mediumTableXZ(m_2 + 1, ell + 1) ];
%             flag = find(arr == 11, 1, 'first');
%             % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%             switch flag
%                 case 1
%                     % right
%                     p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                     p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                 case 2
%                     % up-right
%                     p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                     p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                 case 3
%                     % up
%                     p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
%                     p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
%                 otherwise
%                     flag
%                     error('check');
%             end

%             S_row_adj = zeros(1, 2);
%             S_row_adj(1) = p_adjacent;
%             S_row_adj(2) = 1;
%             sparseS_1{ p_adjacent } = S_row_adj;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row_adj = zeros(1, 2);
%                 S_row_adj(1) = p_adj_back;
%                 S_row_adj(2) = 1;
%                 sparseS_1{ p_adj_back } = S_row_adj;
%             end
%         end
%     end

%     if x_1 <= x_0 + h_x_half + dx / 2 
%         for y = y_0 - h_y_half: dy: y_0 + h_y_half
%             n = int64(y / dy + h_torso / (2 * dy) + 1);
%             m_vertex = 2 * m_1 - 1;
%             n_vertex = 2 * n - 1;
%             ell_vertex = 2 * ell - 1;
%             p0      = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
%             p0_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex;

%             S_row = zeros(1, 2);
%             S_row(1) = p0;
%             S_row(2) = 1;
%             sparseS_1{ p0 } = S_row;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row = zeros(1, 2);
%                 S_row(1) = p0_back;
%                 S_row(2) = 1;
%                 sparseS_1{ p0_back } = S_row;
%             end

%             arr = [ mediumTableXZ(m_1 + 1, ell    ), mediumTableXZ(m_1 + 1, ell + 1), mediumTableXZ(m_1, ell + 1), ...
%                     mediumTableXZ(m_1 - 1, ell + 1), mediumTableXZ(m_1 - 1, ell    ), mediumTableXZ(m_1 - 1, ell - 1), ... 
%                     mediumTableXZ(m_1    , ell - 1), mediumTableXZ(m_1 + 1, ell - 1) ];
%             flag = find(arr == 11, 1, 'first');
%             % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%             switch flag
%                 case 1
%                     % right
%                     p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                     p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                 case 2
%                     % up-right
%                     p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%                     p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%                 case 3
%                     % up
%                     p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
%                     p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
%                 otherwise
%                     error('check');
%             end

%             if x_1 ~= x_0 + h_x_half
%                 S_row_adj = zeros(1, 2);
%                 S_row_adj(1) = p_adjacent;
%                 S_row_adj(2) = 1;
%                 sparseS_1{ p_adjacent } = S_row_adj;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                     S_row_adj = zeros(1, 2);
%                     S_row_adj(1) = p_adj_back;
%                     S_row_adj(2) = 1;
%                     sparseS_1{ p_adj_back } = S_row_adj;
%                 end
%             end
%         end
%     end
% end

end
