function Matlab_sparse = mySparse2MatlabSparse( sparseK, N_e )
    RowIdx = [];
    ColIdx = [];
    Value  = [];

    for idx = 1: 1: N_e
        row = sparseK{ idx };
        rowlength = length(row);
        RowIdx = horzcat( RowIdx, idx * ones(1, rowlength / 2) );
        ColIdx = horzcat( ColIdx, row(1: rowlength / 2) );
        Value  = horzcat( Value , row(rowlength / 2 + 1: end) );
    end
    Matlab_sparse = sparse( RowIdx, ColIdx, Value, N_e, N_e );
end