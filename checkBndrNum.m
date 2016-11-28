function valid = checkBndrNum( XZ9Med )

valid = false;

if length( find(XZ9Med == 0) ) == 3
    valid = true;
end

end