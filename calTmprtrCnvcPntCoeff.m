function coeff = calTmprtrCnvcPntCoeff( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                        PntSegMed, mediumTable, T_b, T_bolus, zeta, sigmaMask, ...
                                        rho, cap, rho_b, cap_b, xi, dt, Phi, alpha, BoneMediumTable, MskMedTab )

    PntsIdx       = zeros( 3, 9 );
    MedValue      = zeros( 3, 9 );
    PntsCrdnt     = zeros( 3, 9, 3 );
    MidPntsCrdnt  = zeros( 3, 9, 3 );
    S1            = zeros( 2, 1 );

    PntQseg       = zeros( 6, 8 );
    TtrVol        = zeros( 6, 8 );
    A_row         = zeros( 1, 14 );
    coeff         = zeros( 1, 7 );
    SegValueXZ    = zeros( m, ell, 6, 8, 'uint8' );
    SegValueXZ( m, ell, :, : ) = PntSegMed;

    [ PntQseg, TtrVol ] = calQsegXZ( m, n, ell, Phi, shiftedCoordinateXYZ, SegValueXZ, ...
                                                        x_idx_max, sigmaMask, rho );

    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt  = calMid27Pnts( PntsCrdnt );
    
    MedValue      = get27MedValue( m, n, ell, mediumTable );
    
    S1 = getS1( MidPntsCrdnt, MedValue );

    % TtrVol = cal48TtrVol( MidPntsCrdnt );

    % RhoCapTerm = sum( sum( rho(PntSegMed) .* cap(PntSegMed) .* TtrVol ) ) / dt;
    % % XiRhoTerm  = sum( sum( xi(PntSegMed) .* rho(PntSegMed) .* TtrVol ) ) * rho_b * cap_b;
    % QsTerm     = sum( sum( PntQseg .* TtrVol ) );

    % differentiate the boundary and the rib part.
    if MskMedTab(m, n, ell) == 0 && BoneMediumTable(m, n, ell) == 1 % normal bondary point
        A_row = fillBndrPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, zeta );
    elseif MskMedTab(m, n, ell) == 0 && BoneMediumTable(m, n, ell) == 16  % rib boundary point
        A_row = fillBndrRibPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                MskMedTab, BoneMediumTable, zeta );
    else
        error('check');
    end

    % A_row = fillBndrPt_A( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, mediumTable, zeta, BlsBndryMsk );
    coeff = A_row(8: 14);

    % CurrZeta = zeta( mediumTable(m, n, ell) );

    % Deno = RhoCapTerm;
    % Nume = TmprtrTauMinus(7) * ( RhoCapTerm - sum(S1) * alpha + coeff(7) ) ...
    %             + TmprtrTauMinus(1) * coeff(1) + TmprtrTauMinus(2) * coeff(2) + TmprtrTauMinus(3) * coeff(3) ...
    %             + TmprtrTauMinus(4) * coeff(4) + TmprtrTauMinus(5) * coeff(5) + TmprtrTauMinus(6) * coeff(6) ...
    %             + QsTerm + T_bolus * sum(S1) * alpha;
    % if ( RhoCapTerm - sum(S1) * alpha + coeff(7) ) < 0 
    %     % || ~isempty( find( coeff(1: 6) < 0 ) )
    %     warning('Change the relation between dt and dx (dy, dz)');
    % end
    % Tmprtr = Nume / Deno;

end