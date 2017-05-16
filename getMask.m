function quadrantMask = getMask(quadrantNum, TypeSubTypeTex, n_864)
    
    quadrantMask = zeros(n_864, 1);
    
    switch TypeSubTypeTex
        case 'Type1-2' % ok
            switch quadrantNum
                case 2
                    quadrantMask(4: 7) = 1;
                case 1
                    quadrantMask(2: 5) = 1;
                case 4
                    quadrantMask([1, 2, 3, 8]) = 1;
                case 3
                    quadrantMask([1, 6, 7, 8]) = 1;
            end
        case 'Type1-4' % ok
            switch quadrantNum
                case { 2, 1 }
                    quadrantMask(2: 3) = 1;
                case { 3, 4 }
                    quadrantMask([1, 4]) = 1;
            end
        case 'Type1-5' % ok
            switch quadrantNum
                case { 2, 3 }
                    quadrantMask([1, 4]) = 1;
                case { 1, 4 }
                    quadrantMask([2: 3]) = 1;
                otherwise
                    error('check');
            end
        case 'Type1-7'
            switch quadrantNum
                case 2
                    quadrantMask(3: 4) = 1;
                case 4
                    quadrantMask(1: 2) = 1;
                otherwise
                    error('check');
            end
        case 'Type4-5' % ok
            switch quadrantNum
                case { 2, 3 }
                    quadrantMask([1, 4]) = 1;
                case { 1, 4 }
                    quadrantMask(2: 3) = 1;
            end
        case 'Type4-7'
            switch quadrantNum
                case 2
                    error('Check');
                case 1
                    quadrantMask(2: 3) = 1;
                case 3
                    quadrantMask(2: 6) = 1;
                otherwise
                    error('check');
            end
        case 'Type2-2' % ok
            switch quadrantNum
                case 2
                    quadrantMask(2: 4) = 1;
                case 1
                    quadrantMask(1: 3) = 1;
                case 4
                    quadrantMask([1, 2, 4]) = 1;
                case 3
                    quadrantMask([1, 3, 4]) = 1;
            end
        case 'Type2-4' % ok
            switch quadrantNum
                case { 2, 1 }
                    quadrantMask(2: 3) = 1;
                case { 3, 4 }
                    quadrantMask(1: 4) = 1;
            end
        case 'Type2-5' % ok
            switch quadrantNum
                case { 2, 3 }
                    quadrantMask(2: 3) = 1;
                case { 1, 4 }
                    quadrantMask([1, 4]) = 1;
                otherwise
                    error('check');
            end
        case 'Type3-5' % ok
            switch quadrantNum
                case { 2, 3 }
                    quadrantMask(2: 3) = 1;
                case { 1, 4 }
                    quadrantMask([1, 4]) = 1;
            end
        case 'Type2-7' % ok
            switch quadrantNum
                case 2
                    error('check');
                case 1
                    quadrantMask(3: 4) = 1;
                case 3
                    quadrantMask([1, 6]) = 1;
                otherwise
                    error('check');
            end
        case 'Type3-2' % ok
            switch quadrantNum
                case 2
                    quadrantMask([1, 6, 7, 8]) = 1;
                case 1
                    quadrantMask([1, 2, 3, 8]) = 1;
                case 4
                    quadrantMask([2: 5]) = 1;
                case 3
                    quadrantMask([4: 7]) = 1;
            end
        case 'Type3-4' % ok
            switch quadrantNum
                case { 2, 1 }
                    quadrantMask([1, 4]) = 1;
                case { 4, 3 }
                    quadrantMask([2: 3]) = 1;
            end
        % case 'Type3-5' and case 'Type2-7' as previous
        case 'Type3-7'
            switch quadrantNum
                case 2
                    quadrantMask([3, 4]) = 1;
                case 4
                    quadrantMask([1, 6]) = 1;
                otherwise
                    error('check');
            end
        case 'Type4-2' % ok
            switch quadrantNum
                case 2
                    quadrantMask([1, 3, 4]) = 1;
                case 1
                    quadrantMask([1, 2, 4]) = 1;
                case 4
                    quadrantMask([1: 3]) = 1;
                case 3
                    quadrantMask([2: 4]) = 1;
            end
        case 'Type4-4' % ok
            switch quadrantNum
                case { 2, 1 }
                    quadrantMask([1, 4]) = 1;
                case { 3, 4 }
                    quadrantMask([2: 3]) = 1;
            end
        % case 'Type4-5' and case 'Type4-7' as previous
        otherwise
            error('check');
    end
end
