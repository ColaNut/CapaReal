function [ Coeff, J ] = calBC( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
                            P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, J_0, J, mu_r, quadrantMask )

% P1_Crdt = zeros(1, 3);
% BkTet = 0;
TtrVol = 0;
Coeff = zeros(6, 3);

if P1_flag == uint8(0) && P2_flag == uint8(0) && P3_flag == uint8(0) && P4_flag == uint8(0)
    return;
end

if quadrantMask == 0
    return;
end

% import \mu for all calBC
Coeff = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, zeros(6, 1), mu_r, 'A_unknown' );

% check the un-corellated vertex is inside the cylinder or not.
tmpArry = [ norm(P1_Crdt), norm(P2_Crdt), norm(P3_Crdt), norm(P4_Crdt) ];
tmpMIN = [];
MIN_IDX = 0;
[ tmpMIN, MIN_IDX ] = min(tmpArry);
% Existence of mainedge on current surface
if P1_flag && P2_flag && P3_flag
    if mainEdge == 1 || mainEdge == 2 || mainEdge == 4 
        x = sum( [P1_Crdt(1), P2_Crdt(1), P3_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P3_Crdt(3)] ) / 3;
        if J == zeros(3, 1) 
            J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
        end
        if MIN_IDX == 4
            Coeff = - Coeff;
        end
    end
elseif  P1_flag && P2_flag && P4_flag
    if mainEdge == 1 || mainEdge == 3 || mainEdge == 5 
        x = sum( [P1_Crdt(1), P2_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P4_Crdt(3)] ) / 3;
        if J == zeros(3, 1) 
            J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
        end
        if MIN_IDX == 3
            Coeff = - Coeff;
        end
    end
elseif  P1_flag && P3_flag && P4_flag
    if mainEdge == 2 || mainEdge == 3 || mainEdge == 6 
        x = sum( [P1_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        if J == zeros(3, 1) 
            J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
        end
        if MIN_IDX == 2
            Coeff = - Coeff;
        end
    end
elseif  P2_flag && P3_flag && P4_flag
    if mainEdge == 4 || mainEdge == 5 || mainEdge == 6 
        x = sum( [P2_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P2_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        if J == zeros(3, 1) 
            J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
        end
        if MIN_IDX == 1
            Coeff = - Coeff;
        end
    end
end

hat_n = zeros(1, 3);
hat_n = cross( P1_Crdt - P2_Crdt, P1_Crdt - P3_Crdt );
hat_n = hat_n / norm(hat_n);
if dot(hat_n, P4_Crdt) < 0
    hat_n = - hat_n;
end

Coeff = cross( repmat(hat_n, 6, 1), Coeff, 2 );

end
