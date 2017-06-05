function [ K1_Value, KEV_Value, KVE_Value ] = calK_Type3( SideCrdnt, CntrlCrdnt, FaceSegMed, ...
                                                                mu_r, epsilon_r, corner_flag, SideIdx )
% the center point is a column vector; while the side point are row vector.

switch SideIdx
    case '1'
        K1_Value  = zeros(1, 13);
        KEV_Value = zeros(1, 6);
        KVE_Value = zeros(6, 1);
        FourTet_e = zeros(4, 6);
        FourTet_v = zeros(4, 4);

        [ FourTet_e(1, :), FourTet_v(1, :) ] = get6E4V( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ FourTet_e(2, :), FourTet_v(2, :) ] = get6E4V( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ FourTet_e(3, :), FourTet_v(3, :) ] = get6E4V( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ FourTet_e(4, :), FourTet_v(4, :) ] = get6E4V( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );

        % trim
        if corner_flag(1, 1)
            vec = [1, 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(1, 5)
            vec = [2, 3];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [1, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        K1_Value(1)  = FourTet_e(1, 5) + FourTet_e(4, 4);
        K1_Value(2)  = FourTet_e(1, 4);
        K1_Value(3)  = FourTet_e(1, 6) + FourTet_e(2, 6);
        K1_Value(4)  = FourTet_e(2, 2);
        K1_Value(5)  = FourTet_e(2, 3) + FourTet_e(3, 2);
        K1_Value(6)  = FourTet_e(3, 3);
        K1_Value(7)  = FourTet_e(3, 6) + FourTet_e(4, 6);
        K1_Value(8)  = FourTet_e(4, 5);
        K1_Value(9)  = FourTet_e(1, 1) + FourTet_e(4, 1);
        K1_Value(10) = FourTet_e(1, 2) + FourTet_e(2, 4);
        K1_Value(11) = FourTet_e(2, 1) + FourTet_e(3, 1);
        K1_Value(12) = FourTet_e(3, 5) + FourTet_e(4, 3);
        K1_Value(13) = FourTet_e(1, 3) + FourTet_e(2, 5) + FourTet_e(3, 4) + FourTet_e(4, 2);

        KEV_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KEV_Value(2) = FourTet_v(2, 1) + FourTet_v(3, 1);
        KEV_Value(3) = FourTet_v(1, 4) + FourTet_v(2, 4) + FourTet_v(3, 3) + FourTet_v(4, 3);
        KEV_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 2);
        KEV_Value(5) = FourTet_v(1, 3) + FourTet_v(2, 3);
        KEV_Value(6) = FourTet_v(1, 1) + FourTet_v(2, 2) + FourTet_v(3, 2) + FourTet_v(4, 1);

        FourTet_v = - FourTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        % no volume for KVE
        % on Gamma surface
        if corner_flag(1, 1)
            hat_n = [0, 0, 1];
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Surface' );
        end
        if corner_flag(2, 6)
            hat_n = [0, - 1, 0];
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 1, hat_n, 'Surface' );
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(2, 3)
            hat_n = [0, 0, - 1];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 3, hat_n, 'Surface' );
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 3, hat_n, 'Surface' );
        end
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), 3, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 2, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), 2, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 2, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 1)
            vec = [1, 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(1, 5)
            vec = [2, 3];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [1, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        KVE_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KVE_Value(2) = FourTet_v(2, 1) + FourTet_v(3, 1);
        KVE_Value(3) = FourTet_v(1, 4) + FourTet_v(2, 4) + FourTet_v(3, 3) + FourTet_v(4, 3);
        KVE_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 2);
        KVE_Value(5) = FourTet_v(1, 3) + FourTet_v(2, 3);
        KVE_Value(6) = FourTet_v(1, 1) + FourTet_v(2, 2) + FourTet_v(3, 2) + FourTet_v(4, 1);
    case '2'
        K1_Value  = zeros(1, 25);
        KEV_Value = zeros(1, 10);
        KVE_Value = zeros(10, 1);
        EightTet_e = zeros(8, 6);
        EightTet_v = zeros(8, 4);

        [ EightTet_e(1, :), EightTet_v(1, :) ] = get6E4V( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), SideCrdnt(6, :), 1, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ EightTet_e(2, :), EightTet_v(2, :) ] = get6E4V( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ EightTet_e(3, :), EightTet_v(3, :) ] = get6E4V( SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ EightTet_e(4, :), EightTet_v(4, :) ] = get6E4V( SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );
        [ EightTet_e(5, :), EightTet_v(5, :) ] = get6E4V( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ) );
        [ EightTet_e(6, :), EightTet_v(6, :) ] = get6E4V( SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ) );
        [ EightTet_e(7, :), EightTet_v(7, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), 2, 'ext', mu_r( FaceSegMed(7) ), epsilon_r( FaceSegMed(7) ) );
        [ EightTet_e(8, :), EightTet_v(8, :) ] = get6E4V( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), 1, 'ext', mu_r( FaceSegMed(8) ), epsilon_r( FaceSegMed(8) ) );

        % trim
        if corner_flag(1, 1)
            vec = [1: 4];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(1, 4)
            vec = [3: 6];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [1, 2, 7, 8];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [5: 8];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end

        K1_Value(1)  = EightTet_e(1, 3) + EightTet_e(8, 2);
        K1_Value(2)  = EightTet_e(1, 6);
        K1_Value(3)  = EightTet_e(1, 2) + EightTet_e(2, 5);
        K1_Value(4)  = EightTet_e(2, 3);
        K1_Value(5)  = EightTet_e(2, 1) + EightTet_e(3, 4);
        K1_Value(6)  = EightTet_e(3, 1);
        K1_Value(7)  = EightTet_e(3, 2) + EightTet_e(4, 2);
        K1_Value(8)  = EightTet_e(4, 1);
        K1_Value(9)  = EightTet_e(4, 4) + EightTet_e(5, 2);
        K1_Value(10) = EightTet_e(5, 1);
        K1_Value(11) = EightTet_e(5, 4) + EightTet_e(6, 1);
        K1_Value(12) = EightTet_e(6, 2);
        K1_Value(13) = EightTet_e(6, 4) + EightTet_e(7, 1);
        K1_Value(14) = EightTet_e(7, 5);
        K1_Value(15) = EightTet_e(7, 3) + EightTet_e(8, 3);
        K1_Value(16) = EightTet_e(8, 6);
        K1_Value(17) = EightTet_e(1, 5) + EightTet_e(8, 4);
        K1_Value(18) = EightTet_e(1, 4) + EightTet_e(2, 6);
        K1_Value(19) = EightTet_e(2, 2) + EightTet_e(3, 5);
        K1_Value(20) = EightTet_e(3, 3) + EightTet_e(4, 3);
        K1_Value(21) = EightTet_e(4, 5) + EightTet_e(5, 3);
        K1_Value(22) = EightTet_e(5, 5) + EightTet_e(6, 3);
        K1_Value(23) = EightTet_e(6, 6) + EightTet_e(7, 4);
        K1_Value(24) = EightTet_e(7, 6) + EightTet_e(8, 5);
        K1_Value(25) = EightTet_e(1, 1) + EightTet_e(2, 4) + EightTet_e(3, 6) + EightTet_e(4, 6) ...
                         + EightTet_e(5, 6) + EightTet_e(6, 5) + EightTet_e(7, 2) + EightTet_e(8, 1);

        KEV_Value(1) = EightTet_v(5, 2) + EightTet_v(6, 1);
        KEV_Value(2) = EightTet_v(6, 3) + EightTet_v(7, 2);
        KEV_Value(3) = EightTet_v(7, 4) + EightTet_v(8, 4);
        KEV_Value(4) = EightTet_v(4, 2) + EightTet_v(5, 1);
        KEV_Value(5) = EightTet_v(1, 1) + EightTet_v(2, 2) + EightTet_v(3, 3) + EightTet_v(4, 3) ...
                        + EightTet_v(5, 3) + EightTet_v(6, 2) + EightTet_v(7, 1) + EightTet_v(8, 1);
        KEV_Value(6) = EightTet_v(1, 4) + EightTet_v(8, 3);
        KEV_Value(7) = EightTet_v(3, 1) + EightTet_v(4, 1);
        KEV_Value(8) = EightTet_v(2, 1) + EightTet_v(3, 2);
        KEV_Value(9) = EightTet_v(1, 3) + EightTet_v(2, 4);
        KEV_Value(10) = EightTet_v(1, 2) + EightTet_v(2, 3) + EightTet_v(3, 4) + EightTet_v(4, 4) ...
                        + EightTet_v(5, 4) + EightTet_v(6, 4) + EightTet_v(7, 3) + EightTet_v(8, 2);

        EightTet_v = - EightTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            EightTet_v(1, :) = EightTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), SideCrdnt(6, :), 1, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 2, hat_n, 'Volume' );
            EightTet_v(2, :) = EightTet_v(2, :) + calKVE_TetPatch( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 3, hat_n, 'Volume' );
            EightTet_v(3, :) = EightTet_v(3, :) + calKVE_TetPatch( SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Volume' );
            EightTet_v(4, :) = EightTet_v(4, :) + calKVE_TetPatch( SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Volume' );
            EightTet_v(5, :) = EightTet_v(5, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ), 4, hat_n, 'Volume' );
            EightTet_v(6, :) = EightTet_v(6, :) + calKVE_TetPatch( SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ), 4, hat_n, 'Volume' );
            EightTet_v(7, :) = EightTet_v(7, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), 2, 'ext', mu_r( FaceSegMed(7) ), epsilon_r( FaceSegMed(7) ), 3, hat_n, 'Volume' );
            EightTet_v(8, :) = EightTet_v(8, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), 1, 'ext', mu_r( FaceSegMed(8) ), epsilon_r( FaceSegMed(8) ), 2, hat_n, 'Volume' );
        end

        % on Gamma surface
        if corner_flag(1, 1)
            hat_n = [0, 0, 1];
            EightTet_v(5, :) = EightTet_v(5, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ), 2, hat_n, 'Surface' );
            EightTet_v(8, :) = EightTet_v(8, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), 1, 'ext', mu_r( FaceSegMed(8) ), epsilon_r( FaceSegMed(8) ), 4, hat_n, 'Surface' );
        end
        if corner_flag(2, 2)
            hat_n = [- 1, 0, 0];
            EightTet_v(3, :) = EightTet_v(3, :) + calKVE_TetPatch( SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 1, hat_n, 'Surface' );
            EightTet_v(6, :) = EightTet_v(6, :) + calKVE_TetPatch( SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(2, 3)
            hat_n = [0, 0, - 1];
            EightTet_v(1, :) = EightTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), SideCrdnt(6, :), 1, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 3, hat_n, 'Surface' );
            EightTet_v(4, :) = EightTet_v(4, :) + calKVE_TetPatch( SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), CntrlCrdnt', 6, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(1, 4)
            hat_n = [1, 0, 0];
            EightTet_v(2, :) = EightTet_v(2, :) + calKVE_TetPatch( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 4, hat_n, 'Surface' );
            EightTet_v(7, :) = EightTet_v(7, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), 2, 'ext', mu_r( FaceSegMed(7) ), epsilon_r( FaceSegMed(7) ), 4, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 1)
            vec = [1: 4];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(1, 4)
            vec = [3: 6];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [1, 2, 7, 8];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [5: 8];
            EightTet_e(vec, :) = 0;
            EightTet_v(vec, :) = 0;
        end

        KVE_Value(1) = EightTet_v(5, 2) + EightTet_v(6, 1);
        KVE_Value(2) = EightTet_v(6, 3) + EightTet_v(7, 2);
        KVE_Value(3) = EightTet_v(7, 4) + EightTet_v(8, 4);
        KVE_Value(4) = EightTet_v(4, 2) + EightTet_v(5, 1);
        KVE_Value(5) = EightTet_v(1, 1) + EightTet_v(2, 2) + EightTet_v(3, 3) + EightTet_v(4, 3) ...
                        + EightTet_v(5, 3) + EightTet_v(6, 2) + EightTet_v(7, 1) + EightTet_v(8, 1);
        KVE_Value(6) = EightTet_v(1, 4) + EightTet_v(8, 3);
        KVE_Value(7) = EightTet_v(3, 1) + EightTet_v(4, 1);
        KVE_Value(8) = EightTet_v(2, 1) + EightTet_v(3, 2);
        KVE_Value(9) = EightTet_v(1, 3) + EightTet_v(2, 4);
        KVE_Value(10) = EightTet_v(1, 2) + EightTet_v(2, 3) + EightTet_v(3, 4) + EightTet_v(4, 4) ...
                        + EightTet_v(5, 4) + EightTet_v(6, 4) + EightTet_v(7, 3) + EightTet_v(8, 2);
    case '3'
        K1_Value  = zeros(1, 13);
        KEV_Value = zeros(1, 6);
        KVE_Value = zeros(6, 1);
        FourTet_e = zeros(4, 6);
        FourTet_v = zeros(4, 4);

        [ FourTet_e(1, :), FourTet_v(1, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), 6, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ FourTet_e(2, :), FourTet_v(2, :) ] = get6E4V( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ FourTet_e(3, :), FourTet_v(3, :) ] = get6E4V( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ FourTet_e(4, :), FourTet_v(4, :) ] = get6E4V( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );

        % trim
        if corner_flag(1, 5)
            vec = [1, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(1, 4)
            vec = [1, 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [2, 3];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        K1_Value(1)  = FourTet_e(1, 5) + FourTet_e(4, 2);
        K1_Value(2)  = FourTet_e(1, 1);
        K1_Value(3)  = FourTet_e(1, 3) + FourTet_e(2, 2);
        K1_Value(4)  = FourTet_e(2, 3);
        K1_Value(5)  = FourTet_e(2, 6) + FourTet_e(3, 4);
        K1_Value(6)  = FourTet_e(3, 6);
        K1_Value(7)  = FourTet_e(3, 5) + FourTet_e(4, 6);
        K1_Value(8)  = FourTet_e(4, 3);
        K1_Value(9)  = FourTet_e(1, 4) + FourTet_e(4, 1);
        K1_Value(10) = FourTet_e(1, 2) + FourTet_e(2, 1);
        K1_Value(11) = FourTet_e(2, 5) + FourTet_e(3, 2);
        K1_Value(12) = FourTet_e(3, 3) + FourTet_e(4, 5);
        K1_Value(13) = FourTet_e(1, 6) + FourTet_e(2, 4) + FourTet_e(3, 1) + FourTet_e(4, 4);

        KEV_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KEV_Value(2) = FourTet_v(2, 4) + FourTet_v(3, 4);
        KEV_Value(3) = FourTet_v(1, 4) + FourTet_v(2, 3) + FourTet_v(3, 2) + FourTet_v(4, 3);
        KEV_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 1);
        KEV_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KEV_Value(6) = FourTet_v(1, 3) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 2);

        FourTet_v = - FourTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        % no volume for KVE
        % on Gamma surface
        if corner_flag(2, 2)
            hat_n = [- 1, 0, 0];
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), 6, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 1, hat_n, 'Surface' );
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(2, 6)
            hat_n = [0, - 1, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), 6, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 2, hat_n, 'Surface' );
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(1, 4)
            hat_n = [1, 0, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Surface' );
        end
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), 4, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 4, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 3, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 5)
            vec = [1, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(1, 4)
            vec = [1, 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [2, 3];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        KVE_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KVE_Value(2) = FourTet_v(2, 4) + FourTet_v(3, 4);
        KVE_Value(3) = FourTet_v(1, 4) + FourTet_v(2, 3) + FourTet_v(3, 2) + FourTet_v(4, 3);
        KVE_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 1);
        KVE_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KVE_Value(6) = FourTet_v(1, 3) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 2);
    case '4'
        K1_Value  = zeros(1, 13);
        KEV_Value = zeros(1, 6);
        KVE_Value = zeros(6, 1);
        FourTet_e = zeros(4, 6);
        FourTet_v = zeros(4, 4);

        [ FourTet_e(1, :), FourTet_v(1, :) ] = get6E4V( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), 2, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ FourTet_e(2, :), FourTet_v(2, :) ] = get6E4V( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ FourTet_e(3, :), FourTet_v(3, :) ] = get6E4V( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ FourTet_e(4, :), FourTet_v(4, :) ] = get6E4V( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );

        % trim
        if corner_flag(1, 1)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        K1_Value(1)  = FourTet_e(1, 6) + FourTet_e(4, 5);
        K1_Value(2)  = FourTet_e(1, 5);
        K1_Value(3)  = FourTet_e(1, 4) + FourTet_e(2, 6);
        K1_Value(4)  = FourTet_e(2, 2);
        K1_Value(5)  = FourTet_e(2, 3) + FourTet_e(3, 2);
        K1_Value(6)  = FourTet_e(3, 3);
        K1_Value(7)  = FourTet_e(3, 6) + FourTet_e(4, 4);
        K1_Value(8)  = FourTet_e(4, 6);
        K1_Value(9)  = FourTet_e(1, 3) + FourTet_e(4, 4);
        K1_Value(10) = FourTet_e(1, 1) + FourTet_e(2, 4);
        K1_Value(11) = FourTet_e(2, 1) + FourTet_e(3, 1);
        K1_Value(12) = FourTet_e(3, 5) + FourTet_e(4, 2);
        K1_Value(13) = FourTet_e(1, 2) + FourTet_e(2, 5) + FourTet_e(3, 4) + FourTet_e(4, 1);

        KEV_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KEV_Value(2) = FourTet_v(2, 1) + FourTet_v(3, 1);
        KEV_Value(3) = FourTet_v(1, 3) + FourTet_v(2, 4) + FourTet_v(3, 3) + FourTet_v(4, 2);
        KEV_Value(4) = FourTet_v(1, 4) + FourTet_v(4, 3);
        KEV_Value(5) = FourTet_v(1, 2) + FourTet_v(2, 3);
        KEV_Value(6) = FourTet_v(1, 1) + FourTet_v(2, 2) + FourTet_v(3, 2) + FourTet_v(4, 1);

        FourTet_v = - FourTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        % volume for KVE
        if corner_flag(1, 2)
            hat_n = [- 1, 0, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), 2, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 1, hat_n, 'Volume' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 1, hat_n, 'Volume' );
        end
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 2, hat_n, 'Volume' );
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 2, hat_n, 'Volume' );
        end

        % on Gamma surface
        if corner_flag(1, 1)
            hat_n = [0, 0, 1];
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), 1, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Surface' );
        end
        if corner_flag(2, 3)
            hat_n = [0, 0, - 1];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), 2, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 2, hat_n, 'Surface' );
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 3, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 1)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 3)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        KVE_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KVE_Value(2) = FourTet_v(2, 1) + FourTet_v(3, 1);
        KVE_Value(3) = FourTet_v(1, 3) + FourTet_v(2, 4) + FourTet_v(3, 3) + FourTet_v(4, 2);
        KVE_Value(4) = FourTet_v(1, 4) + FourTet_v(4, 3);
        KVE_Value(5) = FourTet_v(1, 2) + FourTet_v(2, 3);
        KVE_Value(6) = FourTet_v(1, 1) + FourTet_v(2, 2) + FourTet_v(3, 2) + FourTet_v(4, 1);
    case '5'
        K1_Value  = zeros(1, 13);
        KEV_Value = zeros(1, 6);
        KVE_Value = zeros(6, 1);
        FourTet_e = zeros(4, 6);
        FourTet_v = zeros(4, 4);

        [ FourTet_e(1, :), FourTet_v(1, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ FourTet_e(2, :), FourTet_v(2, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), 4, 'inn', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ FourTet_e(3, :), FourTet_v(3, :) ] = get6E4V( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), 1, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ FourTet_e(4, :), FourTet_v(4, :) ] = get6E4V( SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );

        % trim
        if corner_flag(1, 4)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        K1_Value(1)  = FourTet_e(1, 4) + FourTet_e(4, 1);
        K1_Value(2)  = FourTet_e(1, 1);
        K1_Value(3)  = FourTet_e(1, 2) + FourTet_e(2, 1);
        K1_Value(4)  = FourTet_e(2, 3);
        K1_Value(5)  = FourTet_e(2, 5) + FourTet_e(3, 2);
        K1_Value(6)  = FourTet_e(3, 6);
        K1_Value(7)  = FourTet_e(3, 3) + FourTet_e(4, 5);
        K1_Value(8)  = FourTet_e(4, 5);
        K1_Value(9)  = FourTet_e(1, 5) + FourTet_e(4, 2);
        K1_Value(10) = FourTet_e(1, 3) + FourTet_e(2, 2);
        K1_Value(11) = FourTet_e(2, 6) + FourTet_e(3, 4);
        K1_Value(12) = FourTet_e(3, 5) + FourTet_e(4, 6);
        K1_Value(13) = FourTet_e(1, 6) + FourTet_e(2, 4) + FourTet_e(3, 1) + FourTet_e(4, 4);

        KEV_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KEV_Value(2) = FourTet_v(2, 4) + FourTet_v(3, 3);
        KEV_Value(3) = FourTet_v(1, 3) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 2);
        KEV_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 1);
        KEV_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KEV_Value(6) = FourTet_v(1, 4) + FourTet_v(2, 3) + FourTet_v(3, 2) + FourTet_v(4, 3);

        FourTet_v = - FourTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        % volume for KVE
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 4, hat_n, 'Volume' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 3, hat_n, 'Volume' );
        end
        if corner_flag(1, 3)
            hat_n = [0, 0, - 1];
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), 4, 'inn', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 3, hat_n, 'Volume' );
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), 1, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 2, hat_n, 'Volume' );
        end

        % on Gamma surface
        if corner_flag(2, 2)
            hat_n = [- 1, 0, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 1, hat_n, 'Surface' );
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), 4, 'inn', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 1, hat_n, 'Surface' );
        end
        if corner_flag(1, 4)
            hat_n = [1, 0, 0];
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), 1, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(1, :), 4, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 4)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 2)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        KVE_Value(1) = FourTet_v(3, 4) + FourTet_v(4, 4);
        KVE_Value(2) = FourTet_v(2, 4) + FourTet_v(3, 3);
        KVE_Value(3) = FourTet_v(1, 3) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 2);
        KVE_Value(4) = FourTet_v(1, 2) + FourTet_v(4, 1);
        KVE_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KVE_Value(6) = FourTet_v(1, 4) + FourTet_v(2, 3) + FourTet_v(3, 2) + FourTet_v(4, 3);
    case '6'
        K1_Value  = zeros(1, 13);
        KEV_Value = zeros(1, 6);
        KVE_Value = zeros(6, 1);
        FourTet_e = zeros(4, 6);
        FourTet_v = zeros(4, 4);

        [ FourTet_e(1, :), FourTet_v(1, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', 5, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ FourTet_e(2, :), FourTet_v(2, :) ] = get6E4V( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ FourTet_e(3, :), FourTet_v(3, :) ] = get6E4V( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ FourTet_e(4, :), FourTet_v(4, :) ] = get6E4V( SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );

        % trim
        if corner_flag(1, 5)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        K1_Value(1)  = FourTet_e(1, 4) + FourTet_e(4, 1);
        K1_Value(2)  = FourTet_e(1, 2);
        K1_Value(3)  = FourTet_e(1, 1) + FourTet_e(2, 1);
        K1_Value(4)  = FourTet_e(2, 2);
        K1_Value(5)  = FourTet_e(2, 4) + FourTet_e(3, 2);
        K1_Value(6)  = FourTet_e(3, 4);
        K1_Value(7)  = FourTet_e(3, 1) + FourTet_e(4, 2);
        K1_Value(8)  = FourTet_e(4, 4);
        K1_Value(9)  = FourTet_e(1, 6) + FourTet_e(4, 5);
        K1_Value(10) = FourTet_e(1, 3) + FourTet_e(2, 3);
        K1_Value(11) = FourTet_e(2, 6) + FourTet_e(3, 6);
        K1_Value(12) = FourTet_e(3, 5) + FourTet_e(4, 6);
        K1_Value(13) = FourTet_e(1, 5) + FourTet_e(2, 5) + FourTet_e(3, 3) + FourTet_e(4, 3);

        KEV_Value(1) = FourTet_v(3, 2) + FourTet_v(4, 3);
        KEV_Value(2) = FourTet_v(2, 3) + FourTet_v(3, 3);
        KEV_Value(3) = FourTet_v(1, 2) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 1);
        KEV_Value(4) = FourTet_v(1, 3) + FourTet_v(4, 2);
        KEV_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KEV_Value(6) = FourTet_v(1, 4) + FourTet_v(2, 4) + FourTet_v(3, 4) + FourTet_v(4, 4);

        FourTet_v = - FourTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );

        % volume
        if corner_flag(1, 4)
            hat_n = [1, 0, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', 5, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 4, hat_n, 'Volume' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 4, hat_n, 'Volume' );
        end
        if corner_flag(1, 1)
            hat_n = [0, 0, 1];
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 4, hat_n, 'Volume' );
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 4, hat_n, 'Volume' );
        end

        % on Gamma surface
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            FourTet_v(3, :) = FourTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 2, hat_n, 'Surface' );
            FourTet_v(4, :) = FourTet_v(4, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', 3, 'ext', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 3, hat_n, 'Surface' );
        end
        if corner_flag(2, 6)
            hat_n = [0, - 1, 0];
            FourTet_v(1, :) = FourTet_v(1, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', 5, 'inn', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 1, hat_n, 'Surface' );
            FourTet_v(2, :) = FourTet_v(2, :) + calKVE_TetPatch( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 5, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 1, hat_n, 'Surface' );
        end

        % trim
        if corner_flag(1, 5)
            vec = [1: 2];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end
        if corner_flag(2, 6)
            vec = [3, 4];
            FourTet_e(vec, :) = 0;
            FourTet_v(vec, :) = 0;
        end

        KVE_Value(1) = FourTet_v(3, 2) + FourTet_v(4, 3);
        KVE_Value(2) = FourTet_v(2, 3) + FourTet_v(3, 3);
        KVE_Value(3) = FourTet_v(1, 2) + FourTet_v(2, 2) + FourTet_v(3, 1) + FourTet_v(4, 1);
        KVE_Value(4) = FourTet_v(1, 3) + FourTet_v(4, 2);
        KVE_Value(5) = FourTet_v(1, 1) + FourTet_v(2, 1);
        KVE_Value(6) = FourTet_v(1, 4) + FourTet_v(2, 4) + FourTet_v(3, 4) + FourTet_v(4, 4);
    case '7'
        K1_Value  = zeros(1, 19);
        KEV_Value = zeros(1, 8);
        KVE_Value = zeros(8, 1);
        SixTet_e  = zeros(6, 6);
        SixTet_v  = zeros(6, 4);

        % K_1: the 1-st to the 8-th tetdrahedron
        [ SixTet_e(1, :), SixTet_v(1, :) ] = get6E4V( SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(7, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ) );
        [ SixTet_e(2, :), SixTet_v(2, :) ] = get6E4V( SideCrdnt(3, :), SideCrdnt(7, :), CntrlCrdnt', SideCrdnt(6, :), 6, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ) );
        [ SixTet_e(3, :), SixTet_v(3, :) ] = get6E4V( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(5, :), 4, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ) );
        [ SixTet_e(4, :), SixTet_v(4, :) ] = get6E4V( SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), 1, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ) );
        [ SixTet_e(5, :), SixTet_v(5, :) ] = get6E4V( SideCrdnt(1, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 1, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ) );
        [ SixTet_e(6, :), SixTet_v(6, :) ] = get6E4V( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(3, :), CntrlCrdnt', 4, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ) );

        K1_Value(1)  = SixTet_e(1, 1) + SixTet_e(6, 2);
        K1_Value(2)  = SixTet_e(1, 2);
        K1_Value(3)  = SixTet_e(1, 4) + SixTet_e(2, 1);
        K1_Value(4)  = SixTet_e(2, 5);
        K1_Value(5)  = SixTet_e(2, 3) + SixTet_e(3, 2);
        K1_Value(6)  = SixTet_e(3, 6);
        K1_Value(7)  = SixTet_e(3, 3) + SixTet_e(4, 3);
        K1_Value(8)  = SixTet_e(4, 5);
        K1_Value(9)  = SixTet_e(4, 1) + SixTet_e(5, 4);
        K1_Value(10) = SixTet_e(5, 2);
        K1_Value(11) = SixTet_e(5, 1) + SixTet_e(6, 4);
        K1_Value(12) = SixTet_e(6, 1);
        K1_Value(13) = SixTet_e(1, 3) + SixTet_e(6, 3);
        K1_Value(14) = SixTet_e(1, 6) + SixTet_e(2, 4);
        K1_Value(15) = SixTet_e(2, 6) + SixTet_e(3, 4);
        K1_Value(16) = SixTet_e(3, 5) + SixTet_e(4, 6);
        K1_Value(17) = SixTet_e(4, 4) + SixTet_e(5, 6);
        K1_Value(18) = SixTet_e(5, 3) + SixTet_e(6, 5);
        K1_Value(19) = SixTet_e(1, 5) + SixTet_e(2, 2) + SixTet_e(3, 1) ...
                        + SixTet_e(4, 2) + SixTet_e(5, 5) + SixTet_e(6, 6);

        KEV_Value(1) = SixTet_v(5, 1) + SixTet_v(6, 2);
        KEV_Value(2) = SixTet_v(4, 2) + SixTet_v(5, 3);
        KEV_Value(3) = SixTet_v(1, 2) + SixTet_v(2, 1) + SixTet_v(3, 1) ...
                        + SixTet_v(4, 1) + SixTet_v(5, 2) + SixTet_v(6, 3);
        KEV_Value(4) = SixTet_v(1, 1) + SixTet_v(6, 1);
        KEV_Value(5) = SixTet_v(3, 4) + SixTet_v(4, 4);
        KEV_Value(6) = SixTet_v(2, 3) + SixTet_v(3, 3);
        KEV_Value(7) = SixTet_v(1, 3) + SixTet_v(2, 2);
        KEV_Value(8) = SixTet_v(1, 4) + SixTet_v(2, 4) + SixTet_v(3, 2) ...
                        + SixTet_v(4, 3) + SixTet_v(5, 4) + SixTet_v(6, 4);

        SixTet_v = - SixTet_v ./ repmat( mu_r( FaceSegMed' ) .* epsilon_r( FaceSegMed' ).^2, 1, 4 );
        
        % volume for KVE
        if corner_flag(1, 1)
            hat_n = [0, 0, 1];
            SixTet_v(1, :) = SixTet_v(1, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(7, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 4, hat_n, 'Volume' );
            SixTet_v(2, :) = SixTet_v(2, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(7, :), SideCrdnt(6, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 4, hat_n, 'Volume' );
        end
        if corner_flag(1, 6)
            hat_n = [0, - 1, 0];
            SixTet_v(3, :) = SixTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(5, :), 4, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 2, hat_n, 'Volume' );
            SixTet_v(4, :) = SixTet_v(4, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), 1, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 3, hat_n, 'Volume' );
        end
        if corner_flag(1, 4)
            hat_n = [1, 0, 0];
            SixTet_v(5, :) = SixTet_v(5, :) + calKVE_TetPatch( SideCrdnt(1, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 1, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ), 4, hat_n, 'Volume' );
            SixTet_v(6, :) = SixTet_v(6, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(3, :), CntrlCrdnt', 4, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ), 4, hat_n, 'Volume' );
        end
        if corner_flag(1, 5)
            hat_n = [0, 1, 0];
            SixTet_v(1, :) = SixTet_v(1, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(7, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(1) ), epsilon_r( FaceSegMed(1) ), 2, hat_n, 'Volume' );
            SixTet_v(6, :) = SixTet_v(6, :) + calKVE_TetPatch( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(3, :), CntrlCrdnt', 4, 'ext', mu_r( FaceSegMed(6) ), epsilon_r( FaceSegMed(6) ), 3, hat_n, 'Volume' );
        end
        if corner_flag(1, 2)
            hat_n = [- 1, 0, 0];
            SixTet_v(2, :) = SixTet_v(2, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(7, :), SideCrdnt(6, :), CntrlCrdnt', 6, 'ext', mu_r( FaceSegMed(2) ), epsilon_r( FaceSegMed(2) ), 1, hat_n, 'Volume' );
            SixTet_v(3, :) = SixTet_v(3, :) + calKVE_TetPatch( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(5, :), 4, 'inn', mu_r( FaceSegMed(3) ), epsilon_r( FaceSegMed(3) ), 1, hat_n, 'Volume' );
        end
        if corner_flag(1, 3)
            hat_n = [0, 0, - 1];
            SixTet_v(4, :) = SixTet_v(4, :) + calKVE_TetPatch( SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), 1, 'inn', mu_r( FaceSegMed(4) ), epsilon_r( FaceSegMed(4) ), 1, hat_n, 'Volume' );
            SixTet_v(5, :) = SixTet_v(5, :) + calKVE_TetPatch( SideCrdnt(1, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', 1, 'inn', mu_r( FaceSegMed(5) ), epsilon_r( FaceSegMed(5) ), 2, hat_n, 'Volume' );
        end

        KVE_Value(1) = SixTet_v(5, 1) + SixTet_v(6, 2);
        KVE_Value(2) = SixTet_v(4, 2) + SixTet_v(5, 3);
        KVE_Value(3) = SixTet_v(1, 2) + SixTet_v(2, 1) + SixTet_v(3, 1) ...
                        + SixTet_v(4, 1) + SixTet_v(5, 2) + SixTet_v(6, 3);
        KVE_Value(4) = SixTet_v(1, 1) + SixTet_v(6, 1);
        KVE_Value(5) = SixTet_v(3, 4) + SixTet_v(4, 4);
        KVE_Value(6) = SixTet_v(2, 3) + SixTet_v(3, 3);
        KVE_Value(7) = SixTet_v(1, 3) + SixTet_v(2, 2);
        KVE_Value(8) = SixTet_v(1, 4) + SixTet_v(2, 4) + SixTet_v(3, 2) ...
                        + SixTet_v(4, 3) + SixTet_v(5, 4) + SixTet_v(6, 4);
    end

end
