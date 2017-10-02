function nzCols_4row = get16Idx_Side(p1, p2, p3, p4, p5, p6, p7)
    nzCols_4row = zeros(4, 4);
    nzCols_4row = [ p1, p2, p3, p4; 
                    p1, p2, p4, p5;
                    p1, p2, p5, p6;
                    p1, p2, p6, p7 ];
end