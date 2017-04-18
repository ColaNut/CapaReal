function OneSideH_XZ = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, sixEdge_A_Value, mu )
    OneSideH_XZ = zeros(3, 1);

    % sixEdge_A_Value = zeros(1, 6);
    tmp_curl_W = zeros(6, 3);

    TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

    tmp_curl_W(1, :) = - (P4_Crdt - P3_Crdt);
    tmp_curl_W(2, :) =   (P4_Crdt - P2_Crdt);
    tmp_curl_W(3, :) = - (P3_Crdt - P2_Crdt);
    tmp_curl_W(4, :) = - (P4_Crdt - P1_Crdt);
    tmp_curl_W(5, :) =   (P3_Crdt - P1_Crdt);
    tmp_curl_W(6, :) = - (P2_Crdt - P1_Crdt);

    OneSideH_XZ = ( tmp_curl_W' * sixEdge_A_Value ) / ( 3 * TtrVol * mu );
end