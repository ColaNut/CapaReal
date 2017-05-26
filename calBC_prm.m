function [ Tet7 ] = calBC_prm( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
                            P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, J_0, J, mu_r )

Tet7 = zeros(7, 1);

% J is not used in calBC_prm
% first 6: for six edges; 
% last  1: for B_k

% === % ======================================= % === %
% === % the process to calculate Tet7(7) or B_k % === %
% === % ======================================= % === %

% BkTet = 0;
projArea = 0;
TtrVol = 0;
J = zeros(1, 3);
A_1 = 0;
A_2 = 0;
A_3 = 1;

if P1_flag == uint8(0) && P2_flag == uint8(0) && P3_flag == uint8(0) && P4_flag == uint8(0)
    return;
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

% check by hand
% adjacent vertex to mainEdge
GradDiff = zeros(1, 3);
AdjVrtx = zeros(1, 2);
switch mainEdge
    case 1
        GradDiff = nabla(2, :) - nabla(1, :);
        AdjVrtx = [2, 1];
    case 2
        GradDiff = nabla(3, :) - nabla(1, :);
        AdjVrtx = [3, 1];
    case 3
        GradDiff = nabla(4, :) - nabla(1, :);
        AdjVrtx = [4, 1];
    case 4
        GradDiff = nabla(3, :) - nabla(2, :);
        AdjVrtx = [3, 2];
    case 5
        GradDiff = nabla(4, :) - nabla(2, :);
        AdjVrtx = [4, 2];
    case 6
        GradDiff = nabla(4, :) - nabla(3, :);
        AdjVrtx = [4, 3];
    otherwise
        error('check');
end

% Existence of mainedge on current surface
if P1_flag && P2_flag && P3_flag
    if mainEdge == 1 || mainEdge == 2 || mainEdge == 4 
        x = sum( [P1_Crdt(1), P2_Crdt(1), P3_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P3_Crdt(3)] ) / 3;
        J = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
        % projArea = ( x_1 * y_2 + x_3 * y_1 + x_2 * y_3 ...
                    % - x_3 * y_2 - x_1 * y_3 - x_2 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P2_Crdt(2) + P3_Crdt(1) * P1_Crdt(2) + P2_Crdt(1) * P3_Crdt(2) ...
                    - P3_Crdt(1) * P2_Crdt(2) - P1_Crdt(1) * P3_Crdt(2) - P2_Crdt(1) * P1_Crdt(2) ) / 2;
        % triArea = norm( calTriVec( P1_Crdt, P2_Crdt, P3_Crdt ) );
        % equations for the surface: A_1 x + A_2 y + A_3 z + A = 0
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P2_Crdt(1), P2_Crdt(2), P2_Crdt(3); P3_Crdt(1), P3_Crdt(2), P3_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P2_Crdt(2), P2_Crdt(3),   1; P3_Crdt(2), P3_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P2_Crdt(1), P2_Crdt(3),   1; P3_Crdt(1), P3_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P2_Crdt(1), P2_Crdt(2),   1; P3_Crdt(1), P3_Crdt(2),   1 ] );
    end
elseif  P1_flag && P2_flag && P4_flag
    if mainEdge == 1 || mainEdge == 3 || mainEdge == 5 
        x = sum( [P1_Crdt(1), P2_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P4_Crdt(3)] ) / 3;
        J = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
        % projArea = ( x_1 * y_2 + x_4 * y_1 + x_2 * y_4 ...
                    % - x_4 * y_2 - x_1 * y_4 - x_2 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P2_Crdt(2) + P4_Crdt(1) * P1_Crdt(2) + P2_Crdt(1) * P4_Crdt(2) ...
                    - P4_Crdt(1) * P2_Crdt(2) - P1_Crdt(1) * P4_Crdt(2) - P2_Crdt(1) * P1_Crdt(2) ) / 2;
        % triArea = norm( calTriVec( P1_Crdt, P2_Crdt, P4_Crdt ) );
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P2_Crdt(1), P2_Crdt(2), P2_Crdt(3); P4_Crdt(1), P4_Crdt(2), P4_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P2_Crdt(2), P2_Crdt(3),   1; P4_Crdt(2), P4_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P2_Crdt(1), P2_Crdt(3),   1; P4_Crdt(1), P4_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P2_Crdt(1), P2_Crdt(2),   1; P4_Crdt(1), P4_Crdt(2),   1 ] );
    end
