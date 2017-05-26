function [ AuxiIdx, EdgeTable ] = checkSheetIdx(EdgeTable, CandiSet, varargin)
    
    AuxiIdx = 0;
    nVarargs = length(varargin);
    specified = false;
    
    % halfLgth = length(CandiSet) / 2;
    % if length( find( CandiSet(halfLgth + 1: end) ) ) ~= 9
    %         error('check the Cansidset input');
    % end

    if nVarargs == 6
        lastFlag = varargin{6};
        if lastFlag
            specified = true;
        end
    end
    if nVarargs == 5 
        specified = true;
    end

    if specified
        vIdx_prm     = varargin{1};
        edgeNum      = varargin{2};
        x_max_vertex = varargin{3};
        y_max_vertex = varargin{4};
        z_max_vertex = varargin{5};
        AuxiIdx = vIdx2eIdx(vIdx_prm, edgeNum, x_max_vertex, y_max_vertex, z_max_vertex);
        if EdgeTable(AuxiIdx, 1)
            error('check the input eIdx');
        end
        % if isempty( find(CandiSet == AuxiIdx) )
        %     error('check the input eIdx');
        % end
        EdgeTable(AuxiIdx, 1) = true;
    % else
    %     if nVarargs ~= 0 && nVarargs ~= 6
    %         error('check');
    %     end
        
    %     IdxCandi = CandiSet( find( CandiSet(halfLgth + 1: end), 9, 'last' ) );
    %     % lucky sequence
    %     chosenPref = [9, 8, 7, 6, 4, 5, 3, 2, 1];
    %     for idx = 1: 1: 9
    %         if EdgeTable(IdxCandi(chosenPref(idx)), 1) == false && EdgeTable(IdxCandi(chosenPref(idx)), 2) == false
    %             AuxiIdx = IdxCandi(chosenPref(idx));
    %             EdgeTable(AuxiIdx, 1) = true;
    %             return;
    %         end
    %     end
    %     error('Check why not within 9 iterations');
    end
end