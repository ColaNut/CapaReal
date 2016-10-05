function [ intGridValue, gc_diff ] = nearestIntGrid( curveValue, interval )

    % initialization
    intGridValue = - pi;
    gc_diff      = pi;% grid-curve difference

    ceil_diff  = curveValue - myCeil( curveValue, interval ); % a positive value
    floor_diff = curveValue - myFloor( curveValue, interval ); % a negative value

    if mod( curveValue, interval ) == 0
        intGridValue = curveValue;
        gc_diff = 0;
        return;
    end

    if abs(ceil_diff) > abs(floor_diff)
        intGridValue = myFloor(curveValue, interval);
        gc_diff = floor_diff;
        return;
    elseif abs(ceil_diff) == abs(floor_diff)
        error('re-check');
    else
        intGridValue = myCeil(curveValue, interval);
        gc_diff = ceil_diff;
        return;
    end

    if intGridValue == pi
        error('check intGridValue');
    elseif gc_diff == pi
        error('check gc_diff');
    end

end