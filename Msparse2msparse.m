function m_three = Msparse2msparse( M_three )
    n = size(M_three, 1);
    m_three = cell(n, 1);

    [row_idx, col_idx, value] = find( M_three );

    [row_idx, idxSet] = sort(row_idx);
    col_idx = col_idx(idxSet);
    value = value(idxSet);

    First     = 1;
    nextFirst = 1;
    disp('Time for redistribution');
    for idx = 1: 1: n - 1
        if mod(idx, 100) == 0
            idx
        end
        First = nextFirst;
        nextFirst = (First - 1) + find(row_idx(First: end) == idx + 1, 1);
        % if isempty(First) || isempty(nextFirst)
        %     error('check');
        % end
        IdxLength = nextFirst - First;
        candidateRow = zeros(1, 2 * IdxLength);
        candidateRow(1: IdxLength)       = col_idx(First: nextFirst - 1);
        candidateRow(IdxLength + 1: end) = value(First: nextFirst - 1);

        % row_idx(First: nextFirst - 1) = [];
        % col_idx(First: nextFirst - 1) = [];
        % value(First: nextFirst - 1)   = [];
        m_three{ idx } = candidateRow;
    end

    IdxLength = length(row_idx(nextFirst: end));
    candidateRow = zeros(1, 2 * IdxLength);
    candidateRow(1: IdxLength)       = col_idx(nextFirst: end);
    candidateRow(IdxLength + 1: end) = value(nextFirst: end);
    m_three{ n } = candidateRow;
end