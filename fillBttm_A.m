function [ A_row ] = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max )

    A_row = zeros(1, 4);
    p0  = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m ); % center point
    p1  = int64( ( ell     ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m ); % ell + 1
    % p2  = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m - 1 ); % m - 1
    % p3  = int64( ( ell - 2 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m ); % ell - 1
    % p4  = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m + 1 ); % m + 1
    % p5  = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n     ) * x_idx_max + m ); % n + 1
    % p6  = int64( ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 2 ) * x_idx_max + m ); % n - 1

    A_row(1) = p0;
    A_row(2) = p1;
    A_row(3) = - 1;
    A_row(4) = 1;
    
end