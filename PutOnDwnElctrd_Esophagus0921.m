function [ sparseS_1, B_phi ] = PutOnDwnElctrd_Esophagus0921( sparseS_1, B_phi, V_0, x_max_vertex, y_max_vertex )

loadParas;
loadAmendParas_Esophagus;
m_vertex = 2 * ( x_es / dx + air_x / (2 * dx) + 1 ) - 1;
n_vertex = 2 * ( 0 / dy + h_torso / (2 * dy) + 1 ) - 1;
ell_vertex = 2 * ( z_es / dz + air_z / (2 * dz) + 1 ) - 1;

% p0 = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
Pnt = zeros(9, 1);
Pnt(1) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 2 ) * x_max_vertex + m_vertex - 1;
Pnt(2) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 2 ) * x_max_vertex + m_vertex    ;
Pnt(3) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 2 ) * x_max_vertex + m_vertex + 1;
Pnt(4) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex - 1;
Pnt(5) = ( ell_vertex - 3 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ; % V
Pnt(6) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
Pnt(7) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex - 1;
Pnt(8) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
Pnt(9) = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;

for idx = 1: 1: 9
    S_row = zeros(1, 2); S_row(1) = Pnt(idx); S_row(2) = 1;
    sparseS_1{ Pnt(idx) } = S_row;
    B_phi( Pnt(idx) ) = V_0;
end

% % x_0 = 0;
% % y_0 = 0;
% % z_0 = 5 / 100;
% % m_v = 2 * ( int64(x_0/ dx + air_x / (2 * dx) + 1) ) - 1;
% % n_v = 2 * ( int64(y_0/ dy + h_torso / (2 * dy) + 1) ) - 1;
% % ell_v = 2 * ( int64(z_0/ dz + air_z / (2 * dz) + 1) ) - 1;

% % h_x_half = 1 / 100;
% % h_y_half = 1 / 100;

% % for n_v_itr = n_v - 1: 1: n_v + 1
% %     % p0 = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
% %     p_lft = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v_itr - 1 ) * x_max_vertex + m_v - 1;
% %     p_dwn = ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v_itr - 1 ) * x_max_vertex + m_v;
% %     p_rght = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v_itr - 1 ) * x_max_vertex + m_v + 1;

% %     S_row = zeros(1, 2); S_row(1) = p_lft; S_row(2) = 1;
% %     sparseS_1{ p_lft } = S_row;

% %     S_row = zeros(1, 2); S_row(1) = p_dwn; S_row(2) = 1;
% %     sparseS_1{ p_dwn } = S_row;

% %     S_row = zeros(1, 2); S_row(1) = p_rght; S_row(2) = 1;
% %     sparseS_1{ p_rght } = S_row;
% % end

% loadParas;
% loadAmendParas_Esophagus;
% x_0 = x_es;
% y_0 = 0;
% h_y_half = r_es;
% h_x_half = r_es;

% Counter = 0;
% % sweep over x_table
% for x = x_0 - r_es: dx: x_0 + r_es
%     for y = 0 - r_es: dy: 0 + r_es
%         m = int64(x / dx + air_x / (2 * dx) + 1);
%         n = int64(y / dy + h_torso / (2 * dy) + 1);
%         ell = find(mediumTableXZ(m, :) == 1, 1, 'first');
        
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
%             Counter = Counter + 1;

%             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                 S_row = zeros(1, 2);
%                 S_row(1) = p0_back;
%                 S_row(2) = 1;
%                 sparseS_1{ p0_back } = S_row;
%                 Counter = Counter + 1;
%             end

%             % if x < 0
%                 arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell - 1), mediumTableXZ(m, ell - 1), ...
%                         mediumTableXZ(m - 1, ell - 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell + 1), ... 
%                         mediumTableXZ(m    , ell + 1), mediumTableXZ(m + 1, ell + 1) ];
%                 flag = find(arr == 1, 1, 'first');
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
%                     case 5
%                         ;
%                     otherwise
%                         flag
%                         error('check');
%                 end
%             % else % x >= 0
%             %     arr = [ mediumTableXZ(m + 1, ell    ), mediumTableXZ(m + 1, ell + 1), mediumTableXZ(m, ell + 1), ...
%             %             mediumTableXZ(m - 1, ell + 1), mediumTableXZ(m - 1, ell    ), mediumTableXZ(m - 1, ell - 1), ... 
%             %             mediumTableXZ(m    , ell - 1), mediumTableXZ(m + 1, ell - 1) ];
%             %     flag = find(arr == 1, 1, 'first');
%             %     % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
%             %     switch flag
%             %         case 1
%             %             % right
%             %             p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%             %             p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%             %         case 2
%             %             % up-right
%             %             p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
%             %             p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
%             %         case 3
%             %             % up
%             %             p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
%             %             p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;

%             %         % dangerous act to disable the error message.
%             %         % otherwise
%             %         %     flag
%             %         %     error('check');
%             %     end
%             % end

%             if x ~= x_0 + h_x_half
%                 S_row_adj = zeros(1, 2);
%                 S_row_adj(1) = p_adjacent;
%                 S_row_adj(2) = 1;
%                 sparseS_1{ p_adjacent } = S_row_adj;
%                 Counter = Counter + 1;

%                 if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
%                     S_row_adj = zeros(1, 2);
%                     S_row_adj(1) = p_adj_back;
%                     S_row_adj(2) = 1;
%                     sparseS_1{ p_adj_back } = S_row_adj;
%                     Counter = Counter + 1;
%                 end
%             end
%         end
%     end
% end

