function flag = getMNL_flag(m, n, ell)
    
    flag = '000';

    if mod(m, 2) == 0
        flag(1) = '0';
    elseif mod(m, 2) == 1
        flag(1) = '1';
    else
        error('check');
    end

    if mod(n, 2) == 0
        flag(2) = '0';
    elseif mod(n, 2) == 1
        flag(2) = '1';
    else
        error('check');
    end

    if mod(ell, 2) == 0
        flag(3) = '0';
    elseif mod(ell, 2) == 1
        flag(3) = '1';
    else
        error('check');
    end

end