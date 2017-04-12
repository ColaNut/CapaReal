function [ m, ell ] = getML(idx, x_idx_max)

    % idx = ( ell - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = int64(x_idx_max);
    else
        m = int64(tmp_m);
    end

    ell = int64( ( idx - m ) / x_idx_max + 1 );

end