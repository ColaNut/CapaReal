function varargout = fillNrml_K_Type1( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                    z_max_vertex, PntSegMed, auxiSegMed, epsilon_r, mu_r, omega, B_k, SheetPntsTable, J_0, corner_flag )

    K1_row_1    = ones(1, 50);
    K1_row_2    = ones(1, 50);
    K1_row_3    = ones(1, 50);
    K1_row_4    = ones(1, 26);
    K1_row_5    = ones(1, 26);
    K1_row_6    = ones(1, 26);
    K1_row_7    = ones(1, 38);

    KEV_row_1   = ones(1, 20);
    KEV_row_2   = ones(1, 20);
    KEV_row_3   = ones(1, 20);
    KEV_row_4   = ones(1, 12);
    KEV_row_5   = ones(1, 12);
    KEV_row_6   = ones(1, 12);
    KEV_row_7   = ones(1, 16);

    KVE_col_1   = KEV_row_1';
    KVE_col_2   = KEV_row_2';
    KVE_col_3   = KEV_row_3';
    KVE_col_4   = KEV_row_4';
    KVE_col_5   = KEV_row_5';
    KVE_col_6   = KEV_row_6';
    KVE_col_7   = KEV_row_7';

    PntsIdx     = zeros( 3, 9 );
    PntsIdx_prm = zeros( 3, 9 );
    PntsCrdnt   = zeros( 3, 9, 3 ); 
    Pnts_Cflags = zeros(3, 9, 'uint8');

    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );

    [ PntsIdx_prm, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    try
    Pnts_Cflags = get27_Cflag( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SheetPntsTable );
    catch
        [m_v, n_v, ell_v]
    end

    % if K1_flag
        % 1-st edge
        K1_row_1(1)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(2)    = vIdx2eIdx(PntsIdx_prm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(3)    = vIdx2eIdx(PntsIdx_prm(3, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(4)    = vIdx2eIdx(PntsIdx_prm(3, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(5)    = vIdx2eIdx(PntsIdx_prm(3, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(6)    = vIdx2eIdx(PntsIdx_prm(3, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(7)    = vIdx2eIdx(PntsIdx_prm(3, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(8)    = vIdx2eIdx(PntsIdx_prm(3, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(9)    = vIdx2eIdx(PntsIdx_prm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(10)   = vIdx2eIdx(PntsIdx_prm(2, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(11)   = vIdx2eIdx(PntsIdx_prm(2, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(12)   = vIdx2eIdx(PntsIdx_prm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(13)   = vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(14)   = vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(15)   = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(16)   = vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(17)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(18)   = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(19)   = vIdx2eIdx(PntsIdx_prm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(20)   = vIdx2eIdx(PntsIdx_prm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(21)   = vIdx2eIdx(PntsIdx_prm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(22)   = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(23)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(24)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_1(25)   = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    % end
    KEV_row_1(1: 9) = p2Face_2( PntsIdx, 'Med' )';
    KEV_row_1(10)   = PntsIdx(2, 5);
    KVE_col_1(1: 10) = KEV_row_1(1: 10)';

    % p1
    % tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    % each face have ten contribution: 9 on each face and 1 in the center.
    FaceCrdnt = zeros( 1, 9, 3 );
    FaceCrdnt = p2Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(9, 1, 'uint8');
    Side_Cflags = p2Face_2( Pnts_Cflags, 'Med' );
    % K_1 [000, 1], [111, 1] 
    [ K1_row_1(26: 50), KEV_row_1(11: 20), KVE_col_1(11: 20) ] = calK_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(2, :), mu_r, epsilon_r, corner_flag, '1' );
    B_k( K1_row_1(25) ) = calBk_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '1' );

    % if K1_flag
        % 2-nd edge
        K1_row_2(1)    = vIdx2eIdx(PntsIdx_prm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(2)    = vIdx2eIdx(PntsIdx_prm(3, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(3)    = vIdx2eIdx(PntsIdx_prm(3, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(4)    = vIdx2eIdx(PntsIdx_prm(3, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(5)    = vIdx2eIdx(PntsIdx_prm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(6)    = vIdx2eIdx(PntsIdx_prm(3, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(7)    = vIdx2eIdx(PntsIdx_prm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(8)    = vIdx2eIdx(PntsIdx_prm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(9)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(10)   = vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(11)   = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(12)   = vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(13)   = vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(14)   = vIdx2eIdx(PntsIdx_prm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(15)   = vIdx2eIdx(PntsIdx_prm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(16)   = vIdx2eIdx(PntsIdx_prm(2, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(17)   = vIdx2eIdx(PntsIdx_prm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(18)   = vIdx2eIdx(PntsIdx_prm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(19)   = vIdx2eIdx(PntsIdx_prm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(20)   = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(21)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(22)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(23)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(24)   = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_2(25)   = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    % end

    KEV_row_2(1: 9) = p6Face_2( PntsIdx, 'Med' )';
    KEV_row_2(10)   = PntsIdx(2, 5);
    KVE_col_2(1: 10) = KEV_row_2(1: 10)';

    FaceCrdnt = zeros( 1, 9, 3 );
    FaceCrdnt = p6Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(9, 1, 'uint8');
    Side_Cflags = p6Face_2( Pnts_Cflags, 'Med' );
    [ K1_row_2(26: 50), KEV_row_2(11: 20), KVE_col_2(11: 20) ] = calK_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(6, :), mu_r, epsilon_r, corner_flag, '2' );
    B_k( K1_row_2(25) ) = calBk_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '2' );

    % if K1_flag
        % 3-rd edge
        K1_row_3(1)    = vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(2)    = vIdx2eIdx(PntsIdx_prm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(3)    = vIdx2eIdx(PntsIdx_prm(1, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(4)    = vIdx2eIdx(PntsIdx_prm(1, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(5)    = vIdx2eIdx(PntsIdx_prm(1, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(6)    = vIdx2eIdx(PntsIdx_prm(1, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(7)    = vIdx2eIdx(PntsIdx_prm(1, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(8)    = vIdx2eIdx(PntsIdx_prm(1, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(9)    = vIdx2eIdx(PntsIdx_prm(1, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(10)   = vIdx2eIdx(PntsIdx_prm(1, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(11)   = vIdx2eIdx(PntsIdx_prm(1, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(12)   = vIdx2eIdx(PntsIdx_prm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(13)   = vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(14)   = vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(15)   = vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(16)   = vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(17)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(18)   = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(19)   = vIdx2eIdx(PntsIdx_prm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(20)   = vIdx2eIdx(PntsIdx_prm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(21)   = vIdx2eIdx(PntsIdx_prm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(22)   = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(23)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(24)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_3(25)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    % end

    KEV_row_3(1: 9) = p3Face_2( PntsIdx, 'Med' )';
    KEV_row_3(10)   = PntsIdx(2, 5);
    KVE_col_3(1: 10) = KEV_row_3(1: 10)';

    FaceCrdnt = zeros( 1, 9, 3 );
    FaceCrdnt = p3Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(9, 1, 'uint8');
    Side_Cflags = p3Face_2( Pnts_Cflags, 'Med' );
    % FaceCrdnt = p3Face( PntsCrdnt );
    [ K1_row_3(26: 50), KEV_row_3(11: 20), KVE_col_3(11: 20) ] = calK_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(3, :), mu_r, epsilon_r, corner_flag, '3' );
    B_k( K1_row_3(25) ) = calBk_Type1( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '3' );

    % if K1_flag
        % 4-th edge
        K1_row_4(1)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(2)    = vIdx2eIdx(PntsIdx_prm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(3)    = vIdx2eIdx(PntsIdx_prm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(4)    = vIdx2eIdx(PntsIdx_prm(3, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(5)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(6)    = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(7)    = vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(8)    = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(9)    = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(10)   = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(11)   = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_4(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    % end
    
    KEV_row_4(1: 5) = p26Face_2( PntsIdx, 'Med' )';
    KEV_row_4(6)    = PntsIdx(2, 5);
    KEV_col_4(1: 6) = KEV_row_4(1: 6)';

    FaceCrdnt = zeros(1, 5, 3);
    FaceCrdnt = p26Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(5, 1);
    Side_Cflags = p26Face_2( Pnts_Cflags, 'Med' );
    tmpSegMed = zeros(1, 4, 'uint8');
    tmpSegMed = [ PntSegMed(6, 4), PntSegMed(2, 1), PntSegMed(2, 8), PntSegMed(6, 5) ];
    [ K1_row_4(14: 26), KEV_row_4(7: 12), KEV_col_4(7: 12) ] = calK_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), tmpSegMed, mu_r, epsilon_r, corner_flag, '4' );
    B_k( K1_row_4(13) ) = calBk_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '4' );

    % if K1_flag
        % 5-th edge
        K1_row_5(1)    = vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(2)    = vIdx2eIdx(PntsIdx_prm(1, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(3)    = vIdx2eIdx(PntsIdx_prm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(4)    = vIdx2eIdx(PntsIdx_prm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(5)    = vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(6)    = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(7)    = vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(8)    = vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(9)    = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(10)   = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(11)   = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_5(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    % end
    KEV_row_5(1: 5) = p63Face_2( PntsIdx, 'Med' )';
    KEV_row_5(6)    = PntsIdx(2, 5);
    KEV_col_5(1: 6) = KEV_row_5(1: 6)';

    FaceCrdnt = zeros(1, 5, 3);
    FaceCrdnt = p63Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(5, 1);
    Side_Cflags = p63Face_2( Pnts_Cflags, 'Med' );
    % FaceCrdnt = p63Face( PntsCrdnt );
    tmpSegMed = [ PntSegMed(4, 6), PntSegMed(6, 7), PntSegMed(6, 6), PntSegMed(4, 7) ];
    [ K1_row_5(14: 26), KEV_row_5(7: 12), KEV_col_5(7: 12) ] = calK_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), tmpSegMed, mu_r, epsilon_r, corner_flag, '5' );
    B_k( K1_row_5(13) ) = calBk_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '5' );

    % if K1_flag
        % 6-th edge
        K1_row_6(1)    = vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(2)    = vIdx2eIdx(PntsIdx_prm(2, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(3)    = vIdx2eIdx(PntsIdx_prm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(4)    = vIdx2eIdx(PntsIdx_prm(1, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(5)    = vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(6)    = vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(7)    = vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(8)    = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(9)    = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(10)   = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(11)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_6(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    % end

    KEV_row_6(1: 5) = p32Face_2( PntsIdx, 'Med' )';
    KEV_row_6(6)    = PntsIdx(2, 5);
    KEV_col_6(1: 6) = KEV_row_6(1: 6)';

    FaceCrdnt = zeros(1, 5, 3);
    FaceCrdnt = p32Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(5, 1);
    Side_Cflags = p32Face_2( Pnts_Cflags, 'Med' );
    % FaceCrdnt = p32Face( PntsCrdnt );
    tmpSegMed = [ PntSegMed(2, 6), PntSegMed(3, 1), PntSegMed(3, 8), PntSegMed(2, 7) ];
    [ K1_row_6(14: 26), KEV_row_6(7: 12), KEV_col_6(7: 12) ] = calK_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), tmpSegMed, mu_r, epsilon_r, corner_flag, '6' );
    B_k( K1_row_6(13) ) = calBk_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '6' );

    % if K1_flag
        % 7-th edge
        K1_row_7(1)    = vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(2)    = vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(3)    = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(4)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(5)    = vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(6)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(7)    = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(8)    = vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(9)    = vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(10)   = vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(11)   = vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(12)   = vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(14)   = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(15)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(16)   = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(17)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(18)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
        K1_row_7(19)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    % end

    KEV_row_7(1: 7) = p623Face_2( PntsIdx, 'Med' )';
    KEV_row_7(8)    = PntsIdx(2, 5);
    KVE_col_7(1: 8) = KEV_row_7(1: 8)';

    FaceCrdnt = zeros(1, 7, 3);
    FaceCrdnt = p623Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(7, 1);
    Side_Cflags = p623Face_2( Pnts_Cflags, 'Med' );
    % FaceCrdnt = zeros(1, 7, 3);
    % FaceCrdnt = p623Face( PntsCrdnt );
    tmpSegMed = zeros(1, 6, 'uint8');
    tmpSegMed = [ PntSegMed(6, 6), PntSegMed(6, 5), PntSegMed(2, 8), PntSegMed(2, 7), PntSegMed(3, 8), PntSegMed(3, 7) ];
    [ K1_row_7(20: 38), KEV_row_7(9: 16), KVE_col_7(9: 16) ] = calK_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), tmpSegMed, mu_r, epsilon_r, corner_flag, '7' );
    B_k( K1_row_7(19) ) = calBk_Type1( squeeze(FaceCrdnt), squeeze( PntsCrdnt(2, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 5), J_0, '7' );

    Flags = find( corner_flag(2, :) );
    if isempty(Flags)
        varargout{1}  = K1_row_1;
        varargout{2}  = K1_row_2;
        varargout{3}  = K1_row_3;
        varargout{4}  = K1_row_4;
        varargout{5}  = K1_row_5;
        varargout{6}  = K1_row_6;
        varargout{7}  = K1_row_7;
        varargout{8}  = KEV_row_1;
        varargout{9}  = KEV_row_2;
        varargout{10} = KEV_row_3;
        varargout{11} = KEV_row_4;
        varargout{12} = KEV_row_5;
        varargout{13} = KEV_row_6;
        varargout{14} = KEV_row_7;
        varargout{15} = KVE_col_1;
        varargout{16} = KVE_col_2;
        varargout{17} = KVE_col_3;
        varargout{18} = KVE_col_4;
        varargout{19} = KVE_col_5;
        varargout{20} = KVE_col_6;
        varargout{21} = KVE_col_7;
        varargout{22} = B_k;
    else
        if length(Flags) == 1
            switch Flags
                case 6
                    varargout{1} = KVE_col_1;
                    varargout{2} = KVE_col_3;
                    varargout{3} = KVE_col_6;
                case 2
                    varargout{1} = KVE_col_2;
                    varargout{2} = KVE_col_3;
                    varargout{3} = KVE_col_5;
                case 3
                    varargout{1} = KVE_col_1;
                    varargout{2} = KVE_col_2;
                    varargout{3} = KVE_col_4;
                otherwise
                    error('check');
            end
        elseif length(Flags) == 2
            if Flags == [3, 6];
                varargout{1} = KVE_col_1;
            elseif Flags == [2, 6];
                varargout{1} = KVE_col_3;
            elseif Flags == [2, 3];
                varargout{1} = KVE_col_2;
            end
        end
    end
end