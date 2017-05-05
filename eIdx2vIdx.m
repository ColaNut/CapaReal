function [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex)

    x_max_vertex_prm = x_max_vertex - 1;
    y_max_vertex_prm = y_max_vertex - 1;
    z_max_vertex_prm = z_max_vertex - 1;

    volumeIdx = x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm;
    face1Idx  = x_max_vertex_prm * z_max_vertex_prm;
    face2Idx  = y_max_vertex_prm * z_max_vertex_prm;
    face3Idx  = x_max_vertex_prm * y_max_vertex_prm;
    line1Idx  = x_max_vertex_prm;
    line2Idx  = z_max_vertex_prm;
    line3Idx  = y_max_vertex_prm;

    Middle_eIdx = 7 * ( x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm / 2 + x_max_vertex_prm * y_max_vertex_prm / 2 + x_max_vertex_prm / 2 ) + 1;

    idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
    W_ratio   = [          7,       3,        3,        3,        1,        1,        1 ];
    idxCumSum = cumsum(idxLevel);
    weightCumSum = cumsum(idxLevel .* W_ratio);

    if eIdx <= weightCumSum(1)
        % volume
        vIdx_prm = ceil(eIdx / 7);
        edgeNum = (eIdx + 7) - 7 * vIdx_prm;

        [ m_v_prm, n_v_prm, ell_v_prm ] = getMNL(vIdx_prm, x_max_vertex - 1, y_max_vertex - 1, z_max_vertex - 1);
        m_v   = m_v_prm + 1;
        n_v   = n_v_prm + 1;
        ell_v = ell_v_prm + 1;

    elseif eIdx <= weightCumSum(2)
        % face 1
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(1) ) / 3 );
        edgeIdx = eIdx - weightCumSum(1) - (tmpIdx_prm - 1) * 3;

        switch edgeIdx
            case 1
                edgeNum = 1;
            case 2
                edgeNum = 3;
            case 3
                edgeNum = 6;
            otherwise
                error('check');
        end

        [ m_v_prm, ell_v_prm ] = getML( tmpIdx_prm, x_max_vertex );
        m_v   = m_v_prm + 1;
        n_v   = 1;
        ell_v = ell_v_prm + 1;
    elseif eIdx <= weightCumSum(3)
        % face 2
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(2) ) / 3 );
        edgeIdx = eIdx - weightCumSum(2) - (tmpIdx_prm - 1) * 3;

        switch edgeIdx
            case 1
                edgeNum = 2;
            case 2
                edgeNum = 3;
            case 3
                edgeNum = 5;
            otherwise
                error('check');
        end

        [ n_v_prm, ell_v_prm ] = getML( tmpIdx_prm, y_max_vertex );
        m_v   = 1;
        n_v   = n_v_prm + 1;
        ell_v = ell_v_prm + 1;
    elseif eIdx <= weightCumSum(4)
         % face 3
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(3) ) / 3 );
        edgeIdx = eIdx - weightCumSum(3) - (tmpIdx_prm - 1) * 3;

        switch edgeIdx
            case 1
                edgeNum = 1;
            case 2
                edgeNum = 2;
            case 3
                edgeNum = 4;
            otherwise
                error('check');
        end

        [ m_v_prm, n_v_prm ] = getML( tmpIdx_prm, x_max_vertex );
        m_v   = m_v_prm + 1;
        n_v   = n_v_prm + 1;
        ell_v = 1;
    elseif eIdx <= weightCumSum(5)
        edgeNum = 1;
        m_v_prm = eIdx - weightCumSum(4);

        m_v   = m_v_prm + 1;
        n_v   = 1;
        ell_v = 1;
    elseif eIdx <= weightCumSum(6)
        edgeNum = 3;
        ell_v_prm = eIdx - weightCumSum(5);

        m_v   = 1;
        n_v   = 11;
        ell_v = ell_v_prm + 1;
    elseif eIdx <= weightCumSum(7)
        edgeNum = 2;
        n_v_prm = eIdx - weightCumSum(5);

        m_v   = 1;
        n_v   = n_v_prm + 1;
        ell_v = 1;
    else
        error('check');
    end
end