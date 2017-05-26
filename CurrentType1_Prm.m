function [ K1_Value, Bk_m ] = CurrentType1_Prm( SideCrdnt, CntrlCrdnt, Side_Cflag, Cntrl_Cflag, SegMed, J_0, mu_r, SideIdx )
% Cflag -> current flag
% the center point is a column vector; while the side point are row vector.

switch SideIdx
    case '1'
        Bk_m = 0;
        EightTet_e = zeros(8, 7);
        % first six value: for six edges of a tetrahedron; 
        % last value: for the calculation of B_k
        K1_Value = zeros(1, 25);
        J = zeros(3, 1); 

        % K_1: the 1-st to the 8-th tetdrahedron
        [ EightTet_e(1, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(9), Side_Cflag(6), 1, 'inn', J_0, J, mu_r(SegMed(1)) );
        [ EightTet_e(2, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(9, :), ...
                                Cntrl_Cflag, Side_Cflag(8), Side_Cflag(5), Side_Cflag(9), 2, 'ext', J_0, J, mu_r(SegMed(2)) );
        [ EightTet_e(3, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), ...
                                Cntrl_Cflag, Side_Cflag(7), Side_Cflag(8), Side_Cflag(5), 3, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ EightTet_e(4, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), ...
                                Cntrl_Cflag, Side_Cflag(7), Side_Cflag(4), Side_Cflag(5), 3, 'ext', J_0, J, mu_r(SegMed(4)) );
        [ EightTet_e(5, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(1), Side_Cflag(5), 3, 'ext', J_0, J, mu_r(SegMed(5)) );
        [ EightTet_e(6, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), ...
                                Cntrl_Cflag, Side_Cflag(1), Side_Cflag(5), Side_Cflag(2), 2, 'inn', J_0, J, mu_r(SegMed(6)) );
        [ EightTet_e(7, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), Side_Cflag(3), 1, 'ext', J_0, J, mu_r(SegMed(7)) );
        [ EightTet_e(8, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(6), Side_Cflag(3), 1, 'inn', J_0, J, mu_r(SegMed(8)) );

        K1_Value = Tet2K1(K1_Value, EightTet_e(:, 1: 6), 'Type1-1');
        Bk_m = sum(EightTet_e(:, 7));
    case '2'
        % % the fist three rows: x, y and z direction; 
        % % the last row: recording edges around the sheet
        % nVarargs = length(varargin);
        % if nVarargs == 1
        %     TiltType = varargin{1};
        % else
        %     error('check');
        % end
        Bk_m = 0;
        EightTet_e = zeros(8, 7);
        K1_Value = zeros(1, 25);
        J = zeros(3, 1); 

        % quadrantMask = zeros(8, 1);
        % quadrantMask = getMask(quadrantNum, 'Type1-2', 8, TiltType);

        % K_1: the 1-st to the 8-th tetdrahedron
        [ EightTet_e(1, :, : ) ] = calBC_prm( SideCrdnt(9, :), SideCrdnt(6, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(9), Side_Cflag(6), Cntrl_Cflag, Side_Cflag(5), 6, 'inn', J_0, J, mu_r(SegMed(1)) );
        [ EightTet_e(2, :, : ) ] = calBC_prm( SideCrdnt(9, :), CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), ...
                                Side_Cflag(9), Cntrl_Cflag, Side_Cflag(8), Side_Cflag(5), 5, 'inn', J_0, J, mu_r(SegMed(2)) );
        [ EightTet_e(3, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(8, :), SideCrdnt(5, :), SideCrdnt(7, :), ...
                                Cntrl_Cflag, Side_Cflag(8), Side_Cflag(5), Side_Cflag(7), 2, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ EightTet_e(4, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(4, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(7), Side_Cflag(4), 1, 'ext', J_0, J, mu_r(SegMed(4)) );
        [ EightTet_e(5, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(4), Side_Cflag(1), 1, 'ext', J_0, J, mu_r(SegMed(5)) );
        [ EightTet_e(6, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), Side_Cflag(1), 1, 'inn', J_0, J, mu_r(SegMed(6)) );
        [ EightTet_e(7, :, : ) ] = calBC_prm( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), ...
                                Side_Cflag(3), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), 4, 'inn', J_0, J, mu_r(SegMed(7)) );
        [ EightTet_e(8, :, : ) ] = calBC_prm( SideCrdnt(6, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(6), Side_Cflag(3), Cntrl_Cflag, Side_Cflag(5), 6, 'inn', J_0, J, mu_r(SegMed(8)) );

        % suppose the first one is H_1
        K1_Value = Tet2K1(K1_Value, EightTet_e(:, 1: 6), 'Type1-2');
        Bk_m = sum(EightTet_e(:, 7));
        % Bk_m = sum(EightTet);
        % if length( find( K1_Value(4, :) ) )~= 9
        %     TiltType
        %     quadrantNum
        %     quadrantMask
        %     error('check the Tet2K1');
        % end
    case '3'
        Bk_m = 0;
        EightTet_e = zeros(8, 7);
        K1_Value = zeros(1, 25);
        J = zeros(3, 1); 

        % K_1: the 1-st to the 8-th tetdrahedron
        [ EightTet_e(1, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(9), Side_Cflag(6), 1, 'inn', J_0, J, mu_r(SegMed(1)) );
        [ EightTet_e(2, :, : ) ] = calBC_prm( SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), ...
                                Side_Cflag(8), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(9), 4, 'inn', J_0, J, mu_r(SegMed(2)) );
        [ EightTet_e(3, :, : ) ] = calBC_prm( SideCrdnt(7, :), SideCrdnt(8, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(7), Side_Cflag(8), Cntrl_Cflag, Side_Cflag(5), 6, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ EightTet_e(4, :, : ) ] = calBC_prm( SideCrdnt(7, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(7), Side_Cflag(4), Cntrl_Cflag, Side_Cflag(5), 6, 'ext', J_0, J, mu_r(SegMed(4)) );
        [ EightTet_e(5, :, : ) ] = calBC_prm( SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(4), Side_Cflag(1), Cntrl_Cflag, Side_Cflag(5), 6, 'ext', J_0, J, mu_r(SegMed(5)) );
        [ EightTet_e(6, :, : ) ] = calBC_prm( SideCrdnt(1, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), ...
                                Side_Cflag(1), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), 4, 'ext', J_0, J, mu_r(SegMed(6)) );
        [ EightTet_e(7, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), Side_Cflag(3), 1, 'ext', J_0, J, mu_r(SegMed(7)) );
        [ EightTet_e(8, :, : ) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(6), Side_Cflag(3), 1, 'inn', J_0, J, mu_r(SegMed(8)) );

        K1_Value = Tet2K1(K1_Value, EightTet_e(:, 1: 6), 'Type1-3');
        Bk_m = sum(EightTet_e(:, 7));
        % Bk_m = sum(EightTet);
    case '4'
        Bk_m = 0;
        FourTet_e = zeros(4, 7);
        K1_Value = zeros(1, 13);
        J = zeros(3, 1);

        % quadrantMask = zeros(4, 1);
        % quadrantMask = getMask(quadrantNum, 'Type1-4', 4);

        [ FourTet_e(1, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(5), Side_Cflag(3), 3, 'ext', J_0, J, mu_r(SegMed(1)) );
        [ FourTet_e(2, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(2), Side_Cflag(5), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(2)) );
        [ FourTet_e(3, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(2), Side_Cflag(3), Side_Cflag(1), 2, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ FourTet_e(4, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), Side_Cflag(1), 2, 'ext', J_0, J, mu_r(SegMed(4)) );
        
        K1_Value = Tet2K1(K1_Value, FourTet_e(:, 1: 6), 'Type1-4');
        Bk_m = sum(FourTet_e(:, 7));
        % if length( find( K1_Value(4, :) ) )~= 9
        %     quadrantNum
        %     quadrantMask
        %     error('check the Tet2K1');
        % end
    case '5'
        Bk_m = 0;
        FourTet_e = zeros(4, 7);
        K1_Value = zeros(1, 13);
        J = zeros(3, 1);

        % quadrantMask = zeros(4, 1);
        % quadrantMask = getMask(quadrantNum, 'Type1-5', 4);

        [ FourTet_e(1, :, :) ] = calBC_prm( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), 5, 'ext', J_0, J, mu_r(SegMed(1)) );
        [ FourTet_e(2, :, :) ] = calBC_prm( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(2), Side_Cflag(3), 5, 'inn', J_0, J, mu_r(SegMed(2)) );
        [ FourTet_e(3, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(2), Side_Cflag(3), Side_Cflag(1), 2, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ FourTet_e(4, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), Side_Cflag(1), 2, 'ext', J_0, J, mu_r(SegMed(4)) );
        
        K1_Value = Tet2K1(K1_Value, FourTet_e(:, 1: 6), 'Type1-5');
        Bk_m = sum(FourTet_e(:, 7));
        % if length( find( K1_Value(4, :) ) )~= 9
        %     quadrantNum
        %     quadrantMask
        %     error('check the Tet2K1');
        % end
    case '6'
        Bk_m = 0;
        FourTet_e = zeros(4, 7);
        K1_Value = zeros(1, 13);
        J = zeros(3, 1);

        [ FourTet_e(1, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(4), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(1)) );
        [ FourTet_e(2, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(2), Side_Cflag(5), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(2)) );
        [ FourTet_e(3, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(2), Side_Cflag(3), Side_Cflag(1), 2, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ FourTet_e(4, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), Side_Cflag(1), 2, 'ext', J_0, J, mu_r(SegMed(4)) );

        K1_Value = Tet2K1(K1_Value, FourTet_e(:, 1: 6), 'Type1-6');
        Bk_m = sum(FourTet_e(:, 7));
        % Bk_m = sum(FourTet);
    case '7'
        Bk_m = 0;
        SixTet_e = zeros(6, 7);
        K1_Value = zeros(1, 19);
        J = zeros(3, 1);

        % quadrantMask = zeros(6, 1);
        % quadrantMask = getMask(quadrantNum, 'Type1-7', 6);

        % K_1: the 1-st to the 8-th tetdrahedron
        [ SixTet_e(1, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(7), Side_Cflag(4), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(1)) );
        [ SixTet_e(2, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(7, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(7), Side_Cflag(6), Side_Cflag(3), 3, 'ext', J_0, J, mu_r(SegMed(2)) );
        [ SixTet_e(3, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(6), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(3)) );
        [ SixTet_e(4, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), Side_Cflag(3), 3, 'ext', J_0, J, mu_r(SegMed(4)) );
        [ SixTet_e(5, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(2, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(1), Side_Cflag(2), Side_Cflag(3), 3, 'inn', J_0, J, mu_r(SegMed(5)) );
        [ SixTet_e(6, :, :) ] = calBC_prm( CntrlCrdnt', SideCrdnt(1, :), SideCrdnt(4, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(1), Side_Cflag(4), Side_Cflag(3), 3, 'ext', J_0, J, mu_r(SegMed(6)) );

        K1_Value = Tet2K1(K1_Value, SixTet_e(:, 1: 6), 'Type1-7');
        Bk_m = sum(SixTet_e(:, 7));
        % if length( find( K1_Value(4, :) ) )~= 9
        %     quadrantNum
        %     quadrantMask
        %     error('check the Tet2K1');
        % end
    end

end
