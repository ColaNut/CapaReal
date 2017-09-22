function MedValue = getTetMed_Esophagus_v2( TtrCrdnt, CtrlPntFlag, MedValue )
    
    loadParas;
    loadAmendParas_Esophagus;
    loadAmendParas_Esophagus_Math;
    % update the inner part, only.

    % x_es = 0 / 100;
    % z_es = 5 / 100;
    % r_es = 2 / 200;

    % tumor_x_es = 0 / 100;
    % tumor_y_es = 0 / 100;
    % tumor_z_es = 5 / 100;
    % tumor_r_es = 1 / 200; % radius of 1 cm

    % MedValue = 0;
    x = TtrCrdnt(1);
    y = TtrCrdnt(2);
    z = TtrCrdnt(3);
    if CtrlPntFlag == 31
        if ( (x - x_es_math) / r_es_math)^2 + ( (z - z_es_math) / r_es_math)^2 - 1 < 0 % interior
            MedValue = 1;
        end
    elseif CtrlPntFlag == 32 % esophagal tumor number
        if z >= tumor_es_LowerLine && z <= tumor_es_UpperLine && MedValue == 1
            MedValue = 9;
        end
    else
        error('check the mediumTable');
    end

end