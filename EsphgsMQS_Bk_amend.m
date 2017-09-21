% === % =================================== % === %
% === % Filling Time of K1, Kev, Kve and Bk % === %
% === % =================================== % === %
% Vrtx_bndry: v-location of current sheet and computational domain 
Vrtx_bndry = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 'uint8');
%  2: computational domain boundary
n_far  = y_idx_max - 1;
n_near = 2;
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    borderFlag = getBorderFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
    if my_F(borderFlag, 1)
        Vrtx_bndry(m_v, n_v, ell_v) = 2;
    end
end

% update the Vrtx_bndry for vertical current sheet.
SheetY_0 = 0;
% 1: sheetPoints boundary
m_v_0 = 2 * ( tumor_x_es / dx + air_x / (2 * dx) + 1 ) - 1;
n_v_0 = 2 * ( tumor_y_es / dx + h_torso / (2 * dy) + 1 ) - 1;
ell_v_0 = 2 * ( tumor_z_es / dx + air_z / (2 * dz) + 1 ) - 1;

half_size = 1;
Vrtx_bndry(m_v_0 - half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 + half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 + half_size, n_v_0 - half_size: n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size, ell_v_0     ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 + half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size, ell_v_0 - 1 ) = 7;
Vrtx_bndry(m_v_0 - half_size: m_v_0 + half_size, n_v_0 - half_size, ell_v_0     ) = 7;

Vrtx_bndry(m_v_0    , n_v_0 - 1, ell_v_0    ) = 3;
Vrtx_bndry(m_v_0    , n_v_0 - 1, ell_v_0 - 1) = 3;
Vrtx_bndry(m_v_0 + 1, n_v_0    , ell_v_0    ) = 4;
Vrtx_bndry(m_v_0 + 1, n_v_0    , ell_v_0 - 1) = 4;
Vrtx_bndry(m_v_0    , n_v_0 + 1, ell_v_0    ) = 5;
Vrtx_bndry(m_v_0    , n_v_0 + 1, ell_v_0 - 1) = 5;
Vrtx_bndry(m_v_0 - 1, n_v_0    , ell_v_0    ) = 6;
Vrtx_bndry(m_v_0 - 1, n_v_0    , ell_v_0 - 1) = 6;

% % oblique version
% Vrtx_bndry(m_v_0 - 2, n_v_0 - 1: n_v_0 + 1, ell_v_0    ) = 1;
% Vrtx_bndry(m_v_0 - 1, n_v_0 - 1: n_v_0 + 1, ell_v_0 - 1) = 1;
% Vrtx_bndry(m_v_0 + 1, n_v_0 - 1: n_v_0 + 1, ell_v_0 - 1) = 1;
% Vrtx_bndry(m_v_0 + 2, n_v_0 - 1: n_v_0 + 1, ell_v_0    ) = 1;
% Vrtx_bndry(m_v_0 - 1: m_v_0 + 1, n_v_0 + 2, ell_v_0    ) = 1;
% Vrtx_bndry(m_v_0 - 1: m_v_0 + 1, n_v_0 + 1, ell_v_0 - 1) = 1;
% Vrtx_bndry(m_v_0 - 1: m_v_0 + 1, n_v_0 - 1, ell_v_0 - 1) = 1;
% Vrtx_bndry(m_v_0 - 1: m_v_0 + 1, n_v_0 - 2, ell_v_0    ) = 1;
% Vrtx_bndry(m_v_0 + 2, n_v_0 + 2, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 + 2, n_v_0 - 2, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 - 2, n_v_0 - 2, ell_v_0) = 1;
% Vrtx_bndry(m_v_0 - 2, n_v_0 + 2, ell_v_0) = 1;


B_k = zeros(N_e, 1);
J_0 = 400; % surface current density: 5000 (A/m)
tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
parfor eIdx = 1: 1: l_G
    % eIdx = full( G(P2(lGidx), P1(lGidx)) );
    Candi = [];
    [ m_P1_v, n_P1_v, ell_P1_v ] = getMNL(P1(eIdx), x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_P2_v, n_P2_v, ell_P2_v ] = getMNL(P2(eIdx), x_max_vertex, y_max_vertex, z_max_vertex);
    if Vrtx_bndry(m_P1_v, n_P1_v, ell_P1_v) >= uint8(3) && Vrtx_bndry(m_P2_v, n_P2_v, ell_P2_v) >= uint8(3)
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
                    tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                    if length(tetRow) ~= 1
                        error('check te construction of MedTetTable');
                    end
                    MedFinder = MedTetTableCell{ tetRow };
                    MedVal = MedFinder(5);
                    % MedVal = MedTetTable( tetRow, v1234(1) );
                    % use tetRow to check the accordance of SigmaE and J_xyz
                    B_k_Pnt = fillBk_Esphgs_Vrtcl( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                        G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry, J_0, ...
                        B_k_Pnt, zeros(1, 3), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
                end
            end
        end
        B_k(eIdx) = B_k_Pnt;
    end
end
toc;