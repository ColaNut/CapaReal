function Tet48Crdnt = get48TetCrdnt( MidPntsCrdnt )
    Tet48Crdnt = zeros(6, 8, 3);
    % MidPntsCrdnt  = zeros( 3, 9, 3 );

    Tet48Crdnt(1, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 6, :) + MidPntsCrdnt( 3, 9, :) ) / 4;
    Tet48Crdnt(1, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 9, :) + MidPntsCrdnt( 3, 8, :) ) / 4;
    Tet48Crdnt(1, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 8, :) + MidPntsCrdnt( 3, 7, :) ) / 4;
    Tet48Crdnt(1, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 7, :) + MidPntsCrdnt( 3, 4, :) ) / 4;
    Tet48Crdnt(1, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 4, :) + MidPntsCrdnt( 3, 1, :) ) / 4;
    Tet48Crdnt(1, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 1, :) + MidPntsCrdnt( 3, 2, :) ) / 4;
    Tet48Crdnt(1, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 2, :) + MidPntsCrdnt( 3, 3, :) ) / 4;
    Tet48Crdnt(1, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 3, 5, :) + MidPntsCrdnt( 3, 3, :) + MidPntsCrdnt( 3, 6, :) ) / 4;

    Tet48Crdnt(2, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 2, 1, :) + MidPntsCrdnt( 3, 1, :) ) / 4;
    Tet48Crdnt(2, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 3, 1, :) + MidPntsCrdnt( 3, 4, :) ) / 4;
    Tet48Crdnt(2, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 3, 4, :) + MidPntsCrdnt( 3, 7, :) ) / 4;
    Tet48Crdnt(2, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 3, 7, :) + MidPntsCrdnt( 2, 7, :) ) / 4;
    Tet48Crdnt(2, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 2, 7, :) + MidPntsCrdnt( 1, 7, :) ) / 4;
    Tet48Crdnt(2, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 1, 7, :) + MidPntsCrdnt( 1, 4, :) ) / 4;
    Tet48Crdnt(2, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 1, 4, :) + MidPntsCrdnt( 1, 1, :) ) / 4;
    Tet48Crdnt(2, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 4, :) + MidPntsCrdnt( 1, 1, :) + MidPntsCrdnt( 2, 1, :) ) / 4;

    Tet48Crdnt(3, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 4, :) + MidPntsCrdnt( 1, 7, :) ) / 4;
    Tet48Crdnt(3, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 7, :) + MidPntsCrdnt( 1, 8, :) ) / 4;
    Tet48Crdnt(3, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 8, :) + MidPntsCrdnt( 1, 9, :) ) / 4;
    Tet48Crdnt(3, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 9, :) + MidPntsCrdnt( 1, 6, :) ) / 4;
    Tet48Crdnt(3, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 6, :) + MidPntsCrdnt( 1, 3, :) ) / 4;
    Tet48Crdnt(3, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 3, :) + MidPntsCrdnt( 1, 2, :) ) / 4;
    Tet48Crdnt(3, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 2, :) + MidPntsCrdnt( 1, 1, :) ) / 4;
    Tet48Crdnt(3, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 1, 5, :) + MidPntsCrdnt( 1, 1, :) + MidPntsCrdnt( 1, 4, :) ) / 4;

    Tet48Crdnt(4, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 2, 9, :) + MidPntsCrdnt( 3, 9, :) ) / 4;
    Tet48Crdnt(4, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 3, 9, :) + MidPntsCrdnt( 3, 6, :) ) / 4;
    Tet48Crdnt(4, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 3, 6, :) + MidPntsCrdnt( 3, 3, :) ) / 4;
    Tet48Crdnt(4, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 3, 3, :) + MidPntsCrdnt( 2, 3, :) ) / 4;
    Tet48Crdnt(4, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 2, 3, :) + MidPntsCrdnt( 1, 3, :) ) / 4;
    Tet48Crdnt(4, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 1, 3, :) + MidPntsCrdnt( 1, 6, :) ) / 4;
    Tet48Crdnt(4, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 1, 6, :) + MidPntsCrdnt( 1, 9, :) ) / 4;
    Tet48Crdnt(4, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 6, :) + MidPntsCrdnt( 1, 9, :) + MidPntsCrdnt( 2, 9, :) ) / 4;

    Tet48Crdnt(5, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 2, 7, :) + MidPntsCrdnt( 3, 7, :) ) / 4;
    Tet48Crdnt(5, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 3, 7, :) + MidPntsCrdnt( 3, 8, :) ) / 4;
    Tet48Crdnt(5, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 3, 8, :) + MidPntsCrdnt( 3, 9, :) ) / 4;
    Tet48Crdnt(5, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 3, 9, :) + MidPntsCrdnt( 2, 9, :) ) / 4;
    Tet48Crdnt(5, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 2, 9, :) + MidPntsCrdnt( 1, 9, :) ) / 4;
    Tet48Crdnt(5, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 1, 9, :) + MidPntsCrdnt( 1, 8, :) ) / 4;
    Tet48Crdnt(5, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 1, 8, :) + MidPntsCrdnt( 1, 7, :) ) / 4;
    Tet48Crdnt(5, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 8, :) + MidPntsCrdnt( 1, 7, :) + MidPntsCrdnt( 2, 7, :) ) / 4;

    Tet48Crdnt(6, 1, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 2, 3, :) + MidPntsCrdnt( 3, 3, :) ) / 4;
    Tet48Crdnt(6, 2, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 3, 3, :) + MidPntsCrdnt( 3, 2, :) ) / 4;
    Tet48Crdnt(6, 3, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 3, 2, :) + MidPntsCrdnt( 3, 1, :) ) / 4;
    Tet48Crdnt(6, 4, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 3, 1, :) + MidPntsCrdnt( 2, 1, :) ) / 4;
    Tet48Crdnt(6, 5, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 2, 1, :) + MidPntsCrdnt( 1, 1, :) ) / 4;
    Tet48Crdnt(6, 6, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 1, 1, :) + MidPntsCrdnt( 1, 2, :) ) / 4;
    Tet48Crdnt(6, 7, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 1, 2, :) + MidPntsCrdnt( 1, 3, :) ) / 4;
    Tet48Crdnt(6, 8, :) = ( MidPntsCrdnt( 2, 5, :) + MidPntsCrdnt( 2, 2, :) + MidPntsCrdnt( 1, 3, :) + MidPntsCrdnt( 2, 3, :) ) / 4;

end