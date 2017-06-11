function findOrNot = my_F(arr, targetVal)
    findOrNot = false;
    larr = length(arr);
    if ~larr
        return
    end
    for idx = 1: 1: larr
        if arr(idx) == targetVal
            findOrNot = true;
            return;
        end
    end
    % idx = [];
end