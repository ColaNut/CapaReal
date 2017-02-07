function RibCases = CheckRibLR(BoneMed9Value)
    RibCases = true(2, 1);

    if BoneMed9Value(8) == 1
        RibCases = false(2, 1);
    else
        if BoneMed9Value(6) == 1 && BoneMed9Value(9) == 1
            RibCases(1) = false;
        end
        if BoneMed9Value(4) == 1 && BoneMed9Value(7) == 1
            RibCases(2) = false;
        end
    end

end