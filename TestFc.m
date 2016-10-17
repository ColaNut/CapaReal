% function [ AxA, BxB ] = TestFc( a, b, c )

% % AxA = cell(2, 1);
% % AxA{1} = 30;
% % AxA{2} = 60;

% % CxC = horzcat( cell(2, 1), AxA )

% % BxB = 0;
% x = 1;
% AxA = x;
% BxB = x + 1;

% end

% a = 1;
% try
%     if a == 1
%         a = 9
%         error('testing catch funtion');
%     end
% catch a
%     ;% a = 3
% end
% b = 6
% % xAx = complex(a,0);

idx = 4320;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    if mod( idx, x_idx_max * y_idx_max ) == 0
        n = y_idx_max;
    else
        n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
    end
    
    ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

    [ m, n, ell ]