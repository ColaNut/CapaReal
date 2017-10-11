function [ m_B, n_B, ell_B ] = A_MNEllv_2_B_MNEll(m_v, n_v, ell_v, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top)

    if m_v <= m_v_Rght && m_v >= m_v_Lft && n_v <= n_v_Far && n_v >= n_v_Near ...
            && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn
        m_B = m_v - m_v_Lft + 1;
        n_B = n_v - n_v_Near + 1;
        ell_B = ell_v - ell_v_Dwn + 1;
    else
        error('check');
    end
end