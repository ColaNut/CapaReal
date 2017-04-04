function IndvdlValue = calK1_mn( SideCrdnt, CntrlCrdnt, FaceSegMed, mu_r )
    
    IndvdlValue = zeros(1, 25);

    EightTet = zeros(8, 6);
% the center point is a column vector; while the side point are row vector.

    % S_1: the 1-st to the 8-th tetdrahedron
    EightTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), mu_r( FaceSegMed(1) ) );
    EightTet(2, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(8, :), SideCrdnt(9, :), mu_r( FaceSegMed(2) ) );
    EightTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(8, :), mu_r( FaceSegMed(3) ) );
    EightTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(7, :), mu_r( FaceSegMed(4) ) );
    EightTet(5, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(1, :), SideCrdnt(4, :), mu_r( FaceSegMed(5) ) );
    EightTet(6, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), mu_r( FaceSegMed(6) ) );
    EightTet(7, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), mu_r( FaceSegMed(7) ) );
    EightTet(8, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), mu_r( FaceSegMed(8) ) );

    IndvdlValue(1)  = EightTet(8, 4) + EightTet(1, 5);
    IndvdlValue(2)  = EightTet(1, 6);
    IndvdlValue(3)  = EightTet(1, 4) + EightTet(2, 5);
    IndvdlValue(4)  = EightTet(2, 6);
    IndvdlValue(5)  = EightTet(2, 4) + EightTet(3, 5);
    IndvdlValue(6)  = EightTet(3, 6);
    IndvdlValue(7)  = EightTet(3, 4) + EightTet(4, 5);
    IndvdlValue(8)  = EightTet(4, 6);
    IndvdlValue(9)  = EightTet(4, 4) + EightTet(5, 5);
    IndvdlValue(10) = EightTet(5, 6);
    IndvdlValue(11) = EightTet(5, 4) + EightTet(6, 5);
    IndvdlValue(12) = EightTet(6, 6);
    IndvdlValue(13) = EightTet(6, 4) + EightTet(7, 5);
    IndvdlValue(14) = EightTet(7, 6);
    IndvdlValue(15) = EightTet(7, 4) + EightTet(8, 5);
    IndvdlValue(16) = EightTet(8, 6);

    IndvdlValue(17) = EightTet(1, 3) + EightTet(8, 2);
    IndvdlValue(18) = EightTet(1, 2) + EightTet(2, 3);
    IndvdlValue(19) = EightTet(2, 2) + EightTet(3, 3);
    IndvdlValue(20) = EightTet(3, 2) + EightTet(4, 3);
    IndvdlValue(21) = EightTet(4, 2) + EightTet(5, 3);
    IndvdlValue(22) = EightTet(5, 2) + EightTet(6, 3);
    IndvdlValue(23) = EightTet(6, 2) + EightTet(7, 3);
    IndvdlValue(24) = EightTet(7, 2) + EightTet(8, 3);

    IndvdlValue(25) = sum(EightTet(:, 1));

end
