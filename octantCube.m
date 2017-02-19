function [ w, SegMed ] = octantCube( Med2Layers, epsilon_r )

w = ones(2, 1);
SegMed = ones(1, 2, 'uint8');

    if Med2Layers(2, 2) ~= 0 && Med2Layers(2, 3) ~= 0
        w(1) = epsilon_r( Med2Layers(2, 2) );
        w(2) = epsilon_r( Med2Layers(2, 3) );
        SegMed(1) = Med2Layers(2, 2);
        SegMed(2) = Med2Layers(2, 3);
    elseif Med2Layers(2, 2) ~= 0 && Med2Layers(2, 3) == 0
        w(1) = epsilon_r( Med2Layers(2, 2) );
        w(2) = epsilon_r( Med2Layers(2, 2) );
        SegMed(1) = Med2Layers(2, 2);
        SegMed(2) = Med2Layers(2, 2);
    elseif Med2Layers(2, 2) == 0 && Med2Layers(2, 3) ~= 0
        w(1) = epsilon_r( Med2Layers(2, 3) );
        w(2) = epsilon_r( Med2Layers(2, 3) );
        SegMed(1) = Med2Layers(2, 3);
        SegMed(2) = Med2Layers(2, 3);
    elseif Med2Layers(2, 2) == 0 && Med2Layers(2, 3) == 0
        if Med2Layers(1, 4) == 0 && Med2Layers(1, 2) ~= 0 && Med2Layers(1, 3) ~= 0
            w(1) = epsilon_r( Med2Layers(1, 2) );
            w(2) = epsilon_r( Med2Layers(1, 3) );
            SegMed(1) = Med2Layers(1, 2);
            SegMed(2) = Med2Layers(1, 3);
        else
            tmpArr = [ Med2Layers(1, 2), Med2Layers(1, 3), Med2Layers(1, 4), Med2Layers(2, 4) ];
            nonZeroIdx = find(tmpArr);
            if isempty(nonZeroIdx) % all the eight points are boundary points 
                w(1) = epsilon_r(3); % this region belongs to muscle [ valid only in test case ]
                w(2) = epsilon_r(3);
                SegMed(1) = 3;
                SegMed(2) = 3;
            else
                for idx = 1: 1: length(nonZeroIdx)
                    if tmpArr(nonZeroIdx(idx)) ~= tmpArr(nonZeroIdx(1))
                        tmpArr
                        warning('check for the homogeneity');
                    end
                end
                w(1) = epsilon_r( tmpArr( nonZeroIdx(1) ) );
                w(2) = epsilon_r( tmpArr( nonZeroIdx(1) ) );
                SegMed(1) = tmpArr( nonZeroIdx(1) );
                SegMed(2) = tmpArr( nonZeroIdx(1) );
            end
        end
    else
        error('check other case');
    end

end