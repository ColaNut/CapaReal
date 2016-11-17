function Med9Value = get9Med( MedValue )

    Med9Value     = zeros( 9, 1, 'uint8' );

    Med9Value(1) = MedValue(1, 4);
    Med9Value(2) = MedValue(1, 5);
    Med9Value(3) = MedValue(1, 6);
    Med9Value(4) = MedValue(2, 4);
    Med9Value(5) = MedValue(2, 5);
    Med9Value(6) = MedValue(2, 6);
    Med9Value(7) = MedValue(3, 4);
    Med9Value(8) = MedValue(3, 5);
    Med9Value(9) = MedValue(3, 6);

end