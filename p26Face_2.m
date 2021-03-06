function Extract5 = p26Face_2( Ori27, Text )

switch Text
    case 'Crdnt'
        Extract5 = zeros(1, 5, 3);
        Extract5(1, 1, :) = Ori27(1, 1, :);
        Extract5(1, 2, :) = Ori27(2, 4, :);
        Extract5(1, 3, :) = Ori27(2, 1, :);
        Extract5(1, 4, :) = Ori27(2, 2, :);
        Extract5(1, 5, :) = Ori27(3, 1, :);
    case 'Med'
        Extract5 = zeros(5, 1);
        Extract5(1) = Ori27(1, 1);
        Extract5(2) = Ori27(2, 4);
        Extract5(3) = Ori27(2, 1);
        Extract5(4) = Ori27(2, 2);
        Extract5(5) = Ori27(3, 1);
    otherwise
        error('check');
end

    % tmpMidCrdnt = zeros(5, 3);
    % tmpMidCrdnt(1, :) = squeeze( MidPntsCrdnt(1, 1, :) )';
    % tmpMidCrdnt(2, :) = squeeze( MidPntsCrdnt(2, 4, :) )';
    % tmpMidCrdnt(3, :) = squeeze( MidPntsCrdnt(2, 1, :) )';
    % tmpMidCrdnt(4, :) = squeeze( MidPntsCrdnt(2, 2, :) )';
    % tmpMidCrdnt(5, :) = squeeze( MidPntsCrdnt(3, 1, :) )';

end