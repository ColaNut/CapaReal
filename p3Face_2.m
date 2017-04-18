function Extract9 = p3Face_2( Ori27, Text )

switch Text
    case 'Crdnt'
        Extract9 = zeros(1, 9, 3);
        Extract9(1, 1, :) = Ori27(1, 3, :);
        Extract9(1, 2, :) = Ori27(1, 2, :);
        Extract9(1, 3, :) = Ori27(1, 1, :);
        Extract9(1, 4, :) = Ori27(1, 6, :);
        Extract9(1, 5, :) = Ori27(1, 5, :);
        Extract9(1, 6, :) = Ori27(1, 4, :);
        Extract9(1, 7, :) = Ori27(1, 9, :);
        Extract9(1, 8, :) = Ori27(1, 8, :);
        Extract9(1, 9, :) = Ori27(1, 7, :);
    case 'Med'
        Extract9 = zeros(9, 1);
        Extract9(1) = Ori27(1, 3);
        Extract9(2) = Ori27(1, 2);
        Extract9(3) = Ori27(1, 1);
        Extract9(4) = Ori27(1, 6);
        Extract9(5) = Ori27(1, 5);
        Extract9(6) = Ori27(1, 4);
        Extract9(7) = Ori27(1, 9);
        Extract9(8) = Ori27(1, 8);
        Extract9(9) = Ori27(1, 7);
    otherwise
        error('check');
end

    % tmpMidCrdnt(1, 1, :) = MidPntsCrdnt(1, 3, :);
    % tmpMidCrdnt(1, 2, :) = MidPntsCrdnt(1, 2, :);
    % tmpMidCrdnt(1, 3, :) = MidPntsCrdnt(1, 1, :);
    % tmpMidCrdnt(1, 4, :) = MidPntsCrdnt(1, 6, :);
    % tmpMidCrdnt(1, 5, :) = MidPntsCrdnt(1, 5, :);
    % tmpMidCrdnt(1, 6, :) = MidPntsCrdnt(1, 4, :);
    % tmpMidCrdnt(1, 7, :) = MidPntsCrdnt(1, 9, :);
    % tmpMidCrdnt(1, 8, :) = MidPntsCrdnt(1, 8, :);
    % tmpMidCrdnt(1, 9, :) = MidPntsCrdnt(1, 7, :);

end