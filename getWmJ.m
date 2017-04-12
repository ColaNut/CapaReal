function BkTet = getWmJ( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, medValue, J_0 )

BkTet = 0;

S_1 = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
S_2 = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
J = zeros(1, 3);

if medValue == 3
    x = sum( [P1_Crdt(1), P2_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 4;
    z = sum( [P1_Crdt(3), P2_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 4;
    J = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
end

BkTet = dot( S_2 - S_1, J ) / 12;

end
