function Matlab_sparse = mySparse2MatlabSparse( sparseK, Rows, Cols, RowColText )
    RowIdx = [];
    ColIdx = [];
    Value  = [];

    if strcmp(RowColText, 'Row')
        for idx = 1: 1: Rows
            row = sparseK{ idx };
            rowlength = length(row);
            RowIdx = horzcat( RowIdx, idx * ones(1, rowlength / 2) );
            ColIdx = horzcat( ColIdx, row(1: rowlength / 2) );
            Value  = horzcat( Value , row(rowlength / 2 + 1: end) );
        end
    else
        for idx = 1: 1: Cols
            col = sparseK{ idx };
            collength = length(col);
            RowIdx = vertcat( RowIdx, col(1: collength / 2) );
            ColIdx = vertcat( ColIdx, idx * ones(collength / 2, 1) );
            Value  = vertcat( Value , col(collength / 2 + 1: end) );
        end
    end
        
    Matlab_sparse = sparse( RowIdx, ColIdx, Value, Rows, Cols );
end