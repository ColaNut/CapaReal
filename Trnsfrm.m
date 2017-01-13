function ReOrder = Trnsfrm(XZBls9Med)

    % Re-order the Medium table
    ReOrder = [ XZBls9Med(7), XZBls9Med(8), XZBls9Med(9);
                XZBls9Med(4), XZBls9Med(5), XZBls9Med(6);
                XZBls9Med(1), XZBls9Med(2), XZBls9Med(3) ];

    for idx = 1: 1: 2
        BndryOrder = find(ReOrder(idx, :) == 11 | ReOrder(idx, :) == 12);
        if isempty(BndryOrder)
            ReOrder(idx, :) = 1;
            % error('check');
        else
            if BndryOrder(1) ~= 1
                ReOrder(idx, 1: BndryOrder(1) - 1) = 1;
            end
            if BndryOrder(end) ~= 3
                ReOrder(idx, 3) = 2;
            end
        end
    end

    for idx = 1: 1: 2
        BndryOrder = find(ReOrder(:, idx) == 11 | ReOrder(:, idx) == 12);
        if isempty(BndryOrder)
            ReOrder(:, idx) = 1;
        else
            if BndryOrder(1) ~= 1
                ReOrder(idx, 1: BndryOrder(1) - 1) = 1;
            end
            if BndryOrder(end) ~= 3
                ReOrder(idx, 3) = 2;
            end
        end
    end

    if ReOrder(3, 3) == 0
        ReOrder(3, 3) = 3;
    end

    % XZBls9Med = [ReOrder(3, 1); ReOrder(3, 2); ReOrder(3, 3); 
    %              ReOrder(2, 1); ReOrder(2, 2); ReOrder(2, 3); 
    %              ReOrder(1, 1); ReOrder(1, 2); ReOrder(1, 3) ];
end
