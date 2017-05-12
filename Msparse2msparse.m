function m_three = Msparse2msparse( M_three, varargin )

    n = size(M_three, 1);
    nVarargs = length(varargin);
    if nVarargs == 1
        n = varargin{1};
    end
    m_three = cell(n, 1);

    [row_idx, col_idx, value] = find( M_three );

    [row_idx, idxSet] = sort(row_idx);
    col_idx = col_idx(idxSet);
    value = value(idxSet);

    First     = 1;
    nextFirst = 1;

    for idx = 1: 1: n - 1
        First = nextFirst;
        nextFirst = (First - 1) + find(row_idx(First: end) == idx + 1, 1);
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

    if nVarargs ~= 1 && ( nextFirst ~= length(row_idx) + 1 )
        IdxLength = length(row_idx(nextFirst: end));
        candidateRow = zeros(1, 2 * IdxLength);
        candidateRow(1: IdxLength)       = col_idx(nextFirst: end);
        candidateRow(IdxLength + 1: end) = value(nextFirst: end);
        m_three{ n } = candidateRow;
    end
end