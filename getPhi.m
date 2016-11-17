function Phi = getPhi( bar_x_my_gmres, x_idx_max, y_idx_max, z_idx_max )

    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
            
        % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
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

        Phi(m, n, ell) = bar_x_my_gmres(idx);
    end
    
end