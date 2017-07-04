function SheetPntsXZ = UpdtSheetPnts(SheetPntsXZ, idx, varargin)

    nVarargs = length(varargin);
    if nVarargs == 1
        MedVal = varargin{1};
    else
        MedVal = 1;
    end
    % SheetPntsXZ = zeros( 9, 1, 'uint8');
    SheetPntsXZ(5) = uint8(MedVal);

    switch idx
        case 1
            if SheetPntsXZ(6) == MedVal
                error('check');
            end
            SheetPntsXZ(6) = uint8(MedVal);
        case 2
            if SheetPntsXZ(9) == MedVal
                error('check');
            end
            SheetPntsXZ(9) = uint8(MedVal);
        case 3
            if SheetPntsXZ(8) == MedVal
                error('check');
            end
            SheetPntsXZ(8) = uint8(MedVal);
        case 4
            if SheetPntsXZ(7) == MedVal
                error('check');
            end
            SheetPntsXZ(7) = uint8(MedVal);
        case 5
            if SheetPntsXZ(4) == MedVal
                error('check');
            end
            SheetPntsXZ(4) = uint8(MedVal);
        case 6
            if SheetPntsXZ(1) == MedVal
                error('check');
            end
            SheetPntsXZ(1) = uint8(MedVal);
        case 7
            if SheetPntsXZ(2) == MedVal
                error('check');
            end
            SheetPntsXZ(2) = uint8(MedVal);
        case 8
            if SheetPntsXZ(3) == MedVal
                error('check');
            end
            SheetPntsXZ(3) = uint8(MedVal);
    end

end