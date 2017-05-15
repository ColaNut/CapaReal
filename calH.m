function varargout = calH( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, InnExtText, sixEdge_A_Value, mu, varargin )

    nVarargs = length(varargin);
    if nVarargs == 1
        % A is unknown
        KnownType = varargin{1};
        if ~strcmp(KnownType, 'A_unknown')
            error('Check');
        end
        Coeff = zeros(6, 3);
    end

    OneSideH_XZ = zeros(3, 1);

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

    if nVarargs == 1
        Coeff = tmp_curl_W / ( 3 * TtrVol * mu );
        varargout{1} = Coeff;
    else
        OneSideH_XZ = ( tmp_curl_W' * sixEdge_A_Value ) / ( 3 * TtrVol * mu );
        varargout{1} = OneSideH_XZ;
    end

end