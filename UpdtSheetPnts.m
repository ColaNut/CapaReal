function SheetPntsXZ = UpdtSheetPnts(SheetPntsXZ, idx)

    % SheetPntsXZ = zeros( 9, 1, 'uint8');
    SheetPntsXZ(5) = uint8(1);

    switch idx
        case 1
            if SheetPntsXZ(6) == 1
                error('check');
            end
            SheetPntsXZ(6) = uint8(1);
        case 2
            if SheetPntsXZ(9) == 1
                error('check');
            end
            SheetPntsXZ(9) = uint8(1);
        case 3
            if SheetPntsXZ(8) == 1
                error('check');
            end
            SheetPntsXZ(8) = uint8(1);
        case 4
            if SheetPntsXZ(7) == 1
                error('check');
            end
            SheetPntsXZ(7) = uint8(1);
        case 5
            if SheetPntsXZ(4) == 1
                error('check');
            end
            SheetPntsXZ(4) = uint8(1);
        case 6
            if SheetPntsXZ(1) == 1
                error('check');
            end
            SheetPntsXZ(1) = uint8(1);
        case 7
            if SheetPntsXZ(2) == 1
                error('check');
            end
            SheetPntsXZ(2) = uint8(1);
        case 8
            if SheetPntsXZ(3) == 1
                error('check');
            end
            SheetPntsXZ(3) = uint8(1);
    end

end