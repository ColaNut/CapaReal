function SheetPntsXZ = UpdtSheetPnts(SheetPntsXZ, idx)

    % SheetPntsXZ = zeros( 9, 1, 'uint8');
    SheetPntsXZ(5) = uint8(1);

    switch idx
        case 1
            SheetPntsXZ(6) = uint8(1);
        case 2
            SheetPntsXZ(9) = uint8(1);
        case 3
            SheetPntsXZ(8) = uint8(1);
        case 4
            SheetPntsXZ(7) = uint8(1);
        case 5
            SheetPntsXZ(4) = uint8(1);
        case 6
            SheetPntsXZ(1) = uint8(1);
        case 7
            SheetPntsXZ(2) = uint8(1);
        case 8
            SheetPntsXZ(3) = uint8(1);
    end

end