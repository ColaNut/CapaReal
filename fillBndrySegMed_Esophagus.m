function SegMed = fillBndrySegMed_Esophagus( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                    mediumTable, SegMed, EsBndryNum, EsNum )

    PntsIdx       = zeros( 3, 9 );
    PntsCrdnt     = zeros( 3, 9, 3 );
    PntsMed       = zeros( 3, 9 );
    MidPntsCrdnt  = zeros( 3, 9, 3 );
    tmpMidCrdnt   = zeros( 1, 9, 3 );
    tmpMed2Layers = zeros( 2, 9 );
    % SegMed        = ones( 6, 8, 'uint8' );
    
    loadParas;
    loadAmendParas_Esophagus;
    tumor_y_es_n = tumor_y_es / dy + h_torso / (2 * dy) + 1;
    
    [ PntsIdx, PntsCrdnt ]  = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    PntsMed                 = get27PntsMed( PntsIdx, mediumTable );
    MidPntsCrdnt            = calMid27Pnts( PntsCrdnt );

    % p1
    tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    if PntsMed(3, 5) == 1
        SegMed(1, :) = ones( size(SegMed(1, :)) ) * PntsMed(3, 5);
    % elseif PntsMed(3, 5) == EsBndryNum
    %     SegMed(1, :) = fillSideBndrySegMed_Esophagus( squeeze( MidPntsCrdnt(3, :, :) ), ...
    %                     squeeze( PntsCrdnt(2, 5, :) )', PntsMed(3, 5), PntsMed(2, 5) );
    end

    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    if PntsMed(2, 4) == 1
        SegMed(2, :) = ones( size(SegMed(2, :)) ) * PntsMed(2, 4);
    % elseif PntsMed(2, 4) == EsBndryNum
    %     SegMed(2, :) = fillSideBndrySegMed_Esophagus( squeeze( tmpMidCrdnt ), ...
    %                     squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 4), PntsMed(2, 5) );
    end

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    if PntsMed(1, 5) == 1
        SegMed(3, :) = ones( size(SegMed(3, :)) ) * PntsMed(1, 5);
        if n == tumor_y_es_n
            SegMed(3, :) = 9;
        end
    % elseif PntsMed(1, 5) == EsBndryNum
    %     tmpMed2Layers = p3FaceMed( PntsMed );
    %     SegMed(3, :) = fillSideBndrySegMed_Esophagus( squeeze( tmpMidCrdnt ), ...
    %                     squeeze( PntsCrdnt(2, 5, :) )', PntsMed(1, 5), PntsMed(2, 5) );
    end

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    if PntsMed(2, 6) == 1
        SegMed(4, :) = ones( size(SegMed(4, :)) ) * PntsMed(2, 6);
    % elseif PntsMed(2, 6) == EsBndryNum
    %     tmpMed2Layers = p4FaceMed( PntsMed );
    %     SegMed(4, :) = fillSideBndrySegMed_Esophagus( squeeze( tmpMidCrdnt ), ...
    %                     squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 6), PntsMed(2, 5) );
    end

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    if PntsMed(2, 8) == 1
        SegMed(5, :) = ones( size(SegMed(5, :)) ) * PntsMed(2, 8);
    elseif PntsMed(2, 8) == EsBndryNum
        tmpMed2Layers = p5FaceMed( PntsMed );
        SegMed(5, :) = fillSideBndrySegMed_Esophagus( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 8), PntsMed(2, 5), SegMed(5, :) );
    else
        error('check');
    end

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    if PntsMed(2, 2) == 1
        SegMed(6, :) = ones( size(SegMed(6, :)) ) * PntsMed(2, 2);
    elseif PntsMed(2, 2) == EsBndryNum
        tmpMed2Layers = p6FaceMed( PntsMed );
        SegMed(6, :) = fillSideBndrySegMed_Esophagus( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 2), PntsMed(2, 5), SegMed(6, :) );
    else
        error('check');
    end

end