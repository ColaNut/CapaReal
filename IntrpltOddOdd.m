function [ IntrpltPnt ] = IntrpltOddOdd( SARseg, TtrVol, CrossSecText )
    
    IntrpltPnt = 0;
    EightRegion = zeros(8, 1);
    
    EightRegion = getEightRegion( SARseg, TtrVol, CrossSecText );

    IntrpltPnt = sum( EightRegion ) / 8;

end