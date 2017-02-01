function lxFltr = getBndryNum(idx, lengthArray)

    cumArray = cumsum(lengthArray);
    lxFltr = - 1;

    % lengthArray = [ bolus, skin, muscle, left lung, right lung, tumor ]
    %             or [ left lung, right lung, tumor ]
    % bolus-air:   11
    % bolus-skin:  12
    % skin-muscle: 13
    % muscle-lung: 14
    % lung-tumor:  15

    if length(lengthArray) == 6
        if idx <= cumArray(1)
            lxFltr = 11;
        elseif idx <= cumArray(2)
            lxFltr = 12;
        elseif idx <= cumArray(3)
            lxFltr = 13;
        elseif idx <= cumArray(4)
            lxFltr = 14;
        elseif idx <= cumArray(5)
            lxFltr = 14;
        elseif idx <= cumArray(6)
            lxFltr = 15;
        else
            error('check');
        end
    elseif length(lengthArray) == 3
        if idx <= cumArray(1)
            lxFltr = 14;
        elseif idx <= cumArray(2)
            lxFltr = 14;
        elseif idx <= cumArray(3)
            lxFltr = 15;
        else
            error('check');
        end
    else
        error('check');
    end
end