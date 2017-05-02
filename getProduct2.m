function MidMat2 = getProduct2( sparseKEV, sparseG_VV_inv, n_mid )

    % KEV     : M by n_mid 
    % G_VV_inv: n_mid by N
    M = length(sparseKEV);
    N = length(sparseG_VV_inv);
    MidMat2 = cell(M, 1);

    parfor m = 1: 1: M
        % K_EV_row = sparse2NrmlVec( sparseKEV{ m }', n_mid )';
        % row_2 = zeros(1, n_mid);
        % disp('unit time');
        % tic;
        row_2 = [];
        K_EV_row = sparseKEV{ m };
        for n = 1: 1: N
            tmpSum = 0;
            G_VV_inv_col = sparseG_VV_inv{ n };
            KEV_idx = K_EV_row(1: length(K_EV_row) / 2);
            G_VV_inv_idx = G_VV_inv_col(1: length(G_VV_inv_col) / 2);

            ell = length( G_VV_inv_idx );
            for idx = 1: 1: ell
                Match = find(KEV_idx == G_VV_inv_idx(idx), 1);
                if Match
                    tmpSum = tmpSum + K_EV_row(length(K_EV_row) / 2 + Match) * G_VV_inv_col(length(G_VV_inv_col) / 2 + idx);
                end
            end
            if tmpSum
                row_2 = insertIdx( row_2, n, tmpSum );
            end
        end
        MidMat2{ m } = row_2;
        % toc;
    end
end
