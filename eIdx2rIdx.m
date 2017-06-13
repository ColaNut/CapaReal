function [ m, n, ell, edgeNum ] = eIdx2rIdx(eIdx, x_idx_max, y_idx_max, z_idx_max)
% [m, n, ell] start from [2, 2, 2]

    x_idx_max_prm = x_idx_max - 1;
    y_idx_max_prm = y_idx_max - 1;
    z_idx_max_prm = z_idx_max - 1;

    volumeIdx = x_idx_max_prm * y_idx_max_prm * z_idx_max_prm;
    face1Idx  = x_idx_max_prm * z_idx_max_prm;
    face2Idx  = y_idx_max_prm * z_idx_max_prm;
    face3Idx  = x_idx_max_prm * y_idx_max_prm;
    line1Idx  = x_idx_max_prm;
    line2Idx  = z_idx_max_prm;
    line3Idx  = y_idx_max_prm;

    % becareful for the Middle_eIdx maniplation 
    Middle_eIdx = 28 * ( x_idx_max_prm * y_idx_max_prm * z_idx_max_prm / 2 + x_idx_max_prm * y_idx_max_prm / 2 + x_idx_max_prm / 2 ) + 1;

    idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
    W_ratio   = [         28,       6,        6,        6,        1,        1,        1 ];
    idxCumSum = cumsum(idxLevel);
    weightCumSum = cumsum(idxLevel .* W_ratio);

    if eIdx <= weightCumSum(1)
        % volume
        vIdx_prm = ceil(eIdx / 28);
        edgeNum = (eIdx + 28) - 28 * vIdx_prm;
        [ m_prm, n_prm, ell_prm ] = getMNL(vIdx_prm, x_idx_max_prm, y_idx_max_prm, z_idx_max_prm);
        m   = m_prm + 1;
        n   = n_prm + 1;
        ell = ell_prm + 1;
    elseif eIdx <= weightCumSum(2)
        % face 1
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(1) ) / 6 );
        edgeIdx = eIdx - weightCumSum(1) - (tmpIdx_prm - 1) * 6;
        switch edgeIdx
            case 1
                edgeNum = 1;
            case 2
                edgeNum = 3;
            case 3
                edgeNum = 12;
            case 4
                edgeNum = 13;
            case 5
                edgeNum = 14;
            case 6
                edgeNum = 15;
            otherwise
                error('check');
        end
        [ m_prm, ell_prm ] = getML( tmpIdx_prm, x_idx_max_prm );
        m   = m_prm + 1;
        n   = 1;
        ell = ell_prm + 1;
    elseif eIdx <= weightCumSum(3)
        % face 2
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(2) ) / 6 );
        edgeIdx = eIdx - weightCumSum(2) - (tmpIdx_prm - 1) * 6;
        switch edgeIdx
            case 1
                edgeNum = 2;
            case 2
                edgeNum = 3;
            case 3
                edgeNum = 8;
            case 4
                edgeNum = 9;
            case 5
                edgeNum = 10;
            case 6
                edgeNum = 11;
            otherwise
                error('check');
        end
        [ n_prm, ell_prm ] = getML( tmpIdx_prm, y_idx_max_prm );
        m   = 1;
        n   = n_prm + 1;
        ell = ell_prm + 1;
    elseif eIdx <= weightCumSum(4)
         % face 3
        tmpIdx_prm = ceil( ( eIdx - weightCumSum(3) ) / 6 );
        edgeIdx = eIdx - weightCumSum(3) - (tmpIdx_prm - 1) * 6;
        switch edgeIdx
            case 1
                edgeNum = 1;
            case 2
                edgeNum = 2;
            case 3
                edgeNum = 4;
            case 4
                edgeNum = 5;
            case 5
                edgeNum = 6;
            case 6
                edgeNum = 7;
            otherwise
                error('check');
        end
        [ m_prm, n_prm ] = getML( tmpIdx_prm, x_idx_max_prm );
        m   = m_prm + 1;
        n   = n_prm + 1;
        ell = 1;
    elseif eIdx <= weightCumSum(5)
        edgeNum = 1;
        m_prm = eIdx - weightCumSum(4);
        m   = m_prm + 1;
        n   = 1;
        ell = 1;
    elseif eIdx <= weightCumSum(6)
        edgeNum = 3;
        ell_prm = eIdx - weightCumSum(5);
        m   = 1;
        n   = 11;
        ell = ell_prm + 1;
    elseif eIdx <= weightCumSum(7)
        edgeNum = 2;
        n_prm = eIdx - weightCumSum(5);
        m   = 1;
        n   = n_prm + 1;
        ell = 1;
    else
        error('check');
    end
end