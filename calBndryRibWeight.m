function [ weight, SegMed ] = calBndryRibWeight( BoneMed27Value, medValue, epsilon_r, faceName )

    med2Layers      = medValue;
    weight          = zeros(8, 1);
    SegMed          = ones( 1, 8, 'uint8' );
    tmp_Med2Layers  = zeros( 2, 4 );
    SubRibCases     = false(2, 1);
    BoneMed9Value   = get9Med( BoneMed27Value );

    tmp_Med2Layers = firstQdrt( med2Layers );
    [ weight(1: 2), SegMed(1: 2) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = secondQdrt( med2Layers );
    [ weight(3: 4), SegMed(3: 4) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = thirdQdrt( med2Layers );
    [ weight(5: 6), SegMed(5: 6) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = fourthQdrt( med2Layers );
    [ weight(7: 8), SegMed(7: 8) ] = octantCube( tmp_Med2Layers, epsilon_r );

    if strcmp(faceName, 'p1') || strcmp(faceName, 'p3')
        if strcmp(faceName, 'p1')
            SubRibCases = CheckSubRibLR(BoneMed9Value);
        else
            SubRibCases = CheckSubRibLR( p3BoneMed9Value(BoneMed9Value) );
        end
        if SubRibCases(1) 
            % BoneMed27Value(2, 8) is the front end
            if BoneMed27Value(2, 8) ~= 1
                SegMed(1: 2) = uint8(6);
                weight(1: 2) = epsilon_r(6);
            end
            % BoneMed27Value(2, 2) is the back end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(7: 8) = uint8(6);
                weight(7: 8) = epsilon_r(6);
            end
        end
        if SubRibCases(2) 
            if BoneMed27Value(2, 8) ~= 1
                SegMed(3: 4) = uint8(6);
                weight(3: 4) = epsilon_r(6);
            end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(5: 6) = uint8(6);
                weight(5: 6) = epsilon_r(6);
            end
        end
        if BoneMed27Value(2, 8) == 1 && BoneMed27Value(2, 2) == 1
            error('check');
        end
    elseif strcmp(faceName, 'p2')
        SubRibCases = CheckSubRibLR( p2BoneMed9Value(BoneMed9Value) );
        if SubRibCases(1) 
            if BoneMed27Value(2, 8) ~= 1
                SegMed(3: 4) = uint8(6);
                weight(3: 4) = epsilon_r(6);
            end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(1: 2) = uint8(6);
                weight(1: 2) = epsilon_r(6);
            end
        end
        if SubRibCases(2) 
            if BoneMed27Value(2, 8) ~= 1
                SegMed(5: 6) = uint8(6);
                weight(5: 6) = epsilon_r(6);
            end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(7: 8) = uint8(6);
                weight(7: 8) = epsilon_r(6);
            end
        end
        if BoneMed27Value(2, 8) == 1 && BoneMed27Value(2, 2) == 1
            error('check');
        end
    elseif strcmp(faceName, 'p4')
        SubRibCases = CheckSubRibLR( p4BoneMed9Value(BoneMed9Value) );
        if SubRibCases(1) 
            if BoneMed27Value(2, 8) ~= 1
                SegMed(7: 8) = uint8(6);
                weight(7: 8) = epsilon_r(6);
            end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(5: 6) = uint8(6);
                weight(5: 6) = epsilon_r(6);
            end
        end
        if SubRibCases(2) 
            if BoneMed27Value(2, 8) ~= 1
                SegMed(1: 2) = uint8(6);
                weight(1: 2) = epsilon_r(6);
            end
            if BoneMed27Value(2, 2) ~= 1
                SegMed(3: 4) = uint8(6);
                weight(3: 4) = epsilon_r(6);
            end
        end
        if BoneMed27Value(2, 8) == 1 && BoneMed27Value(2, 2) == 1
            error('check');
        end
    elseif strcmp(faceName, 'p5')
        if BoneMed27Value(2, 8) ~= 1
            qua = ones(4, 1);
            Qua = [];

            % 1-st qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(2, 4), BoneMed27Value(3, 5), BoneMed27Value(3, 4) ];
            Qua = [ Qua, detQua( qua ) ];
            % 2-nd qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(3, 5), BoneMed27Value(2, 6), BoneMed27Value(3, 6) ];
            Qua = [ Qua, detQua( qua ) ];
            % 3-rd qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(2, 6), BoneMed27Value(1, 5), BoneMed27Value(1, 6) ];
            Qua = [ Qua, detQua( qua ) ];
            % 1-st qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(1, 5), BoneMed27Value(2, 4), BoneMed27Value(1, 4) ];
            Qua = [ Qua, detQua( qua ) ];

            QuaIdx = find( Qua == 1 );
            SegMed( QuaIdx ) = uint8(6);
            weight( QuaIdx ) = epsilon_r(6);
        end
    elseif strcmp(faceName, 'p6')
        if BoneMed27Value(2, 2) ~= 1
            qua = ones(4, 1);
            Qua = [];

            % 1-st qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(2, 6), BoneMed27Value(3, 5), BoneMed27Value(3, 6) ];
            Qua = [ Qua, detQua( qua ) ];
            % 2-nd qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(3, 5), BoneMed27Value(2, 4), BoneMed27Value(3, 4) ];
            Qua = [ Qua, detQua( qua ) ];
            % 3-rd qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(2, 4), BoneMed27Value(1, 5), BoneMed27Value(1, 4) ];
            Qua = [ Qua, detQua( qua ) ];
            % 1-st qua
            qua = [ BoneMed27Value(2, 5), BoneMed27Value(1, 5), BoneMed27Value(2, 6), BoneMed27Value(1, 6) ];
            Qua = [ Qua, detQua( qua ) ];

            QuaIdx = find( Qua == 1 );
            SegMed( QuaIdx ) = uint8(6);
            weight( QuaIdx ) = epsilon_r(6);
        end
    else
        error('check');
    end

end