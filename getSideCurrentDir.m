function SideCurrent = getSideCurrentDir( SideSegMed, SideMidLyr, CtrlPnts, J_0 )

    SideCurrent = zeros(8, 3); 
    % six SideCurrent gathered to be CurrentDir(6, 8, 3);
    if SideSegMed(1) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(6, 1), SideMidLyr(9, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(6, 3), SideMidLyr(9, 3)] ) / 4;
        SideCurrent(1, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(2) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(9, 1), SideMidLyr(8, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(9, 3), SideMidLyr(8, 3)] ) / 4;
        SideCurrent(2, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(3) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(8, 1), SideMidLyr(7, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(8, 3), SideMidLyr(7, 3)] ) / 4;
        SideCurrent(3, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(4) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(7, 1), SideMidLyr(4, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(7, 3), SideMidLyr(4, 3)] ) / 4;
        SideCurrent(4, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(5) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(4, 1), SideMidLyr(1, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(4, 3), SideMidLyr(1, 3)] ) / 4;
        SideCurrent(5, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(6) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(1, 1), SideMidLyr(2, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(1, 3), SideMidLyr(2, 3)] ) / 4;
        SideCurrent(6, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(7) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(2, 1), SideMidLyr(3, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(2, 3), SideMidLyr(3, 3)] ) / 4;
        SideCurrent(7, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end
    if SideSegMed(8) == 3
        x = sum( [CtrlPnts(1), SideMidLyr(5, 1), SideMidLyr(3, 1), SideMidLyr(6, 1)] ) / 4;
        z = sum( [CtrlPnts(3), SideMidLyr(5, 3), SideMidLyr(3, 3), SideMidLyr(6, 3)] ) / 4;
        SideCurrent(8, :) = J_0 * [ - z, 0, x ] / norm( [ - z, 0, x ] );
    end

end