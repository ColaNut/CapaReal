function eIdx = vIdxprm2eIdx_Reg(idx_prm, edgeNum, x_idx_max, y_idx_max, z_idx_max)

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

    % becare for the Middle_eIdx maniplation 
    Middle_eIdx = 28 * ( x_idx_max_prm * y_idx_max_prm * z_idx_max_prm / 2 + x_idx_max_prm * y_idx_max_prm / 2 + x_idx_max_prm / 2 ) + 1;

    idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
    W_ratio   = [         28,       6,        6,        6,        1,        1,        1 ];
    idxCumSum = cumsum(idxLevel);
    weightCumSum = cumsum(idxLevel .* W_ratio);

    if idx_prm <= idxCumSum(1)
        eIdx = 28 * ( idx_prm - 1 ) + edgeNum;
    elseif idx_prm <= idxCumSum(2)
        switch edgeNum
            case 1
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 1;
            case 3
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 2;
            case 12
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 3;
            case 13
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 4;
            case 14
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 5;
            case 15
                eIdx = weightCumSum(1) + 6 * (idx_prm - idxCumSum(1) - 1) + 6;
            otherwise
                eIdx = Middle_eIdx;
                error('check');
        end
    elseif idx_prm <= idxCumSum(3)
        switch edgeNum
            case 2
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 1;
            case 3
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 2;
            case 8
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 3;
            case 9
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 4;
            case 10
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 5;
            case 11
                eIdx = weightCumSum(2) + 6 * (idx_prm - idxCumSum(2) - 1) + 6;
            otherwise
                eIdx = Middle_eIdx;
                error('check');
        end
    elseif idx_prm <= idxCumSum(4)
        switch edgeNum
            case 1
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 1;
            case 2
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 2;
            case 4
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 3;
            case 5
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 4;
            case 6
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 5;
            case 7
                eIdx = weightCumSum(3) + 6 * (idx_prm - idxCumSum(3) - 1) + 6;
            otherwise
                eIdx = Middle_eIdx;
                error('check');
        end
    elseif idx_prm <= idxCumSum(5)
        if edgeNum == 1
            eIdx = weightCumSum(4) + idx_prm - idxCumSum(4);
        else
            eIdx = Middle_eIdx;
            error('check');
        end
    elseif idx_prm <= idxCumSum(6)
        if edgeNum == 3
            eIdx = weightCumSum(5) + idx_prm - idxCumSum(5);
        else
            eIdx = Middle_eIdx;
            error('check');
        end
    elseif idx_prm <= idxCumSum(7)
        if edgeNum == 2
            eIdx = weightCumSum(6) + idx_prm - idxCumSum(6);
        else
            eIdx = Middle_eIdx;
            error('check');
        end
    else
        eIdx = Middle_eIdx;
        error('check');
    end
end