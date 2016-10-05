function [ floor_value ] = myFloor( curveValue, interval )

floor_value = curveValue - mod(curveValue, interval);

end