% counter

% % % sweep over z_table
% % for z = - air_z / 2: dz: 0
% %     ell = int64(z / dz + air_z / (2 * dz) + 1);
% %     % right point
% %     m_1 = find(mediumTableXZ(:, ell) == 1, 1, 'last');
% %     x_1 = (m_1 - 1) * dx - air_x / 2;
% %     % left point
% %     m_2 = find(mediumTableXZ(:, ell) == 1, 1, 'first');
% %     x_2 = (m_2 - 1) * dx - air_x / 2;

% %     if x_2 >= x_0 - h_x_half - dx / 2 
% %         for y = y_0 - h_y_half: dy: y_0 + h_y_half
% %             n = int64(y / dy + h_torso / (2 * dy) + 1);
% %             m_vertex = 2 * m_2 - 1;
% %             n_vertex = 2 * n - 1;
% %             ell_vertex = 2 * ell - 1;
% %             p0      = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
% %             p0_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex;

% %             S_row = zeros(1, 2);
% %             S_row(1) = p0;
% %             S_row(2) = 1;
% %             sparseS_1{ p0 } = S_row;

% %             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
% %                 S_row = zeros(1, 2);
% %                 S_row(1) = p0_back;
% %                 S_row(2) = 1;
% %                 sparseS_1{ p0_back } = S_row;
% %             end

% %             arr = [ mediumTableXZ(m_2 + 1, ell    ), mediumTableXZ(m_2 + 1, ell - 1), mediumTableXZ(m_2, ell - 1), ...
% %                     mediumTableXZ(m_2 - 1, ell - 1), mediumTableXZ(m_2 - 1, ell    ), mediumTableXZ(m_2 - 1, ell + 1), ... 
% %                     mediumTableXZ(m_2    , ell + 1), mediumTableXZ(m_2 + 1, ell + 1) ];
% %             flag = find(arr == 1, 1, 'first');
% %             % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
% %             switch flag
% %                 case 1
% %                     % right
% %                     p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
% %                     p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
% %                 case 2
% %                     % up-right
% %                     p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
% %                     p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
% %                 case 3
% %                     % up
% %                     p_adjacent = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
% %                     p_adj_back = ( ell_vertex - 2 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
% %                 otherwise
% %                     flag
% %                     error('check');
% %             end

% %             S_row_adj = zeros(1, 2);
% %             S_row_adj(1) = p_adjacent;
% %             S_row_adj(2) = 1;
% %             sparseS_1{ p_adjacent } = S_row_adj;

% %             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
% %                 S_row_adj = zeros(1, 2);
% %                 S_row_adj(1) = p_adj_back;
% %                 S_row_adj(2) = 1;
% %                 sparseS_1{ p_adj_back } = S_row_adj;
% %             end
% %         end
% %     end

% %     if x_1 <= x_0 + h_x_half + dx / 2 
% %         for y = y_0 - h_y_half: dy: y_0 + h_y_half
% %             n = int64(y / dy + h_torso / (2 * dy) + 1);
% %             m_vertex = 2 * m_1 - 1;
% %             n_vertex = 2 * n - 1;
% %             ell_vertex = 2 * ell - 1;
% %             p0      = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex;
% %             p0_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex;

% %             S_row = zeros(1, 2);
% %             S_row(1) = p0;
% %             S_row(2) = 1;
% %             sparseS_1{ p0 } = S_row;

% %             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
% %                 S_row = zeros(1, 2);
% %                 S_row(1) = p0_back;
% %                 S_row(2) = 1;
% %                 sparseS_1{ p0_back } = S_row;
% %             end

% %             arr = [ mediumTableXZ(m_1 + 1, ell    ), mediumTableXZ(m_1 + 1, ell + 1), mediumTableXZ(m_1, ell + 1), ...
% %                     mediumTableXZ(m_1 - 1, ell + 1), mediumTableXZ(m_1 - 1, ell    ), mediumTableXZ(m_1 - 1, ell - 1), ... 
% %                     mediumTableXZ(m_1    , ell - 1), mediumTableXZ(m_1 + 1, ell - 1) ];
% %             flag = find(arr == 1, 1, 'first');
% %             % flag = 1 to 8, corresponding to the existence of the first '13' in arr[1] to arr[8].
% %             switch flag
% %                 case 1
% %                     % right
% %                     p_adjacent = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
% %                     p_adj_back = ( ell_vertex - 1 ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
% %                 case 2
% %                     % up-right
% %                     p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex + 1;
% %                     p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex + 1;
% %                 case 3
% %                     % up
% %                     p_adjacent = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex - 1 ) * x_max_vertex + m_vertex    ;
% %                     p_adj_back = ( ell_vertex     ) * x_max_vertex * y_max_vertex + ( n_vertex     ) * x_max_vertex + m_vertex    ;
% %                 otherwise
% %                     error('check');
% %             end

% %             if x_1 ~= x_0 + h_x_half
% %                 S_row_adj = zeros(1, 2);
% %                 S_row_adj(1) = p_adjacent;
% %                 S_row_adj(2) = 1;
% %                 sparseS_1{ p_adjacent } = S_row_adj;

% %             if n ~= int64((y_0 + h_y_half) / dy + h_torso / (2 * dy) + 1);
% %                     S_row_adj = zeros(1, 2);
% %                     S_row_adj(1) = p_adj_back;
% %                     S_row_adj(2) = 1;
% %                     sparseS_1{ p_adj_back } = S_row_adj;
% %                 end
% %             end
% %         end
% %     end
% % end

end
