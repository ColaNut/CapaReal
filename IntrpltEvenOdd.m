function [ IntrpltPnt ] = IntrpltEvenOdd( SARsegLft, TtrVolLft, SARsegRght, TtrVolRght, CrossSecText )
    
    IntrpltPnt = 0;
    EightRegionLft = zeros(8, 1);
    EightRegionRght = zeros(8, 1);

    % Check the string input for 'XZ', 'XY' or 'YZ'.
    % Modify the corresponding getEightRegionXZ, getEightRegionXY and getEightRegionYZ.  
    EightRegionLft = getEightRegion( SARsegLft, TtrVolLft, CrossSecText );
    EightRegionRght = getEightRegion( SARsegRght, TtrVolRght, CrossSecText );

    IntrpltPnt = sum( EightRegionLft(1) + EightRegionLft(8) + EightRegionRght(4) + EightRegionRght(5) ) / 4;

end