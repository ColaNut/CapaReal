function [ EdgeTable ] = fillSheetIdx(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                        tpflag, TiltType, lastFlag, EdgeTable, CandiSet1, CandiSet2)

    AuxiIdx = zeros(6, 1);

    vIdxPrm     = zeros( 3, 9 );
    vIdxPrm = get27vIdxPrm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    vIdx_prm0 = vIdxPrm(2, 5);
    vIdx_prm1 = vIdxPrm(3, 5);
    vIdx_prm2 = vIdxPrm(2, 4);
    vIdx_prm3 = vIdxPrm(1, 5);
    vIdx_prm4 = vIdxPrm(2, 6);
    vIdx_prm5 = vIdxPrm(2, 8);
    vIdx_prm6 = vIdxPrm(2, 2);

% lastFlag
    switch tpflag
        case 'type1-II'
            switch TiltType
                case 'Vertical'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type2-II'
            switch TiltType
                case 'Vertical'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type3-II'
            switch TiltType
                case 'Vertical'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type4-II'
            switch TiltType
                case 'Vertical'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental'
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type1-I'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type2-I'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type3-I'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm1, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type4-I'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type1-IV'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(3, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type2-IV'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type3-IV'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type4-IV'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm1, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type1-III'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type2-III'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        case 'type3-III'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm4, 6, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 7, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdxPrm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
            end
        case 'type4-III'
            switch TiltType
                case 'Vertical' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 3, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm0, 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm6, 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Horizental' % ok
                    [ AuxiIdx(1), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdx_prm0, 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(2), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1, vIdxPrm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(3), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet1);
                    [ AuxiIdx(4), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    [ AuxiIdx(5), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2, vIdx_prm4, 1, x_max_vertex, y_max_vertex, z_max_vertex, lastFlag);
                    [ AuxiIdx(6), EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet2);
                case 'Oblique'
                    error('Description');
            end
        otherwise
            error('check');
    end
end
