function OneSideH_XZ = getSideH_XZ( CntrlCrdnt, SideCrdnt, IdxSet, A, mu, SideSegMed )
    OneSideH_XZ = zeros(1, 8, 3);

    % 1-st tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(18), IdxSet(17), IdxSet(3), IdxSet(1), IdxSet(2) ];
    OneSideH_XZ(1, 1, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(1) ) );

    % 2-nd tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(19), IdxSet(18), IdxSet(5), IdxSet(3), IdxSet(4) ];
    OneSideH_XZ(1, 2, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(8, :), SideCrdnt(9, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(2) ) );

    % 3-rd tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(20), IdxSet(19), IdxSet(7), IdxSet(5), IdxSet(6) ];
    OneSideH_XZ(1, 3, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(8, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(3) ) );

    % 4-th tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(21), IdxSet(20), IdxSet(9), IdxSet(7), IdxSet(8) ];
    OneSideH_XZ(1, 4, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(7, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(4) ) );

    % 5-th tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(22), IdxSet(21), IdxSet(11), IdxSet(9), IdxSet(10) ];
    OneSideH_XZ(1, 5, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(1, :), SideCrdnt(4, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(5) ) );

    % 6-th tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(23), IdxSet(22), IdxSet(13), IdxSet(11), IdxSet(12) ];
    OneSideH_XZ(1, 6, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(6) ) );

    % 7-th tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(24), IdxSet(23), IdxSet(15), IdxSet(13), IdxSet(14) ];
    OneSideH_XZ(1, 7, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(7) ) );

    % 8-th tetdrahedron  
    tmp_eIdxSet = [ IdxSet(25), IdxSet(17), IdxSet(24), IdxSet(1), IdxSet(15), IdxSet(16) ];
    OneSideH_XZ(1, 8, :) = calH( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
        A( tmp_eIdxSet ), mu( SideSegMed(8) ) );

end