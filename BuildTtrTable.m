function TtrVolTable = BuildTtrTable( shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max )
    
    TtrVolTable = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);

    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        PntsIdx      = zeros( 3, 9 );
        PntsCrdnt    = zeros( 3, 9, 3 );
        MidPntsCrdnt = zeros( 3, 9, 3 );

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 

            [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
            MidPntsCrdnt = calMid27Pnts( PntsCrdnt );
            
            % p1
            TtrVolTable(m, n, ell, 1, :) = getPntTtr( squeeze( MidPntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ) );

            % p2
            tmpMidCrdnt = p2Face( MidPntsCrdnt );
            TtrVolTable(m, n, ell, 2, :) = getPntTtr( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

            % p3
            tmpMidCrdnt = p3Face( MidPntsCrdnt );
            TtrVolTable(m, n, ell, 3, :) = getPntTtr( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

            % p4
            tmpMidCrdnt = p4Face( MidPntsCrdnt );
            TtrVolTable(m, n, ell, 4, :) = getPntTtr( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

            % p5
            tmpMidCrdnt = p5Face( MidPntsCrdnt );
            TtrVolTable(m, n, ell, 5, :) = getPntTtr( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );

            % p6
            tmpMidCrdnt = p6Face( MidPntsCrdnt );
            TtrVolTable(m, n, ell, 6, :) = getPntTtr( squeeze( tmpMidCrdnt ), squeeze( PntsCrdnt(2, 5, :) ) );
        end
    end

end