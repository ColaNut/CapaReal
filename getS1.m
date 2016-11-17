function S1 = getS1( MidPntsCrdnt, MedValue )

    S1            = zeros( 2, 1 );
    Mid9PntsCrdnt = zeros( 9, 3 );
    Med9Value     = zeros( 9, 1, 'uint8' );

    Mid9PntsCrdnt = p6FaceMidLyr( MidPntsCrdnt );
    Med9Value     = get9Med( MedValue );

    count = 0;
    for idx = 1: 1: 9
        if Med9Value(idx) == 0 && idx ~= 5
            count = count + 1;
            S1(count) = norm( Mid9PntsCrdnt(idx, :) - Mid9PntsCrdnt(5, :) );
        end
        if count == 2 
            S1 = S1 * squeeze( ( MidPntsCrdnt(2, 8, 2) - MidPntsCrdnt(2, 2, 2) ) );
            return
            % error('Check Med9Value');
        end
    end

    S1 = S1 * norm( MidPntsCrdnt(2, 8, :) - MidPntsCrdnt(2, 2, :) );

end