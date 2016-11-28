function XZ9Med = getXZ9Med( m, n, ell, mediumTable )

XZ9Med = ones( 9, 1, 'uint8');

XZ9Med(1) = mediumTable(m - 1, n, ell - 1);
XZ9Med(2) = mediumTable(m    , n, ell - 1);
XZ9Med(3) = mediumTable(m + 1, n, ell - 1);
XZ9Med(4) = mediumTable(m - 1, n, ell    );
XZ9Med(5) = mediumTable(m    , n, ell    );
XZ9Med(6) = mediumTable(m + 1, n, ell    );
XZ9Med(7) = mediumTable(m - 1, n, ell + 1);
XZ9Med(8) = mediumTable(m    , n, ell + 1);
XZ9Med(9) = mediumTable(m + 1, n, ell + 1);

end