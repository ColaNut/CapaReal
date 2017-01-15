function SegMed = specialSegMed(m, n, ell)

    SegMed = ones( 6, 8, 'uint8' );
    % if m >= 17 && m <= 19 && ell == 12
    %     SegMed(1, :) = 4;
    %     SegMed(2, :) = 3;
    %     SegMed(3, :) = 3;
    %     SegMed(4, 1:4) = 4; SegMed(4, 5: 8) = 3;
    %     SegMed(5, 1) = 3; SegMed(5, 2:4) = 4; SegMed(5, 5:8) = 3;
    %     SegMed(6, 1:3) = 4; SegMed(6, 4:8) = 3;
    % elseif m >= 17 && m <= 19 && (ell == 12 || ell == 30)

    SegMed(1, :) = 3;
    SegMed(2, :) = 3;
    SegMed(3, :) = 4;
    SegMed(4, 1:4) = 3; SegMed(4, 5: 8) = 4;

    if n >= 17 && n <= 19 && (ell == 12 || ell == 30)
        SegMed(5, 1:4) = 3; SegMed(5, 5:7) = 4; SegMed(5, 8) = 3;
        SegMed(6, 1:5) = 3; SegMed(6, 6:8) = 4;
        if ell == 12
            SegMed = RecoverSegMed( SegMed, 3 );
        end
    elseif n == 16 && (ell == 12 || ell == 30)
        SegMed(5, 1:4) = 3; SegMed(5, 5:7) = 4; SegMed(5, 8) = 3;
        SegMed(6, :) = 3;
        if ell == 12
            SegMed = RecoverSegMed( SegMed, 3 );
        end
    elseif n == 20 && (ell == 12 || ell == 30)
        SegMed(5, :) = 3;
        SegMed(6, 1:5) = 3; SegMed(6, 6:8) = 4;
        if ell == 12
            SegMed = RecoverSegMed( SegMed, 3 );
        end
    else
        error('check');
    end

end