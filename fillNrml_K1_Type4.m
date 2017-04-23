function [ K1_row_1, K1_row_2, K1_row_3, K1_row_4, K1_row_5, ...
      K1_row_6, K1_row_7, B_k ] = fillNrml_K1_Type4( m_v, n_v, ell_v, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                                            z_max_vertex, PntSegMed, auxiSegMed, epsilon_r, mu_r, omega, B_k, SheetPntsTable, J_0 )
      
    K1_row_1 = zeros(1, 26);
    K1_row_2 = zeros(1, 26);
    K1_row_3 = zeros(1, 50);

    K1_row_4 = zeros(1, 26);
    K1_row_5 = zeros(1, 26);
    K1_row_6 = zeros(1, 26);

    K1_row_7 = zeros(1, 38);

    PntsIdx_prm = zeros( 3, 9 );
    PntsCrdnt   = zeros( 3, 9, 3 ); 

    [ PntsIdx_prm, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    Pnts_Cflags = get27_Cflag( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SheetPntsTable );

    % 1-st edge
    K1_row_1(1)    = vIdx2eIdx(PntsIdx_prm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(2)    = vIdx2eIdx(PntsIdx_prm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(3)    = vIdx2eIdx(PntsIdx_prm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(4)    = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_1(5)    = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(6)    = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(7)    = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(8)    = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_1(9)    = vIdx2eIdx(PntsIdx_prm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(10)   = vIdx2eIdx(PntsIdx_prm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(11)   = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_1(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_1(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);

    % tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    % each face have ten contribution: 9 on each face and 1 in the center.
    FaceCrdnt = zeros(5, 3);
    FaceCrdnt(1, :) = squeeze( PntsCrdnt(1, 5, :) )';
    FaceCrdnt(2, :) = squeeze( PntsCrdnt(2, 1, :) )';
    FaceCrdnt(3, :) = squeeze( PntsCrdnt(2, 5, :) )';
    FaceCrdnt(4, :) = squeeze( PntsCrdnt(2, 7, :) )';
    FaceCrdnt(5, :) = squeeze( PntsCrdnt(3, 5, :) )';
    Side_Cflags = zeros(5, 1, 'uint8');
    Side_Cflags(1) = Pnts_Cflags(1, 5);
    Side_Cflags(2) = Pnts_Cflags(2, 1);
    Side_Cflags(3) = Pnts_Cflags(2, 5);
    Side_Cflags(4) = Pnts_Cflags(2, 7);
    Side_Cflags(5) = Pnts_Cflags(3, 5);
    % FaceCrdnt = p4FaceMidLyr( PntsCrdnt );
    tmpSegMed = [ PntSegMed(2, 1), PntSegMed(2, 8), PntSegMed(1, 5), PntSegMed(1, 4) ];
    K1_row_1(14: 26) = calK1_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 4, :) ), tmpSegMed, mu_r, '1' );
    B_k( K1_row_1(13) ) = calBk_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 4, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 4), J_0, '1' );

    % 2-nd edge
    K1_row_2(1)    = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(2)    = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(3)    = vIdx2eIdx(PntsIdx_prm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(4)    = vIdx2eIdx(PntsIdx_prm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_2(5)    = vIdx2eIdx(PntsIdx_prm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(6)    = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(7)    = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(8)    = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_2(9)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(10)   = vIdx2eIdx(PntsIdx_prm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(11)   = vIdx2eIdx(PntsIdx_prm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_2(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_2(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    % tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    % each face have ten contribution: 9 on each face and 1 in the center.
    FaceCrdnt = zeros(5, 3);
    FaceCrdnt(1, :) = squeeze( PntsCrdnt(1, 5, :) )';
    FaceCrdnt(2, :) = squeeze( PntsCrdnt(2, 3, :) )';
    FaceCrdnt(3, :) = squeeze( PntsCrdnt(2, 5, :) )';
    FaceCrdnt(4, :) = squeeze( PntsCrdnt(2, 1, :) )';
    FaceCrdnt(5, :) = squeeze( PntsCrdnt(3, 5, :) )';
    Side_Cflags = zeros(5, 1, 'uint8');
    Side_Cflags(1) = Pnts_Cflags(1, 5);
    Side_Cflags(2) = Pnts_Cflags(2, 3);
    Side_Cflags(3) = Pnts_Cflags(2, 5);
    Side_Cflags(4) = Pnts_Cflags(2, 1);
    Side_Cflags(5) = Pnts_Cflags(3, 5);
    % FaceCrdnt = p4FaceMidLyr( PntsCrdnt );
    tmpSegMed = [ PntSegMed(2, 7), PntSegMed(2, 6), PntSegMed(1, 7), PntSegMed(1, 6) ];
    K1_row_2(14: 26) = calK1_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 2, :) ), tmpSegMed, mu_r, '2' );
    B_k( K1_row_2(13) ) = calBk_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 2, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 2), J_0, '2' );

    % 3-rd edge
    K1_row_3(1)    = vIdx2eIdx(PntsIdx_prm(2, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(2)    = vIdx2eIdx(PntsIdx_prm(2, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(3)    = vIdx2eIdx(PntsIdx_prm(2, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(4)    = vIdx2eIdx(PntsIdx_prm(2, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_3(5)    = vIdx2eIdx(PntsIdx_prm(2, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(6)    = vIdx2eIdx(PntsIdx_prm(2, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(7)    = vIdx2eIdx(PntsIdx_prm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(8)    = vIdx2eIdx(PntsIdx_prm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_3(9)    = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(10)   = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(11)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(12)   = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_3(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(14)   = vIdx2eIdx(PntsIdx_prm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(15)   = vIdx2eIdx(PntsIdx_prm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(16)   = vIdx2eIdx(PntsIdx_prm(2, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_3(17)   = vIdx2eIdx(PntsIdx_prm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(18)   = vIdx2eIdx(PntsIdx_prm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(19)   = vIdx2eIdx(PntsIdx_prm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(20)   = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(21)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(22)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(23)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_3(24)   = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_3(25)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);

    % p1
    % tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    % each face have ten contribution: 9 on each face and 1 in the center.
    FaceCrdnt  = zeros( 1, 9, 3 );
    FaceCrdnt = p1Face_Type4( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(9, 1, 'uint8');
    Side_Cflags = p1Face_Type4( Pnts_Cflags, 'Med' );
    % FaceCrdnt  = zeros( 9, 3 );
    % FaceCrdnt = p1FaceMidLyr( PntsCrdnt );
    % K_1 [000, 1], [111, 1] 
    K1_row_3(26: 50) = calK1_Type4( squeeze(FaceCrdnt), squeeze( PntsCrdnt(1, 5, :) ), PntSegMed(1, :), mu_r, '3' );
    B_k( K1_row_3(25) ) = calBk_Type4( squeeze(FaceCrdnt), squeeze( PntsCrdnt(1, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(1, 5), J_0, '3' );
    
    % 4-th edge
    K1_row_4(1)    = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(2)    = vIdx2eIdx(PntsIdx_prm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(3)    = vIdx2eIdx(PntsIdx_prm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(4)    = vIdx2eIdx(PntsIdx_prm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_4(5)    = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(6)    = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(7)    = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(8)    = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_4(9)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(10)   = vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(11)   = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_4(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_4(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    
    FaceCrdnt = zeros(5, 3);
    FaceCrdnt(1, :) = squeeze( PntsCrdnt(1, 5, :) )';
    FaceCrdnt(2, :) = squeeze( PntsCrdnt(2, 2, :) )';
    FaceCrdnt(3, :) = squeeze( PntsCrdnt(2, 5, :) )';
    FaceCrdnt(4, :) = squeeze( PntsCrdnt(2, 4, :) )';
    FaceCrdnt(5, :) = squeeze( PntsCrdnt(3, 5, :) )';
    Side_Cflags = zeros(5, 1, 'uint8');
    Side_Cflags(1) = Pnts_Cflags(1, 5);
    Side_Cflags(2) = Pnts_Cflags(2, 2);
    Side_Cflags(3) = Pnts_Cflags(2, 5);
    Side_Cflags(4) = Pnts_Cflags(2, 4);
    Side_Cflags(5) = Pnts_Cflags(3, 5);
    tmpSegMed = zeros(1, 4, 'uint8');
    tmpSegMed = [ auxiSegMed(2, 8), PntSegMed(2, 7), PntSegMed(1, 6), auxiSegMed(1, 5) ];
    K1_row_4(14: 26) = calK1_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 1, :) ), tmpSegMed, mu_r, '4' );
    B_k( K1_row_4(13) ) = calBk_Type4( FaceCrdnt, squeeze( PntsCrdnt(2, 1, :) ), ...
                                    Side_Cflags, Pnts_Cflags(2, 1), J_0, '4' );

    % 5-th edge
    K1_row_5(1)    = vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(2)    = vIdx2eIdx(PntsIdx_prm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(3)    = vIdx2eIdx(PntsIdx_prm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(4)    = vIdx2eIdx(PntsIdx_prm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_5(5)    = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(6)    = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(7)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(8)    = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_5(9)    = vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(10)   = vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(11)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_5(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_5(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    
    % FaceCrdnt = p63Face( PntsCrdnt );
    FaceCrdnt = zeros(5, 3);
    FaceCrdnt(1, :) = squeeze( PntsCrdnt(2, 1, :) )';
    FaceCrdnt(2, :) = squeeze( PntsCrdnt(2, 5, :) )';
    FaceCrdnt(3, :) = squeeze( PntsCrdnt(2, 2, :) )';
    FaceCrdnt(4, :) = squeeze( PntsCrdnt(1, 2, :) )';
    FaceCrdnt(5, :) = squeeze( PntsCrdnt(2, 3, :) )';
    Side_Cflags = zeros(5, 1, 'uint8');
    Side_Cflags(1) = Pnts_Cflags(2, 1);
    Side_Cflags(2) = Pnts_Cflags(2, 5);
    Side_Cflags(3) = Pnts_Cflags(2, 2);
    Side_Cflags(4) = Pnts_Cflags(1, 2);
    Side_Cflags(5) = Pnts_Cflags(2, 3);
    tmpSegMed = [ auxiSegMed(6, 2), auxiSegMed(1, 7), auxiSegMed(1, 6), auxiSegMed(6, 3) ];
    K1_row_5(14: 26) = calK1_Type4( FaceCrdnt, squeeze( PntsCrdnt(1, 5, :) ), tmpSegMed, mu_r, '5' );
    B_k( K1_row_5(13) ) = calBk_Type4( FaceCrdnt, squeeze( PntsCrdnt(1, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(1, 5), J_0, '5' );

    % 6-th edge
    K1_row_6(1)    = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(2)    = vIdx2eIdx(PntsIdx_prm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(3)    = vIdx2eIdx(PntsIdx_prm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(4)    = vIdx2eIdx(PntsIdx_prm(2, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_6(5)    = vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(6)    = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(7)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(8)    = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_6(9)    = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(10)   = vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(11)   = vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_6(12)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_6(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    
    % FaceCrdnt = p32Face( PntsCrdnt );
    FaceCrdnt = zeros(5, 3);
    FaceCrdnt(1, :) = squeeze( PntsCrdnt(2, 1, :) )';
    FaceCrdnt(2, :) = squeeze( PntsCrdnt(1, 4, :) )';
    FaceCrdnt(3, :) = squeeze( PntsCrdnt(2, 4, :) )';
    FaceCrdnt(4, :) = squeeze( PntsCrdnt(2, 5, :) )';
    FaceCrdnt(5, :) = squeeze( PntsCrdnt(2, 7, :) )';
    Side_Cflags = zeros(5, 1, 'uint8');
    Side_Cflags(1) = Pnts_Cflags(2, 1);
    Side_Cflags(2) = Pnts_Cflags(1, 4);
    Side_Cflags(3) = Pnts_Cflags(2, 4);
    Side_Cflags(4) = Pnts_Cflags(2, 5);
    Side_Cflags(5) = Pnts_Cflags(2, 7);
    tmpSegMed = [ auxiSegMed(1, 4), auxiSegMed(2, 3), auxiSegMed(2, 2), auxiSegMed(1, 5) ];
    K1_row_6(14: 26) = calK1_Type4( FaceCrdnt, squeeze( PntsCrdnt(1, 5, :) ), tmpSegMed, mu_r, '6' );
    B_k( K1_row_6(13) ) = calBk_Type4( FaceCrdnt, squeeze( PntsCrdnt(1, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(1, 5), J_0, '6' );

    % 7-th edge
    K1_row_7(1)    = vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(2)    = vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(3)    = vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(4)    = vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_7(5)    = vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(6)    = vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(7)    = vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(8)    = vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_7(9)    = vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(10)   = vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(11)   = vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(12)   = vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_7(13)   = vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(14)   = vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(15)   = vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(16)   = vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(17)   = vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
    K1_row_7(18)   = vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);

    K1_row_7(19)   = vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);

    FaceCrdnt = zeros(1, 7, 3);
    FaceCrdnt = p126Face_2( PntsCrdnt, 'Crdnt' );
    Side_Cflags = zeros(7, 1);
    Side_Cflags = p126Face_2( Pnts_Cflags, 'Med' );
    % FaceCrdnt = zeros(7, 3);
    % FaceCrdnt = p126Face( PntsCrdnt );
    tmpSegMed = zeros(1, 6, 'uint8');
    tmpSegMed = [ auxiSegMed(1, 6), auxiSegMed(1, 5), auxiSegMed(2, 2), auxiSegMed(2, 1), auxiSegMed(6, 4), auxiSegMed(6, 3) ];
    K1_row_7(20: 38) = calK1_Type4( squeeze(FaceCrdnt), squeeze( PntsCrdnt(1, 5, :) ), tmpSegMed, mu_r, '7' );
    B_k( K1_row_7(19) ) = calBk_Type4( squeeze(FaceCrdnt), squeeze( PntsCrdnt(1, 5, :) ), ...
                                    Side_Cflags, Pnts_Cflags(1, 5), J_0, '7' );

end