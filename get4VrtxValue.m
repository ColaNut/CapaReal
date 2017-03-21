function Vrtx4Value = get4VrtxValue( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, epsilonValue, cntrlPntTxt )

Vrtx4Value = zeros(1, 4);
nabla = zeros(4, 3);

nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );

switch cntrlPntTxt
    case 'Nrml'
        Vrtx4Value(1) = dot( nabla(1, :), nabla(1, :) );
        Vrtx4Value(2) = dot( nabla(1, :), nabla(2, :) );
        Vrtx4Value(3) = dot( nabla(1, :), nabla(3, :) );
        Vrtx4Value(4) = dot( nabla(1, :), nabla(4, :) );
    case { 'z_shift', 'x_shift', 'y_shift' }
        Vrtx4Value(1) = dot( nabla(2, :), nabla(1, :) );
        Vrtx4Value(2) = dot( nabla(2, :), nabla(2, :) );
        Vrtx4Value(3) = dot( nabla(2, :), nabla(3, :) );
        Vrtx4Value(4) = dot( nabla(2, :), nabla(4, :) );
    otherwise
        error('check')
end

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

Vrtx4Value = TtrVol * epsilonValue * Vrtx4Value;

end
