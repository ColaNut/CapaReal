function [ m_v_B, n_v_B, ell_v_B ] = A_MNEllv_2_B_MNEllv(m_v, n_v, ell_v, w_x_B, w_y_B, w_z_B)

    loadParas;
    loadParas_Eso0924;
    m_Rght  = ( es_x + w_x_B / 2 ) / dx + air_x / (2 * dx) + 1;
    m_Lft   = ( es_x - w_x_B / 2 ) / dx + air_x / (2 * dx) + 1;
    n_Far   = ( 0    + w_y_B / 2 ) / dy + h_torso / (2 * dy) + 1;
    n_Near  = ( 0    - w_y_B / 2 ) / dy + h_torso / (2 * dy) + 1;
    ell_Top = ( es_z + w_z_B / 2 ) / dz + air_z / (2 * dz) + 1;
    ell_Dwn = ( es_z - w_z_B / 2 ) / dz + air_z / (2 * dz) + 1;

    m_v_Lft = (2 * m_Lft - 1) - 1;
    n_v_Near = (2 * n_Near - 1) - 1;
    ell_v_Dwn = (2 * ell_Dwn - 1) - 1;

    % top-right-far
    m_v_Rght = (2 * m_Rght - 1) + 1;
    n_v_Far = (2 * n_Far - 1) + 1;
    ell_v_Top = (2 * ell_Top - 1) + 1;

    if m_v <= m_v_Rght && m_v >= m_v_Lft && n_v <= n_v_Far && n_v >= n_v_Near ...
            && ell_v <= ell_v_Top && ell_v >= ell_v_Dwn
        m_v_B = 2 * (m_v - m_v_Lft) + 1;
        n_v_B = 2 * (n_v - n_v_Near) + 1;
        ell_v_B = 2 * (ell_v - ell_v_Dwn) + 1;
    else
        error('check');
    end
end