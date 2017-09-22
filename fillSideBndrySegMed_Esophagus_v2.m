function SegMed = fillSideBndrySegMed_Esophagus_v2( Side9Pnts, CtrlPnt, SidePntFlag, CtrlPntFlag, SegMed )

TtrCrdnt    = zeros(8, 3);
% SegMed      = ones(1, 8, 'uint8');
    
    % CtrlPnt has to be a 1-by-3 vector
    TtrCrdnt(1, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(6, :) + Side9Pnts(9, :) ) / 4;
    TtrCrdnt(2, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(9, :) + Side9Pnts(8, :) ) / 4;
    TtrCrdnt(3, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(8, :) + Side9Pnts(7, :) ) / 4;
    TtrCrdnt(4, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(7, :) + Side9Pnts(4, :) ) / 4;
    TtrCrdnt(5, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(4, :) + Side9Pnts(1, :) ) / 4;
    TtrCrdnt(6, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(1, :) + Side9Pnts(2, :) ) / 4;
    TtrCrdnt(7, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(2, :) + Side9Pnts(3, :) ) / 4;
    TtrCrdnt(8, :) = ( CtrlPnt + Side9Pnts(5, :) + Side9Pnts(3, :) + Side9Pnts(6, :) ) / 4;

    for idx = 1: 1: 8
        SegMed(idx) = getTetMed_Esophagus_v2( TtrCrdnt(idx, :), CtrlPntFlag, SegMed(idx) );
    end

end