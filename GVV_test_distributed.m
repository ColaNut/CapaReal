% === % =================== % === %
% === % Calculation of SPAI % === %
% === % =================== % === %

load('0808LungConformal_preGVVinv.mat', 'sparseGVV', 'N_v');
PartNum = 1;

switch PartNum
    case 1
        Rng = [ 1, ceil(N_v / 8) ];
    case 2
        Rng = [ ceil(N_v / 8) + 1, ceil(N_v / 4) ];
    case 3
        Rng = [ ceil(N_v / 4) + 1, ceil(3 * N_v / 8) ];
    case 4
        Rng = [ ceil(3 * N_v / 8) + 1, ceil(1 * N_v / 2) ];
    case 5
        Rng = [ ceil(1 * N_v / 2) + 1, ceil(5 * N_v / 8) ];
    case 6
        Rng = [ ceil(5 * N_v / 8) + 1, ceil(3 * N_v / 4) ];
    case 7
        Rng = [ ceil(3 * N_v / 4) + 1, ceil(7 * N_v / 8) ];
    case 8
        Rng = [ ceil(7 * N_v / 8) + 1, N_v ];
    otherwise
        error('check');
end

Tol = 0.6;
% GVV_test; % a script
% load( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai');

M_sparseGVV = mySparse2MatlabSparse( sparseGVV, N_v, N_v, 'Col' );

sparseId = sparse([1: 1: N_v], [1: 1: N_v], ones(1, N_v), N_v, N_v);
n_s = 27;
% for Tol = 0.1: 0.1: 0.2
% \blue{Start from here}
    sparseGVV_inv_octant = cell(1, N_v);
    disp(strcat('The calculation time of SAI, part ', num2str(PartNum), ' :'));
    tic;
    [ sparseGVV_inv_octant, column_res_oct ] = getSAI_sparse(sparseGVV, N_v, Tol, n_s, Rng(1), Rng(2));
    toc;

    save( strcat( 'GVV_inv_conformal_O', num2str(PartNum), '.mat' ), 'sparseGVV_inv_octant', 'column_res_oct');
    % M_sparseGVV_inv_spai = mySparse2MatlabSparse( sparseGVV_inv, N_v, N_v, 'Col' );
    % tic;
    % cond2 = cond(full(M_sparseGVV * M_sparseGVV_inv_spai), 2);
    % disp( strcat( 'For Tol = ', num2str(Tol), ', the 2-condition number is ', num2str(cond2) ) );
    % disp('The calculation time of 2-condition number of AM: ');
    % toc;
    % tic;
    % f_norm = norm(M_sparseGVV * M_sparseGVV_inv_spai - sparseId, 'fro');
    % disp( strcat( 'and the Frobenius norm is ', num2str(f_norm) ) );
    % disp('The calculation time of Frobenius norm of AM - I: ');
    % toc;
    % save( strcat('SAI_Tol', num2str(Tol), '_', TEX, '_', CaseTEX, '.mat'), 'M_sparseGVV_inv_spai', 'column_res', 'cond2', 'f_norm' );
% end
