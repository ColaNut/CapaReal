function Vrtx4Value = get4V_omega_amend( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, mainEdge, InnExtText, muValue, epsilonValue )

% Edge6Value = zeros(2, 6);
Vrtx4Value = zeros(1, 4);
tmp_curl_W = zeros(6, 3);
nabla      = zeros(4, 3);

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

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

GradDiff = zeros(1, 3);

switch mainEdge
    case 1
        GradDiff = nabla(2, :) - nabla(1, :);
    case 2
        GradDiff = nabla(3, :) - nabla(1, :);
    case 3
        GradDiff = nabla(4, :) - nabla(1, :);
    case 4
        GradDiff = nabla(3, :) - nabla(2, :);
    case 5
        GradDiff = nabla(4, :) - nabla(2, :);
    case 6
        GradDiff = nabla(4, :) - nabla(3, :);
    otherwise
        error('check');
end

GradDiffRep = repmat( GradDiff, 4, 1 );
tmp = dot( GradDiffRep, nabla, 2 );
Vrtx4Value = epsilonValue * tmp' / (36 * TtrVol);

end
