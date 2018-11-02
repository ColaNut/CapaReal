function eIdx = G2eIdx(P1vIdx, P2vIdx, x_max_vertex, y_max_vertex, z_max_vertex)

    [ m_v1, n_v1, ell_v1 ] = getMNL(P1vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v2, n_v2, ell_v2 ] = getMNL(P2vIdx, x_max_vertex, y_max_vertex, z_max_vertex);

    main = 0;

    if ell_v2 > ell_v1
        main = 2;
    elseif ell_v2 < ell_v1
        main = 1;
    else
        if n_v2 > n_v1
            main = 2;
        elseif n_v2 < n_v1
            main = 1;
        else
            if m_v2 > m_v1
                main = 2;
            elseif m_v2 < m_v1
                main = 1;
            else
                error('check the P1 and P2');
            end
        end
    end

    if main == 1
        borderFlag = getBorderFlag(m_v1, n_v1, ell_v1, x_max_vertex, y_max_vertex, z_max_vertex);
        m_dom = m_v1; 
        n_dom = n_v1;
        ell_dom = ell_v1;
        m_rel = m_v2; 
        n_rel = n_v2;
        ell_rel = ell_v2;
    elseif main == 2
        borderFlag = getBorderFlag(m_v2, n_v2, ell_v2, x_max_vertex, y_max_vertex, z_max_vertex);
        m_dom = m_v2;
        n_dom = n_v2;
        ell_dom = ell_v2;
        m_rel = m_v1;
        n_rel = n_v1;
        ell_rel = ell_v1;
    else 
        error('Check');
    end

    % determine the relative position, i.e. determined the edge number
    if ell_dom > ell

    
end
