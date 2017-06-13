function [ m_v, n_v, ell_v ] = getMNL_r2v(idx_r, x_idx_max, y_idx_max, z_idx_max)
    
    m_v = 1;
    n_v = 1;
    ell_v = 1;

    % tiling unit -m
    t_m = x_idx_max;

    % threshold
    thld = [ t_m, t_m - 1]
    if idx_r <= x_idx_max
        m_r = idx_r;
    elseif 
end