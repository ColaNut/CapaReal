function trim_A = getA_Jcol(A, dim, J)
    
    trim_A = zeros(dim, length(J));

    J_length = length(J);

    for idx = 1: 1: J_length
        trim_A(:, idx) = sparse2NrmlVec( A{ J(idx) }, dim );
    end
end
