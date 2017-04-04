function M = getSAI(A, Tol)
    % initialization of M
    Id_Matrix = diag( repmat( 1, 1, size(A, 1) ) );
    M = Id_Matrix; % n-by-n matrix
    n = size(A, 2);

    % J = cell(1, ColNum);
    % I = cell(1, ColNum);
    J = [];

    ns = 5; % number of improvement steps allowed per column

    for column = 1: 1: n
        ek = Id_Matrix(:, column);
        mk = M(:, column);
        J = find( mk );
        I = [];
        for step = 1: 1: ns
            trim_A = A(:, J);
            for idx = 1: 1: n
                if ~isempty( find( trim_A(idx, :) ) )
                    I = vertcat( I, idx );
                end
            end
            hat_A  = trim_A(I, :);
            hat_ek = ek(I);
            % solve for hat_mk and calculate residual
            [ Q, R ] = qr(hat_A);
            hat_mk = R \ ( Q' * hat_ek );
            resid = trim_A * hat_mk - ek;

            if step == ns
                new_mk = zeros(size(mk));
                for idx = 1: 1: length(J)
                    new_mk( J(idx) ) = hat_mk(idx);
                end
                M(:, column) = new_mk;
            end

            if norm(resid) <= Tol
                new_mk = zeros(size(mk));
                for idx = 1: 1: length(J)
                    new_mk( J(idx) ) = hat_mk(idx);
                end
                M(:, column) = new_mk;
                break
            else
                Ell = find(resid);
                counter = 1;

                % union to get tilde J
                tilde_J = [];
                Ell_length = length(Ell);
                while counter <= Ell_length
                    tmp_tilde_J = find( A( Ell(counter), : ) );
                    if ~isempty( tmp_tilde_J )
                        tilde_J = vertcat( tilde_J, tmp_tilde_J' );
                    end
                    counter = counter + 1;
                end
                % delete repeated index
                tilde_J = unique(tilde_J, 'rows');

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
                    rhoSQ(idx) = norm(resid)^2 - ( resid' * A(:, tilde_J(idx)) )^2 / norm( A(:, tilde_J(idx)) )^2;
                end
                [ tmpMin, minI ] = min(rhoSQ);
                J = vertcat( J, tilde_J(minI) );
            end
        end
    end
end