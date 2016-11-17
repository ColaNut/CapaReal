function bolusAround = checkBolusAround( XZ9Med )

bolusAround = false;

if ~isempty( find(XZ9Med == 2) )
    bolusAround = true;
end

end