function [ TtrVol ] = calTtrVol( a, b, c, d )
    TtrVol = 0;
    TtrVol = abs( dot( a - d, cross( b - d, c - d ) ) ) / 6;
end