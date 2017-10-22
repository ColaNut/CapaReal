function MedValue = getTetMed( TtrCrdnt, CtrlPntFlag, varargin )

    nVarargs = length(varargin);
    MedValue = 0;
    x = TtrCrdnt(1);
    y = TtrCrdnt(2);
    z = TtrCrdnt(3);

    if nVarargs == 1
        OrganType = varargin{1};
        if strcmp(OrganType, 'Eso') % rough eso version
            loadParas_Eso0924;
            AirOrTumor = 1;
            if y <= tumor_y_es + tumor_hy_es / 2 && y >= tumor_y_es - tumor_hy_es / 2
                AirOrTumor = 9;
            end
            switch CtrlPntFlag
                case 41
                    % this may be wrong in the junction point of spine
                    if ( (x - es_x) / es_r )^2 + ( (z - es_z) / es_r)^2 - 1 > 0 % exterior
                        MedValue = 3;
                    else % interior
                        MedValue = AirOrTumor;
                    end
                case 42
                    if ( (x - es_x) / es_r )^2 + ( (z - es_z) / es_r)^2 - 1 > 0 % exterior
                        MedValue = 3;
                    else % interior
                        MedValue = AirOrTumor;
                    end
                    if ( (x - endo_x) / endo_r )^2 + ( (z - endo_z) / endo_r)^2 - 1 < 0 % interior
                        MedValue = 2;
                    end
                otherwise
                    error('check eso');
            end
        elseif strcmp(OrganType, 'Eso1009')
            loadParas_Eso0924;
            tumorRegion = false;
            if y <= tumor_y_es + tumor_hy_es / 2 && y >= tumor_y_es - tumor_hy_es / 2
                tumorRegion = true;
            end
            switch CtrlPntFlag
                case 41
                    % this may be wrong in the junction point of spine
                    if ( (x - es_x) / es_r )^2 + ( (z - es_z) / es_r)^2 - 1 > 0 % exterior
                        MedValue = 3;
                    else % interior
                        if ~tumorRegion
                            MedValue = 1;
                        else
                            if z < es_z
                                MedValue = 1;
                            else
                                MedValue = 9;
                            end
                        end
                    end
                case {9, 42}
                    if tumorRegion
                        if z > es_z % uppper part of esophagus
                            MedValue = 9;
                        else % lower part of esophagus
                            MedValue = 1;
                        end
                    else
                        MedValue = 1;
                    end
                otherwise
                    error('check eso');
            end
        elseif strcmp(OrganType, 'Eso1015')
            loadParas_Eso0924;
            tumorRegion = false;
            if y <= tumor_y_es + tumor_hy_es / 2 && y >= tumor_y_es - tumor_hy_es / 2
                tumorRegion = true;
            end
            if ~tumorRegion
                % carve the air region
                if x < es_r / 2 && x > - es_r / 2 && z < es_r / 2 && z > - es_r / 2 
                    MedValue = 1;
                end
            else
                if ( (x - es_x) / es_r )^2 + ( (z - es_z) / es_r)^2 - 1 < 0 % interior
                    if z > es_z - es_r / 4
                        MedValue = 9;
                    end
                    if x < es_r / 2 && x > - es_r / 2 && z < es_r / 4 && z > - es_r / 2 
                        MedValue = 1;
                    end
                end
            end
        else
            error('check');
        end
    else
        loadParas_Cervix;
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
end