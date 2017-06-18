function PatchContri = calKVE_TetPatch_Right( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
                        P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, muValue, epsilonValue )

% unrelatedVertex, hat_n, VolSurfText

PatchContri = zeros(4, 1);
AdjVrtx = zeros(1, 2);

% suitable for right tetrahedron type
finder = find( [P1_flag, P2_flag, P3_flag, P4_flag] == 2 );
if isempty( finder ) || length(finder) ~= 3
   return;
end

% determined the unrelatedVertex
TestVec = zeros(1, 3);
Ctr_0 = zeros(1, 3);
if finder == [1, 2, 3]
    unrelatedVertex = 4;
    hat_n = cross( P2_Crdt - P1_Crdt, P3_Crdt - P2_Crdt );
    Ctr_0 = ( P1_Crdt + P2_Crdt + P3_Crdt ) / 3;
    TestVec = P4_Crdt - Ctr_0;
elseif finder == [1, 2, 4]
    unrelatedVertex = 3;
    hat_n = cross( P2_Crdt - P1_Crdt, P4_Crdt - P2_Crdt );
    Ctr_0 = ( P1_Crdt + P2_Crdt + P4_Crdt ) / 3;
    TestVec = P3_Crdt - Ctr_0;
elseif finder == [1, 3, 4]
    unrelatedVertex = 2;
    hat_n = cross( P3_Crdt - P1_Crdt, P4_Crdt - P3_Crdt );
    Ctr_0 = ( P1_Crdt + P3_Crdt + P4_Crdt ) / 3;
    TestVec = P2_Crdt - Ctr_0;
elseif finder == [2, 3, 4]
    unrelatedVertex = 1;
    hat_n = cross( P3_Crdt - P2_Crdt, P4_Crdt - P3_Crdt );
    Ctr_0 = ( P2_Crdt + P3_Crdt + P4_Crdt ) / 3;
    TestVec = P1_Crdt - Ctr_0;
else
    error('check flag input');
end

% determine hat_n
if dot( TestVec, hat_n ) < 0
    hat_n = - hat_n / norm(hat_n);
else
    hat_n = hat_n / norm(hat_n);
end

VolSurfText = 'Surface';
% based on main edge: determine VolSurfText
if P1_flag == 2 && P2_flag == 2 && P3_flag == 2
    if mainEdge == 1 || mainEdge == 2 || mainEdge == 4 
        VolSurfText = 'Volume';
    end
elseif  P1_flag == 2 && P2_flag == 2 && P4_flag == 2
    if mainEdge == 1 || mainEdge == 3 || mainEdge == 5 
        VolSurfText = 'Volume';
    end
elseif  P1_flag == 2 && P3_flag == 2 && P4_flag == 2
    if mainEdge == 2 || mainEdge == 3 || mainEdge == 6 
        VolSurfText = 'Volume';
    end
elseif  P2_flag == 2 && P3_flag == 2 && P4_flag == 2
    if mainEdge == 4 || mainEdge == 5 || mainEdge == 6 
        VolSurfText = 'Volume';
    end
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

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );
switch unrelatedVertex
    case 1
        TriArea = norm( calTriVec( P2_Crdt, P3_Crdt, P4_Crdt ) );
    case 2
        TriArea = norm( calTriVec( P1_Crdt, P3_Crdt, P4_Crdt ) );
    case 3
        TriArea = norm( calTriVec( P1_Crdt, P2_Crdt, P4_Crdt ) );
    case 4
        TriArea = norm( calTriVec( P1_Crdt, P2_Crdt, P3_Crdt ) );
    otherwise
        error('check');
end

% omega on volume of surface
switch VolSurfText
    case 'Volume'
        LambdaMask = ones(1, 4);
        LambdaMask(unrelatedVertex) = 0;
        GradDiff = zeros(1, 3);
        switch mainEdge
            case 1
                GradDiff = LambdaMask(1) * nabla(2, :) - LambdaMask(2) * nabla(1, :);
                AdjVrtx = [2, 1];
            case 2
                GradDiff = LambdaMask(1) * nabla(3, :) - LambdaMask(3) * nabla(1, :);
                AdjVrtx = [3, 1];
            case 3
                GradDiff = LambdaMask(1) * nabla(4, :) - LambdaMask(4) * nabla(1, :);
                AdjVrtx = [4, 1];
            case 4
                GradDiff = LambdaMask(2) * nabla(3, :) - LambdaMask(3) * nabla(2, :);
                AdjVrtx = [3, 2];
            case 5
                GradDiff = LambdaMask(2) * nabla(4, :) - LambdaMask(4) * nabla(2, :);
                AdjVrtx = [4, 2];
            case 6
                GradDiff = LambdaMask(3) * nabla(4, :) - LambdaMask(4) * nabla(3, :);
                AdjVrtx = [4, 3];
            otherwise
                error('check');
        end

        % the related vertex on the edge
        AdjVrtx( find(AdjVrtx == unrelatedVertex) ) = [];
        % calculate the lambda product integral
        for vrtx = 1: 1: 4
            if vrtx ~= unrelatedVertex
                if vrtx == AdjVrtx
                    PatchContri(vrtx) = TriArea * dot( GradDiff, hat_n ) / ( muValue * epsilonValue * 6 * 3 * TtrVol);
                else
                    PatchContri(vrtx) = TriArea * dot( GradDiff, hat_n ) / ( muValue * epsilonValue * 12 * 3 * TtrVol);
                end
            else
                PatchContri(vrtx) = 0;
            end
        end
    case 'Surface'
        Grad = zeros(2, 3);
        switch mainEdge
            case 1
                Grad(1, :) = nabla(2, :);
                Grad(2, :) = nabla(1, :);
                AdjVrtx = [1, 2];
            case 2
                Grad(1, :) = nabla(3, :);
                Grad(2, :) = nabla(1, :);
                AdjVrtx = [1, 3];
            case 3
                Grad(1, :) = nabla(4, :);
                Grad(2, :) = nabla(1, :);
                AdjVrtx = [1, 4];
            case 4
                Grad(1, :) = nabla(3, :);
                Grad(2, :) = nabla(2, :);
                AdjVrtx = [2, 3];
            case 5
                Grad(1, :) = nabla(4, :);
                Grad(2, :) = nabla(2, :);
                AdjVrtx = [2, 4];
            case 6
                Grad(1, :) = nabla(4, :);
                Grad(2, :) = nabla(3, :);
                AdjVrtx = [3, 4];
            otherwise
                error('check');
        end

        for vrtx = 1: 1: 4
            if vrtx ~= unrelatedVertex
                if vrtx == AdjVrtx(1)
                    PatchContri(vrtx) = TriArea * ( dot( Grad(1, :), hat_n ) / 6 - dot( Grad(2, :), hat_n ) / 12 ) / ( muValue * epsilonValue * 3 * TtrVol);
                elseif vrtx == AdjVrtx(2)
                    PatchContri(vrtx) = TriArea * ( dot( Grad(1, :), hat_n ) / 12 - dot( Grad(2, :), hat_n ) / 6 ) / ( muValue * epsilonValue * 3 * TtrVol);
                elseif isempty( find( AdjVrtx == vrtx ) )
                    PatchContri(vrtx) = TriArea * ( dot( Grad(1, :), hat_n ) / 12 - dot( Grad(2, :), hat_n ) / 12 ) / ( muValue * epsilonValue * 3 * TtrVol);
                else
                    error('check');
                end
            else
                PatchContri(vrtx) = 0;
            end
        end
    otherwise
        error('check');
end

end