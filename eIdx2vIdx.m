function [ vIdx, edgeNum, m, n, ell ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex)

    % implement only for volume
    vIdx = ceil(eIdx / 7);
    edgeNum = (eIdx + 7) - 7 * vIdx;

    [ m_prm, n_prm, ell_prm ] = getMNL(vIdx, x_max_vertex - 1, y_max_vertex - 1, z_max_vertex - 1);
    m   = m_prm + 1;
    n   = n_prm + 1;
    ell = ell_prm + 1;

    % x_max_vertex_prm = x_max_vertex - 1;
    % y_max_vertex_prm = y_max_vertex - 1;
    % z_max_vertex_prm = z_max_vertex - 1;

    % volumeIdx = x_max_vertex_prm * y_max_vertex_prm * z_max_vertex_prm;
    % face1Idx  = x_max_vertex_prm * z_max_vertex_prm;
    % face2Idx  = y_max_vertex_prm * z_max_vertex_prm;
    % face3Idx  = x_max_vertex_prm * y_max_vertex_prm;
    % line1Idx  = x_max_vertex_prm;
    % line2Idx  = z_max_vertex_prm;
    % line3Idx  = y_max_vertex_prm;

    % idxLevel  = [ volumeIdx, face1Idx, face2Idx, face3Idx, line1Idx, line2Idx, line3Idx ];
    % W_ratio   = [          7,       3,        3,        3,        1,        1,        1 ];
    % idxCumSum = cumsum(idxLevel);
    % weightCumSum = cumsum(idxLevel .* W_ratio);

    % if vIdx <= idxCumSum(1)
    %     eIdx = 7 * ( vIdx - 1 ) + edgeNum;
    % elseif vIdx <= idxCumSum(2)
    %     switch edgeNum
    %         case 1
    %             eIdx = weightCumSum(1) + 3 * (vIdx - idxCumSum(1) - 1) + 1;
    %         case 3
    %             eIdx = weightCumSum(1) + 3 * (vIdx - idxCumSum(1) - 1) + 2;
    %         case 6
    %             eIdx = weightCumSum(1) + 3 * (vIdx - idxCumSum(1) - 1) + 3;
    %         otherwise
    %             error('check');
    %     end
    % elseif vIdx <= idxCumSum(3)
    %     switch edgeNum
    %         case 2
    %             eIdx = weightCumSum(2) + 3 * (vIdx - idxCumSum(2) - 1) + 1;
    %         case 3
    %             eIdx = weightCumSum(2) + 3 * (vIdx - idxCumSum(2) - 1) + 2;
    %         case 5
    %             eIdx = weightCumSum(2) + 3 * (vIdx - idxCumSum(2) - 1) + 3;
    %         otherwise
    %             error('check');
    %     end
    % elseif vIdx <= idxCumSum(4)
    %     switch edgeNum
    %         case 1
    %             eIdx = weightCumSum(3) + 3 * (vIdx - idxCumSum(3) - 1) + 1;
    %         case 2
    %             eIdx = weightCumSum(3) + 3 * (vIdx - idxCumSum(3) - 1) + 2;
    %         case 4
    %             eIdx = weightCumSum(3) + 3 * (vIdx - idxCumSum(3) - 1) + 3;
    %         otherwise
    %             error('check');
    %     end
    % elseif vIdx <= idxCumSum(5)
    %     if edgeNum == 1
    %         eIdx = weightCumSum(4) + vIdx - idxCumSum(4);
    %     else
    %         error('check');
    %     end
    % elseif vIdx <= idxCumSum(6)
    %     if edgeNum == 3
    %         eIdx = weightCumSum(5) + vIdx - idxCumSum(5);
    %     else
    %         error('check');
    %     end
    % elseif vIdx <= idxCumSum(7)
    %     if edgeNum == 2
    %         eIdx = weightCumSum(6) + vIdx - idxCumSum(6);
    %     else
    %         error('check');
    %     end
    % else
    %     error('check');
    % end
end