% === % =============== % === %
% === % Amending for K1 % === %
% === % =============== % === %
load('0922EsoMQS_preK.mat');
m_K1 = cell(N_e, 1);
edgeChecker = false(l_G, 1);
J_0 = 400; % surface current density: 50 (A/m) at 8 MHz

TumorRelatedEIdx = false(N_e, 1);
tic; 
disp('Getting tumor related eIdx');
parfor eIdx = 1: 1: N_e
    % eIdx = full( G(P2(lGidx), P1(lGidx)) );
    Candi = [];
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
    % get adjacent tetrahdron
    K1_6 = zeros(1, N_e); 
    % K2_6 = zeros(1, N_e); 
    % Kev_4 = zeros(1, N_e); 
    % Kve_4 = zeros(N_e, 1); 
    B_k_Pnt = 0;
    cFlag = false;
    for TetFinder = 1: 1: length(Candi) - 1
        for itr = TetFinder + 1: length(Candi)
            if uG( Candi(TetFinder), Candi(itr) )
                % linked to become a tetrahedron
                v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
                tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                if length(tetRow) ~= 1
                    error('check te construction of MedTetTable');
                end
                MedVal = MedTetTable( tetRow, v1234(1) );
                if MedVal == 5 || MedVal == 9
                    TumorRelatedEIdx(eIdx) = true;
                end
            end
        end
    end
end
toc;

tic; 
disp('The amending part of K_1 for mu prm prm');
parfor eIdx = 1: 1: N_e
    if TumorRelatedEIdx(eIdx)
        % eIdx = full( G(P2(lGidx), P1(lGidx)) );
        Candi = [];
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
        % get adjacent tetrahdron
        K1_6 = zeros(1, N_e); 
        % K2_6 = zeros(1, N_e); 
        % Kev_4 = zeros(1, N_e); 
        % Kve_4 = zeros(N_e, 1); 
        B_k_Pnt = 0;
        cFlag = false;
        for TetFinder = 1: 1: length(Candi) - 1
            for itr = TetFinder + 1: length(Candi)
                if uG( Candi(TetFinder), Candi(itr) )
                    % linked to become a tetrahedron
                    v1234 = [ P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder) ];
                    tetRow = find( sum( logical(MedTetTable(:, v1234)), 2 ) == 4 );
                    if length(tetRow) ~= 1
                        error('check te construction of MedTetTable');
                    end
                    MedVal = MedTetTable( tetRow, v1234(1) );
                    % use tetRow to check the accordance of SigmaE and J_xyz
                    K1_6 = fillK1_FW_currentsheet( P1(eIdx), P2(eIdx), Candi(itr), Candi(TetFinder), ...
                        G( :, P1(eIdx) ), G( :, P2(eIdx) ), G( :, Candi(itr) ), G( :, Candi(TetFinder) ), Vrtx_bndry, J_0, ...
                        K1_6, B_k_Pnt, zeros(1, 3), MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
                end
            end
        end

        if isempty(K1_6) 
        % if isempty(K1_6) || isempty(K2_6) || isempty(Kev_4)
            disp('K1, K2 or KEV: empty');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
        end
        if isnan(K1_6) 
        % if isnan(K1_6) | isinf(K1_6) | isnan(K2_6) | isinf(K2_6)
            disp('K1 or K2: NaN or Inf');
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
        end
        % if isnan(Kev_4) | isinf(Kev_4)
        %     disp('Kev: NaN or Inf');
        %     [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
        %     [ m_v, n_v, ell_v, edgeNum ]
        % end
        if edgeChecker(eIdx) == true
            lGidx
            [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            [ m_v, n_v, ell_v, edgeNum ]
            error('check')
        end

        edgeChecker(eIdx) = true;
        
        m_K1{eIdx} = Mrow2myRow(K1_6);
        % m_K2{eIdx}  = Mrow2myRow(K2_6);
        % m_KEV{eIdx} = Mrow2myRow(Kev_4);
        % m_KVE{eIdx} = Mrow2myRow(Kve_4')';
        % B_k(eIdx) = B_k_Pnt;
    end
end
toc;

save('0922EsoMQS_K1_Amend.mat', 'm_K1');