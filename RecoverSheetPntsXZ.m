function SheetPntsXZ = RecoverSheetPntsXZ( SheetPntsXZ_Ori, QuadrantNum )

    SheetPntsXZ = zeros( 9, 1, 'uint8' );
    % transform from second quadrant to other quadrant
    if QuadrantNum == 2
        SheetPntsXZ = SheetPntsXZ_Ori;
    elseif QuadrantNum == 1
        SheetPntsXZ(1) = SheetPntsXZ_Ori(3);
        SheetPntsXZ(2) = SheetPntsXZ_Ori(2);
        SheetPntsXZ(3) = SheetPntsXZ_Ori(1);
        SheetPntsXZ(4) = SheetPntsXZ_Ori(6);
        SheetPntsXZ(5) = SheetPntsXZ_Ori(5);
        SheetPntsXZ(6) = SheetPntsXZ_Ori(4);
        SheetPntsXZ(7) = SheetPntsXZ_Ori(9);
        SheetPntsXZ(8) = SheetPntsXZ_Ori(8);
        SheetPntsXZ(9) = SheetPntsXZ_Ori(7);
    elseif QuadrantNum == 3
        SheetPntsXZ(1) = SheetPntsXZ_Ori(7);
        SheetPntsXZ(2) = SheetPntsXZ_Ori(8);
        SheetPntsXZ(3) = SheetPntsXZ_Ori(9);
        SheetPntsXZ(4) = SheetPntsXZ_Ori(4);
        SheetPntsXZ(5) = SheetPntsXZ_Ori(5);
        SheetPntsXZ(6) = SheetPntsXZ_Ori(6);
        SheetPntsXZ(7) = SheetPntsXZ_Ori(1);
        SheetPntsXZ(8) = SheetPntsXZ_Ori(2);
        SheetPntsXZ(9) = SheetPntsXZ_Ori(3);
    elseif QuadrantNum == 4
        SheetPntsXZ(1) = SheetPntsXZ_Ori(9);
        SheetPntsXZ(2) = SheetPntsXZ_Ori(8);
        SheetPntsXZ(3) = SheetPntsXZ_Ori(7);
        SheetPntsXZ(4) = SheetPntsXZ_Ori(6);
        SheetPntsXZ(5) = SheetPntsXZ_Ori(5);
        SheetPntsXZ(6) = SheetPntsXZ_Ori(4);
        SheetPntsXZ(7) = SheetPntsXZ_Ori(3);
        SheetPntsXZ(8) = SheetPntsXZ_Ori(2);
        SheetPntsXZ(9) = SheetPntsXZ_Ori(1);
    end


end