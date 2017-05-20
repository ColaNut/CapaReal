function [ Coeff, J ] = calBC( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
                            P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, J_0, J, mu_r, quadrantMask )

% P1_Crdt = zeros(1, 3);
% BkTet = 0;
hat_n = zeros(1, 3);
TtrVol = 0;
Coeff = zeros(6, 4); 
CoeffFlag = 0;
SheetsArnd = zeros(6, 1);

if P1_flag == uint8(0) && P2_flag == uint8(0) && P3_flag == uint8(0) && P4_flag == uint8(0)
    return;
end

if quadrantMask == 0
    return;
end

% check the un-corellated vertex is inside the cylinder or not.
% tmpArry = [ norm([P1_Crdt(1), P1_Crdt(3)]), norm([P2_Crdt(1), P2_Crdt(3)]), ...
%                 norm([P3_Crdt(1), P3_Crdt(3)]), norm([P4_Crdt(1), P4_Crdt(3)]) ];
% tmpMIN = [];
% MIN_IDX = 0;
% [ tmpMIN, MIN_IDX ] = min(tmpArry);
% Existence of mainedge on current surface
if P1_flag && P2_flag && P3_flag
    if mainEdge == 1 || mainEdge == 2 || mainEdge == 4 
        CoeffFlag = 123;
        x = sum( [P1_Crdt(1), P2_Crdt(1), P3_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P3_Crdt(3)] ) / 3;
        hat_n = cross( P1_Crdt - P2_Crdt, P1_Crdt - P3_Crdt );
        Coeff(:, 1: 3) = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, zeros(6, 1), mu_r, 'A_unknown' );
    end
elseif  P1_flag && P2_flag && P4_flag
    if mainEdge == 1 || mainEdge == 3 || mainEdge == 5 
        CoeffFlag = 124;
        x = sum( [P1_Crdt(1), P2_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P4_Crdt(3)] ) / 3;
        hat_n = cross( P1_Crdt - P2_Crdt, P1_Crdt - P4_Crdt );
        Coeff(:, 1: 3) = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, zeros(6, 1), mu_r, 'A_unknown' );
    end
elseif  P1_flag && P3_flag && P4_flag
    if mainEdge == 2 || mainEdge == 3 || mainEdge == 6 
        CoeffFlag = 134;
        x = sum( [P1_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        hat_n = cross( P1_Crdt - P3_Crdt, P1_Crdt - P4_Crdt );
        Coeff(:, 1: 3) = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, zeros(6, 1), mu_r, 'A_unknown' );
    end
elseif  P2_flag && P3_flag && P4_flag
    if mainEdge == 4 || mainEdge == 5 || mainEdge == 6 
        CoeffFlag = 234;
        x = sum( [P2_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P2_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        hat_n = cross( P2_Crdt - P3_Crdt, P2_Crdt - P4_Crdt );
        Coeff(:, 1: 3) = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, zeros(6, 1), mu_r, 'A_unknown' );
    end
end

if CoeffFlag 
    TestVec = zeros(1, 2);
    if J == zeros(3, 1) 
        J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
    end
    SheetsArnd = ones(1 ,6);
    hat_n = hat_n / norm(hat_n);
    if dot(hat_n, P4_Crdt) < 0
        hat_n = - hat_n;
    end

    switch CoeffFlag
        case 123
            TestVec = [ P4_Crdt(1), P4_Crdt(3) ] - [ x, z ];
        case 124
            TestVec = [ P3_Crdt(1), P3_Crdt(3) ] - [ x, z ];
        case 134
            TestVec = [ P2_Crdt(1), P2_Crdt(3) ] - [ x, z ];
        case 234
            TestVec = [ P1_Crdt(1), P1_Crdt(3) ] - [ x, z ];
        otherwise
            error('check the CoeffFlag');
    end
    if ( TestVec(1) * hat_n(1) + TestVec(2) * hat_n(3) ) < 0 % dot operator < 0
       Coeff(:, 1: 3) = - Coeff(:, 1: 3);
    end
end

Coeff(:, 1: 3) = cross( repmat(hat_n, 6, 1), Coeff(:, 1: 3), 2 );
Coeff(:, 4) = SheetsArnd;

end
