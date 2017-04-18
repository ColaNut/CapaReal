function Bk_m = calBk_m( SideCrdnt, CntrlCrdnt, Side_Cflag, Cntrl_Cflag, J_0, tetNum )
% Cflag -> current flag
% the center point is a column vector; while the side point are row vector.
Bk_m = 0;

switch tetNum
    case 'eightTet'
        Bk_m = 0;
        EightTet = zeros(8, 1);

        % K_1: the 1-st to the 8-th tetdrahedron
        EightTet(1) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(9), Side_Cflag(6), J_0 );
        EightTet(2) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(8, :), SideCrdnt(9, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(8), Side_Cflag(9), J_0 );
        EightTet(3) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(8, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(7), Side_Cflag(8), J_0 );
        EightTet(4) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(7, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(4), Side_Cflag(7), J_0 );
        EightTet(5) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(1, :), SideCrdnt(4, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(1), Side_Cflag(4), J_0 );
        EightTet(6) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(2), Side_Cflag(1), J_0 );
        EightTet(7) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), Side_Cflag(2), J_0 );
        EightTet(8) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), ...
                                    Cntrl_Cflag, Side_Cflag(5), Side_Cflag(6), Side_Cflag(3), J_0 );

        Bk_m = sum(EightTet);
    case 'fourTet'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(5, :), SideCrdnt(4, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(5), Side_Cflag(4), J_0 );
        FourTet(2) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(5, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(2), Side_Cflag(5), J_0 );
        FourTet(3) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), Side_Cflag(2), J_0 );
        FourTet(4) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(4), Side_Cflag(1), J_0 );

        Bk_m = sum(FourTet);
    case 'sixTet'
        Bk_m = 0;
        SixTet = zeros(6, 1);

        % K_1: the 1-st to the 8-th tetdrahedron
        SixTet(1) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(7, :), SideCrdnt(4, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(7), Side_Cflag(4), J_0 );
        SixTet(2) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(6, :), SideCrdnt(7, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(6), Side_Cflag(7), J_0 );
        SixTet(3) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(5, :), SideCrdnt(6, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(5), Side_Cflag(6), J_0 );
        SixTet(4) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(5, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(2), Side_Cflag(5), J_0 );
        SixTet(5) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), Side_Cflag(2), J_0 );
        SixTet(6) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), ...
                                    Cntrl_Cflag, Side_Cflag(3), Side_Cflag(4), Side_Cflag(1), J_0 );

        Bk_m = sum(SixTet);
    end

end
