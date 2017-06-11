function [ starts, ends, vals ] = fillGraph( m_v, n_v, ell_v, starts, ends, vals, x_max_vertex, y_max_vertex, z_max_vertex, corner_flag )

    % corner_flag = false(2, 6);
    PntsIdx = zeros( 3, 9 );
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    PntsIdx_prm = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    dirPair = [];
    Pntvals = [];

    dirPair = [ PntsIdx(3, 9), PntsIdx(3, 6); % pencil - y
                PntsIdx(3, 6), PntsIdx(3, 3); 
                PntsIdx(3, 8), PntsIdx(3, 5); 
                PntsIdx(3, 5), PntsIdx(3, 2); 
                % PntsIdx(3, 7), PntsIdx(3, 4); 
                % PntsIdx(3, 4), PntsIdx(3, 1); 
                PntsIdx(2, 9), PntsIdx(2, 6); 
                PntsIdx(2, 6), PntsIdx(2, 3); 
                PntsIdx(2, 8), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(2, 2) ]; 
                % PntsIdx(2, 7), PntsIdx(2, 4); 
                % PntsIdx(2, 4), PntsIdx(2, 1); 
                % PntsIdx(1, 9), PntsIdx(1, 6); 
                % PntsIdx(1, 6), PntsIdx(1, 3); 
                % PntsIdx(1, 8), PntsIdx(1, 5); 
                % PntsIdx(1, 5), PntsIdx(1, 2); 
                % PntsIdx(1, 7), PntsIdx(1, 4);   
                % PntsIdx(1, 4), PntsIdx(1, 1) ]; 
    Pntvals    = [ vIdx2eIdx(PntsIdx_prm(3, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex) ];
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(2, 9); % red - z
                PntsIdx(2, 9), PntsIdx(1, 9); 
                PntsIdx(3, 8), PntsIdx(2, 8); 
                PntsIdx(2, 8), PntsIdx(1, 8); 
                % PntsIdx(3, 7), PntsIdx(2, 7); 
                % PntsIdx(2, 7), PntsIdx(1, 7); 
                PntsIdx(3, 6), PntsIdx(2, 6); 
                PntsIdx(2, 6), PntsIdx(1, 6); 
                PntsIdx(3, 5), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(1, 5) ] ); 
                % PntsIdx(3, 4), PntsIdx(2, 4); 
                % PntsIdx(2, 4), PntsIdx(1, 4); 
                % PntsIdx(3, 3), PntsIdx(2, 3); 
                % PntsIdx(2, 3), PntsIdx(1, 3); 
                % PntsIdx(3, 2), PntsIdx(2, 2); 
                % PntsIdx(2, 2), PntsIdx(1, 2); 
                % PntsIdx(3, 1), PntsIdx(2, 1); 
                % PntsIdx(2, 1), PntsIdx(1, 1) ] );
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 3, x_max_vertex, y_max_vertex, z_max_vertex) ] );
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(3, 8); % blue - x
                PntsIdx(3, 8), PntsIdx(3, 7); 
                PntsIdx(3, 6), PntsIdx(3, 5); 
                PntsIdx(3, 5), PntsIdx(3, 4); 
                % PntsIdx(3, 3), PntsIdx(3, 2); 
                % PntsIdx(3, 2), PntsIdx(3, 1); 
                PntsIdx(2, 9), PntsIdx(2, 8); 
                PntsIdx(2, 8), PntsIdx(2, 7); 
                PntsIdx(2, 6), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(2, 4) ] );
                % PntsIdx(2, 3), PntsIdx(2, 2); 
                % PntsIdx(2, 2), PntsIdx(2, 1); 
                % PntsIdx(1, 9), PntsIdx(1, 8); 
                % PntsIdx(1, 8), PntsIdx(1, 7); 
                % PntsIdx(1, 6), PntsIdx(1, 5); 
                % PntsIdx(1, 5), PntsIdx(1, 4);
                % PntsIdx(1, 3), PntsIdx(1, 2);     
                % PntsIdx(1, 2), PntsIdx(1, 1) ] ); 
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex) ] );
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(2, 8); % pencil - Face-56-direction
                PntsIdx(2, 8), PntsIdx(1, 7); 
                PntsIdx(1, 9), PntsIdx(2, 8); 
                PntsIdx(2, 8), PntsIdx(3, 7); 
                PntsIdx(3, 6), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(1, 4); 
                PntsIdx(1, 6), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(3, 4) ] );
                % PntsIdx(3, 3), PntsIdx(2, 2); 
                % PntsIdx(2, 2), PntsIdx(1, 1); 
                % PntsIdx(1, 3), PntsIdx(2, 2); 
                % PntsIdx(2, 2), PntsIdx(3, 1) ] );
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 6, x_max_vertex, y_max_vertex, z_max_vertex) ] );
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(2, 6); % blue - Face-24-direction
                PntsIdx(2, 6), PntsIdx(1, 3); 
                PntsIdx(1, 9), PntsIdx(2, 6); 
                PntsIdx(2, 6), PntsIdx(3, 3); 
                PntsIdx(3, 8), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(1, 2); 
                PntsIdx(1, 8), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(3, 2) ] ); 
                % PntsIdx(3, 7), PntsIdx(2, 4); 
                % PntsIdx(2, 4), PntsIdx(1, 1); 
                % PntsIdx(1, 7), PntsIdx(2, 4); 
                % PntsIdx(2, 4), PntsIdx(3, 1) ] );
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 5, x_max_vertex, y_max_vertex, z_max_vertex) ] );
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(3, 5); % red - Face-16-direction
                PntsIdx(3, 5), PntsIdx(3, 1); 
                PntsIdx(3, 3), PntsIdx(3, 5); 
                PntsIdx(3, 5), PntsIdx(3, 7); 
                PntsIdx(2, 9), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(2, 1); 
                PntsIdx(2, 3), PntsIdx(2, 5); 
                PntsIdx(2, 5), PntsIdx(2, 7) ] ); 
                % PntsIdx(1, 9), PntsIdx(1, 5); 
                % PntsIdx(1, 5), PntsIdx(1, 1); 
                % PntsIdx(1, 3), PntsIdx(1, 5); 
                % PntsIdx(1, 5), PntsIdx(1, 7) ] );
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex) ] );
    dirPair = vertcat(dirPair, ...
              [ PntsIdx(3, 9), PntsIdx(2, 5); % oblique - type 1
                PntsIdx(2, 5), PntsIdx(1, 1); 
                PntsIdx(1, 3), PntsIdx(2, 5); % oblique - type 2
                PntsIdx(2, 5), PntsIdx(3, 7); 
                PntsIdx(3, 3), PntsIdx(2, 5); % oblique - type 3
                PntsIdx(2, 5), PntsIdx(1, 7); 
                PntsIdx(1, 9), PntsIdx(2, 5); % oblique - type 4
                PntsIdx(2, 5), PntsIdx(3, 1) ] );
    Pntvals = vertcat(Pntvals, ... 
              [ vIdx2eIdx(PntsIdx_prm(3, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 6), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 8), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(2, 9), 7, x_max_vertex, y_max_vertex, z_max_vertex);
                vIdx2eIdx(PntsIdx_prm(3, 5), 7, x_max_vertex, y_max_vertex, z_max_vertex) ] );

    if corner_flag(1, 6)
        % face 1
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 3), PntsIdx(3, 2); % blue - x
                    PntsIdx(3, 2), PntsIdx(3, 1);
                    PntsIdx(2, 3), PntsIdx(2, 2); 
                    PntsIdx(2, 2), PntsIdx(2, 1) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(3, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex) ] );
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 3), PntsIdx(2, 3); % red - z
                    PntsIdx(2, 3), PntsIdx(1, 3); 
                    PntsIdx(3, 2), PntsIdx(2, 2); 
                    PntsIdx(2, 2), PntsIdx(1, 2) ] );
        Pntvals = vertcat(Pntvals, ...
                  [ vIdx2eIdx(PntsIdx_prm(3, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 3), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 2), 3, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 3), PntsIdx(2, 2); % pencil - Face-56-direction
                    PntsIdx(2, 2), PntsIdx(1, 1); 
                    PntsIdx(1, 3), PntsIdx(2, 2); 
                    PntsIdx(2, 2), PntsIdx(3, 1) ] );
        Pntvals = vertcat(Pntvals, ...
                  [ vIdx2eIdx(PntsIdx_prm(3, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 3), 6, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 2), 6, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end
    if  corner_flag(1, 2) 
        % face 2
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 7), PntsIdx(2, 7); % red - z
                    PntsIdx(2, 7), PntsIdx(1, 7); 
                    PntsIdx(3, 4), PntsIdx(2, 4); 
                    PntsIdx(2, 4), PntsIdx(1, 4) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(3, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 7), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 4), 3, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 7), PntsIdx(3, 4); % pencil - y
                    PntsIdx(3, 4), PntsIdx(3, 1); 
                    PntsIdx(2, 7), PntsIdx(2, 4); 
                    PntsIdx(2, 4), PntsIdx(2, 1) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(3, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 7), PntsIdx(2, 4); % blue - Face-24-direction
                    PntsIdx(2, 4), PntsIdx(1, 1); 
                    PntsIdx(1, 7), PntsIdx(2, 4); 
                    PntsIdx(2, 4), PntsIdx(3, 1) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(3, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 7), 5, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(3, 4), 5, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end
    if corner_flag(1, 3) 
        % face 3
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(1, 9), PntsIdx(1, 6); % pencil - y
                    PntsIdx(1, 6), PntsIdx(1, 3); 
                    PntsIdx(1, 8), PntsIdx(1, 5); 
                    PntsIdx(1, 5), PntsIdx(1, 2) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(1, 9), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 6), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 8), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 5), 2, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(1, 9), PntsIdx(1, 8); % blue - x
                    PntsIdx(1, 8), PntsIdx(1, 7); 
                    PntsIdx(1, 6), PntsIdx(1, 5); 
                    PntsIdx(1, 5), PntsIdx(1, 4) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(1, 9), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 8), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 6), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 5), 1, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(1, 9), PntsIdx(1, 5); % red - Face-16-direction
                    PntsIdx(1, 5), PntsIdx(1, 1); 
                    PntsIdx(1, 3), PntsIdx(1, 5); 
                    PntsIdx(1, 5), PntsIdx(1, 7) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(1, 9), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 5), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 6), 4, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 8), 4, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end
    if corner_flag(1, 3) && corner_flag(1, 6)
        % line 1
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(1, 3), PntsIdx(1, 2); % blue - x
                    PntsIdx(1, 2), PntsIdx(1, 1) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(1, 3), 1, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 2), 1, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end
    if  corner_flag(1, 2) && corner_flag(1, 6)
        % line 2
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(3, 1), PntsIdx(2, 1); % red - z
                    PntsIdx(2, 1), PntsIdx(1, 1) ] );
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(3, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(2, 1), 3, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end
    if corner_flag(1, 2) && corner_flag(1, 3) 
        % line 3
        dirPair = vertcat(dirPair, ...
                  [ PntsIdx(1, 7), PntsIdx(1, 4);  % pencil - y
                    PntsIdx(1, 4), PntsIdx(1, 1) ] ); 
        Pntvals = vertcat(Pntvals, ... 
                  [ vIdx2eIdx(PntsIdx_prm(1, 7), 2, x_max_vertex, y_max_vertex, z_max_vertex);
                    vIdx2eIdx(PntsIdx_prm(1, 4), 2, x_max_vertex, y_max_vertex, z_max_vertex) ] ); 
    end

    starts    = horzcat( starts, dirPair(:, 1)');
    ends      = horzcat( ends,   dirPair(:, 2)');
    vals      = horzcat( vals, Pntvals');
end
