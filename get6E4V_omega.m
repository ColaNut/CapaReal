function [ Edge6Value, Vrtx4Value ] = get6E4V_omega( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, mainEdge, InnExtText, muValue, epsilonValue )

Edge6Value = zeros(2, 6);
Vrtx4Value = zeros(1, 4);
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
Edge6Value(1, :) = tmp' / ( 9 * muValue * TtrVol );

GradDiff = zeros(1, 3);
Pairs = zeros(6, 2);
Pairs = [ 1, 2;
          1, 3;
          1, 4;
          2, 3;
          2, 4;
          3, 4 ];
mainPair = zeros(1, 2);
switch mainEdge
    case 1
        GradDiff = nabla(2, :) - nabla(1, :);
        mainPair = Pairs(1, :);
    case 2
        GradDiff = nabla(3, :) - nabla(1, :);
        mainPair = Pairs(2, :);
    case 3
        GradDiff = nabla(4, :) - nabla(1, :);
        mainPair = Pairs(3, :);
    case 4
        GradDiff = nabla(3, :) - nabla(2, :);
        mainPair = Pairs(4, :);
    case 5
        GradDiff = nabla(4, :) - nabla(2, :);
        mainPair = Pairs(5, :);
    case 6
        GradDiff = nabla(4, :) - nabla(3, :);
        mainPair = Pairs(6, :);
    otherwise
        error('check');
end

GradDiffRep = repmat( GradDiff, 4, 1 );
tmp = dot( GradDiffRep, nabla, 2 );
Vrtx4Value = epsilonValue * tmp' / (36 * TtrVol);

% K2 
% omega_m = lambda_a \nabla lambda_b - lambda_b \nabla \lambda_a
% omega_n = lambda_c \nabla lambda_d - lambda_d \nabla \lambda_c
part = zeros(6, 4);
for n = 1: 1: 6
    vicePair = Pairs(n, :);
    mainSet = [ mainPair(1), mainPair(2), mainPair(1), mainPair(2) ];
    viceSet = [ vicePair(1), vicePair(1), vicePair(2), vicePair(2) ];
    diffMN = find( mainSet - viceSet );
    sameMN = find( mainSet - viceSet == 0 );
    part(n, 1) =   dot( nabla(mainPair(2), :), nabla(vicePair(2), :) );
    part(n, 2) = - dot( nabla(mainPair(1), :), nabla(vicePair(2), :) );
    part(n, 3) = - dot( nabla(mainPair(2), :), nabla(vicePair(1), :) );
    part(n, 4) =   dot( nabla(mainPair(1), :), nabla(vicePair(1), :) );
    part(n, sameMN) = part(n, sameMN) * TtrVol / 10;
    part(n, diffMN) = part(n, diffMN) * TtrVol / 20;
end

% part(1) = lambda_a lambda_c \nabla lambda_b \nabla lambda_d
% part(2) = - lambda_b lambda_c \nabla \lambda_a \nabla lambda_d 
% part(3) = - lambda_a lambda_d \nabla lambda_b \nabla \lambda_c
% part(4) = lambda_b lambda_d \nabla \lambda_a \nabla \lambda_c

Edge6Value(2, :) = epsilonValue * sum(part, 2)';

end
