function Extract9 = p2Face_2( Ori27, Text )

switch Text
    case 'Crdnt'
        Extract9 = zeros(1, 9, 3);
        Extract9(1, 1, :) = Ori27(1, 7, :);
        Extract9(1, 2, :) = Ori27(1, 4, :);
        Extract9(1, 3, :) = Ori27(1, 1, :);
        Extract9(1, 4, :) = Ori27(2, 7, :);
        Extract9(1, 5, :) = Ori27(2, 4, :);
        Extract9(1, 6, :) = Ori27(2, 1, :);
        Extract9(1, 7, :) = Ori27(3, 7, :);
        Extract9(1, 8, :) = Ori27(3, 4, :);
        Extract9(1, 9, :) = Ori27(3, 1, :);
    case 'Med'
        Extract9 = zeros(9, 1);
        Extract9(1) = Ori27(1, 7);
        Extract9(2) = Ori27(1, 4);
        Extract9(3) = Ori27(1, 1);
        Extract9(4) = Ori27(2, 7);
        Extract9(5) = Ori27(2, 4);
        Extract9(6) = Ori27(2, 1);
        Extract9(7) = Ori27(3, 7);
        Extract9(8) = Ori27(3, 4);
        Extract9(9) = Ori27(3, 1);
    otherwise
        error('check');
end

end