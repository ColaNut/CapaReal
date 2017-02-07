function [ weight, SegMed ] = calNrmlRibWeight( BoneMed27Value, medValue, epsilon_r, faceName )

    weight          = zeros(8, 1);
    SegMed          = ones( 1, 8, 'uint8' );
    SubRibCases     = false(2, 1);
    BoneMed9Value   = get9Med( BoneMed27Value );

    SegMed(:) = medValue;
    weight(:) = epsilon_r( medValue );

    if strcmp(faceName, 'p1') || strcmp(faceName, 'p3')
        if strcmp(faceName, 'p1')
            SubRibCases = CheckSubRibLR(BoneMed9Value);
        else
            SubRibCases = CheckSubRibLR( p3BoneMed9Value(BoneMed9Value) );
        end
        if SubRibCases(1) 
            SegMed(1: 2) = uint8(6);
            weight(1: 2) = epsilon_r(6);
            SegMed(7: 8) = uint8(6);
            weight(7: 8) = epsilon_r(6);
        end
        if SubRibCases(2) 
            SegMed(3: 6) = uint8(6);
            weight(3: 6) = epsilon_r(6);
        end
        % BoneMed27Value(2, 8) is the front end
        if BoneMed27Value(2, 8) == 1
            SegMed(1: 4) = medValue;
            weight(1: 4) = epsilon_r(medValue);
        end
        % BoneMed27Value(2, 2) is the back end
        if BoneMed27Value(2, 2) == 1
            SegMed(5: 8) = medValue;
            weight(5: 8) = epsilon_r(medValue);
        end
        if BoneMed27Value(2, 8) == 1 && BoneMed27Value(2, 2) == 1
            error('check');
        end
    elseif strcmp(faceName, 'p2')
        SubRibCases = CheckSubRibLR( p2BoneMed9Value(BoneMed9Value) );
        if SubRibCases(1) 
            SegMed(1: 4) = uint8(6);
            weight(1: 4) = epsilon_r(6);
        end
        if SubRibCases(2) 
            SegMed(5: 8) = uint8(6);
            weight(5: 8) = epsilon_r(6);
        end
        % BoneMed27Value(2, 8) is the front end
        if BoneMed27Value(2, 8) == 1
            SegMed(3: 6) = medValue;
            weight(3: 6) = epsilon_r(medValue);
        end
        % BoneMed27Value(2, 2) is the back end
        if BoneMed27Value(2, 2) == 1
            SegMed(1: 2) = medValue;
            SegMed(7: 8) = medValue;
            weight(1: 2) = epsilon_r(medValue);
            weight(7: 8) = epsilon_r(medValue);
        end
        if BoneMed27Value(2, 8) == 1 && BoneMed27Value(2, 2) == 1
            error('check');
        end
    elseif strcmp(faceName, 'p4')
        SubRibCases = CheckSubRibLR( p4BoneMed9Value(BoneMed9Value) );
        if SubRibCases(1) 
            SegMed(5: 8) = uint8(6);
            weight(5: 8) = epsilon_r(6);
        end
        if SubRibCases(2) 
            SegMed(1: 4) = uint8(6);
            weight(1: 4) = epsilon_r(6);
        end
        % BoneMed27Value(2, 8) is the front end
        if BoneMed27Value(2, 8) == 1
            SegMed(1: 2) = medValue;
            SegMed(7: 8) = medValue;
            weight(1: 2) = epsilon_r(medValue);
            weight(7: 8) = epsilon_r(medValue);
        end
        % BoneMed27Value(2, 2) is the back end
        if BoneMed27Value(2, 2) == 1
            SegMed(3: 6) = medValue;
            weight(3: 6) = epsilon_r(medValue);
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

            % lineArr = [ BoneMed27Value(2, 6), BoneMed27Value(3, 6), BoneMed27Value(3, 5), ...
            %             BoneMed27Value(3, 4), BoneMed27Value(2, 4), BoneMed27Value(1, 4), ...
            %             BoneMed27Value(1, 5), BoneMed27Value(1, 6), BoneMed27Value(2, 6) ];
            % first16 = find( lineArr >= 10, 1 );
            % first1  = find( lineArr == 1, 1 );
            % SegMed( first16: first1 - 2 ) = uint8(6);
            % weight( first16: first1 - 2 ) = epsilon_r(6);

            % lineArr( first16: first1 ) = 1;
            % second16 = find( lineArr >= 10, 1 )
            % if ~isempty( second16 ) && second16 ~= 9
            %     lineArr( 1: second16 ) = 16;
            %     second1 = find( lineArr == 1, 1 );
            %     if ~isempty( second1 )
            %         SegMed( second16: second1 - 2 ) = uint8(6);
            %         weight( second16: second1 - 2 ) = epsilon_r(6);
            %     end
            % end
        end
    else
        error('check');
    end

end