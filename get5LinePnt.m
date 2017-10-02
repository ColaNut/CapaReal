function LinePnts = get5LinePnt(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, Line_Text)
    
    LinePnts = zeros(5, 1);

    switch Line_Text
        case 'z'
            LinePnts(1)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            LinePnts(2)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            LinePnts(3)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            LinePnts(4)  = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            LinePnts(5)  = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
        case 'x'
            LinePnts(1)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
            LinePnts(2)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            LinePnts(3)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            LinePnts(4)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            LinePnts(5)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
        case 'y'
            LinePnts(1)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            LinePnts(2)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            LinePnts(3)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            LinePnts(4)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            LinePnts(5)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
        otherwise
            error('check');
    end
end