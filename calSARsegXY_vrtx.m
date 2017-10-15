function [ PntSARseg, TtrVol, MidPnts9Crdnt ] = calSARsegXY_vrtx( m_B, n_B, ell_B, PhiXY, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B, PntSegMed_B, sigma, rho )

    % notes actually: SARseg = zeros( 1, 1, 6, 8 );
    PntSARseg = zeros( 6, 8 );
    Pnt_absE  = zeros( 6, 8 );
    TtrVol    = zeros( 6, 8 );

    % the PntsIdx is a dummy variable here.
    PntsIdx      = zeros( 3, 9 );
    MidPntsCrdnt = zeros( 3, 9, 3 );
    tmpMidCrdnt  = zeros( 1, 9, 3 );
    MidPhi       = zeros( 3, 9 );
    tmpMidPhi    = zeros( 9, 1 );
    PntSegValue  = PntSegMed_B;

    m_v_B = 2 * m_B - 1;
    n_v_B = 2 * n_B - 1;
    ell_v_B = 2 * ell_B - 1;

    % get MidPntsCrdnt, PntsCrdnt and MidPhi
    [ PntsIdx, MidPntsCrdnt ] = get27Pnts( m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, Vertex_Crdnt_B );
    MidPnts9Crdnt = getMidPnts9CrdntXY( MidPntsCrdnt );
    MidPhi = get27Phi( m_v_B, n_v_B, 2, PhiXY );

% Start from here: cal the volume, the E_x, the E_y and the E_z, and get the corresponding PntSegValue value.
    % p1
    [ PntSARseg(1, :), TtrVol(1, :), Pnt_absE(1, :) ] = calPntSARseg( squeeze( MidPntsCrdnt(3, :, :) ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(1, :), MidPhi(3, :), MidPhi(2, 5), sigma, rho );
    % p2
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    tmpMidPhi   = p2FaceMidPhi( MidPhi );
    [ PntSARseg(2, :), TtrVol(2, :), Pnt_absE(2, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(2, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p3
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    tmpMidPhi   = p3FaceMidPhi( MidPhi );
    [ PntSARseg(3, :), TtrVol(3, :), Pnt_absE(3, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(3, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p4
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    tmpMidPhi   = p4FaceMidPhi( MidPhi );
    [ PntSARseg(4, :), TtrVol(4, :), Pnt_absE(4, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(4, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p5
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    tmpMidPhi   = p5FaceMidPhi( MidPhi );
    [ PntSARseg(5, :), TtrVol(5, :), Pnt_absE(5, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(5, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

    % p6
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    tmpMidPhi   = p6FaceMidPhi( MidPhi );
    [ PntSARseg(6, :), TtrVol(6, :), Pnt_absE(6, :) ] = calPntSARseg( squeeze( tmpMidCrdnt ), squeeze( MidPntsCrdnt(2, 5, :) ), ...
                                PntSegValue(6, :), tmpMidPhi, MidPhi(2, 5), sigma, rho );

end