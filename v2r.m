function rIdx = v2r(vIdx)
    if mod(vIdx, 2) 
        rIdx = 1 + ( vIdx - 1 ) / 2;
    else
        error('invalid even vIdx');
    end
end