elseif  P1_flag && P3_flag && P4_flag
    if mainEdge == 2 || mainEdge == 3 || mainEdge == 6 
        x = sum( [P1_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        J = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
        % projArea = ( x_1 * y_3 + x_4 * y_1 + x_3 * y_4 ...
                    % - x_4 * y_3 - x_1 * y_4 - x_3 * y_1 ) / 2;
        projArea = abs( P1_Crdt(1) * P3_Crdt(2) + P4_Crdt(1) * P1_Crdt(2) + P3_Crdt(1) * P4_Crdt(2) ...
                    - P4_Crdt(1) * P3_Crdt(2) - P1_Crdt(1) * P4_Crdt(2) - P3_Crdt(1) * P1_Crdt(2) ) / 2;
        % triArea = norm( calTriVec( P1_Crdt, P3_Crdt, P4_Crdt ) );
        % A   = - det( [ P1_Crdt(1), P1_Crdt(2), P1_Crdt(3); P3_Crdt(1), P3_Crdt(2), P3_Crdt(3); P4_Crdt(1), P4_Crdt(2), P4_Crdt(3) ] );
        A_1 =   det( [ P1_Crdt(2), P1_Crdt(3),   1; P3_Crdt(2), P3_Crdt(3),   1; P4_Crdt(2), P4_Crdt(3),   1 ] );
        A_2 = - det( [ P1_Crdt(1), P1_Crdt(3),   1; P3_Crdt(1), P3_Crdt(3),   1; P4_Crdt(1), P4_Crdt(3),   1 ] );
        A_3 =   det( [ P1_Crdt(1), P1_Crdt(2),   1; P3_Crdt(1), P3_Crdt(2),   1; P4_Crdt(1), P4_Crdt(2),   1 ] );
    end
elseif  P2_flag && P3_flag && P4_flag
    if mainEdge == 4 || mainEdge == 5 || mainEdge == 6 
        x = sum( [P2_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P2_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
        J = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
        % projArea = ( x_2 * y_3 + x_4 * y_2 + x_3 * y_4 ...
                    % - x_4 * y_3 - x_2 * y_4 - x_3 * y_2 ) / 2;
        projArea = abs( P2_Crdt(1) * P3_Crdt(2) + P4_Crdt(1) * P2_Crdt(2) + P3_Crdt(1) * P4_Crdt(2) ...
                    - P4_Crdt(1) * P3_Crdt(2) - P2_Crdt(1) * P4_Crdt(2) - P3_Crdt(1) * P2_Crdt(2) ) / 2;
        % triArea = norm( calTriVec( P2_Crdt, P3_Crdt, P4_Crdt ) );
        % A   = - det( [ P2_Crdt(1), P2_Crdt(2), P2_Crdt(3); P3_Crdt(1), P3_Crdt(2), P3_Crdt(3); P4_Crdt(1), P4_Crdt(2), P4_Crdt(3) ] );
        A_1 =   det( [ P2_Crdt(2), P2_Crdt(3),   1; P3_Crdt(2), P3_Crdt(3),   1; P4_Crdt(2), P4_Crdt(3),   1 ] );
        A_2 = - det( [ P2_Crdt(1), P2_Crdt(3),   1; P3_Crdt(1), P3_Crdt(3),   1; P4_Crdt(1), P4_Crdt(3),   1 ] );
        A_3 =   det( [ P2_Crdt(1), P2_Crdt(2),   1; P3_Crdt(1), P3_Crdt(2),   1; P4_Crdt(1), P4_Crdt(2),   1 ] );
    end
end

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

if projArea < 0
    error('check');
end

if TtrVol ~= 0
    BkTet = dot( GradDiff, J ) * sqrt( 1 + (A_1 / A_3)^2 + (A_2 / A_3)^2 ) * 2 * projArea / (9 * TtrVol);
else
    error('check');
    BkTet = 0;
end

% === % ======================================= % === %
% === % the process to calculate Coeff and Tet7 % === %
% === % ======================================= % === %

hat_n = zeros(1, 3);
% TtrVol = 0;
Coeff = zeros(6, 3); 
CoeffFlag = 0;
SheetsArnd = zeros(6, 1);

if P1_flag == uint8(0) && P2_flag == uint8(0) && P3_flag == uint8(0) && P4_flag == uint8(0)
    return;
end

% if quadrantMask == 0
%     return;
% end

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

insideFlag = false;
if CoeffFlag 
    TestVec = zeros(1, 2);
    % if J == zeros(3, 1) 
    %     J = J_0 * [ - z, 0, x ]' / norm( [ - z, 0, x ] );
    % end
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
        insideFlag = true;
    end
end

if ~insideFlag
    Tet7(7) = BkTet;
else
    Tet7(7) = 0;
end

Coeff(:, 1: 3) = cross( repmat(hat_n, 6, 1), Coeff(:, 1: 3), 2 );
% Coeff(:, 4) = SheetsArnd;

Tet7(1: 6, 1) = dot( repmat(GradDiff, 6, 1), Coeff, 2 ) * sqrt( 1 + (A_1 / A_3)^2 + (A_2 / A_3)^2 ) * 2 * projArea / (9 * TtrVol);

end
