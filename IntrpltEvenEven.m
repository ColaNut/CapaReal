function [ IntrpltPnt ] = IntrpltEvenEven( SARsegUpRght, TtrVolUpRght, SARsegUpLft, TtrVolUpLft, ...
                                            SARsegDwnLft, TtrVolDwnLft, SARsegDwnRght, TtrVolDwnRght, CrossSecText )
    
    IntrpltPnt = 0;
    EightRegionUpRght  = zeros(8, 1);
    EightRegionUpLft   = zeros(8, 1);
    EightRegionDwnLft  = zeros(8, 1);
    EightRegionDwnRght = zeros(8, 1);

    % Check the string input for 'XZ', 'XY' or 'YZ'.
    % Modify the corresponding getEightRegionXZ, getEightRegionXY and getEightRegionYZ. 
    EightRegionUpRght  = getEightRegion( SARsegUpRght, TtrVolUpRght , CrossSecText);
    EightRegionUpLft   = getEightRegion( SARsegUpLft, TtrVolUpLft, CrossSecText );
    EightRegionDwnLft  = getEightRegion( SARsegDwnLft, TtrVolDwnLft, CrossSecText );
    EightRegionDwnRght = getEightRegion( SARsegDwnRght, TtrVolDwnRght, CrossSecText );

    IntrpltPnt = sum( EightRegionUpRght(5:6) + EightRegionUpLft(7:8) + EightRegionDwnLft(1:2) + EightRegionDwnRght(3:4) ) / 8;

end