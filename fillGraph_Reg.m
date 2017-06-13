function [ starts, ends, vals ] = fillGraph_Reg( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag )

    % corner_flag = false(2, 6);
    PntsIdx = zeros( 3, 9 );
    PntsIdx = get27Pnts_KEV( m_v - 1, n_v - 1, ell_v - 1, x_max_vertex, y_max_vertex, z_max_vertex );
    m = (m_v + 1) / 2;
    n = (n_v + 1) / 2;
    ell = (ell_v + 1) / 2;
    x_idx_max = ( x_max_vertex - 1 ) / 2 + 1;
    y_idx_max = ( y_max_vertex - 1 ) / 2 + 1;
    z_idx_max = ( z_max_vertex - 1 ) / 2 + 1;
    % the following idx_prm have to be in the first criterion in Prm coordinate
    % idx_prm = get_idx_prm( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    PntsIdx_prm = get27Pnts_prm( m, n, ell, x_idx_max, y_idx_max, z_idx_max );

    dirPair = [];
    Pntvals = [];

    dirPair = [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 7)); % three transverse lines
                v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 3)); 
                v2r(PntsIdx(3, 9)), v2r(PntsIdx(1, 9)) ]; 
    Pntvals    = [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 1, x_idx_max, y_idx_max, z_idx_max );
                   vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 2, x_idx_max, y_idx_max, z_idx_max );
                   vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 3, x_idx_max, y_idx_max, z_idx_max ) ];
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(3, 5)); % up face
                v2r(PntsIdx(3, 7)), v2r(PntsIdx(3, 5)); 
                v2r(PntsIdx(3, 1)), v2r(PntsIdx(3, 5)); 
                v2r(PntsIdx(3, 3)), v2r(PntsIdx(3, 5)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 4, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 5, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 6, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 7, x_idx_max, y_idx_max, z_idx_max ) ] );
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(3, 9)), v2r(PntsIdx(2, 6)); % right face
                v2r(PntsIdx(3, 3)), v2r(PntsIdx(2, 6)); 
                v2r(PntsIdx(1, 3)), v2r(PntsIdx(2, 6)); 
                v2r(PntsIdx(1, 9)), v2r(PntsIdx(2, 6)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 8,  x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 9,  x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 10, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 11, x_idx_max, y_idx_max, z_idx_max ) ] );
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(3, 7)), v2r(PntsIdx(2, 8)); % far face
                v2r(PntsIdx(3, 9)), v2r(PntsIdx(2, 8)); 
                v2r(PntsIdx(1, 9)), v2r(PntsIdx(2, 8)); 
                v2r(PntsIdx(1, 7)), v2r(PntsIdx(2, 8)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 12, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 13, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 14, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 15, x_idx_max, y_idx_max, z_idx_max ) ] );

    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 6)); % four upper-center oblique lines
                v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 8)); 
                v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 4)); 
                v2r(PntsIdx(3, 5)), v2r(PntsIdx(2, 2)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 16, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 17, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 18, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 19, x_idx_max, y_idx_max, z_idx_max ) ] );
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(2, 8)), v2r(PntsIdx(2, 6)); % four center horizental lines
                v2r(PntsIdx(2, 4)), v2r(PntsIdx(2, 8)); 
                v2r(PntsIdx(2, 4)), v2r(PntsIdx(2, 2)); 
                v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 6)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 20, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 21, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 22, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 23, x_idx_max, y_idx_max, z_idx_max ) ] );
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 6)); % four lower-center oblique lines
                v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 8)); 
                v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 4)); 
                v2r(PntsIdx(1, 5)), v2r(PntsIdx(2, 2)) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 24, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 25, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 26, x_idx_max, y_idx_max, z_idx_max );
                vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 27, x_idx_max, y_idx_max, z_idx_max ) ] );
    dirPair = vertcat(dirPair, ...
              [ v2r(PntsIdx(2, 2)), v2r(PntsIdx(2, 8)) ] );  % one center transverse horizental line
    Pntvals = vertcat(Pntvals, ... 
              [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 5), 28, x_idx_max, y_idx_max, z_idx_max ) ] );

    % implement the f1, f2, f3 and three lines.
    % add v2r function
    if corner_flag(1, 6)
        % face 1
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(3, 3)), v2r(PntsIdx(3, 1));
                    v2r(PntsIdx(3, 3)), v2r(PntsIdx(1, 3));
                    v2r(PntsIdx(3, 1)), v2r(PntsIdx(2, 2));
                    v2r(PntsIdx(3, 3)), v2r(PntsIdx(2, 2)); 
                    v2r(PntsIdx(1, 3)), v2r(PntsIdx(2, 2));
                    v2r(PntsIdx(1, 1)), v2r(PntsIdx(2, 2)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 1,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 3,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 12, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 13, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 14, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 2), 15, x_idx_max, y_idx_max, z_idx_max ) ] );
    end
    if  corner_flag(1, 2) 
        % face 2
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(3, 7)), v2r(PntsIdx(3, 1));
                    v2r(PntsIdx(3, 7)), v2r(PntsIdx(1, 7));
                    v2r(PntsIdx(3, 7)), v2r(PntsIdx(2, 4));
                    v2r(PntsIdx(3, 1)), v2r(PntsIdx(2, 4)); 
                    v2r(PntsIdx(1, 1)), v2r(PntsIdx(2, 4));
                    v2r(PntsIdx(1, 7)), v2r(PntsIdx(2, 4)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 2,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 3,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 8,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 9,  x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 10, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(2, 4), 11, x_idx_max, y_idx_max, z_idx_max ) ] );
    end
    if corner_flag(1, 3) 
        % face 3
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 7));
                    v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 3));
                    v2r(PntsIdx(1, 9)), v2r(PntsIdx(1, 5));
                    v2r(PntsIdx(1, 7)), v2r(PntsIdx(1, 5)); 
                    v2r(PntsIdx(1, 1)), v2r(PntsIdx(1, 5));
                    v2r(PntsIdx(1, 3)), v2r(PntsIdx(1, 5)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 1, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 2, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 4, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 5, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 6, x_idx_max, y_idx_max, z_idx_max );
                    vIdxprm2eIdx_Reg( PntsIdx_prm(1, 5), 7, x_idx_max, y_idx_max, z_idx_max ) ] );
    end
    if corner_flag(1, 3) && corner_flag(1, 6)
        % line 1
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(1, 3)), v2r(PntsIdx(1, 1)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(1, 2), 1, x_idx_max, y_idx_max, z_idx_max ) ] ); 
    end
    if  corner_flag(1, 2) && corner_flag(1, 6)
        % line 2
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(3, 1)), v2r(PntsIdx(1, 1)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(2, 1), 3, x_idx_max, y_idx_max, z_idx_max ) ] ); 
    end
    if corner_flag(1, 2) && corner_flag(1, 3) 
        % line 3
        dirPair = vertcat(dirPair, ...
                  [ v2r(PntsIdx(1, 7)), v2r(PntsIdx(1, 1)) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdxprm2eIdx_Reg( PntsIdx_prm(1, 4), 2, x_idx_max, y_idx_max, z_idx_max ) ] ); 
    end

    starts    = horzcat( starts, dirPair(:, 1)');
    ends      = horzcat( ends,   dirPair(:, 2)');
    vals      = horzcat( vals, Pntvals');
end
