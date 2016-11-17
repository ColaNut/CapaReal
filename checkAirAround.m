function airAround = checkAirAround( XZ9Med )

airAround = false;

if ~isempty( find(XZ9Med == 1) )
    airAround = true;
end

end