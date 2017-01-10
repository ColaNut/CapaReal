function Pnt8SegValue = get8Seg(PntSegUni)

    Pnt8SegValue = 3 * ones(8, 1);

    for idx = 1: 1: 8
        if ~isempty( find( PntSegUni(idx, :) == 2 ) )
            Pnt8SegValue(idx) = 2;
        end
    end
    
end