function Pnts_Cflags = get27_Cflag( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SheetPntsTable )
    
    Pnts_Cflags     = zeros( 3, 9 );

    if m_v >= 2 && m_v <= x_max_vertex - 1 && n_v >= 2 && n_v <= y_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
        Pnts_Cflags( 1, 1 ) = SheetPntsTable( m_v - 1, n_v - 1, ell_v - 1 );
        Pnts_Cflags( 1, 2 ) = SheetPntsTable( m_v    , n_v - 1, ell_v - 1 );
        Pnts_Cflags( 1, 3 ) = SheetPntsTable( m_v + 1, n_v - 1, ell_v - 1 );
        Pnts_Cflags( 1, 4 ) = SheetPntsTable( m_v - 1, n_v    , ell_v - 1 );
        Pnts_Cflags( 1, 5 ) = SheetPntsTable( m_v    , n_v    , ell_v - 1 );
        Pnts_Cflags( 1, 6 ) = SheetPntsTable( m_v + 1, n_v    , ell_v - 1 );
        Pnts_Cflags( 1, 7 ) = SheetPntsTable( m_v - 1, n_v + 1, ell_v - 1 );
        Pnts_Cflags( 1, 8 ) = SheetPntsTable( m_v    , n_v + 1, ell_v - 1 );
        Pnts_Cflags( 1, 9 ) = SheetPntsTable( m_v + 1, n_v + 1, ell_v - 1 );

        Pnts_Cflags( 2, 1 ) = SheetPntsTable( m_v - 1, n_v - 1, ell_v     );
        Pnts_Cflags( 2, 2 ) = SheetPntsTable( m_v    , n_v - 1, ell_v     );
        Pnts_Cflags( 2, 3 ) = SheetPntsTable( m_v + 1, n_v - 1, ell_v     );
        Pnts_Cflags( 2, 4 ) = SheetPntsTable( m_v - 1, n_v    , ell_v     );
        Pnts_Cflags( 2, 5 ) = SheetPntsTable( m_v    , n_v    , ell_v     );
        Pnts_Cflags( 2, 6 ) = SheetPntsTable( m_v + 1, n_v    , ell_v     );
        Pnts_Cflags( 2, 7 ) = SheetPntsTable( m_v - 1, n_v + 1, ell_v     );
        Pnts_Cflags( 2, 8 ) = SheetPntsTable( m_v    , n_v + 1, ell_v     );
        Pnts_Cflags( 2, 9 ) = SheetPntsTable( m_v + 1, n_v + 1, ell_v     );

        Pnts_Cflags( 3, 1 ) = SheetPntsTable( m_v - 1, n_v - 1, ell_v + 1 );
        Pnts_Cflags( 3, 2 ) = SheetPntsTable( m_v    , n_v - 1, ell_v + 1 );
        Pnts_Cflags( 3, 3 ) = SheetPntsTable( m_v + 1, n_v - 1, ell_v + 1 );
        Pnts_Cflags( 3, 4 ) = SheetPntsTable( m_v - 1, n_v    , ell_v + 1 );
        Pnts_Cflags( 3, 5 ) = SheetPntsTable( m_v    , n_v    , ell_v + 1 );
        Pnts_Cflags( 3, 6 ) = SheetPntsTable( m_v + 1, n_v    , ell_v + 1 );
        Pnts_Cflags( 3, 7 ) = SheetPntsTable( m_v - 1, n_v + 1, ell_v + 1 );
        Pnts_Cflags( 3, 8 ) = SheetPntsTable( m_v    , n_v + 1, ell_v + 1 );
        Pnts_Cflags( 3, 9 ) = SheetPntsTable( m_v + 1, n_v + 1, ell_v + 1 );
    end

end