function [ w1, w2 ] = octantCube( Med2Layers, epsilon_r )

    if Med2Layers(2, 2) ~= 0 && Med2Layers(2, 3) ~= 0
        w1 = epsilon_r( Med2Layers(2, 2) );
        w2 = epsilon_r( Med2Layers(2, 3) );
    elseif Med2Layers(2, 2) ~= 0 && Med2Layers(2, 3) == 0
        w1 = epsilon_r( Med2Layers(2, 2) );
        w2 = epsilon_r( Med2Layers(2, 2) );
    elseif Med2Layers(2, 2) == 0 && Med2Layers(2, 3) ~= 0
        w1 = epsilon_r( Med2Layers(2, 3) );
        w2 = epsilon_r( Med2Layers(2, 3) );
    elseif Med2Layers(2, 2) == 0 && Med2Layers(2, 3) == 0
        if Med2Layers(1, 4) == 0 && Med2Layers(1, 2) ~= 0 && Med2Layers(1, 3) ~= 0
            w1 = epsilon_r( Med2Layers(1, 2) );
            w2 = epsilon_r( Med2Layers(1, 3) );
        else
            tmpArr = [ Med2Layers(1, 2), Med2Layers(1, 3), Med2Layers(1, 4), Med2Layers(2, 4) ];
            nonZeroIdx = find(tmpArr);
            if isempty(nonZeroIdx)
                error('check the input parameters');
            end
            for idx = 1: 1: length(nonZeroIdx)
                if tmpArr(nonZeroIdx(idx)) ~= tmpArr(nonZeroIdx(1))
                    tmpArr
                    error('check for the homogeneity');
                end
            end
            w1 = epsilon_r( tmpArr( nonZeroIdx(1) ) );
            w2 = epsilon_r( tmpArr( nonZeroIdx(1) ) );
        end
    else
        error('check other case');
    end

end