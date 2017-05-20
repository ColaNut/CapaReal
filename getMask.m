function quadrantMask = getMask(quadrantNum, TypeSubTypeTex, n_864, varargin)
    
    quadrantMask = zeros(n_864, 1);
    nVarargs = length(varargin);
    if nVarargs == 1
        TiltType = varargin{1};
    end

    switch TypeSubTypeTex
        case 'Type1-2' % ok
            if nVarargs ~= 1
                error('check');
            end 
            switch TiltType
                case 'Horizental'
                    switch quadrantNum
                        case { 2, 1 }
                            quadrantMask(4: 5) = 1;
                        case { 3, 4 }
                            quadrantMask([1, 8]) = 1;
                    end
                case 'Vertical'
                    switch quadrantNum
                        case { 2, 3 }
                            quadrantMask([6, 7]) = 1;
                        case { 1, 4 }
                            quadrantMask([2, 3]) = 1;
                    end
                case 'Oblique'
                    switch quadrantNum
                        case 2
                            quadrantMask([5, 6]) = 1;
                        case 1
                            quadrantMask([3, 4]) = 1;
                        case 4
                            quadrantMask([1, 2]) = 1;
                        case 3
                            quadrantMask([7, 8]) = 1;
                    end
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
                    quadrantMask(4: 5) = 1;
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
                    quadrantMask(5: 6) = 1;
                otherwise
                    error('check');
            end
        case 'Type2-2' % ok
            if nVarargs ~= 1
                error('check');
            end 
            switch TiltType
                case 'Horizental'
                    switch quadrantNum
                        case { 2, 1 }
                            quadrantMask([2, 3]) = 1;
                        case { 3, 4 }
                            quadrantMask([1, 4]) = 1;
                    end
                case 'Vertical'
                    switch quadrantNum
                        case { 2, 3 }
                            quadrantMask([3, 4]) = 1;
                        case { 1, 4 }
                            quadrantMask([1, 2]) = 1;
                    end
            end
        case 'Type2-4' % ok
            switch quadrantNum
                case { 2, 1 }
                    quadrantMask(2: 3) = 1;
                case { 3, 4 }
                    quadrantMask([1, 4]) = 1;
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
            if nVarargs ~= 1
                error('check');
            end 
            switch TiltType
                case 'Horizental'
                    switch quadrantNum
                        case { 2, 1 }
                            quadrantMask([1, 8]) = 1;
                        case { 3, 4 }
                            quadrantMask(4: 5) = 1;
                    end
                case 'Vertical'
                    switch quadrantNum
                        case { 2, 3 }
                            quadrantMask([6, 7]) = 1;
                        case { 1, 4 }
                            quadrantMask([2, 3]) = 1;
                    end
                case 'Oblique'
                    switch quadrantNum
                        case 2
                            quadrantMask([7, 8]) = 1;
                        case 1
                            quadrantMask([1, 2]) = 1;
                        case 4
                            quadrantMask([3, 4]) = 1;
                        case 3
                            quadrantMask([5, 6]) = 1;
                    end
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
            if nVarargs ~= 1
                error('check');
            end 
            switch TiltType
                case 'Horizental'
                    switch quadrantNum
                        case { 2, 1 }
                            quadrantMask([1, 4]) = 1;
                        case { 3, 4 }
                            quadrantMask([2, 3]) = 1;
                    end
                case 'Vertical'
                    switch quadrantNum
                        case { 2, 3 }
                            quadrantMask([3, 4]) = 1;
                        case { 1, 4 }
                            quadrantMask([1, 2]) = 1;
                    end
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
