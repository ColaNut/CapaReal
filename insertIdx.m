function newLine = insertIdx( oldLine, n, tmpSum )
    
    old_length = length(oldLine);
    newLine = zeros(1, old_length + 2);
    newLine(1: old_length / 2) = oldLine(1: old_length / 2);
    newLine(old_length / 2 + 1) = n;
    newLine(old_length / 2 + 2: end - 1) = oldLine(old_length / 2 + 1: end);
    newLine(end) = tmpSum;
end