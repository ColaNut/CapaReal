function PntH_XZ = getH_XZ(m, n, ell, x_idx_max, y_idx_max, x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, A, mu, PntSegMed)
    PntH_XZ = zeros(6, 8, 3);

    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );

    % p1 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p1');
    PntH_XZ(1, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( MidPntsCrdnt(3, :, :) ), ...
                                            IdxSet, A, mu, PntSegMed(1, :) );

    % p2 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p2');
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    PntH_XZ(2, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(2, :) );

    % p3 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p3');
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    PntH_XZ(3, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(3, :) );

    % p4 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p4');
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    PntH_XZ(4, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(4, :) );

    % p5 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p5');
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    PntH_XZ(5, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(5, :) );

    % p6 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, A, 'p6');
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    PntH_XZ(6, :, :) = getSideH_XZ( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(6, :) );
end
