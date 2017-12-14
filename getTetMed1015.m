function MedValue = getTetMed1015( MedValue, TtrCrdnt, CtrlPntFlag, varargin )

    nVarargs = length(varargin);
    % MedValue = 0;
    x = TtrCrdnt(1);
    y = TtrCrdnt(2);
    z = TtrCrdnt(3);

    if nVarargs == 1
        OrganType = varargin{1};
        if strcmp(OrganType, 'Eso1015')
            loadParas_Eso0924;
            tumorRegion = false;
            if y <= tumor_y_es + tumor_hy_es / 2 && y >= tumor_y_es - tumor_hy_es / 2
                tumorRegion = true;
            end
            if ~tumorRegion
                % carve the air region
                if x < es_x + es_r / 2 && x > es_x - es_r / 2 && z < es_z + es_r / 2 && z > es_z - es_r / 2 
                    MedValue = 1;
                end
            else
                if ( (x - es_x) / es_r )^2 + ( (z - es_z) / es_r)^2 - 1 < 0 % interior
                    if z > es_z - es_r / 4
                        MedValue = 9;
                    end
                    if x < es_x + es_r / 2 && x > es_x - es_r / 2 && z < es_z + es_r / 4 && z > es_z - es_r / 2 
                        MedValue = 1;
                    end
                end
            end
        elseif strcmp(OrganType, 'Adipose')
            loadParas;
            if ( x / ( skin_a + dx / 2 ) )^2 + ( z / ( skin_c + dx / 2 ) )^2 - 1 < 0 % interior of adpose layer
                if ( x / skin_a )^2 + ( z / skin_c )^2 - 1 > 0 % 1cm boundary line from the skin
                    if MedValue ~= 6 % donnot update of bone
                        MedValue = 3;
                    end
                end
            end
        else
            error('check');
        end
    else
       error('check');
    end
end