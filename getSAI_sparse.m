function [ M, column_res ] = getSAI_sparse(A, dim, Tol, ns)

    zeroVec = zeros(dim, 1);
    column_res = zeros(1, dim);
    % initialization of M
    % Id_Matrix = diag( repmat( 1, 1, size(A, 1) ) );
    % M = Id_Matrix; % dim-by-dim matrix
    M = cell(1, dim);

    % J = cell(1, ColNum);
    % I = cell(1, ColNum);
    J = [];

    % ns = 27; % number of improvement steps allowed per column

    for column = 1: 1: dim
        % ek = Id_Matrix(:, column);
        ek = zeroVec;
        ek(column) = 1; % 'column' happen to be k
        mk = zeros( size(ek) );
        mk = ek;
        J = find( mk );
        I = [];
        for step = 1: 1: ns
            trim_A = zeros(dim, length(J));
            % the J must be in the order from small to large
            trim_A = getA_Jcol(A, dim, J);
            for idx = 1: 1: dim
                if ~isempty( find( trim_A(idx, :) ) )
                    I = vertcat( I, idx );
                end
            end
            I = sort(I);
            hat_A  = trim_A(I, :);
            hat_ek = ek(I);
            % solve for hat_mk and calculate residual
            [ Q, R ] = qr(hat_A);
            R = R(1: length(J), :);
            Q = Q(:, 1: length(J));
            hat_mk = R \ ( Q' * hat_ek );
            resid = trim_A * hat_mk - ek;

            if step == ns || norm(resid) <= Tol
                sparse_mk = zeros(2 * length(J), 1);
                sparse_mk(1: length(J)) = J;
                sparse_mk(length(J)+ 1: end) = hat_mk;
                M{ column } = sparse_mk;
                column_res(column) = norm(resid);
                break
            else
                Ell = find( resid );
                counter = 1;
                % union to get tilde J
                tilde_J = [];
                Ell_length = length(Ell);
                while counter <= Ell_length
                    tmp = A{ Ell(counter) };
                    A_row = tmp';
                    tmp_tilde_J = A_row( find( A_row( length(A_row) / 2 + 1: end ) ) );
                    % try
                    if ~isempty( tmp_tilde_J )
                        tilde_J = vertcat( tilde_J, tmp_tilde_J' );
                    end
                    % catch
                    %     tilde_J
                    %     tmp_tilde_J
                    % end
                    counter = counter + 1;
                end
                % delete repeated index
                tilde_J = unique(tilde_J);

                % delete J from tilde_J
                J_length = length(J);
                for idx = 1: 1: J_length
                    RepeatedIdx = find( tilde_J == J(idx) );
                    if ~isempty(RepeatedIdx)
                        tilde_J( RepeatedIdx ) = [];
                    end
                end

                % calculate rhoSQ = rho^2
                rhoSQ = zeros( size(tilde_J) );
                tilde_J_length = length(tilde_J);
                for idx = 1: 1: tilde_J_length
                    rhoSQ(idx) = norm(resid)^2 - ( resid' * getA_Jcol(A, dim, tilde_J(idx)) )^2 / norm( getA_Jcol(A, dim, tilde_J(idx)) )^2;
                end
                tmpMin = 0;
                minI = [];
                [ tmpMin, minI ] = min(rhoSQ);
                J = sort( vertcat( J, tilde_J(minI) ) );
            end
        end
    end
end