function tmpBoneMed9Value = p4BoneMed9Value(BoneMed9Value)
    tmpBoneMed9Value = zeros(9, 1, 'uint8');

    tmpBoneMed9Value(1) = BoneMed9Value(7);
    tmpBoneMed9Value(2) = BoneMed9Value(4);
    tmpBoneMed9Value(3) = BoneMed9Value(1);
    tmpBoneMed9Value(4) = BoneMed9Value(8);
    tmpBoneMed9Value(5) = BoneMed9Value(5);
    tmpBoneMed9Value(6) = BoneMed9Value(2);
    tmpBoneMed9Value(7) = BoneMed9Value(9);
    tmpBoneMed9Value(8) = BoneMed9Value(6);
    tmpBoneMed9Value(9) = BoneMed9Value(3);
end