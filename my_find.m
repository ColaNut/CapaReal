function idx = my_find(arr, targetVal)
    larr = length(arr);
    if ~larr
        error('check the length of input array');
    end
    for idx = 1: 1: larr
        if arr(idx) == targetVal
            return;
        end
    end
    idx = [];
end