function sparseForm = Nrml2Sparse( NrmlRow )
    
    % act on normal row
    idxSet = find(NrmlRow);
    sparseForm = zeros(1, 2 * length( idxSet ));
    sparseForm(1: length( idxSet )) = idxSet;
    sparseForm(length( idxSet ) + 1: end) = NrmlRow(idxSet);
end
