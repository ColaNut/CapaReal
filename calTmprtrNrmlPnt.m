function Tmprtr = calTmprtrNrmlPnt( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                        T_b, zeta, sigma, rho, cap, rho_b, cap_b, xi, dt, TmprtrTauMinus, Phi, LungRatio, BoneMediumTable, MskMedTab, PennesCoeff )

    PntsIdx      = zeros( 3, 9 );
    % MedValue     = zeros( 3, 9 );
    % PntsCrdnt    = zeros( 3, 9, 3 );
    % MidPntsCrdnt = zeros( 3, 9, 3 );
    PntQseg      = zeros( 6, 8 );
    TtrVol       = zeros( 6, 8 );
    A_row        = zeros( 1, 14 );
    coeff        = zeros( 1, 7 );
    SegValueXZ   = zeros( m, ell, 6, 8, 'uint8' );
    SegValueXZ( m, ell, :, : ) = PntSegMed;

    [ PntQseg, TtrVol ] = calQsegXZ( m, n, ell, Phi, shiftedCoordinateXYZ, SegValueXZ, ...
                                                        x_idx_max, sigma, rho );

    % [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    % MidPntsCrdnt = calMid27Pnts( PntsCrdnt );

    % TtrVol = cal48TtrVol( MidPntsCrdnt );

    LungIdx  = find(PntSegMed == 4);
    LungMask = ones(size(PntSegMed));
    LungMask(LungIdx) = LungRatio;
    
    RhoCapTerm = sum( sum( rho(PntSegMed) .* cap(PntSegMed) .* TtrVol .* LungMask ) ) / dt;
    XiRhoTerm  = sum( sum( xi(PntSegMed) .* rho(PntSegMed) .* TtrVol .* LungMask ) ) * rho_b * cap_b;
    QsTerm     = sum( sum( PntQseg .* TtrVol .* LungMask ) );

    % feed in the MskMedTab
    % differentiate the normal and the rib part.
    % if BoneMediumTable(m, n, ell) == 1 % normal normal point
    %     % if mediumTable(p0) == 1 || mediumTable(p0) == 2 || mediumTable(p0) == 3 || mediumTable(p0) == 4 || mediumTable(p0) == 5 
    %         A_row = fillNrmlPt_A( m, n, ell, ...
    %                         shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
    %         A_row = A_row * zeta( mediumTable(m, n, ell) );
    % elseif BoneMediumTable(m, n, ell) >= 16 && BoneMediumTable(m, n, ell) <= 18 % rib normal point
    %         A_row = fillNrmlRibPt_A( m, n, ell, ...
    %             shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
    %                 MskMedTab, BoneMediumTable, zeta );
    % else
    %     error('check');
    % end

    % A_row = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
    % A_row = fillNrmlPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable );
    % coeff = A_row(8: 14);
    coeff = PennesCoeff;

    % CurrZeta = zeta( mediumTable(m, n, ell) );

    Deno = RhoCapTerm;
    Nume = TmprtrTauMinus(7) * ( RhoCapTerm - XiRhoTerm + coeff(7) ) ...
    + ( TmprtrTauMinus(1) * coeff(1) + TmprtrTauMinus(2) * coeff(2) + TmprtrTauMinus(3) * coeff(3) ...
        + TmprtrTauMinus(4) * coeff(4) + TmprtrTauMinus(5) * coeff(5) + TmprtrTauMinus(6) * coeff(6) )...
        + T_b * XiRhoTerm + QsTerm;
    Tmprtr = Nume / Deno;

end