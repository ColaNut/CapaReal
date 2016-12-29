function XYZ9Med = getXYZ9Med( m, n, ell, mediumTable, CrossTexT )

XYZ9Med = ones( 9, 1, 'uint8');

if strcmp(CrossTexT, 'XZ')
    XYZ9Med(1) = mediumTable(m - 1, n, ell - 1);
    XYZ9Med(2) = mediumTable(m    , n, ell - 1);
    XYZ9Med(3) = mediumTable(m + 1, n, ell - 1);
    XYZ9Med(4) = mediumTable(m - 1, n, ell    );
    XYZ9Med(5) = mediumTable(m    , n, ell    );
    XYZ9Med(6) = mediumTable(m + 1, n, ell    );
    XYZ9Med(7) = mediumTable(m - 1, n, ell + 1);
    XYZ9Med(8) = mediumTable(m    , n, ell + 1);
    XYZ9Med(9) = mediumTable(m + 1, n, ell + 1);

elseif strcmp(CrossTexT, 'XY')
    XYZ9Med(1) = mediumTable(m - 1, n - 1, ell);
    XYZ9Med(2) = mediumTable(m    , n - 1, ell);
    XYZ9Med(3) = mediumTable(m + 1, n - 1, ell);
    XYZ9Med(4) = mediumTable(m - 1, n    , ell);
    XYZ9Med(5) = mediumTable(m    , n    , ell);
    XYZ9Med(6) = mediumTable(m + 1, n    , ell);
    XYZ9Med(7) = mediumTable(m - 1, n + 1, ell);
    XYZ9Med(8) = mediumTable(m    , n + 1, ell);
    XYZ9Med(9) = mediumTable(m + 1, n + 1, ell);

elseif strcmp(CrossTexT, 'YZ')
    XYZ9Med(1) = mediumTable(m, n - 1, ell - 1);
    XYZ9Med(2) = mediumTable(m, n    , ell - 1);
    XYZ9Med(3) = mediumTable(m, n + 1, ell - 1);
    XYZ9Med(4) = mediumTable(m, n - 1, ell    );
    XYZ9Med(5) = mediumTable(m, n    , ell    );
    XYZ9Med(6) = mediumTable(m, n + 1, ell    );
    XYZ9Med(7) = mediumTable(m, n - 1, ell + 1);
    XYZ9Med(8) = mediumTable(m, n    , ell + 1);
    XYZ9Med(9) = mediumTable(m, n + 1, ell + 1);
    
else
    error('check the input parameters');
end

end