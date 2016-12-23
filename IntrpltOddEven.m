function [ IntrpltPnt ] = IntrpltOddEven( SARsegUp, TtrVolUp, SARsegDwn, TtrVolDwn, CrossSecText )
    
    IntrpltPnt = 0;
    EightRegionUp = zeros(8, 1);
    EightRegionDwn = zeros(8, 1);

    % Check the string input for 'XZ', 'XY' or 'YZ'.
    % Modify the corresponding getEightRegionXZ, getEightRegionXY and getEightRegionYZ.  
    EightRegionUp = getEightRegion( SARsegUp, TtrVolUp, CrossSecText );
    EightRegionDwn = getEightRegion( SARsegDwn, TtrVolDwn, CrossSecText );

    IntrpltPnt = sum( EightRegionUp(6: 7) + EightRegionDwn(2: 3) ) / 4;

end