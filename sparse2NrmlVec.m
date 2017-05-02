function NrmlVec = sparse2NrmlVec( A_col, dim )
    
    % act on column vector
    
    NrmlVec = zeros(dim, 1);
    halfNum = length( A_col ) / 2;

    for idx = 1: 1: halfNum
        NrmlVec( A_col(idx) ) = A_col( halfNum + idx );
    end
end