function OneSideH_XZ = getSideH_XZ( CntrlCrdnt, SideCrdnt, IdxSet, A, mu, SideSegMed, SideText )
    OneSideH_XZ = zeros(1, 8, 3);

switch SideText
    case 'p1'
        % type4-3
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(2), IdxSet(3), IdxSet(18), IdxSet(1), IdxSet(17), IdxSet(25) ];
        OneSideH_XZ(1, 1, :) = calH( SideCrdnt(9, :), SideCrdnt(6, :), SideCrdnt(5, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(4), IdxSet(3), IdxSet(18), IdxSet(5), IdxSet(19), IdxSet(25) ];
        OneSideH_XZ(1, 2, :) = calH( SideCrdnt(9, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(5), IdxSet(19), IdxSet(6), IdxSet(25), IdxSet(7), IdxSet(20) ];
        OneSideH_XZ(1, 3, :) = calH( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(7, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(7), IdxSet(9), IdxSet(20), IdxSet(21), IdxSet(8) ];
        OneSideH_XZ(1, 4, :) = calH( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(9), IdxSet(11), IdxSet(21), IdxSet(22), IdxSet(10) ];
        OneSideH_XZ(1, 5, :) = calH( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(13), IdxSet(11), IdxSet(23), IdxSet(22), IdxSet(12) ];
        OneSideH_XZ(1, 6, :) = calH( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(15), IdxSet(24), IdxSet(14), IdxSet(25), IdxSet(13), IdxSet(23) ];
        OneSideH_XZ(1, 7, :) = calH( SideCrdnt(3, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(16), IdxSet(1), IdxSet(17), IdxSet(15), IdxSet(24), IdxSet(25) ];
        OneSideH_XZ(1, 8, :) = calH( SideCrdnt(6, :), SideCrdnt(3, :), SideCrdnt(5, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
    case 'p2'
        % type4-3
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(18), IdxSet(17), IdxSet(3), IdxSet(1), IdxSet(2) ];
        OneSideH_XZ(1, 1, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(19), IdxSet(25), IdxSet(18), IdxSet(5), IdxSet(4), IdxSet(3) ];
        OneSideH_XZ(1, 2, :) = calH( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(9, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(20), IdxSet(19), IdxSet(25), IdxSet(6), IdxSet(7), IdxSet(5) ];
        OneSideH_XZ(1, 3, :) = calH( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron
        tmp_eIdxSet = [ IdxSet(20), IdxSet(21), IdxSet(25), IdxSet(8), IdxSet(7), IdxSet(9) ];
        OneSideH_XZ(1, 4, :) = calH( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(21), IdxSet(22), IdxSet(25), IdxSet(10), IdxSet(9), IdxSet(11) ];
        OneSideH_XZ(1, 5, :) = calH( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(22), IdxSet(25), IdxSet(23), IdxSet(11), IdxSet(12), IdxSet(13) ];
        OneSideH_XZ(1, 6, :) = calH( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(23), IdxSet(24), IdxSet(13), IdxSet(15), IdxSet(14) ];
        OneSideH_XZ(1, 7, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(17), IdxSet(24), IdxSet(1), IdxSet(15), IdxSet(16) ];
        OneSideH_XZ(1, 8, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
    case 'p3'
        % type1-3
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(18), IdxSet(17), IdxSet(3), IdxSet(1), IdxSet(2) ];
        OneSideH_XZ(1, 1, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(19), IdxSet(5), IdxSet(4), IdxSet(25), IdxSet(18), IdxSet(3) ];
        OneSideH_XZ(1, 2, :) = calH( SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(6), IdxSet(20), IdxSet(7), IdxSet(19), IdxSet(5), IdxSet(25) ];
        OneSideH_XZ(1, 3, :) = calH( SideCrdnt(7, :), SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron
        tmp_eIdxSet = [ IdxSet(8), IdxSet(20), IdxSet(7), IdxSet(21), IdxSet(9), IdxSet(25) ];
        OneSideH_XZ(1, 4, :) = calH( SideCrdnt(7, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(5, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(10), IdxSet(21), IdxSet(9), IdxSet(22), IdxSet(11), IdxSet(25) ];
        OneSideH_XZ(1, 5, :) = calH( SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(22), IdxSet(11), IdxSet(12), IdxSet(25), IdxSet(23), IdxSet(13) ];
        OneSideH_XZ(1, 6, :) = calH( SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(23), IdxSet(24), IdxSet(13), IdxSet(15), IdxSet(14) ];
        OneSideH_XZ(1, 7, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(17), IdxSet(24), IdxSet(1), IdxSet(15), IdxSet(16) ];
        OneSideH_XZ(1, 8, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
    case 'p4'
        % type2-1
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(2), IdxSet(3), IdxSet(18), IdxSet(1), IdxSet(17), IdxSet(25) ];
        OneSideH_XZ(1, 1, :) = calH( SideCrdnt(9, :), SideCrdnt(6, :), SideCrdnt(5, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(4), IdxSet(3), IdxSet(18), IdxSet(5), IdxSet(19), IdxSet(25) ];
        OneSideH_XZ(1, 2, :) = calH( SideCrdnt(9, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(5), IdxSet(6), IdxSet(19), IdxSet(7), IdxSet(25), IdxSet(20) ];
        OneSideH_XZ(1, 3, :) = calH( SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(7, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron
        tmp_eIdxSet = [ IdxSet(7), IdxSet(9), IdxSet(25), IdxSet(8), IdxSet(20), IdxSet(21) ];
        OneSideH_XZ(1, 4, :) = calH( SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(4, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(9), IdxSet(11), IdxSet(25), IdxSet(10), IdxSet(21), IdxSet(22) ];
        OneSideH_XZ(1, 5, :) = calH( SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(13), IdxSet(11), IdxSet(25), IdxSet(12), IdxSet(23), IdxSet(22) ];
        OneSideH_XZ(1, 6, :) = calH( SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(15), IdxSet(14), IdxSet(24), IdxSet(13), IdxSet(25), IdxSet(23) ];
        OneSideH_XZ(1, 7, :) = calH( SideCrdnt(3, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(16), IdxSet(1), IdxSet(17), IdxSet(15), IdxSet(24), IdxSet(25) ];
        OneSideH_XZ(1, 8, :) = calH( SideCrdnt(6, :), SideCrdnt(3, :), SideCrdnt(5, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
    case 'p5'
        % type3-2
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(3), IdxSet(1), IdxSet(18), IdxSet(17), IdxSet(2) ];
        OneSideH_XZ(1, 1, :) = calH( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), SideCrdnt(6, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(5), IdxSet(19), IdxSet(4), IdxSet(25), IdxSet(3), IdxSet(18) ];
        OneSideH_XZ(1, 2, :) = calH( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(6), IdxSet(7), IdxSet(20), IdxSet(5), IdxSet(19), IdxSet(25) ];
        OneSideH_XZ(1, 3, :) = calH( SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron
        tmp_eIdxSet = [ IdxSet(8), IdxSet(7), IdxSet(20), IdxSet(9), IdxSet(21), IdxSet(25) ];
        OneSideH_XZ(1, 4, :) = calH( SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(10), IdxSet(9), IdxSet(21), IdxSet(11), IdxSet(22), IdxSet(25) ];
        OneSideH_XZ(1, 5, :) = calH( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), CntrlCrdnt', 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(11), IdxSet(12), IdxSet(22), IdxSet(13), IdxSet(25), IdxSet(23) ];
        OneSideH_XZ(1, 6, :) = calH( SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(13), IdxSet(25), IdxSet(15), IdxSet(23), IdxSet(14), IdxSet(24) ];
        OneSideH_XZ(1, 7, :) = calH( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(1), IdxSet(15), IdxSet(17), IdxSet(24), IdxSet(16) ];
        OneSideH_XZ(1, 8, :) = calH( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
    case 'p6'
        % type1-2
        % 1-st tetdrahedron  
        tmp_eIdxSet = [ IdxSet(2), IdxSet(18), IdxSet(3), IdxSet(17), IdxSet(1), IdxSet(25) ];
        OneSideH_XZ(1, 1, :) = calH( SideCrdnt(9, :), SideCrdnt(6, :), CntrlCrdnt', SideCrdnt(5, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

        % 2-nd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(18), IdxSet(4), IdxSet(3), IdxSet(19), IdxSet(25), IdxSet(5) ];
        OneSideH_XZ(1, 2, :) = calH( SideCrdnt(9, :), CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

        % 3-rd tetdrahedron  
        tmp_eIdxSet = [ IdxSet(19), IdxSet(25), IdxSet(20), IdxSet(5), IdxSet(6), IdxSet(7) ];
        OneSideH_XZ(1, 3, :) = calH( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(7, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

        % 4-th tetdrahedron
        tmp_eIdxSet = [ IdxSet(25), IdxSet(20), IdxSet(21), IdxSet(7), IdxSet(9), IdxSet(8) ];
        OneSideH_XZ(1, 4, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(4, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

        % 5-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(21), IdxSet(22), IdxSet(9), IdxSet(11), IdxSet(10) ];
        OneSideH_XZ(1, 5, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(1, :), 'ext', ...
            A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

        % 6-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(25), IdxSet(23), IdxSet(22), IdxSet(13), IdxSet(11), IdxSet(12) ];
        OneSideH_XZ(1, 6, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

        % 7-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(24), IdxSet(15), IdxSet(14), IdxSet(25), IdxSet(23), IdxSet(13) ];
        OneSideH_XZ(1, 7, :) = calH( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

        % 8-th tetdrahedron  
        tmp_eIdxSet = [ IdxSet(16), IdxSet(17), IdxSet(1), IdxSet(24), IdxSet(15), IdxSet(25) ];
        OneSideH_XZ(1, 8, :) = calH( SideCrdnt(6, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), 'inn', ...
            A( tmp_eIdxSet ), mu( SideSegMed(8) ) );
end

end