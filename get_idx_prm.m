function idx_prm = get_idx_prm( m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex )

    m_prm = m - 1;
    n_prm = n - 1;
    ell_prm = ell - 1;

    x_max_vertex_prm = x_max_vertex - 1;
    y_max_vertex_prm = y_max_vertex - 1;
    z_max_vertex_prm = z_max_vertex - 1;

    if m >= 2 && m <= x_max_vertex && n >= 2 && n <= y_max_vertex && ell >= 2 && ell <= z_max_vertex 
        % volume
        idx_prm = int64( ( ell_prm - 1 ) * x_max_vertex_prm * y_max_vertex_prm + ( n_prm - 1 ) * x_max_vertex_prm + m_prm );
    else
        % three faces, three border lines and a point
        volumeIdx = x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm;
        face1Idx  = x_max_vertex_prm * z_max_vertex_prm;
        face2Idx  = y_max_vertex_prm * z_max_vertex_prm;
        face3Idx  = x_max_vertex_prm * y_max_vertex_prm;
        line1Idx  = x_max_vertex_prm;
        line2Idx  = z_max_vertex_prm;
        line3Idx  = y_max_vertex_prm;

        idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
        idxCumSum = cumsum(idxLevel);
        
        % may have access of point with exceeded idx, i.e. m == x_max_vertex + 1 will pass.
        if m >= 2 && n == 1 && ell >= 2
            % face1
            idx_prm = idxCumSum(1) + ( ell_prm - 1 ) * x_max_vertex_prm + m_prm;
        elseif m == 1 && n >= 2 && ell >= 2
            % face2
            idx_prm = idxCumSum(2) + ( ell_prm - 1 ) * y_max_vertex_prm + n_prm;
        elseif m >= 2 && n >= 2 && ell == 1
            % face3
            idx_prm = idxCumSum(3) + ( n_prm - 1 ) * x_max_vertex_prm + m_prm;
        elseif m >= 2 && n == 1 && ell == 1
            % line1
            idx_prm = idxCumSum(4) + m_prm;
        elseif m == 1 && n == 1 && ell >= 2
            % line2
            idx_prm = idxCumSum(5) + ell_prm;
        elseif m == 1 && n >= 2 && ell == 1
            % line3
            idx_prm = idxCumSum(6) + n_prm;
        elseif m == 1 && n == 1 && ell == 1
            % point
            idx_prm = idxCumSum(7) + 1;
        else
            idx_prm = 0;
            % [m, n, ell]
            % error('check');
        end
    end

end