function IndvdlValue = calK1_Type1( SideCrdnt, CntrlCrdnt, FaceSegMed, mu_r, SideIdx )
% the center point is a column vector; while the side point are row vector.

switch SideIdx
    case '1'
        IndvdlValue = zeros(1, 25);
        EightTet = zeros(8, 6);

        EightTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), 1, 'inn', mu_r( FaceSegMed(1) ) );
        EightTet(2, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(9, :), 2, 'ext', mu_r( FaceSegMed(2) ) );
        EightTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), 3, 'inn', mu_r( FaceSegMed(3) ) );
        EightTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), 3, 'ext', mu_r( FaceSegMed(4) ) );
        EightTet(5, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), 3, 'ext', mu_r( FaceSegMed(5) ) );
        EightTet(6, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), 2, 'inn', mu_r( FaceSegMed(6) ) );
        EightTet(7, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), 1, 'ext', mu_r( FaceSegMed(7) ) );
        EightTet(8, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), 1, 'inn', mu_r( FaceSegMed(8) ) );

        IndvdlValue(1)  = EightTet(8, 4) + EightTet(1, 5);
        IndvdlValue(2)  = EightTet(1, 6);
        IndvdlValue(3)  = EightTet(1, 4) + EightTet(2, 6);
        IndvdlValue(4)  = EightTet(2, 5);
        IndvdlValue(5)  = EightTet(2, 4) + EightTet(3, 6);
        IndvdlValue(6)  = EightTet(3, 4);
        IndvdlValue(7)  = EightTet(3, 5) + EightTet(4, 5);
        IndvdlValue(8)  = EightTet(4, 4);
        IndvdlValue(9)  = EightTet(4, 6) + EightTet(5, 5);
        IndvdlValue(10) = EightTet(5, 4);
        IndvdlValue(11) = EightTet(5, 6) + EightTet(6, 4);
        IndvdlValue(12) = EightTet(6, 5);
        IndvdlValue(13) = EightTet(6, 6) + EightTet(7, 4);
        IndvdlValue(14) = EightTet(7, 6);
        IndvdlValue(15) = EightTet(7, 5) + EightTet(8, 5);
        IndvdlValue(16) = EightTet(8, 6);

        IndvdlValue(17) = EightTet(1, 3) + EightTet(8, 2);
        IndvdlValue(18) = EightTet(1, 2) + EightTet(2, 3);
        IndvdlValue(19) = EightTet(2, 1) + EightTet(3, 2);
        IndvdlValue(20) = EightTet(3, 1) + EightTet(4, 1);
        IndvdlValue(21) = EightTet(4, 2) + EightTet(5, 1);
        IndvdlValue(22) = EightTet(5, 2) + EightTet(6, 1);
        IndvdlValue(23) = EightTet(6, 3) + EightTet(7, 2);
        IndvdlValue(24) = EightTet(7, 3) + EightTet(8, 3);

        IndvdlValue(25) = EightTet(1, 1) + EightTet(2, 2) + EightTet(3, 3) + EightTet(4, 3) ...
                         + EightTet(5, 3) + EightTet(6, 2) + EightTet(7, 1) + EightTet(8, 1);
    case '2'
        IndvdlValue = zeros(1, 25);
        EightTet = zeros(8, 6);

        EightTet(1, :) = get6EdgeValue( SideCrdnt(9, :), SideCrdnt(6, :), CntrlCrdnt', SideCrdnt(5, :), 6, 'inn', mu_r( FaceSegMed(1) ) );
        EightTet(2, :) = get6EdgeValue( SideCrdnt(9, :), CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), 5, 'inn', mu_r( FaceSegMed(2) ) );
        EightTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(7, :), 2, 'inn', mu_r( FaceSegMed(3) ) );
        EightTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(4, :), 1, 'ext', mu_r( FaceSegMed(4) ) );
        EightTet(5, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(5) ) );
        EightTet(6, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), 1, 'inn', mu_r( FaceSegMed(6) ) );
        EightTet(7, :) = get6EdgeValue( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), 4, 'inn', mu_r( FaceSegMed(7) ) );
        EightTet(8, :) = get6EdgeValue( SideCrdnt(6, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), 6, 'inn', mu_r( FaceSegMed(8) ) );

        IndvdlValue(1)  = EightTet(8, 3) + EightTet(1, 5);
        IndvdlValue(2)  = EightTet(1, 1);
        IndvdlValue(3)  = EightTet(1, 3) + EightTet(2, 3);
        IndvdlValue(4)  = EightTet(2, 2);
        IndvdlValue(5)  = EightTet(2, 6) + EightTet(3, 4);
        IndvdlValue(6)  = EightTet(3, 5);
        IndvdlValue(7)  = EightTet(3, 6) + EightTet(4, 4);
        IndvdlValue(8)  = EightTet(4, 6);
        IndvdlValue(9)  = EightTet(4, 5) + EightTet(5, 4);
        IndvdlValue(10) = EightTet(5, 6);
        IndvdlValue(11) = EightTet(5, 5) + EightTet(6, 5);
        IndvdlValue(12) = EightTet(6, 6);
        IndvdlValue(13) = EightTet(6, 4) + EightTet(7, 6);
        IndvdlValue(14) = EightTet(7, 3);
        IndvdlValue(15) = EightTet(7, 2) + EightTet(8, 5);
        IndvdlValue(16) = EightTet(8, 1);

        IndvdlValue(17) = EightTet(1, 4) + EightTet(8, 2);
        IndvdlValue(18) = EightTet(1, 2) + EightTet(2, 1);
        IndvdlValue(19) = EightTet(2, 4) + EightTet(3, 1);
        IndvdlValue(20) = EightTet(3, 3) + EightTet(4, 2);
        IndvdlValue(21) = EightTet(4, 3) + EightTet(5, 2);
        IndvdlValue(22) = EightTet(5, 3) + EightTet(6, 3);
        IndvdlValue(23) = EightTet(6, 2) + EightTet(7, 5);
        IndvdlValue(24) = EightTet(7, 1) + EightTet(8, 4);

        IndvdlValue(25) = EightTet(1, 6) + EightTet(2, 5) + EightTet(3, 2) + EightTet(4, 1) ...
                         + EightTet(5, 1) + EightTet(6, 1) + EightTet(7, 4) + EightTet(8, 6);
    case '3'
        IndvdlValue = zeros(1, 25);
        EightTet = zeros(8, 6);

        EightTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), 1, 'inn', mu_r( FaceSegMed(1) ) );
        EightTet(2, :) = get6EdgeValue( SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), 4, 'inn', mu_r( FaceSegMed(2) ) );
        EightTet(3, :) = get6EdgeValue( SideCrdnt(7, :), SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), 6, 'inn', mu_r( FaceSegMed(3) ) );
        EightTet(4, :) = get6EdgeValue( SideCrdnt(7, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(5, :), 6, 'ext', mu_r( FaceSegMed(4) ) );
        EightTet(5, :) = get6EdgeValue( SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), 6, 'ext', mu_r( FaceSegMed(5) ) );
        EightTet(6, :) = get6EdgeValue( SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), 4, 'ext', mu_r( FaceSegMed(6) ) );
        EightTet(7, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), 1, 'ext', mu_r( FaceSegMed(7) ) );
        EightTet(8, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), 1, 'inn', mu_r( FaceSegMed(8) ) );

        IndvdlValue(1)  = EightTet(1, 5) + EightTet(8, 4);
        IndvdlValue(2)  = EightTet(1, 6);
        IndvdlValue(3)  = EightTet(1, 4) + EightTet(2, 6);
        IndvdlValue(4)  = EightTet(2, 3);
        IndvdlValue(5)  = EightTet(2, 2) + EightTet(3, 5);
        IndvdlValue(6)  = EightTet(3, 1);
        IndvdlValue(7)  = EightTet(3, 3) + EightTet(4, 3);
        IndvdlValue(8)  = EightTet(4, 1);
        IndvdlValue(9)  = EightTet(4, 5) + EightTet(5, 3);
        IndvdlValue(10) = EightTet(5, 1);
        IndvdlValue(11) = EightTet(5, 5) + EightTet(6, 2);
        IndvdlValue(12) = EightTet(6, 3);
        IndvdlValue(13) = EightTet(6, 6) + EightTet(7, 4);
        IndvdlValue(14) = EightTet(7, 6);
        IndvdlValue(15) = EightTet(7, 5) + EightTet(8, 5);
        IndvdlValue(16) = EightTet(8, 6);

        IndvdlValue(17) = EightTet(1, 3) + EightTet(8, 2);
        IndvdlValue(18) = EightTet(1, 2) + EightTet(2, 5);
        IndvdlValue(19) = EightTet(2, 1) + EightTet(3, 4);
        IndvdlValue(20) = EightTet(3, 2) + EightTet(4, 2);
        IndvdlValue(21) = EightTet(4, 4) + EightTet(5, 2);
        IndvdlValue(22) = EightTet(5, 4) + EightTet(6, 1);
        IndvdlValue(23) = EightTet(6, 5) + EightTet(7, 2);
        IndvdlValue(24) = EightTet(7, 3) + EightTet(8, 3);

        IndvdlValue(25) = EightTet(1, 1) + EightTet(2, 4) + EightTet(3, 6) + EightTet(4, 6) ...
                         + EightTet(5, 6) + EightTet(6, 4) + EightTet(7, 1) + EightTet(8, 1);
    case '4'
        IndvdlValue = zeros(1, 13);
        FourTet = zeros(4, 6);

        FourTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(1) ) );
        FourTet(2, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(2) ) );
        FourTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'inn', mu_r( FaceSegMed(3) ) );
        FourTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ) );

        IndvdlValue(1)  = FourTet(1, 5) + FourTet(4, 4);
        IndvdlValue(2)  = FourTet(1, 4);
        IndvdlValue(3)  = FourTet(1, 6) + FourTet(2, 6);
        IndvdlValue(4)  = FourTet(2, 4);
        IndvdlValue(5)  = FourTet(2, 5) + FourTet(3, 4);
        IndvdlValue(6)  = FourTet(3, 5);
        IndvdlValue(7)  = FourTet(3, 6) + FourTet(4, 6);
        IndvdlValue(8)  = FourTet(4, 5);

        IndvdlValue(9)  = FourTet(1, 1) + FourTet(4, 1);
        IndvdlValue(10) = FourTet(1, 2) + FourTet(2, 2);
        IndvdlValue(11) = FourTet(2, 1) + FourTet(3, 1);
        IndvdlValue(12) = FourTet(3, 3) + FourTet(4, 3);

        IndvdlValue(13) = FourTet(1, 3) + FourTet(2, 3) + FourTet(3, 2) + FourTet(4, 2);
    case '5'
        IndvdlValue = zeros(1, 13);
        FourTet = zeros(4, 6);

        FourTet(1, :) = get6EdgeValue( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(1) ) );
        FourTet(2, :) = get6EdgeValue( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), 5, 'inn', mu_r( FaceSegMed(2) ) );
        FourTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'inn', mu_r( FaceSegMed(3) ) );
        FourTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ) );

        IndvdlValue(1)  = FourTet(1, 6) + FourTet(4, 4);
        IndvdlValue(2)  = FourTet(1, 2);
        IndvdlValue(3)  = FourTet(1, 3) + FourTet(2, 3);
        IndvdlValue(4)  = FourTet(2, 2);
        IndvdlValue(5)  = FourTet(2, 6) + FourTet(3, 4);
        IndvdlValue(6)  = FourTet(3, 5);
        IndvdlValue(7)  = FourTet(3, 6) + FourTet(4, 6);
        IndvdlValue(8)  = FourTet(4, 5);

        IndvdlValue(9)  = FourTet(1, 4) + FourTet(4, 1);
        IndvdlValue(10) = FourTet(1, 1) + FourTet(2, 1);
        IndvdlValue(11) = FourTet(2, 4) + FourTet(3, 1);
        IndvdlValue(12) = FourTet(3, 3) + FourTet(4, 3);

        IndvdlValue(13) = FourTet(1, 5) + FourTet(2, 5) + FourTet(3, 2) + FourTet(4, 2);
    case '6'
        IndvdlValue = zeros(1, 13);
        FourTet = zeros(4, 6);

        FourTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(1) ) );
        FourTet(2, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(2) ) );
        FourTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'inn', mu_r( FaceSegMed(3) ) );
        FourTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ) );

        IndvdlValue(1)  = FourTet(1, 6) + FourTet(4, 4);
        IndvdlValue(2)  = FourTet(1, 4);
        IndvdlValue(3)  = FourTet(1, 5) + FourTet(2, 6);
        IndvdlValue(4)  = FourTet(2, 4);
        IndvdlValue(5)  = FourTet(2, 5) + FourTet(3, 4);
        IndvdlValue(6)  = FourTet(3, 5);
        IndvdlValue(7)  = FourTet(3, 6) + FourTet(4, 6);
        IndvdlValue(8)  = FourTet(4, 5);

        IndvdlValue(9)  = FourTet(1, 2) + FourTet(4, 1);
        IndvdlValue(10) = FourTet(1, 1) + FourTet(2, 2);
        IndvdlValue(11) = FourTet(2, 1) + FourTet(3, 1);
        IndvdlValue(12) = FourTet(3, 3) + FourTet(4, 3);

        IndvdlValue(13) = FourTet(1, 3) + FourTet(2, 3) + FourTet(3, 2) + FourTet(4, 2);
    case '7'
        IndvdlValue = zeros(1, 19);
        SixTet = zeros(6, 6);

        % K_1: the 1-st to the 8-th tetdrahedron
        SixTet(1, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(1) ) );
        SixTet(2, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(6, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(2) ) );
        SixTet(3, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(3) ) );
        SixTet(4, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(4) ) );
        SixTet(5, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(2, :), SideCrdnt(3, :), 3, 'inn', mu_r( FaceSegMed(5) ) );
        SixTet(6, :) = get6EdgeValue( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(4, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(6) ) );

        IndvdlValue(1)  = SixTet(1, 6) + SixTet(6, 6);
        IndvdlValue(2)  = SixTet(1, 4);
        IndvdlValue(3)  = SixTet(1, 5) + SixTet(2, 5);
        IndvdlValue(4)  = SixTet(2, 4);
        IndvdlValue(5)  = SixTet(2, 6) + SixTet(3, 6);
        IndvdlValue(6)  = SixTet(3, 4);
        IndvdlValue(7)  = SixTet(3, 5) + SixTet(4, 5);
        IndvdlValue(8)  = SixTet(4, 4);
        IndvdlValue(9)  = SixTet(4, 6) + SixTet(5, 6);
        IndvdlValue(10) = SixTet(5, 4);
        IndvdlValue(11) = SixTet(5, 5) + SixTet(6, 5);
        IndvdlValue(12) = SixTet(6, 4);

        IndvdlValue(13) = SixTet(1, 2) + SixTet(6, 2);
        IndvdlValue(14) = SixTet(1, 1) + SixTet(2, 1);
        IndvdlValue(15) = SixTet(2, 2) + SixTet(3, 2);
        IndvdlValue(16) = SixTet(3, 1) + SixTet(4, 1);
        IndvdlValue(17) = SixTet(4, 2) + SixTet(5, 2);
        IndvdlValue(18) = SixTet(5, 1) + SixTet(6, 1);

        IndvdlValue(19) = sum(SixTet(:, 3));
    end

end
