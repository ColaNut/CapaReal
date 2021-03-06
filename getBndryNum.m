function lxFltr = getBndryNum(idx, lengthArray, varargin)

    nVarargs = length(varargin);
    % if nVarargs == 1
    %     TEXT_flag    = varargin{1};
    % end

    cumArray = cumsum(lengthArray);
    lxFltr = - 1;

    % lengthArray = [ bolus, skin, muscle, left lung, right lung, tumor ]
    %             or [ left lung, right lung, tumor ]
    % bolus-air:   11
    % bolus-skin:  12
    % skin-muscle: 13
    % muscle-lung: 14
    % lung-tumor:  15
    % Esophagus-muscle: 41
    % endoscopy-other: 42

    if length(lengthArray) == 6 % design for lung and cervix in the XZ plane
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
    elseif length(lengthArray) == 3 % design for lung in the YZ plane
        if idx <= cumArray(1)
            lxFltr = 14;
        elseif idx <= cumArray(2)
            lxFltr = 14;
        elseif idx <= cumArray(3)
            lxFltr = 15;
        else
            error('check');
        end
    elseif length(lengthArray) == 5 % design for liver in the XZ plane
        if idx <= cumArray(1)
            lxFltr = 11;
        elseif idx <= cumArray(2)
            lxFltr = 12;
        elseif idx <= cumArray(3)
            lxFltr = 13;
        elseif idx <= cumArray(4)
            lxFltr = 14;
        elseif idx <= cumArray(5)
            lxFltr = 15;
        else
            error('check');
        end
    elseif length(lengthArray) == 2 
        if nVarargs % design for esophagus
            if idx <= cumArray(1)
                lxFltr = 41;
            elseif idx <= cumArray(2)
                lxFltr = 42;
            else
                error('check');
            end
        else % design for liver in the YZ plane
            if idx <= cumArray(1)
                lxFltr = 14;
            elseif idx <= cumArray(2)
                lxFltr = 15;
            else
                error('check');
            end
        end
    elseif length(lengthArray) == 1 % esophagus flat boundary 1008
        if idx <= cumArray(1)
            lxFltr = 41;
        else
            error('check');
        end
    else
        error('check');
    end
end