function Edge6Value = get6E( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, mainEdge, InnExtText, muValue, epsilonValue )

Edge6Value = zeros(1, 6);
tmp_curl_W = zeros(6, 3);
nabla      = zeros(4, 3);

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

switch InnExtText
    case 'inn'
        tmp_curl_W(1, :) = - (P4_Crdt - P3_Crdt);
        tmp_curl_W(2, :) =   (P4_Crdt - P2_Crdt);
        tmp_curl_W(3, :) = - (P3_Crdt - P2_Crdt);
        tmp_curl_W(4, :) = - (P4_Crdt - P1_Crdt);
        tmp_curl_W(5, :) =   (P3_Crdt - P1_Crdt);
        tmp_curl_W(6, :) = - (P2_Crdt - P1_Crdt);
    case 'ext'
        tmp_curl_W(1, :) =   (P4_Crdt - P3_Crdt);
        tmp_curl_W(2, :) = - (P4_Crdt - P2_Crdt);
        tmp_curl_W(3, :) =   (P3_Crdt - P2_Crdt);
        tmp_curl_W(4, :) =   (P4_Crdt - P1_Crdt);
        tmp_curl_W(5, :) = - (P3_Crdt - P1_Crdt);
        tmp_curl_W(6, :) =   (P2_Crdt - P1_Crdt);
    otherwise
        error('check');
end

switch InnExtText
    case 'inn'
        nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
        nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
        nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
        nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );
    case 'ext'
        nabla(1, :) = calTriVec( P2_Crdt, P4_Crdt, P3_Crdt );
        nabla(2, :) = calTriVec( P4_Crdt, P1_Crdt, P3_Crdt );
        nabla(3, :) = calTriVec( P4_Crdt, P2_Crdt, P1_Crdt );
        nabla(4, :) = calTriVec( P3_Crdt, P1_Crdt, P2_Crdt );
    otherwise
        error('check');
end

% Edge6Value(1) = dot( tmp_curl_W(1, :), tmp_curl_W(1, :) ) / ( muValue * 9 * TtrVol );
% Edge6Value(2) = dot( tmp_curl_W(1, :), tmp_curl_W(2, :) ) / ( muValue * 9 * TtrVol );
% Edge6Value(3) = dot( tmp_curl_W(1, :), tmp_curl_W(3, :) ) / ( muValue * 9 * TtrVol );
% Edge6Value(4) = dot( tmp_curl_W(1, :), tmp_curl_W(4, :) ) / ( muValue * 9 * TtrVol );
% Edge6Value(5) = dot( tmp_curl_W(1, :), tmp_curl_W(5, :) ) / ( muValue * 9 * TtrVol );
% Edge6Value(6) = dot( tmp_curl_W(1, :), tmp_curl_W(6, :) ) / ( muValue * 9 * TtrVol );

A = repmat( tmp_curl_W(mainEdge, :), 6, 1 );
tmp = dot( A, tmp_curl_W, 2 );
Edge6Value = tmp' / ( 9 * muValue * TtrVol );

end
