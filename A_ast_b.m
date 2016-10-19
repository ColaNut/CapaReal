function [ tilde_b ] = A_ast_b( sparse_A, b )

tilde_b = zeros(size(b));
A_length = size(sparse_A, 1);

for idx = 1: 1: A_length
    sparse_A_row = sparse_A{idx};

    num = int8(size(sparse_A_row, 2)) / 2;
    for idx_2 = 1: 1: num
        tilde_b( idx ) = tilde_b( idx ) + sparse_A_row( num + idx_2 ) * b( uint64(sparse_A_row(idx_2)) );
    end
end

end