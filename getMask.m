function quadrantMask = getMask(quadtantNum, TypeSubTypeTex, n_864)
    
    quadrantMask = zeros(n_864, 1);
    
    switch TypeSubTypeTex
        case 'Type1-2'
            switch quadtantNum
                case 2
                    quadrantMask(4: 7) = 1;
                case 1
                    quadrantMask(2: 5) = 1;
            end
        otherwise
            body
    end
end
