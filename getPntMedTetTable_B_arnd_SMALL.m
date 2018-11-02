function [ PntMedTetTableCell, InvalidTetIdcs ] = getPntMedTetTable_B_arnd_SMALL( PntSegMed_t, Med27Value, ...
                        p0, p0_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                        x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B )

    loadParas_Eso0924;
    loadParas;
    FaceFlag = false;
    p_face = zeros(25, 1);
    NrmlRange = [ 48 * (p0 - 1) + 1: 48 * p0 ];
    % PntSegMed_t is in the order of 8, 8, 8, 8, 8 and 8 for p1, p2, p3, p4, p5 and p6, respectively.
    PntsIdx  = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    % to-do
    % a switch to pipeline the facets, line, and corner cases -- as error checker

    % === === % ================ % === === %
    % === === % the facets cases % === === %
    % === === % ================ % === === %
    if Med27Value(3, 5) % up
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v, n_v, ell_v + 1, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32 + 16, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p1');
        tmpMaskMed = repmat(PntSegMed_t(:, 1), 1, 4)';
        MaskMed = tmpMaskMed(:);

        PntsIdx2Layers = p1FaceMed( PntsIdx );
                            % p6 -> p1 -> p5 -> p3 (counter-clock-wise) ?
        SegOrder16 = [ PntSegMed_t(27), PntSegMed_t(26), PntSegMed_t(35), PntSegMed_t(34), ...
                        PntSegMed_t(11), PntSegMed_t(10), PntSegMed_t(43), PntSegMed_t(42) ];
                                %  p1,   p2,     p3,     p5,     p6 ?
        InvalidTetIdcs = NrmlRange([1: 8, 10, 11, 26, 27, 34, 35, 42, 43]);
    elseif Med27Value(2, 4) % left
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v - 1, n_v, ell_v, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32 + 16, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p2');
        tmpMaskMed = repmat(PntSegMed_t(:, 2), 1, 4)';
        MaskMed = tmpMaskMed(:);

        PntsIdx2Layers = p2FaceMed( PntsIdx );
                            % p6 -> p1 -> p5 -> p3 (counter-clock-wise)
        SegOrder16 = [ PntSegMed_t(45), PntSegMed_t(44), PntSegMed_t(5), PntSegMed_t(4), ...
                        PntSegMed_t(33), PntSegMed_t(40), PntSegMed_t(17), PntSegMed_t(24) ];
                                %  p1,   p2,     p3,     p5,     p6
        InvalidTetIdcs = NrmlRange([4, 5, 9: 16, 17, 24, 33, 40, 44, 45]);
    elseif Med27Value(1, 5) % down
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v, n_v, ell_v - 1, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32 + 16, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p3');
        tmpMaskMed = repmat(PntSegMed_t(:, 3), 1, 4)';
        MaskMed = tmpMaskMed(:);

        PntsIdx2Layers = p3FaceMed( PntsIdx );
                            % p6 -> p1 -> p5 -> p3 (counter-clock-wise) ?
        SegOrder16 = [ PntSegMed_t(15), PntSegMed_t(14), PntSegMed_t(39), PntSegMed_t(38), ...
                        PntSegMed_t(31), PntSegMed_t(30), PntSegMed_t(47), PntSegMed_t(46) ];
                                %  p1,   p2,     p3,     p5,     p6 ?
        InvalidTetIdcs = NrmlRange([14, 15, 17: 24, 30, 31, 38, 39, 46, 47]);
    elseif Med27Value(2, 6) % p4 
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v + 1, n_v, ell_v, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p4');
        tmpMaskMed = repmat(PntSegMed_t(:, 4), 1, 4)';
        MaskMed = tmpMaskMed(:);
        PntsIdx2Layers = p4FaceMed( PntsIdx );
        SegOrder16 = [ PntSegMed_t(37), PntSegMed_t(36), PntSegMed_t(1), PntSegMed_t(8), ...
                        PntSegMed_t(41), PntSegMed_t(48), PntSegMed_t(30), PntSegMed_t(31) ];
                                %     p1,     p2,     p3,     p5,     p6
        InvalidTetIdcs = NrmlRange([1, 8, 20, 21, 25: 32, 36, 37, 41, 48]);
    elseif Med27Value(2, 8) % Far
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v, n_v + 1, ell_v, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32 + 16, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p5');
        tmpMaskMed = repmat(PntSegMed_t(:, 5), 1, 4)';
        MaskMed = tmpMaskMed(:);

        PntsIdx2Layers = p3FaceMed( PntsIdx );
                            % p6 -> p1 -> p5 -> p3 (counter-clock-wise) ?
        SegOrder16 = [ PntSegMed_t(13), PntSegMed_t(12), PntSegMed_t(3), PntSegMed_t(2), ...
                        PntSegMed_t(25), PntSegMed_t(32), PntSegMed_t(19), PntSegMed_t(18) ];
                                %  p1,   p2,     p3,     p5,     p6 ?
        InvalidTetIdcs = NrmlRange([13, 12, 3, 2, 25, 32, 33: 40, 19, 18]);
    elseif Med27Value(2, 2) % Near
        FaceFlag = true;
        [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v, n_v - 1, ell_v, w_x_B, w_y_B, w_z_B);
        PntMedTetTableCell = cell(32 + 16, 1);
        p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'p6');
        tmpMaskMed = repmat(PntSegMed_t(:, 6), 1, 4)';
        MaskMed = tmpMaskMed(:);

        PntsIdx2Layers = p3FaceMed( PntsIdx );
                            % p6 -> p1 -> p5 -> p3 (counter-clock-wise) ?
        SegOrder16 = [ PntSegMed_t(29), PntSegMed_t(28), PntSegMed_t(7), PntSegMed_t(6), ...
                        PntSegMed_t(9), PntSegMed_t(16), PntSegMed_t(23), PntSegMed_t(22) ];
                                %  p1,   p2,     p3,     p5,     p6 ?
        InvalidTetIdcs = NrmlRange([29, 28, 7, 6, 9, 16, 23, 22, 41: 48]);
    end

    if FaceFlag
        nzCols = zeros(32 + 16, 4);
        face6Pnts = zeros(1, 6); 

        face6Pnts = [ p_face(13), p_face(14), p_face(15), p_face(19), p_face(20), p_face(25) ];
        nzCols(1: 4, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(18), p_face(23), p_face(19), p_face(24), p_face(25) ];
        nzCols(5: 8, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(18), p_face(23), p_face(17), p_face(22), p_face(21) ];
        nzCols(9: 12, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(12), p_face(11), p_face(17), p_face(16), p_face(21) ];
        nzCols(13: 16, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(12), p_face(11), p_face(7), p_face(6), p_face(1) ];
        nzCols(17: 20, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(8), p_face(3), p_face(7), p_face(2), p_face(1) ];
        nzCols(21: 24, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(8), p_face(3), p_face(9), p_face(4), p_face(5) ];
        nzCols(25: 28, :) = get16Idx(face6Pnts, p0_v);
        face6Pnts = [ p_face(13), p_face(14), p_face(15), p_face(9), p_face(10), p_face(5) ];
        nzCols(29: 32, :) = get16Idx(face6Pnts, p0_v);

        nzCols(33: 36, :) = get16Idx_Side( PntsIdx2Layers(2, 5), PntsIdx2Layers(2, 6), ...
                                    p_face(5), p_face(10), p_face(15), p_face(20), p_face(25) );
        nzCols(37: 40, :) = get16Idx_Side( PntsIdx2Layers(2, 5), PntsIdx2Layers(2, 8), ...
                                    p_face(25), p_face(24), p_face(23), p_face(22), p_face(21) );
        nzCols(41: 44, :) = get16Idx_Side( PntsIdx2Layers(2, 5), PntsIdx2Layers(2, 4), ...
                                    p_face(21), p_face(16), p_face(11), p_face(6), p_face(1) );
        nzCols(45: 48, :) = get16Idx_Side( PntsIdx2Layers(2, 5), PntsIdx2Layers(2, 2), ...
                                    p_face(1), p_face(2), p_face(3), p_face(4), p_face(5) );
        for idx = 1: 1: 32
            PntMedTetTableCell{idx} = [ nzCols(idx, :), double(repmat(PntSegMed_t(idx), 1, 4)) ];
        end
        for idx = 33: 1: 48
            PntMedTetTableCell{idx} = [ nzCols(idx, :), double( repmat( SegOrder16(myCeil((idx - 32) / 2, 1)), 1, 4 ) ) ];
        end
        return;
    end

    % % === === % =============== % === === %
    % % === === % the lines cases % === === %
    % % === === % =============== % === === %
    % % to-do 
    % % implement the following line cases
    % LineFlag = false;
    % XYplane = find(squeeze(Med27Value(2, :)));
    % XZplane = find([Med27Value(1, 4), Med27Value(1, 5), Med27Value(1, 6), ...
    %                 Med27Value(2, 4), Med27Value(2, 5), Med27Value(2, 6), ...
    %                 Med27Value(3, 4), Med27Value(3, 5), Med27Value(3, 6)]);
    % YZplane = find([Med27Value(1, 2), Med27Value(1, 5), Med27Value(1, 8), ...
    %                 Med27Value(2, 2), Med27Value(2, 5), Med27Value(2, 8), ...
    %                 Med27Value(3, 2), Med27Value(3, 5), Med27Value(3, 8)]);
    % if length(find(XYplane)) == 1 
    %     PntMedTetTableCell = cell(8, 1);
    %     nzCols = zeros(8, 4);
    %     LinePnts = zeros(5, 1);
    %     PntsIdx  = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    %     if XYplane == 1 % only the first place is found 
    %         LineFlag  = true;
    %         [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v - 1, n_v - 1, ell_v, w_x_B, w_y_B, w_z_B);
    %         LinePnts = get5LinePnt(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'z');
    %         % to-do
    %         % implement getLine16Idx.m
    %         nzCols = getLine16Idx(LinePnts, PntsIdx(2, 2), PntsIdx(2, 5), PntsIdx(2, 4));
    %         Med16 = [ PntSegMed_t(44), PntSegMed_t(9), PntSegMed_t(16), PntSegMed_t(45) ];
    %     elseif XYplane == 3 
    %         LineFlag  = true;
    %     elseif XYplane == 7 
    %         LineFlag  = true;
    %         [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv_SMALL(m_v - 1, n_v + 1, ell_v, w_x_B, w_y_B, w_z_B);
    %         LinePnts = get5LinePnt(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, 'z');
    %         nzCols = getLine16Idx(LinePnts, PntsIdx(2, 4), PntsIdx(2, 5), PntsIdx(2, 8));
    %         Med16 = [ PntSegMed_t(12), PntSegMed_t(33), PntSegMed_t(40), PntSegMed_t(13) ];
    %     elseif XYplane == 9 
    %     end

    %     for idx = 1: 1: 8
    %         PntMedTetTableCell{idx} = [ nzCols(idx, :), double(repmat(Med16(myCeil(idx / 2, 1)), 1, 4)) ];
    %     end
    % end

    % if length(find(XZplane)) == 1 
    %     if XZplane == 1 % only the first place is found
    %     elseif XZplane == 3 
    %     elseif XZplane == 7 
    %     elseif XZplane == 9 
    %     end
    % end
    % if length(find(YZplane)) == 1 
    %     if YZplane == 1 % only the first place is found
    %     elseif YZplane == 3 
    %     elseif YZplane == 7 
    %     elseif YZplane == 9 
    %     end
    % end

    % if LineFlag
    %     ;
    % end

    % === === % ================ % === === %
    % === === % the corner cases % === === %
    % === === % ================ % === === %
    PntMedTetTableCell = cell(0, 1);
    InvalidTetIdcs = [];
    return;
end