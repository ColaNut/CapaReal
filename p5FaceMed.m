function [ tmpMed2Layers ] = p5FaceMed( mediumTable )

    tmpMed2Layers(1, 1) = mediumTable(1, 9);
    tmpMed2Layers(1, 2) = mediumTable(1, 8);
    tmpMed2Layers(1, 3) = mediumTable(1, 7);
    tmpMed2Layers(1, 4) = mediumTable(2, 9);
    tmpMed2Layers(1, 5) = mediumTable(2, 8);
    tmpMed2Layers(1, 6) = mediumTable(2, 7);
    tmpMed2Layers(1, 7) = mediumTable(3, 9);
    tmpMed2Layers(1, 8) = mediumTable(3, 8);
    tmpMed2Layers(1, 9) = mediumTable(3, 7);

    tmpMed2Layers(2, 1) = mediumTable(1, 6);
    tmpMed2Layers(2, 2) = mediumTable(1, 5);
    tmpMed2Layers(2, 3) = mediumTable(1, 4);
    tmpMed2Layers(2, 4) = mediumTable(2, 6);
    tmpMed2Layers(2, 5) = mediumTable(2, 5);
    tmpMed2Layers(2, 6) = mediumTable(2, 4);
    tmpMed2Layers(2, 7) = mediumTable(3, 6);
    tmpMed2Layers(2, 8) = mediumTable(3, 5);
    tmpMed2Layers(2, 9) = mediumTable(3, 4);

end