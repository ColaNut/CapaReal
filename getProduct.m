function MidMat2 = getProduct( sparseKEV, sparseG_VV_inv, n_mid )

    % KEV     : M by n_mid 
    % G_VV_inv: n_mid by N

    M = length(sparseKEV);
    N = length(sparseG_VV_inv);
    MidMat2 = cell(M, 1);

    parfor m = 1: 1: M
        disp('unit time');
        tic;
        K_EV_row = sparse2NrmlVec( sparseKEV{ m }', n_mid )';
        row_2 = zeros(1, n_mid);
        for n = 1: 1: N
            row_2(n) = K_EV_row * sparse2NrmlVec( sparseG_VV_inv{ n }, n_mid );
        end
        MidMat2{ m } = Nrml2Sparse( row_2 );
        toc;
    end
end
