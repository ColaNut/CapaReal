function sparseK_row = getRow( K_1_row, K_EV_row, G_VV_inv, K_VE, N_v, N_e )
    % sparseK_row = [];
    sparseK_row = [];

    K1_length = length(K_1_row);
    KEV_length = length(K_EV_row);

    
    row_1 = sparse2NrmlVec( K_EV_row, N_v )';

    row_2 = zeros(1, N_v);
    row_3 = zeros(1, N_e);

    for idx = 1: 1: N_e
        % tic;
        % disp('One unit product time');
        for idx_2 = 1: 1: N_v
            row_2(idx_2) = row_1 * sparse2NrmlVec( G_VV_inv{idx_2}, N_v );
        end
        try
        row_3(idx) = row_2 * sparse2NrmlVec( K_VE{idx}, N_v );
        catch
            idx
            idx_2
        end
        % toc;
    end

    NrmlRow_K1 = sparse2NrmlVec( K_1_row, N_e )';
    sparseK_row = Nrml2Sparse(NrmlRow_K1 - row_3);
end