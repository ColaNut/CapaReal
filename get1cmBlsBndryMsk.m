function BlsBndryMsk = get1cmBlsBndryMsk( bolus_a, bolus_b, muscle_a, muscle_b, dx, dz, x_idx_max, z_idx_max, air_x, air_z )

    BlsBndryMsk = zeros( x_idx_max, z_idx_max );
    % [0, 1, 2] = [nothing, exterior boundary point, interior boundary point]
    
    % take cares to gird points lying near enough to ``both'' the two boundary interfaces
    [ XtableExt, ZtableExt ] = fillTradlElctrd( bolus_a, bolus_b, dx, dz );
    [ XtableInt, ZtableInt ] = fillTradlElctrd( muscle_a, muscle_b, dx, dz );
    % Xtable = [ int_grid_x, z1, int_grid_x, z2 ];
    % Ztable = [ x1, int_grid_z, x2, int_grid_z ];
    lenX_ext = size(XtableExt, 1);
    lenZ_ext = size(ZtableExt, 1);

    % Exterior: 11; Interior: 12;
    
    % For exterior point
    for idx = 1: 1: lenX_ext
        x  = XtableExt(idx, 1); 
        z1 = XtableExt(idx, 2); 
        z2 = XtableExt(idx, 4); 
        if XtableExt(idx, 1) ~= XtableExt(idx, 3)
            error('check XtableExt');
        end 
        m = int64( x / dx + air_x / (2 * dx) + 1 );
        ell_1 = int64( z1 / dz + air_z / (2 * dz) + 1 );
        ell_2 = int64( z2 / dz + air_z / (2 * dz) + 1 );

        BlsBndryMsk(m, ell_1) = 11;
        BlsBndryMsk(m, ell_2) = 11;
    end

    for idx = 1: 1: lenZ_ext
        x1 = ZtableExt(idx, 1); 
        z  = ZtableExt(idx, 2); 
        x2 = ZtableExt(idx, 3); 
        if ZtableExt(idx, 2) ~= ZtableExt(idx, 4)
            error('check ZtableExt');
        end 
        m_1 = int64( x1 / dx + air_x / (2 * dx) + 1 );
        m_2 = int64( x2 / dx + air_x / (2 * dx) + 1 );
        ell = int64( z / dz + air_z / (2 * dz) + 1 );

        BlsBndryMsk(m_1, ell) = 11;
        BlsBndryMsk(m_2, ell) = 11;
    end

    % For interior point
    lenX_int = size(XtableInt, 1);
    lenZ_int = size(ZtableInt, 1);

    for idx = 1: 1: lenX_int
        x  = XtableInt(idx, 1); 
        z1 = XtableInt(idx, 2); 
        z2 = XtableInt(idx, 4); 
        if XtableInt(idx, 1) ~= XtableInt(idx, 3)
            error('check XtableInt');
        end 
        m = int64( x / dx + air_x / (2 * dx) + 1 );
        ell_1 = int64( z1 / dz + air_z / (2 * dz) + 1 );
        ell_2 = int64( z2 / dz + air_z / (2 * dz) + 1 );

        BlsBndryMsk(m, ell_1) = 12;
        BlsBndryMsk(m, ell_2) = 12;
    end

    for idx = 1: 1: lenZ_int
        x1 = ZtableInt(idx, 1); 
        z  = ZtableInt(idx, 2); 
        x2 = ZtableInt(idx, 3); 
        if ZtableInt(idx, 2) ~= ZtableInt(idx, 4)
            error('check ZtableInt');
        end 
        m_1 = int64( x1 / dx + air_x / (2 * dx) + 1 );
        m_2 = int64( x2 / dx + air_x / (2 * dx) + 1 );
        ell = int64( z / dz + air_z / (2 * dz) + 1 );

        BlsBndryMsk(m_1, ell) = 12;
        BlsBndryMsk(m_2, ell) = 12;
    end

end