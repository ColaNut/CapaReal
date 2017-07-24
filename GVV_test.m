switch TEX
    case 'Regular'
        N_v = N_v_r;
    case 'Right'
        M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );
    otherwise
        error('check');
end

sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
n_s = 27;
% for Tol = 0.1: 0.1: 0.2
    sparseGVV_inv = cell(1, N_v);
    disp('The calculation time of SAI: ');
    tic;
    [ sparseGVV_inv, column_res ] = getSAI_sparse(sparseGVV, N_v, Tol, n_s);
    toc;
    M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
    % tic;
    % cond2 = cond(full(M_sparseGVV * M_sparseGVV_inv_spai), 2);
    % disp( strcat( 'For Tol = ', num2str(Tol), ', the 2-condition number is ', num2str(cond2) ) );
    % disp('The calculation time of 2-condition number of AM: ');
    % toc;
    tic;
    f_norm = norm(M_sparseGVV * M_sparseGVV_inv_spai - sparseId, 'fro');
    disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );
    disp('The calculation time of Frobenius norm of AM - I: ');
    toc;
    % save( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai', 'column_res', 'cond2', 'f_norm' );
% end
