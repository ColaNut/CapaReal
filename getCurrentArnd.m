function Current = getCurrentArnd( v1234, BndryTable, TpElctrdPos, bar_x_my_gmresPhi, Sigma, MedVal, ...
                                    x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt )
    Current = complex(0, 0);
    m_v   = zeros(4, 1);
    n_v   = zeros(4, 1);
    ell_v = zeros(4, 1);

    % get four m_v, n_v and ell_v
    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(v1234(1), x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(v1234(2), x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(v1234(3), x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(v1234(4), x_max_vertex, y_max_vertex, z_max_vertex);

    % get four coordinates
    % Px_Crdt = zeros(1, 3);
    P1_Crdt = squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) )';
    P2_Crdt = squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) )';
    P3_Crdt = squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) )';
    P4_Crdt = squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) )';

    % get four Phi
    Phi_1 = bar_x_my_gmresPhi(v1234(1));
    Phi_2 = bar_x_my_gmresPhi(v1234(2));
    Phi_3 = bar_x_my_gmresPhi(v1234(3));
    Phi_4 = bar_x_my_gmresPhi(v1234(4));

    % get four BndryFlags
    P1_flag = BndryTable( m_v(1), n_v(1), ell_v(1) );
    P2_flag = BndryTable( m_v(2), n_v(2), ell_v(2) );
    P3_flag = BndryTable( m_v(3), n_v(3), ell_v(3) );
    P4_flag = BndryTable( m_v(4), n_v(4), ell_v(4) );

    % calculate TriVec that pointing inwards  
    % check if the un-corellated vertex is on the inner part; if not -> return
    TriVec = zeros(1, 3); % pointed inward
    if P1_flag == TpElctrdPos && P2_flag == TpElctrdPos && P3_flag == TpElctrdPos
        CoeffFlag = 123;
        TriVec = calTriVec( P1_Crdt, P2_Crdt, P3_Crdt );
        x = sum( [P1_Crdt(1), P2_Crdt(1), P3_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P3_Crdt(3)] ) / 3;
    elseif  P1_flag == TpElctrdPos && P2_flag == TpElctrdPos && P4_flag == TpElctrdPos
        CoeffFlag = 124;
        TriVec = calTriVec( P1_Crdt, P2_Crdt, P4_Crdt );
        x = sum( [P1_Crdt(1), P2_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P2_Crdt(3), P4_Crdt(3)] ) / 3;
    elseif  P1_flag == TpElctrdPos && P3_flag == TpElctrdPos && P4_flag == TpElctrdPos
        CoeffFlag = 134;
        TriVec = calTriVec( P1_Crdt, P3_Crdt, P4_Crdt );
        x = sum( [P1_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P1_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
    elseif  P2_flag == TpElctrdPos && P3_flag == TpElctrdPos && P4_flag == TpElctrdPos
        CoeffFlag = 234;
        TriVec = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
        x = sum( [P2_Crdt(1), P3_Crdt(1), P4_Crdt(1)] ) / 3;
        z = sum( [P2_Crdt(3), P3_Crdt(3), P4_Crdt(3)] ) / 3;
    elseif P1_flag == TpElctrdPos && P2_flag == TpElctrdPos && P3_flag == TpElctrdPos && P4_flag == TpElctrdPos 
        [ m_v(1), n_v(1), ell_v(1);
          m_v(2), n_v(2), ell_v(2);
          m_v(3), n_v(3), ell_v(3);
          m_v(4), n_v(4), ell_v(4) ];
        error('check flags');
    else
        return;
    end

    % only valid Points undergo the following processes
    if dot(TriVec, P4_Crdt) > 0
        TriVec = - TriVec;
    end

    TestVec = zeros(1, 2);
    switch CoeffFlag
        case 123
            TestVec = [ P4_Crdt(1), P4_Crdt(3) ] - [ x, z ];
        case 124
            TestVec = [ P3_Crdt(1), P3_Crdt(3) ] - [ x, z ];
        case 134
            TestVec = [ P2_Crdt(1), P2_Crdt(3) ] - [ x, z ];
        case 234
            TestVec = [ P1_Crdt(1), P1_Crdt(3) ] - [ x, z ];
        otherwise
            error('check the CoeffFlag');
    end
    if ( TestVec(1) * TriVec(1) + TestVec(2) * TriVec(3) ) < 0 % dot operator < 0
        return;
    end

    % calculate E field
    E_field = zeros(1, 3);
    E_field = calE( P1_Crdt', P2_Crdt', P3_Crdt', P4_Crdt', Phi_1, Phi_2, Phi_3, Phi_4 );

    Current = Sigma(MedVal) * dot( E_field, TriVec );

    if MedVal ~= 2
        error('check medium');
    end
    % if the real part is not positive; error message
    if real(Current) < 0
        error('check TriVec');
    end

end