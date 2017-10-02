function SegMed = fillBndrySegMed( m, n, ell, shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, ...
                                    mediumTable, varargin )

    PntsIdx       = zeros( 3, 9 );
    PntsCrdnt     = zeros( 3, 9, 3 );
    PntsMed       = zeros( 3, 9 );
    MidPntsCrdnt  = zeros( 3, 9, 3 );
    tmpMidCrdnt   = zeros( 1, 9, 3 );
    tmpMed2Layers = zeros( 2, 9 );
    SegMed        = ones( 6, 8, 'uint8' );
    
    [ PntsIdx, PntsCrdnt ]  = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    PntsMed                 = get27PntsMed( PntsIdx, mediumTable );
    MidPntsCrdnt            = calMid27Pnts( PntsCrdnt );

    % p1
    tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    if PntsMed(3, 5) < 10
        SegMed(1, :) = ones( size(SegMed(1, :)) ) * PntsMed(3, 5);
    else
        SegMed(1, :) = fillSideBndrySegMed( squeeze( MidPntsCrdnt(3, :, :) ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(3, 5), PntsMed(2, 5), varargin{:} );
    end

    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    if PntsMed(2, 4) < 10
        SegMed(2, :) = ones( size(SegMed(2, :)) ) * PntsMed(2, 4);
    else
        SegMed(2, :) = fillSideBndrySegMed( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 4), PntsMed(2, 5), varargin{:} );
    end

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    if PntsMed(1, 5) < 10
        SegMed(3, :) = ones( size(SegMed(3, :)) ) * PntsMed(1, 5);
    else
        tmpMed2Layers = p3FaceMed( PntsMed );
        SegMed(3, :) = fillSideBndrySegMed( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(1, 5), PntsMed(2, 5), varargin{:} );
    end

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    if PntsMed(2, 6) < 10
        SegMed(4, :) = ones( size(SegMed(4, :)) ) * PntsMed(2, 6);
    else
        tmpMed2Layers = p4FaceMed( PntsMed );
        SegMed(4, :) = fillSideBndrySegMed( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 6), PntsMed(2, 5), varargin{:} );
    end

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    if PntsMed(2, 8) < 10
        SegMed(5, :) = ones( size(SegMed(5, :)) ) * PntsMed(2, 8);
    else
        tmpMed2Layers = p5FaceMed( PntsMed );
        SegMed(5, :) = fillSideBndrySegMed( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 8), PntsMed(2, 5), varargin{:} );
    end

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    if PntsMed(2, 2) < 10
        SegMed(6, :) = ones( size(SegMed(6, :)) ) * PntsMed(2, 2);
    else
        tmpMed2Layers = p6FaceMed( PntsMed );
        SegMed(6, :) = fillSideBndrySegMed( squeeze( tmpMidCrdnt ), ...
                        squeeze( PntsCrdnt(2, 5, :) )', PntsMed(2, 2), PntsMed(2, 5), varargin{:} );
    end

end