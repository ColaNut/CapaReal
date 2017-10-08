function [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv(m_v, n_v, ell_v, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top)

    if m_v <= m_v_Rght && m_v >= m_v_Lft && n_v <= n_v_Far && n_v >= n_v_Near ...
            && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn
        m_v_B = 2 * (m_v - m_v_Lft) + 1;
        n_v_B = 2 * (n_v - n_v_Near) + 1;
        ell_v_B = 2 * (ell_v - ell_v_Dwn) + 1;
    else
        error('check');
    end
end