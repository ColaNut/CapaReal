function valid = checkCol(sparseMat)
valid = false;
lgth = length(sparseMat);

for idx = 1: 1: lgth
    if size(sparseMat{idx}, 1) <= 1
        break
    end
end
valid = true;

end