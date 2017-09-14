function MedValue = getTetMed( TtrCrdnt, CtrlPntFlag )
    loadParas_Cervix;
    MedValue = 0;
    x = TtrCrdnt(1);
    y = TtrCrdnt(2);
    z = TtrCrdnt(3);
    switch CtrlPntFlag
        case 11
            if (x / bolus_a)^2 + (z / bolus_c)^2 - 1 > 0 % exterior
                MedValue = 3;
            else % interior
                MedValue = 4;
            end
        case 13
            if (x / muscle_a)^2 + (z / muscle_c)^2 - 1 > 0 % exterior
                MedValue = 4;
            else % interior
                MedValue = 2;
            end
        case 12
            if (x / skin_a)^2 + (z / skin_c)^2 - 1 > 0 % exterior
                MedValue = 2;
            else % interior
                MedValue = 1;
            end
        otherwise
            error('check the mediumTable');
    end

end