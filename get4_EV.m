function Edge6Value = get4_EV( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, epsilon_r )

Edge6Value = zeros(1, 6);
tmp_curl_W = zeros(6, 3);

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

tmp_curl_W(1, :) = - (P4_Crdt - P3_Crdt);
tmp_curl_W(2, :) =   (P4_Crdt - P2_Crdt);
tmp_curl_W(3, :) = - (P3_Crdt - P2_Crdt);
tmp_curl_W(4, :) = - (P4_Crdt - P1_Crdt);
tmp_curl_W(5, :) =   (P3_Crdt - P1_Crdt);
tmp_curl_W(6, :) = - (P2_Crdt - P1_Crdt);

% Edge6Value(1) = dot( tmp_curl_W(1, :), tmp_curl_W(1, :) ) / ( epsilon_r * 9 * TtrVol );
% Edge6Value(2) = dot( tmp_curl_W(1, :), tmp_curl_W(2, :) ) / ( epsilon_r * 9 * TtrVol );
% Edge6Value(3) = dot( tmp_curl_W(1, :), tmp_curl_W(3, :) ) / ( epsilon_r * 9 * TtrVol );
% Edge6Value(4) = dot( tmp_curl_W(1, :), tmp_curl_W(4, :) ) / ( epsilon_r * 9 * TtrVol );
% Edge6Value(5) = dot( tmp_curl_W(1, :), tmp_curl_W(5, :) ) / ( epsilon_r * 9 * TtrVol );
% Edge6Value(6) = dot( tmp_curl_W(1, :), tmp_curl_W(6, :) ) / ( epsilon_r * 9 * TtrVol );

A = repmat( tmp_curl_W(1, :), 6, 1 );
tmp = dot(A, tmp_curl_W, 2);
Edge6Value = tmp' / ( 9 * epsilon_r * TtrVol );

end
