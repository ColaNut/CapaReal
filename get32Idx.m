function nzCols_8row = get32Idx(face9Pnts, Cpnts)
    nzCols_8row = zeros(8, 4);
    nzCols_8row = [ Cpnts, face9Pnts(5), face9Pnts(9), face9Pnts(6); 
                    Cpnts, face9Pnts(5), face9Pnts(8), face9Pnts(9);
                    Cpnts, face9Pnts(5), face9Pnts(7), face9Pnts(8);
                    Cpnts, face9Pnts(5), face9Pnts(4), face9Pnts(7);
                    Cpnts, face9Pnts(5), face9Pnts(1), face9Pnts(4);
                    Cpnts, face9Pnts(5), face9Pnts(2), face9Pnts(1);
                    Cpnts, face9Pnts(5), face9Pnts(3), face9Pnts(2);
                    Cpnts, face9Pnts(5), face9Pnts(6), face9Pnts(3) ];
end