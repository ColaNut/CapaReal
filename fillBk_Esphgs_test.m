function B_k_Pnt = fillBk_Esphgs_test( vIdx1, vIdx2, vIdx3, vIdx4, v1Table, v2Table, v3Table, v4Table, Vrtx_bndry, J_0, ...
                    B_k_Pnt, PntJ_xyz, MedVal, epsilon_r, mu_r, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, varargin )
    
    % PntJ_xyz = zeros(1, 3);
    % v to P
    vIdxSet = [vIdx1, vIdx2, vIdx3, vIdx4];
    % the following find should appreas once in each entry
    FindMat = [ 0,                          my_F(find(v1Table), vIdx2), my_F(find(v1Table), vIdx3), my_F(find(v1Table), vIdx4);
                my_F(find(v2Table), vIdx1), 0,                          my_F(find(v2Table), vIdx3), my_F(find(v2Table), vIdx4);
                my_F(find(v3Table), vIdx1), my_F(find(v3Table), vIdx2), 0,                          my_F(find(v3Table), vIdx4);
                my_F(find(v4Table), vIdx1), my_F(find(v4Table), vIdx2), my_F(find(v4Table), vIdx3), 0                          ];

    Counter = [ length(find(FindMat(1, :))), length(find(FindMat(2, :))), length(find(FindMat(3, :))), length(find(FindMat(4, :))) ]';

    % A self-checker
    if ~find(Counter == 0) || ~find(Counter == 1) || ~find(Counter == 2) || ~find(Counter == 3) 
        error('check the original feed in');
    end
    
    vIdxSet_permute = [ find(Counter == 3), find(Counter == 2), find(Counter == 1), find(Counter == 0) ];
    mainEdgeFinder = vIdxSet_permute <= 2;

    P1 = vIdxSet( vIdxSet_permute(1) );
    P2 = vIdxSet( vIdxSet_permute(2) );
    P3 = vIdxSet( vIdxSet_permute(3) );
    P4 = vIdxSet( vIdxSet_permute(4) );

    G4Row = horzcat(v1Table, v2Table, v3Table, v4Table);
    P1_table = G4Row( :, vIdxSet_permute(1) );
    P2_table = G4Row( :, vIdxSet_permute(2) );
    P3_table = G4Row( :, vIdxSet_permute(3) );
    P4_table = G4Row( :, vIdxSet_permute(4) );
    
    % get the coordinate
    m_v   = zeros(1, 4);
    n_v   = zeros(1, 4);
    ell_v = zeros(1, 4);
    
    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(P1, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(P2, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(P3, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(P4, x_max_vertex, y_max_vertex, z_max_vertex);
    
    P1_flag = Vrtx_bndry( m_v(1), n_v(1), ell_v(1) );
    P2_flag = Vrtx_bndry( m_v(2), n_v(2), ell_v(2) );
    P3_flag = Vrtx_bndry( m_v(3), n_v(3), ell_v(3) );
    P4_flag = Vrtx_bndry( m_v(4), n_v(4), ell_v(4) );

    P1_Crdt = zeros(1, 3);
    P2_Crdt = zeros(1, 3);
    P3_Crdt = zeros(1, 3);
    P4_Crdt = zeros(1, 3);
    P1_Crdt = squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
    P2_Crdt = squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
    P3_Crdt = squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
    P4_Crdt = squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';

    % determine main edge
    if mainEdgeFinder == [ 1, 1, 0, 0 ]
        mainEdge = 1;
    elseif mainEdgeFinder == [ 1, 0, 1, 0 ]
        mainEdge = 2;
    elseif mainEdgeFinder == [ 1, 0, 0, 1 ]
        mainEdge = 3;
    elseif mainEdgeFinder == [ 0, 1, 1, 0 ]
        mainEdge = 4;
    elseif mainEdgeFinder == [ 0, 1, 0, 1 ]
        mainEdge = 5;
    elseif mainEdgeFinder == [ 0, 0, 1, 1 ]
        mainEdge = 6;
    else
        error('check');
    end

    % determine external of internal
    if dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) > 0
        InnExtText = 'inn';
    elseif dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) < 0
        InnExtText = 'ext';
    else
        error('Check the P1, P2, P3 and P4 Crdnt');
    end

    % % calculate K1, Kev, Kve
    % six_eIdx     = zeros(1, 6);
    % six_eVal     = zeros(2, 6); % first row for K1; while the second for K2
    % four_vIdx    = zeros(1, 4);
    % four_vVal_ev = zeros(1, 4);
    % four_vVal_ve = zeros(4, 1);
    Bk_val = 0;

    % EightTet_e = zeros(8, 6);
    % EightTet_v = zeros(8, 4);

    % six_eIdx(1) = P1_table(P2);
    % six_eIdx(2) = P1_table(P3);
    % six_eIdx(3) = P1_table(P4);
    % six_eIdx(4) = P2_table(P3);
    % six_eIdx(5) = P2_table(P4);
    % six_eIdx(6) = P3_table(P4);
    % four_vIdx = [ P1, P2, P3, P4 ]; 

    % update tge Px_flag and J_0
    cFlag = false;
    Bk_val = getWmJ_esphgs_test( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
                            P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, J_0, cFlag );
    % [ six_eVal, four_vVal_ev ] = get6E4V_omega( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, mainEdge, InnExtText, mu_r(MedVal), epsilon_r(MedVal) );

    % % Right tetrahedron
    % four_vVal_ve = four_vVal_ev' / ( epsilon_r(MedVal)^2 * mu_r(MedVal) ) ...
    %         - calKVE_TetPatch_Right( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, ...
    %                 P1_flag, P2_flag, P3_flag, P4_flag, mainEdge, InnExtText, mu_r(MedVal), epsilon_r(MedVal) );

    % K1_6(six_eIdx) = K1_6(six_eIdx) + six_eVal(1, :); 
    % K2_6(six_eIdx) = K2_6(six_eIdx) + six_eVal(2, :); 
    % Kev_4(four_vIdx) = Kev_4(four_vIdx) + four_vVal_ev;
    % Kve_4(four_vIdx) = Kve_4(four_vIdx) - four_vVal_ve;
    B_k_Pnt = B_k_Pnt + Bk_val;
end