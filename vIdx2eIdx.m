function eIdx = vIdx2eIdx(vIdx_prm, edgeNum, x_max_vertex, y_max_vertex, z_max_vertex)

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

% becare for the Middle_eIdx maniplation 
    Middle_eIdx = 7 * ( x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm / 2 + x_max_vertex_prm * y_max_vertex_prm / 2 + x_max_vertex_prm / 2 ) + 1;

    idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
    W_ratio   = [          7,       3,        3,        3,        1,        1,        1 ];
    idxCumSum = cumsum(idxLevel);
    weightCumSum = cumsum(idxLevel .* W_ratio);

    if vIdx_prm <= idxCumSum(1)
        eIdx = 7 * ( vIdx_prm - 1 ) + edgeNum;
    elseif vIdx_prm <= idxCumSum(2)
        switch edgeNum
            case 1
                eIdx = weightCumSum(1) + 3 * (vIdx_prm - idxCumSum(1) - 1) + 1;
            case 3
                eIdx = weightCumSum(1) + 3 * (vIdx_prm - idxCumSum(1) - 1) + 2;
            case 6
                eIdx = weightCumSum(1) + 3 * (vIdx_prm - idxCumSum(1) - 1) + 3;
            otherwise
                eIdx = Middle_eIdx;
                % error('check');
        end
    elseif vIdx_prm <= idxCumSum(3)
        switch edgeNum
            case 2
                eIdx = weightCumSum(2) + 3 * (vIdx_prm - idxCumSum(2) - 1) + 1;
            case 3
                eIdx = weightCumSum(2) + 3 * (vIdx_prm - idxCumSum(2) - 1) + 2;
            case 5
                eIdx = weightCumSum(2) + 3 * (vIdx_prm - idxCumSum(2) - 1) + 3;
            otherwise
                eIdx = Middle_eIdx;
                % error('check');
        end
    elseif vIdx_prm <= idxCumSum(4)
        switch edgeNum
            case 1
                eIdx = weightCumSum(3) + 3 * (vIdx_prm - idxCumSum(3) - 1) + 1;
            case 2
                eIdx = weightCumSum(3) + 3 * (vIdx_prm - idxCumSum(3) - 1) + 2;
            case 4
                eIdx = weightCumSum(3) + 3 * (vIdx_prm - idxCumSum(3) - 1) + 3;
            otherwise
                eIdx = Middle_eIdx;
                % error('check');
        end
    elseif vIdx_prm <= idxCumSum(5)
        if edgeNum == 1
            eIdx = weightCumSum(4) + vIdx_prm - idxCumSum(4);
        else
            eIdx = Middle_eIdx;
            % error('check');
        end
    elseif vIdx_prm <= idxCumSum(6)
        if edgeNum == 3
            eIdx = weightCumSum(5) + vIdx_prm - idxCumSum(5);
        else
            eIdx = Middle_eIdx;
            % error('check');
        end
    elseif vIdx_prm <= idxCumSum(7)
        if edgeNum == 2
            eIdx = weightCumSum(6) + vIdx_prm - idxCumSum(6);
        else
            eIdx = Middle_eIdx;
            % error('check');
        end
    else
        eIdx = Middle_eIdx;
        % error('check');
    end
end