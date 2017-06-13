function m_three = Msparse2msparse( M_three, varargin )

    % un-supportive of transforming only a few rows
    colFlag = false;
    nVarargs = length(varargin);
    if nVarargs == 1
        colTex = varargin{1};
        if strcmp(colTex, 'Col')
            colFlag = true;
        else
            error('check');
        end
    end

    [row_idx, col_idx, value] = find( M_three );

    if ~colFlag % convert to sparse row version 
        n = size(M_three, 1);
        m_three = cell(n, 1);
        [row_idx, idxSet] = sort(row_idx);
        col_idx = col_idx(idxSet);
        value = value(idxSet);

        First     = 1;
        nextFirst = 1;

        for idx = 1: 1: n - 1
            First = nextFirst;
            nextFirst = (First - 1) + my_find(row_idx(First: end), idx + 1);
            if isempty(First)
                error('check');
            end
            if isempty(nextFirst)
                nextFirst = length(row_idx) + 1
            end
            IdxLength = nextFirst - First;
            candidateRow = zeros(1, 2 * IdxLength);
            candidateRow(1: IdxLength)       = col_idx(First: nextFirst - 1);
            candidateRow(IdxLength + 1: end) = value(First: nextFirst - 1);
            % row_idx(First: nextFirst - 1) = [];
            % col_idx(First: nextFirst - 1) = [];
            % value(First: nextFirst - 1)   = [];
            m_three{ idx } = candidateRow;
            if nextFirst == length(row_idx) + 1
                break;
            end
        end

        if ( nextFirst ~= length(row_idx) + 1 )
            IdxLength = length(row_idx(nextFirst: end));
            candidateRow = zeros(1, 2 * IdxLength);
            candidateRow(1: IdxLength)       = col_idx(nextFirst: end);
            candidateRow(IdxLength + 1: end) = value(nextFirst: end);
            m_three{ n } = candidateRow;
        end
    else
        n = size(M_three, 2);
        m_three = cell(1, n);
        [col_idx, idxSet] = sort(col_idx);
        row_idx = row_idx(idxSet);
        value = value(idxSet);

        First     = 1;
        nextFirst = 1;

        for idx = 1: 1: n - 1
            First = nextFirst;
            nextFirst = (First - 1) + my_find(col_idx(First: end), idx + 1);
            if isempty(First)
                error('check');
            end
            if isempty(nextFirst)
                nextFirst = length(col_idx) + 1
            end
            IdxLength = nextFirst - First;
            candidateCol = zeros(2 * IdxLength, 1);
            candidateCol(1: IdxLength)       = row_idx(First: nextFirst - 1);
            candidateCol(IdxLength + 1: end) = value(First: nextFirst - 1);
            % col_idx(First: nextFirst - 1) = [];
            % row_idx(First: nextFirst - 1) = [];
            % value(First: nextFirst - 1)   = [];
            m_three{ idx } = candidateCol;
            if nextFirst == length(col_idx) + 1
                break;
            end
        end

        if ( nextFirst ~= length(col_idx) + 1 )
            IdxLength = length(col_idx(nextFirst: end));
            candidateCol = zeros(2 * IdxLength, 1);
            candidateCol(1: IdxLength)       = row_idx(nextFirst: end);
            candidateCol(IdxLength + 1: end) = value(nextFirst: end);
            m_three{ n } = candidateCol;
        end
    end
end