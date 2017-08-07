function PntH_or_E = calH_2( vIdx1, vIdx2, vIdx3, vIdx4, G1, G234, A, Vertex_Crdnt, mu_r, medVal, x_max_vertex, y_max_vertex, z_max_vertex, varargin )

    % most of the code are duplicated from fillK
    PntH_or_E = zeros(3, 1);

    % determine P1, P2, P3 and P4 
    v1Table = G1;
    v2Table = G234(:, 1);
    v3Table = G234(:, 2);
    v4Table = G234(:, 3);

    vIdxSet = [vIdx1, vIdx2, vIdx3, vIdx4];
    % the following find should appreas once in each entry
    FindMat = [ 0,                          my_F(find(v1Table), vIdx2), my_F(find(v1Table), vIdx3), my_F(find(v1Table), vIdx4);
                my_F(find(v2Table), vIdx1), 0,                          my_F(find(v2Table), vIdx3), my_F(find(v2Table), vIdx4);
                my_F(find(v3Table), vIdx1), my_F(find(v3Table), vIdx2), 0,                          my_F(find(v3Table), vIdx4);
                my_F(find(v4Table), vIdx1), my_F(find(v4Table), vIdx2), my_F(find(v4Table), vIdx3), 0                          ];

    Counter = [ length(find(FindMat(1, :))), length(find(FindMat(2, :))), length(find(FindMat(3, :))), length(find(FindMat(4, :))) ]';

    % A self-checker
    if ~find(Counter == 0) || ~find(Counter == 1) || ~find(Counter == 2) || ~find(Counter == 3) 
        error('check the original feed in');
    end
    
    vIdxSet_permute = [ find(Counter == 3), find(Counter == 2), find(Counter == 1), find(Counter == 0) ];
    mainEdgeFinder = vIdxSet_permute <= 2;

    P1 = vIdxSet( vIdxSet_permute(1) );
    P2 = vIdxSet( vIdxSet_permute(2) );
    P3 = vIdxSet( vIdxSet_permute(3) );
    P4 = vIdxSet( vIdxSet_permute(4) );

    G4Col = horzcat(v1Table, v2Table, v3Table, v4Table);
    P1_table = G4Col( :, vIdxSet_permute(1) );
    P2_table = G4Col( :, vIdxSet_permute(2) );
    P3_table = G4Col( :, vIdxSet_permute(3) );
    P4_table = G4Col( :, vIdxSet_permute(4) );

    % get the corresponding P1_Crdt, P2_Crdt, P3_Crdt and P4_Crdt
    [ m_v(1), n_v(1), ell_v(1) ] = getMNL(P1, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(2), n_v(2), ell_v(2) ] = getMNL(P2, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(3), n_v(3), ell_v(3) ] = getMNL(P3, x_max_vertex, y_max_vertex, z_max_vertex);
    [ m_v(4), n_v(4), ell_v(4) ] = getMNL(P4, x_max_vertex, y_max_vertex, z_max_vertex);
    
    P1_Crdt = squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) );
    P2_Crdt = squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) );
    P3_Crdt = squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) );
    P4_Crdt = squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) );

    % determin the InnExtText
    if dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) > 0
        InnExtText = 'inn';
    elseif dot( cross( P3_Crdt - P2_Crdt, P4_Crdt - P2_Crdt ), P1_Crdt - (P2_Crdt + P3_Crdt + P4_Crdt) / 3 ) < 0
        InnExtText = 'ext';
    else
        error('Check the P1, P2, P3 and P4 Crdnt');
    end

    six_eIdx = zeros(1, 6);
    six_eIdx(1) = P1_table(P2);
    six_eIdx(2) = P1_table(P3);
    six_eIdx(3) = P1_table(P4);
    six_eIdx(4) = P2_table(P3);
    six_eIdx(5) = P2_table(P4);
    six_eIdx(6) = P3_table(P4);

    % sixEdge_A_Value = zeros(6, 1);
    tmp_curl_W = zeros(6, 3);

    TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

switch InnExtText
    case 'inn'
        tmp_curl_W(1, :) = - (P4_Crdt - P3_Crdt);
        tmp_curl_W(2, :) =   (P4_Crdt - P2_Crdt);
        tmp_curl_W(3, :) = - (P3_Crdt - P2_Crdt);
        tmp_curl_W(4, :) = - (P4_Crdt - P1_Crdt);
        tmp_curl_W(5, :) =   (P3_Crdt - P1_Crdt);
        tmp_curl_W(6, :) = - (P2_Crdt - P1_Crdt);
    case 'ext'
        tmp_curl_W(1, :) =   (P4_Crdt - P3_Crdt);
        tmp_curl_W(2, :) = - (P4_Crdt - P2_Crdt);
        tmp_curl_W(3, :) =   (P3_Crdt - P2_Crdt);
        tmp_curl_W(4, :) =   (P4_Crdt - P1_Crdt);
        tmp_curl_W(5, :) = - (P3_Crdt - P1_Crdt);
        tmp_curl_W(6, :) =   (P2_Crdt - P1_Crdt);
    otherwise
        error('check');
end

    % if nVarargs == 1
        % Coeff = tmp_curl_W / ( 3 * TtrVol * mu );
        % varargout{1} = Coeff;
    % else
        % PntH_or_E = ( tmp_curl_W' * A(six_eIdx) ) / ( 3 * TtrVol * mu_r(medVal) );
    % end

    nVarargs = length(varargin);
    if nVarargs == 1
        TexFlag = varargin{1};
        if strcmp(TexFlag, 'H')
            % original H_XZ
            PntH_or_E = ( tmp_curl_W' * A(six_eIdx) ) / ( 3 * TtrVol * mu_r(medVal) );
        else
            error('check the input');
        end
    else
        % E field from A
        switch InnExtText
            case 'inn'
                nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
                nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
                nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
                nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );
            case 'ext'
                nabla(1, :) = calTriVec( P2_Crdt, P4_Crdt, P3_Crdt );
                nabla(2, :) = calTriVec( P4_Crdt, P1_Crdt, P3_Crdt );
                nabla(3, :) = calTriVec( P4_Crdt, P2_Crdt, P1_Crdt );
                nabla(4, :) = calTriVec( P3_Crdt, P1_Crdt, P2_Crdt );
            otherwise
                error('check');
        end

        GradDiff = zeros(6, 3);
        GradDiff(1, :) = nabla(2, :) - nabla(1, :);
        GradDiff(2, :) = nabla(3, :) - nabla(1, :);
        GradDiff(3, :) = nabla(4, :) - nabla(1, :);
        GradDiff(4, :) = nabla(3, :) - nabla(2, :);
        GradDiff(5, :) = nabla(4, :) - nabla(2, :);
        GradDiff(6, :) = nabla(4, :) - nabla(3, :);

        % PntH_or_E = zeros(3, 1);
        % Mu_0          = 4 * pi * 10^(-7);
        % the 1 / 2 is contributed by lambda in the middle point.
        PntH_or_E = ( GradDiff' * A(six_eIdx) ) / ( 3 * TtrVol * 2 );
    end

end