function [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max)

    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = int64(x_idx_max);
    else
        m = int64(tmp_m);
    end

    if mod( idx, x_idx_max * y_idx_max ) == 0
        n = int64(y_idx_max);
    else
        n = int64( ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1 );
    end
    
    ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

end