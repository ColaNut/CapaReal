function [ ceil_value ] = myCeil( curveValue, interval )

if mod(curveValue, interval) == 0
    ceil_value = curveValue;
else
    ceil_value = myFloor( curveValue, interval ) + interval;
end

end