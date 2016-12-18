function valid = checkBndrNum( XZ9Med, BndrNum )

valid = false;

if length( find(XZ9Med == 0) ) == BndrNum
    valid = true;
end

end