tic; 
disp('The filling time of K_1, K_EV, K_VE and B: ');
for lGidx = 1: 1: l_G
    eIdx = full( G(P1(lGidx), P2(lGidx)) );
    if eIdx == 8555
        Candi = [];
        % get candidate points
        P1_cand = uG(P1(lGidx), :);
        P2_cand = uG(P2(lGidx), :);
        P1_nz = find(P1_cand);
        P2_nz = find(P2_cand);
        for CandiFinder = 1: 1: length(P1_nz)
            if find(P2_nz == P1_nz(CandiFinder))
                Candi = horzcat(Candi, P1_nz(CandiFinder));
            end
        end
        % get adjacent tetrahdron
        K1_6 = sparse(1, N_e); 
        Kev_4 = sparse(1, N_v);
        Kve_4 = sparse(N_v, 1);
        B_k_Pnt = 0;
        for TetFinder = 1: 1: length(Candi) - 1
            for itr = TetFinder + 1: length(Candi)
                if uG( Candi(TetFinder), Candi(itr) )
                    % linked to become a tetrahedron
                    v1234 = [ P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder) ];
                    tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                    if length(tetRow) ~= 1
                        error('check te construction of MedTetTable');
                    end
                    MedVal = MedTetTable( tetRow, v1234(1) );
                    [ K1_6, Kev_4, Kve_4, B_k_Pnt ] = fillK( P1(lGidx), P2(lGidx), Candi(itr), Candi(TetFinder), ...
                        G( P1(lGidx), : ), G( P2(lGidx), : ), G( Candi(itr), : ), G( Candi(TetFinder), : ), ...
                        SheetPntsTable( P1(lGidx) ), SheetPntsTable( P2(lGidx) ), SheetPntsTable( Candi(itr) ), SheetPntsTable( Candi(TetFinder) ), ...
                        lGidx, K1_6, Kev_4, Kve_4, B_k_Pnt, J_0, MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
                end
            end
        end
        if isempty(K1_6)
            disp('K1: empty');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            break
        end
        if isnan(K1_6) | isinf(K1_6)
            disp('K1: NaN or Inf');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            break
        end
        if isempty(Kev_4)
            disp('Kev: empty');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            break
        end
        if isnan(Kev_4) | isinf(Kev_4)
            disp('Kev: NaN or Inf');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            break
        end
        if edgeChecker(eIdx) == true
            lGidx
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            error('check')
        end

        edgeChecker(eIdx) = true;
        M_K1(eIdx, :)  = M_K1(eIdx, :)  + K1_6;
        M_KEV(eIdx, :) = M_KEV(eIdx, :) + Kev_4;
        M_KVE(:, eIdx) = M_KVE(:, eIdx) + Kve_4;
        B_k(eIdx) = B_k(eIdx) + B_k_Pnt;
    end
end
toc;

% Shift2d;
% load('0608Coil.mat', 'bar_x_my_gmres');
% AFigsScript;

% % tol = 1e-6;
% % ext_itr_num = 10;
% % int_itr_num = 50;

% % bar_x_my_gmres = zeros(size(B_k));
% % % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% % % tic; 
% % % disp('Computational time for solving Ax = b: ')
% % % bar_x_my_gmres = nrmlM_K\B_k;
% % % toc;
% % tic;
% % disp('The gmres solutin of Ax = B: ');
% % bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num );
% % toc;

% % % save('Case0528_preBC_Case4.mat', 'bar_x_my_gmres', 'B_k');

% % AFigsScript;