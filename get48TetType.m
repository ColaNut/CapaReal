function PntTetType = get48TetType
    PntTetType = cell(48, 1);

    % up
    PntTetType{1}  = 'ext';
    PntTetType{2}  = 'inn';
    PntTetType{3}  = 'inn';
    PntTetType{4}  = 'inn';
    PntTetType{5}  = 'inn';
    PntTetType{6}  = 'ext';
    PntTetType{7}  = 'ext';
    PntTetType{8}  = 'ext';

    % left
    PntTetType{9}  = 'inn';
    PntTetType{10} = 'ext';
    PntTetType{11} = 'inn';
    PntTetType{12} = 'ext';
    PntTetType{13} = 'ext';
    PntTetType{14} = 'inn';
    PntTetType{15} = 'ext';
    PntTetType{16} = 'inn';

    % down
    PntTetType{17} = 'inn';
    PntTetType{18} = 'inn';
    PntTetType{19} = 'inn';
    PntTetType{20} = 'ext';
    PntTetType{21} = 'ext';
    PntTetType{22} = 'ext';
    PntTetType{23} = 'ext';
    PntTetType{24} = 'inn';

    % right
    PntTetType{25} = 'ext';
    PntTetType{26} = 'inn';
    PntTetType{27} = 'ext';
    PntTetType{28} = 'inn';
    PntTetType{29} = 'inn';
    PntTetType{30} = 'ext';
    PntTetType{31} = 'inn';
    PntTetType{32} = 'ext';

    % far
    PntTetType{33} = 'ext';
    PntTetType{34} = 'ext';
    PntTetType{35} = 'ext';
    PntTetType{36} = 'inn';
    PntTetType{37} = 'inn';
    PntTetType{38} = 'ext';
    PntTetType{39} = 'ext';
    PntTetType{40} = 'ext';

    % near
    PntTetType{41} = 'inn';
    PntTetType{42} = 'inn';
    PntTetType{43} = 'inn';
    PntTetType{44} = 'ext';
    PntTetType{45} = 'ext';
    PntTetType{46} = 'inn';
    PntTetType{47} = 'inn';
    PntTetType{48} = 'inn';
end