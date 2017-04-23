function [ PntsIdx, PntsCrdnt ] = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt )

    PntsIdx     = zeros( 3, 9 );
    PntsCrdnt   = zeros( 3, 9, 3 );
    % PntsMed     = zeros( 3, 9 );

    PntsIdx( 1, 1 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 1, 2 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v );
    PntsIdx( 1, 3 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 1, 4 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 1, 5 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v );
    PntsIdx( 1, 6 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 1, 7 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v - 1 );
    PntsIdx( 1, 8 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v );
    PntsIdx( 1, 9 ) = int64( ( ell_v - 2 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1 );

    PntsIdx( 2, 1 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 2, 2 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v );
    PntsIdx( 2, 3 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 2, 4 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 2, 5 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v );
    PntsIdx( 2, 6 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 2, 7 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v - 1 );
    PntsIdx( 2, 8 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v );
    PntsIdx( 2, 9 ) = int64( ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1 );

    PntsIdx( 3, 1 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 3, 2 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v );
    PntsIdx( 3, 3 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 2 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 3, 4 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v - 1 );
    PntsIdx( 3, 5 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v );
    PntsIdx( 3, 6 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v + 1 );
    PntsIdx( 3, 7 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v - 1 );
    PntsIdx( 3, 8 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v );
    PntsIdx( 3, 9 ) = int64( ( ell_v     ) * x_max_vertex * y_max_vertex + ( n_v     ) * x_max_vertex + m_v + 1 );

    % need to check whether to add squeeze or not.
    PntsCrdnt( 1, 1, : ) = getCoord( m_v - 1, n_v - 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 2, : ) = getCoord( m_v    , n_v - 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 3, : ) = getCoord( m_v + 1, n_v - 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 4, : ) = getCoord( m_v - 1, n_v    , ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 5, : ) = getCoord( m_v    , n_v    , ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 6, : ) = getCoord( m_v + 1, n_v    , ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 7, : ) = getCoord( m_v - 1, n_v + 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 8, : ) = getCoord( m_v    , n_v + 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 1, 9, : ) = getCoord( m_v + 1, n_v + 1, ell_v - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    PntsCrdnt( 2, 1, : ) = getCoord( m_v - 1, n_v - 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 2, : ) = getCoord( m_v    , n_v - 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 3, : ) = getCoord( m_v + 1, n_v - 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 4, : ) = getCoord( m_v - 1, n_v    , ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 5, : ) = getCoord( m_v    , n_v    , ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 6, : ) = getCoord( m_v + 1, n_v    , ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 7, : ) = getCoord( m_v - 1, n_v + 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 8, : ) = getCoord( m_v    , n_v + 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 2, 9, : ) = getCoord( m_v + 1, n_v + 1, ell_v    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    PntsCrdnt( 3, 1, : ) = getCoord( m_v - 1, n_v - 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 2, : ) = getCoord( m_v    , n_v - 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 3, : ) = getCoord( m_v + 1, n_v - 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 4, : ) = getCoord( m_v - 1, n_v    , ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 5, : ) = getCoord( m_v    , n_v    , ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 6, : ) = getCoord( m_v + 1, n_v    , ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 7, : ) = getCoord( m_v - 1, n_v + 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 8, : ) = getCoord( m_v    , n_v + 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsCrdnt( 3, 9, : ) = getCoord( m_v + 1, n_v + 1, ell_v + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    % PntsMed( 1, 1 ) = mediumTable( PntsIdx( 1, 1 ) );
    % PntsMed( 1, 2 ) = mediumTable( PntsIdx( 1, 2 ) );
    % PntsMed( 1, 3 ) = mediumTable( PntsIdx( 1, 3 ) );
    % PntsMed( 1, 4 ) = mediumTable( PntsIdx( 1, 4 ) );
    % PntsMed( 1, 5 ) = mediumTable( PntsIdx( 1, 5 ) );
    % PntsMed( 1, 6 ) = mediumTable( PntsIdx( 1, 6 ) );
    % PntsMed( 1, 7 ) = mediumTable( PntsIdx( 1, 7 ) );
    % PntsMed( 1, 8 ) = mediumTable( PntsIdx( 1, 8 ) );
    % PntsMed( 1, 9 ) = mediumTable( PntsIdx( 1, 9 ) );

    % PntsMed( 2, 1 ) = mediumTable( PntsIdx( 2, 1 ) );
    % PntsMed( 2, 2 ) = mediumTable( PntsIdx( 2, 2 ) );
    % PntsMed( 2, 3 ) = mediumTable( PntsIdx( 2, 3 ) );
    % PntsMed( 2, 4 ) = mediumTable( PntsIdx( 2, 4 ) );
    % PntsMed( 2, 5 ) = mediumTable( PntsIdx( 2, 5 ) );
    % PntsMed( 2, 6 ) = mediumTable( PntsIdx( 2, 6 ) );
    % PntsMed( 2, 7 ) = mediumTable( PntsIdx( 2, 7 ) );
    % PntsMed( 2, 8 ) = mediumTable( PntsIdx( 2, 8 ) );
    % PntsMed( 2, 9 ) = mediumTable( PntsIdx( 2, 9 ) );

    % PntsMed( 3, 1 ) = mediumTable( PntsIdx( 3, 1 ) );
    % PntsMed( 3, 2 ) = mediumTable( PntsIdx( 3, 2 ) );
    % PntsMed( 3, 3 ) = mediumTable( PntsIdx( 3, 3 ) );
    % PntsMed( 3, 4 ) = mediumTable( PntsIdx( 3, 4 ) );
    % PntsMed( 3, 5 ) = mediumTable( PntsIdx( 3, 5 ) );
    % PntsMed( 3, 6 ) = mediumTable( PntsIdx( 3, 6 ) );
    % PntsMed( 3, 7 ) = mediumTable( PntsIdx( 3, 7 ) );
    % PntsMed( 3, 8 ) = mediumTable( PntsIdx( 3, 8 ) );
    % PntsMed( 3, 9 ) = mediumTable( PntsIdx( 3, 9 ) );

end