function E0_sqr = get48_E0_sqr( E_0 )
    E0_sqr = zeros(6, 8);

    for s_idx = 1: 1: 6
        for e_idx = 1: 1: 8
            E0_sqr(s_idx, e_idx) = norm( squeeze(E_0(s_idx, e_idx, :)) )^2;
        end
    end
end