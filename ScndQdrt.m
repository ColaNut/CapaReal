function SegMed = ScndQdrt( XZBls9Med )
    
    % 14 cases
    SegMed = zeros(6, 8, 'uint8');
    ReOrder = zeros(3, 3);
    CntrClckOrdr11 = zeros(8, 1);
    CntrClckOrdr12 = zeros(8, 1);
    SegReordrXZ = 2 * ones(8, 6, 'uint8');
    ReOrder = Trnsfrm(XZBls9Med);

    if XZBls9Med(5) == 11
        CntrClckOrdr11 = [ ReOrder(2, 3); ReOrder(1, 3); ReOrder(1, 2); ReOrder(1, 1); 
                         ReOrder(2, 1); ReOrder(3, 1); ReOrder(3, 2); ReOrder(3, 3) ];
        AirIdx = find(CntrClckOrdr11 == 1);
        for idx = AirIdx(1) - 1: 1: AirIdx(end)
            SegReordrXZ(idx, :) = 1;
        end
    elseif XZBls9Med(5) == 12
        CntrClckOrdr12 = [ ReOrder(2, 1); ReOrder(3, 1); ReOrder(3, 2); ReOrder(3, 3); 
                         ReOrder(2, 3); ReOrder(1, 3); ReOrder(1, 2); ReOrder(1, 1) ];
        TorsoIdx = find(CntrClckOrdr12 == 3);
        for idx = TorsoIdx(1) + 3: 1: TorsoIdx(end) + 4
            if mod(idx, 8) == 0
                SegReordrXZ(8, :) = 3;
            else
                SegReordrXZ(mod(idx, 8), :) = 3;
            end
        end
    else
        error('Check');
    end

    % SegReordrXZ = [   SegMed(4, 1), SegMed(4, 2), SegMed(4, 3), SegMed(4, 4), SegMed(5, 4), SegMed(6, 1);
    %                   SegMed(1, 1), SegMed(1, 2), SegMed(1, 7), SegMed(1, 8), SegMed(5, 3), SegMed(6, 2); 
    %                   SegMed(1, 3), SegMed(1, 4), SegMed(1, 5), SegMed(1, 6), SegMed(5, 2), SegMed(6, 3); 
    %                   SegMed(2, 1), SegMed(2, 2), SegMed(2, 3), SegMed(2, 4), SegMed(5, 1), SegMed(6, 4); 
    %                   SegMed(2, 5), SegMed(2, 6), SegMed(2, 7), SegMed(2, 8), SegMed(5, 8), SegMed(6, 5); 
    %                   SegMed(3, 1), SegMed(3, 2), SegMed(3, 7), SegMed(3, 8), SegMed(5, 7), SegMed(6, 6); 
    %                   SegMed(3, 3), SegMed(3, 4), SegMed(3, 5), SegMed(3, 6), SegMed(5, 6), SegMed(6, 7); 
    %                   SegMed(4, 5), SegMed(4, 6), SegMed(4, 7), SegMed(4, 8), SegMed(5, 5), SegMed(6, 8) ];

    SegMed(4, 1) = SegReordrXZ(1, 1);   SegMed(1, 1) = SegReordrXZ(2, 1);   SegMed(1, 3) = SegReordrXZ(3, 1);
    SegMed(4, 2) = SegReordrXZ(1, 2);   SegMed(1, 2) = SegReordrXZ(2, 2);   SegMed(1, 4) = SegReordrXZ(3, 2);
    SegMed(4, 3) = SegReordrXZ(1, 3);   SegMed(1, 7) = SegReordrXZ(2, 3);   SegMed(1, 5) = SegReordrXZ(3, 3);
    SegMed(4, 4) = SegReordrXZ(1, 4);   SegMed(1, 8) = SegReordrXZ(2, 4);   SegMed(1, 6) = SegReordrXZ(3, 4);
    SegMed(5, 4) = SegReordrXZ(1, 5);   SegMed(5, 3) = SegReordrXZ(2, 5);   SegMed(5, 2) = SegReordrXZ(3, 5);
    SegMed(6, 1) = SegReordrXZ(1, 6);   SegMed(6, 2) = SegReordrXZ(2, 6);   SegMed(6, 3) = SegReordrXZ(3, 6);

    SegMed(2, 1) = SegReordrXZ(4, 1);   SegMed(2, 5) = SegReordrXZ(5, 1);   SegMed(3, 1) = SegReordrXZ(6, 1);
    SegMed(2, 2) = SegReordrXZ(4, 2);   SegMed(2, 6) = SegReordrXZ(5, 2);   SegMed(3, 2) = SegReordrXZ(6, 2);
    SegMed(2, 3) = SegReordrXZ(4, 3);   SegMed(2, 7) = SegReordrXZ(5, 3);   SegMed(3, 7) = SegReordrXZ(6, 3);
    SegMed(2, 4) = SegReordrXZ(4, 4);   SegMed(2, 8) = SegReordrXZ(5, 4);   SegMed(3, 8) = SegReordrXZ(6, 4);
    SegMed(5, 1) = SegReordrXZ(4, 5);   SegMed(5, 8) = SegReordrXZ(5, 5);   SegMed(5, 7) = SegReordrXZ(6, 5);
    SegMed(6, 4) = SegReordrXZ(4, 6);   SegMed(6, 5) = SegReordrXZ(5, 6);   SegMed(6, 6) = SegReordrXZ(6, 6);

    SegMed(3, 3) = SegReordrXZ(7, 1);   SegMed(4, 5) = SegReordrXZ(8, 1);
    SegMed(3, 4) = SegReordrXZ(7, 2);   SegMed(4, 6) = SegReordrXZ(8, 2);
    SegMed(3, 5) = SegReordrXZ(7, 3);   SegMed(4, 7) = SegReordrXZ(8, 3);
    SegMed(3, 6) = SegReordrXZ(7, 4);   SegMed(4, 8) = SegReordrXZ(8, 4);
    SegMed(5, 6) = SegReordrXZ(7, 5);   SegMed(5, 5) = SegReordrXZ(8, 5);
    SegMed(6, 7) = SegReordrXZ(7, 6);   SegMed(6, 8) = SegReordrXZ(8, 6);

end