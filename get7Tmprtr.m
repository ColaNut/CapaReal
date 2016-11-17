function TmprtrTauMinus = get7Tmprtr( m, n, ell, t_Minus, TmprtrTau )
    
    TmprtrTauMinus = zeros(7, 1);

    TmprtrTauMinus(1) = TmprtrTau( m    , n    , ell + 1, t_Minus );
    TmprtrTauMinus(2) = TmprtrTau( m - 1, n    , ell    , t_Minus );
    TmprtrTauMinus(3) = TmprtrTau( m    , n    , ell - 1, t_Minus );
    TmprtrTauMinus(4) = TmprtrTau( m + 1, n    , ell    , t_Minus );
    TmprtrTauMinus(5) = TmprtrTau( m    , n + 1, ell    , t_Minus );
    TmprtrTauMinus(6) = TmprtrTau( m    , n - 1, ell    , t_Minus );
    TmprtrTauMinus(7) = TmprtrTau( m    , n    , ell    , t_Minus );

end