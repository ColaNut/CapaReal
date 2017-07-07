function myRow = Mrow2myRow(M_row)

    M_idx = find(M_row);
    myRow = [ M_idx, M_row(M_idx) ];

end
