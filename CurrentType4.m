function [ K1_Value, J ] = CurrentType4( SideCrdnt, CntrlCrdnt, Side_Cflag, Cntrl_Cflag, SegMed, J_0, mu_r, SideIdx, quadrantNum, varargin )
% Cflag -> current flag
% the center point is a column vector; while the side point are row vector.

% start from here.
switch SideIdx
    case '1'
        Bk_m = 0;
        FourTet_e = zeros(4, 1);

        FourTet_e(1, :, :) = calBC( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(3), Side_Cflag(4), Cntrl_Cflag, 5, 'inn', J_0 );
        FourTet_e(2, :, :) = calBC( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), ...
                                Side_Cflag(5), Side_Cflag(3), Cntrl_Cflag, Side_Cflag(2), 4, 'inn', J_0 );
        FourTet_e(3, :, :) = calBC( SideCrdnt(3, :), SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(2, :), ...
                                Side_Cflag(3), Side_Cflag(1), Cntrl_Cflag, Side_Cflag(2), 2, 'inn', J_0 );
        FourTet_e(4, :, :) = calBC( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(4, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(1), Side_Cflag(4), Cntrl_Cflag, 3, 'inn', J_0 );

        Bk_m = sum(FourTet_e);
    case '2'
        nVarargs = length(varargin);
        if nVarargs == 1
            TiltType = varargin{1};
        else
            error('check');
        end
        FourTet_e = zeros(4, 6, 4);
        K1_Value = zeros(4, 13);
        J = zeros(3, 1);

        quadrantMask = zeros(4, 1);
        quadrantMask = getMask(quadrantNum, 'Type4-2', 4, TiltType);

        [ FourTet_e(1, :, :), J ] = calBC( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(4, :), ...
                                Side_Cflag(5), Side_Cflag(3), Cntrl_Cflag, Side_Cflag(4), 4, 'inn', J_0, J, mu_r(SegMed(1)), quadrantMask(1) );
        [ FourTet_e(2, :, :), J ] = calBC( SideCrdnt(2, :), SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', ...
                                Side_Cflag(2), Side_Cflag(5), Side_Cflag(3), Cntrl_Cflag, 6, 'ext', J_0, J, mu_r(SegMed(2)), quadrantMask(2) );
        [ FourTet_e(3, :, :), J ] = calBC( SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), CntrlCrdnt', ...
                                Side_Cflag(2), Side_Cflag(3), Side_Cflag(1), Cntrl_Cflag, 5, 'ext', J_0, J, mu_r(SegMed(3)), quadrantMask(3) );
        [ FourTet_e(4, :, :), J ] = calBC( SideCrdnt(3, :), SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(4, :), ...
                                Side_Cflag(3), Side_Cflag(1), Cntrl_Cflag, Side_Cflag(4), 2, 'inn', J_0, J, mu_r(SegMed(4)), quadrantMask(4) );

        K1_Value = Tet2K1(K1_Value, FourTet_e, 'Type4-2');
        if length( find( K1_Value(4, :) ) )~= 9
            TiltType
            quadrantNum
            quadrantMask
            error('check the Tet2K1');
        end
        % Bk_m = sum(FourTet_e);
    case '3'
        Bk_m = 0;
        EightTet_e = zeros(8, 1);

        % K_1: the 1-st to the 8-th tetdrahedron
        EightTet_e(1, :, :) = calBC( SideCrdnt(9, :), SideCrdnt(6, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(9), Side_Cflag(6), Side_Cflag(5), Cntrl_Cflag, 6, 'ext', J_0 );
        EightTet_e(2, :, :) = calBC( SideCrdnt(9, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(9), Side_Cflag(8), Side_Cflag(5), Cntrl_Cflag, 6, 'inn', J_0 );
        EightTet_e(3, :, :) = calBC( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(7, :), ...
                                Side_Cflag(8), Side_Cflag(5), Cntrl_Cflag, Side_Cflag(7), 4, 'inn', J_0 );
        EightTet_e(4, :, :) = calBC( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(7), Side_Cflag(4), 1, 'inn', J_0 );
        EightTet_e(5, :, :) = calBC( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(4), Side_Cflag(1), 1, 'inn', J_0 );
        EightTet_e(6, :, :) = calBC( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(2), Side_Cflag(1), 1, 'ext', J_0 );
        EightTet_e(7, :, :) = calBC( SideCrdnt(3, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), ...
                                Side_Cflag(3), Side_Cflag(5), Cntrl_Cflag, Side_Cflag(2), 4, 'ext', J_0 );
        EightTet_e(8, :, :) = calBC( SideCrdnt(6, :), SideCrdnt(3, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(6), Side_Cflag(3), Side_Cflag(5), Cntrl_Cflag, 6, 'ext', J_0 );

        Bk_m = sum(EightTet_e);
    case '4'
        FourTet_e = zeros(4, 6, 4);
        K1_Value = zeros(4, 13);
        J = zeros(3, 1);

        quadrantMask = zeros(4, 1);
        quadrantMask = getMask(quadrantNum, 'Type4-4', 4);

        [ FourTet_e(1, :, :), J ] = calBC( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(3), Side_Cflag(4), Cntrl_Cflag, 5, 'inn', J_0, J, mu_r(SegMed(1)), quadrantMask(1) );
        [ FourTet_e(2, :, :), J ] = calBC( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(3), Side_Cflag(2), Cntrl_Cflag, 5, 'ext', J_0, J, mu_r(SegMed(2)), quadrantMask(2) );
        [ FourTet_e(3, :, :), J ] = calBC( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(1), Side_Cflag(2), Cntrl_Cflag, 3, 'ext', J_0, J, mu_r(SegMed(3)), quadrantMask(3) );
        [ FourTet_e(4, :, :), J ] = calBC( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(4, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(1), Side_Cflag(4), Cntrl_Cflag, 3, 'inn', J_0, J, mu_r(SegMed(4)), quadrantMask(4) );

        K1_Value = Tet2K1(K1_Value, FourTet_e, 'Type4-4');
        if length( find( K1_Value(4, :) ) )~= 9
            quadrantNum
            quadrantMask
            error('check the Tet2K1');
        end
        % Bk_m = sum(FourTet_e);
    case '5'
        FourTet_e = zeros(4, 6, 4);
        K1_Value = zeros(4, 13);
        J = zeros(3, 1);

        quadrantMask = zeros(4, 1);
        quadrantMask = getMask(quadrantNum, 'Type4-5', 4);

        [ FourTet_e(1, :, :), J ] = calBC( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(4), 4, 'inn', J_0, J, mu_r(SegMed(1)), quadrantMask(1) );
        [ FourTet_e(2, :, :), J ] = calBC( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), ...
                                Side_Cflag(5), Side_Cflag(2), Cntrl_Cflag, Side_Cflag(3), 6, 'ext', J_0, J, mu_r(SegMed(2)), quadrantMask(2) );
        [ FourTet_e(3, :, :), J ] = calBC( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Side_Cflag(2), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), 4, 'ext', J_0, J, mu_r(SegMed(3)), quadrantMask(3) );
        [ FourTet_e(4, :, :), J ] = calBC( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(3), Side_Cflag(4), Side_Cflag(1), 1, 'inn', J_0, J, mu_r(SegMed(4)), quadrantMask(4) );

        K1_Value = Tet2K1(K1_Value, FourTet_e, 'Type4-5');
        if length( find( K1_Value(4, :) ) )~= 9
            quadrantNum
            quadrantMask
            error('check the Tet2K1');
        end
        % Bk_m = sum(FourTet_e);
    case '6'
        Bk_m = 0;
        FourTet_e = zeros(4, 1);

        FourTet_e(1, :, :) = calBC( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Side_Cflag(4), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), 5, 'inn', J_0 );
        FourTet_e(2, :, :) = calBC( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), Side_Cflag(2), 2, 'inn', J_0 );
        FourTet_e(3, :, :) = calBC( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(3), Side_Cflag(2), Side_Cflag(1), 1, 'ext', J_0 );
        FourTet_e(4, :, :) = calBC( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Side_Cflag(4), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), 4, 'inn', J_0 );

        Bk_m = sum(FourTet_e);
    case '7'
        SixTet_e = zeros(6, 6, 4);
        K1_Value = zeros(4, 19);
        J = zeros(3, 1);

        quadrantMask = zeros(6, 1);
        quadrantMask = getMask(quadrantNum, 'Type4-7', 6);

        % K_1: the 1-st to the 8-th tetdrahedron
        [ SixTet_e(1, :, :), J ] = calBC( SideCrdnt(7, :), CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), ...
                                Side_Cflag(7), Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), 5, 'ext', J_0, J, mu_r(SegMed(1)), quadrantMask(1) );
        [ SixTet_e(2, :, :), J ] = calBC( SideCrdnt(7, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Side_Cflag(7), Cntrl_Cflag, Side_Cflag(6), Side_Cflag(3), 5, 'inn', J_0, J, mu_r(SegMed(2)), quadrantMask(2) );
        [ SixTet_e(3, :, :), J ] = calBC( CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(6), Side_Cflag(5), Side_Cflag(3), 3, 'ext', J_0, J, mu_r(SegMed(3)), quadrantMask(3) );
        [ SixTet_e(4, :, :), J ] = calBC( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), Side_Cflag(2), 2, 'inn', J_0, J, mu_r(SegMed(4)), quadrantMask(4) );
        [ SixTet_e(5, :, :), J ] = calBC( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(3, :), SideCrdnt(2, :), ...
                                Cntrl_Cflag, Side_Cflag(1), Side_Cflag(3), Side_Cflag(2), 2, 'ext', J_0, J, mu_r(SegMed(5)), quadrantMask(5) );
        [ SixTet_e(6, :, :), J ] = calBC( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(1), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(6)), quadrantMask(6) );

        K1_Value = Tet2K1(K1_Value, SixTet_e, 'Type4-7');
        if length( find( K1_Value(4, :) ) )~= 9
            quadrantNum
            quadrantMask
            error('check the Tet2K1');
        end
        % Bk_m = sum(SixTet_e);
    end

end
