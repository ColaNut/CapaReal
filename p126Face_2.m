function Extract7 = p126Face_2( Ori27, Text )

switch Text
    case 'Crdnt'
        Extract7 = zeros(1, 7, 3);
        Extract7(1, 1, :) = Ori27(1, 2, :);
        Extract7(1, 2, :) = Ori27(1, 1, :);
        Extract7(1, 3, :) = Ori27(2, 1, :);
        Extract7(1, 4, :) = Ori27(2, 2, :);
        Extract7(1, 5, :) = Ori27(1, 4, :);
        Extract7(1, 6, :) = Ori27(2, 4, :);
        Extract7(1, 7, :) = Ori27(2, 5, :);
    case 'Med'
        Extract7 = zeros(7, 1);
        Extract7(1) = Ori27(1, 2);
        Extract7(2) = Ori27(1, 1);
        Extract7(3) = Ori27(2, 1);
        Extract7(4) = Ori27(2, 2);
        Extract7(5) = Ori27(1, 4);
        Extract7(6) = Ori27(2, 4);
        Extract7(7) = Ori27(2, 5);
    otherwise
        error('check');
end
    % tmpMidCrdnt = zeros(7, 3);
    % tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 2, :) )';
    % tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(1, 1, :) )';
    % tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(2, 1, :) )';
    % tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(2, 2, :) )';
    % tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(1, 4, :) )';
    % tmpMidCrdnt(6, :) = squeeze( MidPntsCrdnt(2, 4, :) )';
    % tmpMidCrdnt(7, :) = squeeze( MidPntsCrdnt(2, 5, :) )';
end
