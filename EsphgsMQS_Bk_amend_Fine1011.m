% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %
% Vrtx_bndry: v-location of current sheet and computational domain 
Vrtx_bndry_B = zeros( x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, 'uint8');
%  2: computational domain boundary
n_far  = y_idx_max_B - 1;
n_near = 2;
for vIdx = 1: 1: x_max_vertex_B * y_max_vertex_B * z_max_vertex_B
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    if my_F(borderFlag, 1)
        Vrtx_bndry_B(m_v, n_v, ell_v) = 2;
    end
end

% update the Vrtx_bndry for vertical current sheet.
SheetY_0 = 0;
% 1: sheetPoints boundary
m_v_0_B = 2 * ( (es_x - es_x)/ dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1 ) - 1;
n_v_0_B = 2 * ( (0 - 0) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1 ) - 1;
ell_v_0_B = 2 * ( (es_z - es_z) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1 ) - 1;

% an ugly mask, for temporary usage
ell_v_0_B = ell_v_0_B - 1;

h_x = 2;
h_y = 8;

%     y
%     ^
%     |
% 7---5---7
% |       |
% 6       4 ----> x
% |       |
% 7---3---7
% schematic of boundary number around the coil

Vrtx_bndry_B(m_v_0_B - h_x, n_v_0_B - h_y: n_v_0_B + h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 7; % pre-6
Vrtx_bndry_B(m_v_0_B + h_x, n_v_0_B - h_y: n_v_0_B + h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 7; % pre-4

Vrtx_bndry_B(m_v_0_B - h_x: m_v_0_B + h_x, n_v_0_B + h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 7; % pre-5
Vrtx_bndry_B(m_v_0_B - h_x: m_v_0_B + h_x, n_v_0_B - h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 7; % pre-3

Vrtx_bndry_B(m_v_0_B - h_x + 1: m_v_0_B + h_x - 1, n_v_0_B - h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 3;
Vrtx_bndry_B(m_v_0_B + h_x, n_v_0_B - h_y + 1: n_v_0_B + h_y - 1, ell_v_0_B - 1: ell_v_0_B + 1) = 4; 
Vrtx_bndry_B(m_v_0_B - h_x + 1: m_v_0_B + h_x - 1, n_v_0_B + h_y, ell_v_0_B - 1: ell_v_0_B + 1) = 5;
Vrtx_bndry_B(m_v_0_B - h_x, n_v_0_B - h_y + 1: n_v_0_B + h_y - 1, ell_v_0_B - 1: ell_v_0_B + 1) = 6;

B_k = zeros(N_e_B, 1);
% J_0 = 1000; % surface current density: 5000 (A/m)
tic; 
disp('The filling time of B_k: ');
parfor eIdx = 1: 1: N_e_B
    % eIdx = full( G(P2(lGidx), P1(lGidx)) );
    Candi = [];
    [ m_P1_v, n_P1_v, ell_P1_v ] = getMNL(P1(eIdx), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    [ m_P2_v, n_P2_v, ell_P2_v ] = getMNL(P2(eIdx), x_max_vertex_B, y_max_vertex_B, z_max_vertex_B);
    if Vrtx_bndry_B(m_P1_v, n_P1_v, ell_P1_v) >= uint8(3) && Vrtx_bndry_B(m_P2_v, n_P2_v, ell_P2_v) >= uint8(3)
        % get candidate points
        P1_cand = uG(:, P1(eIdx));
        P2_cand = uG(:, P2(eIdx));
        P1_nz = find(P1_cand);
        P2_nz = find(P2_cand);
        for CandiFinder = 1: 1: length(P1_nz)
            if find(P2_nz == P1_nz(CandiFinder))
                Candi = horzcat(Candi, P1_nz(CandiFinder));
            end
        end

        B_k_Pnt = 0;
        for TetFinder = 1: 1: length(Candi) - 1
            for itr = TetFinder + 1: length(Candi)
                if uG( Candi(TetFinder), Candi(itr) )
                    % linked to become a tetrahedron
                    v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
                    tetRow = find( sum( logical(MedTetTable_B(:, v1234)), 2 ) == 4 );
                    if length(tetRow) ~= 1
                        error('check te construction of MedTetTable_B');
                    end
                    MedFinder = MedTetTableCell_B{ tetRow };
                    MedVal = MedFinder(5);
                    % MedVal = MedTetTable( tetRow, v1234(1) );
                    % use tetRow to check the accordance of SigmaE and J_xyz
                    B_k_Pnt = fillBk_Esphgs_Vrtcl( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                        G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry_B, J_0, ...
                        B_k_Pnt, zeros(1, 3), MedVal, epsilon_r, mu_r, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt_B );
                end
            end
        end
        B_k(eIdx) = B_k_Pnt;
    end
end
toc;