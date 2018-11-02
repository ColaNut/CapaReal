% BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
Current = complex(0, 0);

disp('Estimate the current out of the plate')
tic;
for idx = x_idx_max * y_idx_max * z_idx_max / 2: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    if BndryTable(m_v, n_v, ell_v) == TpElctrdPos
        vIdx = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
        CandiTet = find( MedTetTable(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            TetRow = MedTetTableCell{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            MedVal = TetRow(5);
            % implement the getCurrentArnd.m
            Current = Current + getCurrentArnd( v1234, BndryTable, TpElctrdPos, bar_x_my_gmresPhi, sigma, MedVal, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
        end
    end
end
toc;

Current

W = V_0 * conj(Current) / 2

% save( strcat(fname, '\', CaseName, 'currentEst.mat'), 'Current', 'W' );