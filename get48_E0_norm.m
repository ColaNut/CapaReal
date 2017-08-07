function E0_norm = get48_E0_norm( E_0 )
    E0_norm = zeros(6, 8);

    for s_idx = 1: 1: 6
        for e_idx = 1: 1: 8
            E0_norm(s_idx, e_idx) = norm( squeeze(E_0(s_idx, e_idx, :)) );
        end
    end
end