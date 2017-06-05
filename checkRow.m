function valid = checkRow(sparseMat)
valid = false;
lgth = length(sparseMat);

for idx = 1: 1: lgth
    if size(sparseMat{idx}, 2) <= 1
        break
    end
end
valid = true;

end