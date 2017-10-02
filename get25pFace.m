function p_face = get25pFace(m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, P_Text)
    
    p_face = zeros(25, 1);

    % replace the following getIdx to fx type
    switch P_Text
        case 'p1'
            p_face(1)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B - 2;
            p_face(2)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B - 1;
            p_face(3)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B    ;
            p_face(4)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B + 1;
            p_face(5)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B + 2;

            p_face(6)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B - 2;
            p_face(7)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B - 1;
            p_face(8)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B    ;
            p_face(9)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B + 1;
            p_face(10) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B + 2;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;

            p_face(16) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B - 2;
            p_face(17) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B - 1;
            p_face(18) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B    ;
            p_face(19) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B + 1;
            p_face(20) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B + 2;

            p_face(21) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B - 2;
            p_face(22) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(23) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(24) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(25) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B + 2;
        case 'p2'
            p_face(1)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
            p_face(2)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(3)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(4)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(5)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;

            p_face(6)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
            p_face(7)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(8)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(9)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(10) = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;

            p_face(16) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
            p_face(17) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(18) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(19) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(20) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;

            p_face(21) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
            p_face(22) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(23) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(24) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(25) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
        case 'p3'
            p_face(1)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B + 2;
            p_face(2)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B + 1;
            p_face(3)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B    ;
            p_face(4)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B - 1;
            p_face(5)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B - 2;

            p_face(6)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B + 2;
            p_face(7)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B + 1;
            p_face(8)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B    ;
            p_face(9)  = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B - 1;
            p_face(10) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B - 2;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(16) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B + 2;
            p_face(17) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B + 1;
            p_face(18) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B    ;
            p_face(19) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B - 1;
            p_face(20) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B - 2;

            p_face(21) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(22) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(23) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(24) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(25) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B - 2;
        case 'p4'
            p_face(1)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            p_face(2)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(3)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(4)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(5)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;

            p_face(6)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            p_face(7)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(8)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(9)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(10) = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;

            p_face(16) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            p_face(17) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(18) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(19) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(20) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;

            p_face(21) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 3 ) * x_max_vertex_B + m_v_B;
            p_face(22) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 2 ) * x_max_vertex_B + m_v_B;
            p_face(23) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B;
            p_face(24) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B     ) * x_max_vertex_B + m_v_B;
            p_face(25) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B + 1 ) * x_max_vertex_B + m_v_B;
        case 'p5'
            p_face(1)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(2)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(3)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(4)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(5)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(6)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(7)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(8)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(9)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(10) = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(16) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(17) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(18) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(19) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(20) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(21) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(22) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(23) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(24) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(25) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
        case 'p6'
            p_face(1)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
            p_face(2)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(3)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(4)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(5)  = N_v + ( ell_v_B - 3 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;

            p_face(6)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
            p_face(7)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(8)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(9)  = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(10) = N_v + ( ell_v_B - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;

            p_face(11) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
            p_face(12) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(13) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(14) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(15) = N_v + ( ell_v_B - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;

            p_face(16) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(17) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(18) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(19) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(20) = N_v + ( ell_v_B     ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;

            p_face(21) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 2;
            p_face(22) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B + 1;
            p_face(23) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B    ;
            p_face(24) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 1;
            p_face(25) = N_v + ( ell_v_B + 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v_B - 1 ) * x_max_vertex_B + m_v_B - 2;
        otherwise
            error('check');
    end
end