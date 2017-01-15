function SegMed = RecoverSegMed( SegMedOri, QuadrantNum )

    SegMed = ones( 6, 8, 'uint8' );
    % transform from second quadrant to other quadrant
    if QuadrantNum == 2
        SegMed = SegMedOri;
    elseif QuadrantNum == 1
        SegMed(1, 1) = SegMedOri(1, 4);    SegMed(2, 1) = SegMedOri(4, 4);    SegMed(3, 1) = SegMedOri(3, 4);
        SegMed(1, 2) = SegMedOri(1, 3);    SegMed(2, 2) = SegMedOri(4, 3);    SegMed(3, 2) = SegMedOri(3, 3);
        SegMed(1, 3) = SegMedOri(1, 2);    SegMed(2, 3) = SegMedOri(4, 2);    SegMed(3, 3) = SegMedOri(3, 2);
        SegMed(1, 4) = SegMedOri(1, 1);    SegMed(2, 4) = SegMedOri(4, 1);    SegMed(3, 4) = SegMedOri(3, 1);
        SegMed(1, 5) = SegMedOri(1, 8);    SegMed(2, 5) = SegMedOri(4, 8);    SegMed(3, 5) = SegMedOri(3, 8);
        SegMed(1, 6) = SegMedOri(1, 7);    SegMed(2, 6) = SegMedOri(4, 7);    SegMed(3, 6) = SegMedOri(3, 7);
        SegMed(1, 7) = SegMedOri(1, 6);    SegMed(2, 7) = SegMedOri(4, 6);    SegMed(3, 7) = SegMedOri(3, 6);
        SegMed(1, 8) = SegMedOri(1, 5);    SegMed(2, 8) = SegMedOri(4, 5);    SegMed(3, 8) = SegMedOri(3, 5);

        SegMed(4, 1) = SegMedOri(2, 4);    SegMed(5, 1) = SegMedOri(5, 4);    SegMed(6, 1) = SegMedOri(6, 4);
        SegMed(4, 2) = SegMedOri(2, 3);    SegMed(5, 2) = SegMedOri(5, 3);    SegMed(6, 2) = SegMedOri(6, 3);
        SegMed(4, 3) = SegMedOri(2, 2);    SegMed(5, 3) = SegMedOri(5, 2);    SegMed(6, 3) = SegMedOri(6, 2);
        SegMed(4, 4) = SegMedOri(2, 1);    SegMed(5, 4) = SegMedOri(5, 1);    SegMed(6, 4) = SegMedOri(6, 1);
        SegMed(4, 5) = SegMedOri(2, 8);    SegMed(5, 5) = SegMedOri(5, 8);    SegMed(6, 5) = SegMedOri(6, 8);
        SegMed(4, 6) = SegMedOri(2, 7);    SegMed(5, 6) = SegMedOri(5, 7);    SegMed(6, 6) = SegMedOri(6, 7);
        SegMed(4, 7) = SegMedOri(2, 6);    SegMed(5, 7) = SegMedOri(5, 6);    SegMed(6, 7) = SegMedOri(6, 6);
        SegMed(4, 8) = SegMedOri(2, 5);    SegMed(5, 8) = SegMedOri(5, 5);    SegMed(6, 8) = SegMedOri(6, 5);
    elseif QuadrantNum == 3
        SegMed(1, 1) = SegMedOri(3, 4);    SegMed(2, 1) = SegMedOri(2, 8);    SegMed(3, 1) = SegMedOri(1, 4);
        SegMed(1, 2) = SegMedOri(3, 3);    SegMed(2, 2) = SegMedOri(2, 7);    SegMed(3, 2) = SegMedOri(1, 3);
        SegMed(1, 3) = SegMedOri(3, 2);    SegMed(2, 3) = SegMedOri(2, 6);    SegMed(3, 3) = SegMedOri(1, 2);
        SegMed(1, 4) = SegMedOri(3, 1);    SegMed(2, 4) = SegMedOri(2, 5);    SegMed(3, 4) = SegMedOri(1, 1);
        SegMed(1, 5) = SegMedOri(3, 8);    SegMed(2, 5) = SegMedOri(2, 4);    SegMed(3, 5) = SegMedOri(1, 8);
        SegMed(1, 6) = SegMedOri(3, 7);    SegMed(2, 6) = SegMedOri(2, 3);    SegMed(3, 6) = SegMedOri(1, 7);
        SegMed(1, 7) = SegMedOri(3, 6);    SegMed(2, 7) = SegMedOri(2, 2);    SegMed(3, 7) = SegMedOri(1, 6);
        SegMed(1, 8) = SegMedOri(3, 5);    SegMed(2, 8) = SegMedOri(2, 1);    SegMed(3, 8) = SegMedOri(1, 5);

        SegMed(4, 1) = SegMedOri(4, 8);    SegMed(5, 1) = SegMedOri(5, 8);    SegMed(6, 1) = SegMedOri(6, 8);
        SegMed(4, 2) = SegMedOri(4, 7);    SegMed(5, 2) = SegMedOri(5, 7);    SegMed(6, 2) = SegMedOri(6, 7);
        SegMed(4, 3) = SegMedOri(4, 6);    SegMed(5, 3) = SegMedOri(5, 6);    SegMed(6, 3) = SegMedOri(6, 6);
        SegMed(4, 4) = SegMedOri(4, 5);    SegMed(5, 4) = SegMedOri(5, 5);    SegMed(6, 4) = SegMedOri(6, 5);
        SegMed(4, 5) = SegMedOri(4, 4);    SegMed(5, 5) = SegMedOri(5, 4);    SegMed(6, 5) = SegMedOri(6, 4);
        SegMed(4, 6) = SegMedOri(4, 3);    SegMed(5, 6) = SegMedOri(5, 3);    SegMed(6, 6) = SegMedOri(6, 3);
        SegMed(4, 7) = SegMedOri(4, 2);    SegMed(5, 7) = SegMedOri(5, 2);    SegMed(6, 7) = SegMedOri(6, 2);
        SegMed(4, 8) = SegMedOri(4, 1);    SegMed(5, 8) = SegMedOri(5, 1);    SegMed(6, 8) = SegMedOri(6, 1);
    elseif QuadrantNum == 4
        SegMed(1, 1) = SegMedOri(3, 1);    SegMed(2, 1) = SegMedOri(4, 5);    SegMed(3, 1) = SegMedOri(1, 1);
        SegMed(1, 2) = SegMedOri(3, 2);    SegMed(2, 2) = SegMedOri(4, 6);    SegMed(3, 2) = SegMedOri(1, 2);
        SegMed(1, 3) = SegMedOri(3, 3);    SegMed(2, 3) = SegMedOri(4, 7);    SegMed(3, 3) = SegMedOri(1, 3);
        SegMed(1, 4) = SegMedOri(3, 4);    SegMed(2, 4) = SegMedOri(4, 8);    SegMed(3, 4) = SegMedOri(1, 4);
        SegMed(1, 5) = SegMedOri(3, 5);    SegMed(2, 5) = SegMedOri(4, 1);    SegMed(3, 5) = SegMedOri(1, 5);
        SegMed(1, 6) = SegMedOri(3, 6);    SegMed(2, 6) = SegMedOri(4, 2);    SegMed(3, 6) = SegMedOri(1, 6);
        SegMed(1, 7) = SegMedOri(3, 7);    SegMed(2, 7) = SegMedOri(4, 3);    SegMed(3, 7) = SegMedOri(1, 7);
        SegMed(1, 8) = SegMedOri(3, 8);    SegMed(2, 8) = SegMedOri(4, 4);    SegMed(3, 8) = SegMedOri(1, 8);

        SegMed(4, 1) = SegMedOri(2, 5);    SegMed(5, 1) = SegMedOri(5, 5);    SegMed(6, 1) = SegMedOri(6, 5);
        SegMed(4, 2) = SegMedOri(2, 6);    SegMed(5, 2) = SegMedOri(5, 6);    SegMed(6, 2) = SegMedOri(6, 6);
        SegMed(4, 3) = SegMedOri(2, 7);    SegMed(5, 3) = SegMedOri(5, 7);    SegMed(6, 3) = SegMedOri(6, 7);
        SegMed(4, 4) = SegMedOri(2, 8);    SegMed(5, 4) = SegMedOri(5, 8);    SegMed(6, 4) = SegMedOri(6, 8);
        SegMed(4, 5) = SegMedOri(2, 1);    SegMed(5, 5) = SegMedOri(5, 1);    SegMed(6, 5) = SegMedOri(6, 1);
        SegMed(4, 6) = SegMedOri(2, 2);    SegMed(5, 6) = SegMedOri(5, 2);    SegMed(6, 6) = SegMedOri(6, 2);
        SegMed(4, 7) = SegMedOri(2, 3);    SegMed(5, 7) = SegMedOri(5, 3);    SegMed(6, 7) = SegMedOri(6, 3);
        SegMed(4, 8) = SegMedOri(2, 4);    SegMed(5, 8) = SegMedOri(5, 4);    SegMed(6, 8) = SegMedOri(6, 4);
    end


end