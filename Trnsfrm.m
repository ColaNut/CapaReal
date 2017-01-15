function ReOrder = Trnsfrm(XZBls9Med)

    % Re-order the Medium table
    ReOrder = [ XZBls9Med(7), XZBls9Med(8), XZBls9Med(9);
                XZBls9Med(4), XZBls9Med(5), XZBls9Med(6);
                XZBls9Med(1), XZBls9Med(2), XZBls9Med(3) ];

    if XZBls9Med(5) == 11
        % Update the first two rows
        for idx = 1: 1: 2
            BndryOrder = find(ReOrder(idx, :) == 11 | ReOrder(idx, :) == 12);
            if isempty(BndryOrder)
                ReOrder(idx, :) = 1;
            else
                if BndryOrder(1) ~= 1
                    ReOrder(idx, 1: BndryOrder(1) - 1) = 1;
                end
                if BndryOrder(end) ~= 3
                    ReOrder(idx, 3) = 2;
                end
            end
        end
        % Update the first two columns
        for idx = 1: 1: 2
            BndryOrder = find(ReOrder(:, idx) == 11 | ReOrder(:, idx) == 12);
            if isempty(BndryOrder)
                ReOrder(:, idx) = 1;
            else
                % start from here: reevaluate the following dertermining conditions.
                if BndryOrder(1) ~= 1
                    ReOrder(1: BndryOrder(1) - 1, idx) = 1;
                end
                if BndryOrder(end) ~= 3
                    ReOrder(3, idx) = 2;
                end
            end
        end
        % Update the last element
        if ReOrder(3, 3) == 0
            ReOrder(3, 3) = 3;
        end

    elseif XZBls9Med(5) == 12
        % Update the first row
        if ReOrder(1, 1) == 0
            ReOrder(1, 1) = 1;
        end
        if ReOrder(1, 2) == 0
            ReOrder(1, 2) = 2;
        end
        if ReOrder(1, 3) == 0
            if ReOrder(1, 2) == 11 && ReOrder(2, 3) == 12
                ReOrder(1, 3) = 2;
            else
                ReOrder(1, 3) = 3;
            end
        end
        % Update the last two rows
        for idx = 2: 1: 3
            BndryOrder = find(ReOrder(idx, :) == 11 | ReOrder(idx, :) == 12);
            if isempty(BndryOrder)
                ReOrder(idx, :) = 3;
            else
                if BndryOrder(1) == 0
                   ReOrder(idx, 1) = 2;
                end
                if BndryOrder(end) ~= 3
                    ReOrder(idx, BndryOrder(end) + 1: 3) = 3;
                end
                if BndryOrder(1) == 2
                    ReOrder(idx, 1) = 2;
                end
            end
        end
    else
        error('check bolus boundary');
    end

    % XZBls9Med = [ReOrder(3, 1); ReOrder(3, 2); ReOrder(3, 3); 
    %              ReOrder(2, 1); ReOrder(2, 2); ReOrder(2, 3); 
    %              ReOrder(1, 1); ReOrder(1, 2); ReOrder(1, 3) ];
end
