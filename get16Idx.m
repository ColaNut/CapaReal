function nzCols_4row = get16Idx(face6Pnts, Cpnts)
    nzCols_4row = zeros(4, 4);
    nzCols_4row = [ Cpnts, face6Pnts(1), face6Pnts(2), face6Pnts(4); 
                    Cpnts, face6Pnts(2), face6Pnts(3), face6Pnts(4);
                    Cpnts, face6Pnts(3), face6Pnts(4), face6Pnts(5);
                    Cpnts, face6Pnts(4), face6Pnts(5), face6Pnts(6) ];
end