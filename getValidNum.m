function validNum = getValidNum(x_idx_max, y_idx_max, z_idx_max)
    validNum = 0;
    validNum = 48 * x_idx_max * y_idx_max * z_idx_max ... % Volume Tet 
            - 24 * (x_idx_max * y_idx_max + y_idx_max * z_idx_max + x_idx_max * z_idx_max) * 2 ... % Tet on the facets
            + 12 * (x_idx_max + y_idx_max + z_idx_max) * 4 ... % Tet on the lines
            - 48; % the corner Tet
end