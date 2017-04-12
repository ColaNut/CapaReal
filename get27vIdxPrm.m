function vIdxPrm = get27vIdxPrm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex )

    vIdxPrm     = zeros( 3, 9 );
    % PntsCrdnt   = zeros( 3, 9, 3 );
    % PntsMed     = zeros( 3, 9 );

    vIdxPrm( 1, 1 ) = get_idx_prm( m_v - 1, n_v - 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 2 ) = get_idx_prm( m_v    , n_v - 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 3 ) = get_idx_prm( m_v + 1, n_v - 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 4 ) = get_idx_prm( m_v - 1, n_v    , ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 5 ) = get_idx_prm( m_v    , n_v    , ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 6 ) = get_idx_prm( m_v + 1, n_v    , ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 7 ) = get_idx_prm( m_v - 1, n_v + 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 8 ) = get_idx_prm( m_v    , n_v + 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 1, 9 ) = get_idx_prm( m_v + 1, n_v + 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex ); 

    vIdxPrm( 2, 1 ) = get_idx_prm( m_v - 1, n_v - 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 2 ) = get_idx_prm( m_v    , n_v - 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 3 ) = get_idx_prm( m_v + 1, n_v - 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 4 ) = get_idx_prm( m_v - 1, n_v    , ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 5 ) = get_idx_prm( m_v    , n_v    , ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 6 ) = get_idx_prm( m_v + 1, n_v    , ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 7 ) = get_idx_prm( m_v - 1, n_v + 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 8 ) = get_idx_prm( m_v    , n_v + 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 2, 9 ) = get_idx_prm( m_v + 1, n_v + 1, ell_v    , x_max_vertex, y_max_vertex, z_max_vertex ); 

    vIdxPrm( 3, 1 ) = get_idx_prm( m_v - 1, n_v - 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 2 ) = get_idx_prm( m_v    , n_v - 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 3 ) = get_idx_prm( m_v + 1, n_v - 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 4 ) = get_idx_prm( m_v - 1, n_v    , ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 5 ) = get_idx_prm( m_v    , n_v    , ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 6 ) = get_idx_prm( m_v + 1, n_v    , ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 7 ) = get_idx_prm( m_v - 1, n_v + 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 8 ) = get_idx_prm( m_v    , n_v + 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 
    vIdxPrm( 3, 9 ) = get_idx_prm( m_v + 1, n_v + 1, ell_v + 1, x_max_vertex, y_max_vertex, z_max_vertex ); 

    % % need to check whether to add squeeze or not.
    % PntsCrdnt( 1, 1, : ) = getCoord( m - 1, n - 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 2, : ) = getCoord( m    , n - 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 3, : ) = getCoord( m + 1, n - 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 4, : ) = getCoord( m - 1, n    , ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 5, : ) = getCoord( m    , n    , ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 6, : ) = getCoord( m + 1, n    , ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 7, : ) = getCoord( m - 1, n + 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 8, : ) = getCoord( m    , n + 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 1, 9, : ) = getCoord( m + 1, n + 1, ell - 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    % PntsCrdnt( 2, 1, : ) = getCoord( m - 1, n - 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 2, : ) = getCoord( m    , n - 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 3, : ) = getCoord( m + 1, n - 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 4, : ) = getCoord( m - 1, n    , ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 5, : ) = getCoord( m    , n    , ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 6, : ) = getCoord( m + 1, n    , ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 7, : ) = getCoord( m - 1, n + 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 8, : ) = getCoord( m    , n + 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 2, 9, : ) = getCoord( m + 1, n + 1, ell    , Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    % PntsCrdnt( 3, 1, : ) = getCoord( m - 1, n - 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 2, : ) = getCoord( m    , n - 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 3, : ) = getCoord( m + 1, n - 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 4, : ) = getCoord( m - 1, n    , ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 5, : ) = getCoord( m    , n    , ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 6, : ) = getCoord( m + 1, n    , ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 7, : ) = getCoord( m - 1, n + 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 8, : ) = getCoord( m    , n + 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );
    % PntsCrdnt( 3, 9, : ) = getCoord( m + 1, n + 1, ell + 1, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex );

    % PntsMed( 1, 1 ) = mediumTable( vIdxPrm( 1, 1 ) );
    % PntsMed( 1, 2 ) = mediumTable( vIdxPrm( 1, 2 ) );
    % PntsMed( 1, 3 ) = mediumTable( vIdxPrm( 1, 3 ) );
    % PntsMed( 1, 4 ) = mediumTable( vIdxPrm( 1, 4 ) );
    % PntsMed( 1, 5 ) = mediumTable( vIdxPrm( 1, 5 ) );
    % PntsMed( 1, 6 ) = mediumTable( vIdxPrm( 1, 6 ) );
    % PntsMed( 1, 7 ) = mediumTable( vIdxPrm( 1, 7 ) );
    % PntsMed( 1, 8 ) = mediumTable( vIdxPrm( 1, 8 ) );
    % PntsMed( 1, 9 ) = mediumTable( vIdxPrm( 1, 9 ) );

    % PntsMed( 2, 1 ) = mediumTable( vIdxPrm( 2, 1 ) );
    % PntsMed( 2, 2 ) = mediumTable( vIdxPrm( 2, 2 ) );
    % PntsMed( 2, 3 ) = mediumTable( vIdxPrm( 2, 3 ) );
    % PntsMed( 2, 4 ) = mediumTable( vIdxPrm( 2, 4 ) );
    % PntsMed( 2, 5 ) = mediumTable( vIdxPrm( 2, 5 ) );
    % PntsMed( 2, 6 ) = mediumTable( vIdxPrm( 2, 6 ) );
    % PntsMed( 2, 7 ) = mediumTable( vIdxPrm( 2, 7 ) );
    % PntsMed( 2, 8 ) = mediumTable( vIdxPrm( 2, 8 ) );
    % PntsMed( 2, 9 ) = mediumTable( vIdxPrm( 2, 9 ) );

    % PntsMed( 3, 1 ) = mediumTable( vIdxPrm( 3, 1 ) );
    % PntsMed( 3, 2 ) = mediumTable( vIdxPrm( 3, 2 ) );
    % PntsMed( 3, 3 ) = mediumTable( vIdxPrm( 3, 3 ) );
    % PntsMed( 3, 4 ) = mediumTable( vIdxPrm( 3, 4 ) );
    % PntsMed( 3, 5 ) = mediumTable( vIdxPrm( 3, 5 ) );
    % PntsMed( 3, 6 ) = mediumTable( vIdxPrm( 3, 6 ) );
    % PntsMed( 3, 7 ) = mediumTable( vIdxPrm( 3, 7 ) );
    % PntsMed( 3, 8 ) = mediumTable( vIdxPrm( 3, 8 ) );
    % PntsMed( 3, 9 ) = mediumTable( vIdxPrm( 3, 9 ) );

end