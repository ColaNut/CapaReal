function Extract9 = p1Face_Type4( Ori27, Text )

switch Text
    case 'Crdnt'
        Extract9 = zeros(1, 9, 3);
        Extract9(1, 1, :) = Ori27(2, 1, :);
        Extract9(1, 2, :) = Ori27(2, 2, :);
        Extract9(1, 3, :) = Ori27(2, 3, :);
        Extract9(1, 4, :) = Ori27(2, 4, :);
        Extract9(1, 5, :) = Ori27(2, 5, :);
        Extract9(1, 6, :) = Ori27(2, 6, :);
        Extract9(1, 7, :) = Ori27(2, 7, :);
        Extract9(1, 8, :) = Ori27(2, 8, :);
        Extract9(1, 9, :) = Ori27(2, 9, :);
    case 'Med'
        Extract9 = zeros(9, 1);
        Extract9(1) = Ori27(2, 1);
        Extract9(2) = Ori27(2, 2);
        Extract9(3) = Ori27(2, 3);
        Extract9(4) = Ori27(2, 4);
        Extract9(5) = Ori27(2, 5);
        Extract9(6) = Ori27(2, 6);
        Extract9(7) = Ori27(2, 7);
        Extract9(8) = Ori27(2, 8);
        Extract9(9) = Ori27(2, 9);
    otherwise
        error('check');
end

    % tmpMidLyr = zeros(9, 3);
    % tmpMidLyr(1, :) = squeeze( PntsCrdnt(2, 1, :));
    % tmpMidLyr(2, :) = squeeze( PntsCrdnt(2, 2, :));
    % tmpMidLyr(3, :) = squeeze( PntsCrdnt(2, 3, :));
    % tmpMidLyr(4, :) = squeeze( PntsCrdnt(2, 4, :));
    % tmpMidLyr(5, :) = squeeze( PntsCrdnt(2, 5, :));
    % tmpMidLyr(6, :) = squeeze( PntsCrdnt(2, 6, :));
    % tmpMidLyr(7, :) = squeeze( PntsCrdnt(2, 7, :));
    % tmpMidLyr(8, :) = squeeze( PntsCrdnt(2, 8, :));
    % tmpMidLyr(9, :) = squeeze( PntsCrdnt(2, 9, :));

end
