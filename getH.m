function PntH = getH(m, n, ell, x_idx_max, y_idx_max, x_max_vertex, y_max_vertex, z_max_vertex, shiftedCoordinateXYZ, A, mu, PntSegMed)
    PntH = zeros(6, 8, 3);

    [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
    MidPntsCrdnt = calMid27Pnts( PntsCrdnt );

    % p1 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p1');
    PntH(1, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( MidPntsCrdnt(3, :, :) ), ...
                                            IdxSet, A, mu, PntSegMed(1, :), 'p1' );

    % p2 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p2');
    tmpMidCrdnt = p2Face( MidPntsCrdnt );
    PntH(2, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(2, :), 'p2');

    % p3 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p3');
    tmpMidCrdnt = p3Face( MidPntsCrdnt );
    PntH(3, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(3, :), 'p3');

    % p4 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p4');
    tmpMidCrdnt = p4Face( MidPntsCrdnt );
    PntH(4, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(4, :), 'p4');

    % p5 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p5');
    tmpMidCrdnt = p5Face( MidPntsCrdnt );
    PntH(5, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(5, :), 'p5');

    % p6 face
    IdxSet = get_eIdxSet(m, n, ell, x_max_vertex, y_max_vertex, z_max_vertex, 'p6');
    tmpMidCrdnt = p6Face( MidPntsCrdnt );
    PntH(6, :, :) = getSideH( squeeze( MidPntsCrdnt(2, 5, :) ), squeeze( tmpMidCrdnt ), ...
                                            IdxSet, A, mu, PntSegMed(6, :), 'p6');
end
