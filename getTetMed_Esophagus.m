function MedValue = getTetMed_Esophagus( TtrCrdnt, CtrlPntFlag, MedValue )
    
    loadParas;
    loadAmendParas_Esophagus;
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
        if ( (x - x_es) / r_es)^2 + ( (z - z_es) / r_es)^2 - 1 < 0 % interior
            MedValue = 1;
        end
    else
        error('check the mediumTable');
    end

end