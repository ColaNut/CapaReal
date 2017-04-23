function Bk_m = calBk_Type3( SideCrdnt, CntrlCrdnt, Side_Cflag, Cntrl_Cflag, J_0, SideIdx )
% Cflag -> current flag
% the center point is a column vector; while the side point are row vector.
Bk_m = 0;

% start from here.
switch SideIdx
    case '1'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(5), Side_Cflag(3), 3, 'ext', J_0 );
        FourTet(2) = getWmJ( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Side_Cflag(2), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), 5, 'ext', J_0 );
        FourTet(3) = getWmJ( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Side_Cflag(2), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), 4, 'ext', J_0 );
        FourTet(4) = getWmJ( CntrlCrdnt', SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(4), Side_Cflag(3), Side_Cflag(1), 2, 'ext', J_0 );

        Bk_m = sum(FourTet);
    case '2'
        Bk_m = 0;
        EightTet = zeros(8, 1);

        % K_1: the 1-st to the 8-th tetdrahedron
        EightTet(1) = getWmJ( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), SideCrdnt(6, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(9), Side_Cflag(6), 1, 'ext', J_0 );
        EightTet(2) = getWmJ( SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(9, :), ...
                                Side_Cflag(8), Side_Cflag(5), Cntrl_Cflag, Side_Cflag(9), 4, 'ext', J_0 );
        EightTet(3) = getWmJ( SideCrdnt(7, :), SideCrdnt(8, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(7), Side_Cflag(8), Side_Cflag(5), Cntrl_Cflag, 6, 'ext', J_0 );
        EightTet(4) = getWmJ( SideCrdnt(7, :), SideCrdnt(4, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(7), Side_Cflag(4), Side_Cflag(5), Cntrl_Cflag, 6, 'inn', J_0 );
        EightTet(5) = getWmJ( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(5, :), CntrlCrdnt', ...
                                Side_Cflag(4), Side_Cflag(1), Side_Cflag(5), Cntrl_Cflag, 6, 'inn', J_0 );
        EightTet(6) = getWmJ( SideCrdnt(1, :), SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(1), Side_Cflag(5), Side_Cflag(2), Cntrl_Cflag, 5, 'ext', J_0 );
        EightTet(7) = getWmJ( SideCrdnt(5, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), ...
                                Side_Cflag(5), Side_Cflag(2), Cntrl_Cflag, Side_Cflag(3), 2, 'ext', J_0 );
        EightTet(8) = getWmJ( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(3, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(6), Side_Cflag(3), 1, 'ext', J_0 );

        Bk_m = sum(EightTet);
    case '3'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( SideCrdnt(5, :), SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), ...
                                Side_Cflag(5), Side_Cflag(4), Cntrl_Cflag, Side_Cflag(3), 6, 'inn', J_0 );
        FourTet(2) = getWmJ( SideCrdnt(5, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), ...
                                Side_Cflag(5), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(2), 4, 'ext', J_0 );
        FourTet(3) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(2, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(3), Side_Cflag(2), Side_Cflag(1), 1, 'ext', J_0 );
        FourTet(4) = getWmJ( SideCrdnt(4, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Side_Cflag(4), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), 4, 'inn', J_0 );

        Bk_m = sum(FourTet);
    case '4'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), ...
                                Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), Side_Cflag(4), 2, 'ext', J_0 );
        FourTet(2) = getWmJ( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), ...
                                Side_Cflag(2), Cntrl_Cflag, Side_Cflag(5), Side_Cflag(3), 5, 'ext', J_0 );
        FourTet(3) = getWmJ( SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(1, :), ...
                                Side_Cflag(2), Cntrl_Cflag, Side_Cflag(3), Side_Cflag(1), 4, 'ext', J_0 );
        FourTet(4) = getWmJ( CntrlCrdnt', SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), ...
                                Cntrl_Cflag, Side_Cflag(3), Side_Cflag(4), Side_Cflag(1), 1, 'ext', J_0 );

        Bk_m = sum(FourTet);
    case '5'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(4), Side_Cflag(3), Cntrl_Cflag, 6, 'ext', J_0 );
        FourTet(2) = getWmJ( SideCrdnt(5, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), ...
                                Side_Cflag(5), Side_Cflag(3), Cntrl_Cflag, Side_Cflag(2), 4, 'inn', J_0 );
        FourTet(3) = getWmJ( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(2, :), SideCrdnt(1, :), ...
                                Side_Cflag(3), Cntrl_Cflag, Side_Cflag(2), Side_Cflag(1), 1, 'inn', J_0 );
        FourTet(4) = getWmJ( SideCrdnt(4, :), SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(1, :), ...
                                Side_Cflag(4), Side_Cflag(3), Cntrl_Cflag, Side_Cflag(1), 4, 'ext', J_0 );

        Bk_m = sum(FourTet);
    case '6'
        Bk_m = 0;
        FourTet = zeros(4, 1);

        FourTet(1) = getWmJ( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(4, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(3), Side_Cflag(4), Cntrl_Cflag, 5, 'inn', J_0 );
        FourTet(2) = getWmJ( SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(5), Side_Cflag(3), Side_Cflag(2), Cntrl_Cflag, 5, 'ext', J_0 );
        FourTet(3) = getWmJ( SideCrdnt(3, :), SideCrdnt(1, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(1), Side_Cflag(2), Cntrl_Cflag, 3, 'ext', J_0 );
        FourTet(4) = getWmJ( SideCrdnt(3, :), SideCrdnt(4, :), SideCrdnt(1, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(4), Side_Cflag(1), Cntrl_Cflag, 3, 'ext', J_0 );

        Bk_m = sum(FourTet);
    case '7'
        Bk_m = 0;
        SixTet = zeros(6, 1);

        % K_1: the 1-st to the 8-th tetdrahedron
        SixTet(1) = getWmJ( SideCrdnt(4, :), SideCrdnt(3, :), SideCrdnt(7, :), CntrlCrdnt', ...
                                Side_Cflag(4), Side_Cflag(3), Side_Cflag(7), Cntrl_Cflag, 5, 'ext', J_0 );
        SixTet(2) = getWmJ( SideCrdnt(3, :), SideCrdnt(7, :), SideCrdnt(6, :), CntrlCrdnt', ...
                                Side_Cflag(3), Side_Cflag(7), Side_Cflag(6), Cntrl_Cflag, 2, 'ext', J_0 );
        SixTet(3) = getWmJ( SideCrdnt(3, :), CntrlCrdnt', SideCrdnt(6, :), SideCrdnt(5, :), ...
                                Side_Cflag(3), Cntrl_Cflag, Side_Cflag(6), Side_Cflag(5), 1, 'inn', J_0 );
        SixTet(4) = getWmJ( SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', SideCrdnt(5, :), ...
                                Side_Cflag(3), Side_Cflag(2), Cntrl_Cflag, Side_Cflag(5), 2, 'inn', J_0 );
        SixTet(5) = getWmJ( SideCrdnt(1, :), SideCrdnt(3, :), SideCrdnt(2, :), CntrlCrdnt', ...
                                Side_Cflag(1), Side_Cflag(3), Side_Cflag(2), Cntrl_Cflag, 5, 'inn', J_0 );
        SixTet(6) = getWmJ( SideCrdnt(4, :), SideCrdnt(1, :), SideCrdnt(3, :), CntrlCrdnt', ...
                                Side_Cflag(4), Side_Cflag(1), Side_Cflag(3), Cntrl_Cflag, 6, 'ext', J_0 );

        Bk_m = sum(SixTet);
    end

end
