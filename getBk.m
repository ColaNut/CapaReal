function Bk_val = getBk( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt, mainEdge, InnExtText, PntJ_xyz )
    % PntJ_xyz = zeros(mki91, 3);
    Bk_val = 0;
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

    GradDiff = zeros(1, 3);
    switch mainEdge
        case 1
            GradDiff = nabla(2, :) - nabla(1, :);
        case 2
            GradDiff = nabla(3, :) - nabla(1, :);
        case 3
            GradDiff = nabla(4, :) - nabla(1, :);
        case 4
            GradDiff = nabla(3, :) - nabla(2, :);
        case 5
            GradDiff = nabla(4, :) - nabla(2, :);
        case 6
            GradDiff = nabla(4, :) - nabla(3, :);
        otherwise
            error('check');
    end

    % TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );

    % if TtrVol ~= 0
        Bk_val = dot( GradDiff, PntJ_xyz ) / 12;
    % else
    %     BkTet = 0;
    % end

end
