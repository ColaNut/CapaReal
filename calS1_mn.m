function face10Value = calS1_mn( SideCrdnt, CntrlCrdnt, FaceSegMed, epsilon_r, typeTxt )

% the center point is a column vector; while the side point are row vector.

    face10Value = zeros(1, 10);
    Tet32Value = zeros(8, 4);

    % the 1-st to the 8-th tetdrahedron
    Tet32Value(1, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), epsilon_r( FaceSegMed(1) ), typeTxt );
    Tet32Value(2, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(8, :), SideCrdnt(9, :), epsilon_r( FaceSegMed(2) ), typeTxt );
    Tet32Value(3, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(8, :), epsilon_r( FaceSegMed(3) ), typeTxt );
    Tet32Value(4, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(7, :), epsilon_r( FaceSegMed(4) ), typeTxt );
    Tet32Value(5, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(1, :), SideCrdnt(4, :), epsilon_r( FaceSegMed(5) ), typeTxt );
    Tet32Value(6, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), epsilon_r( FaceSegMed(6) ), typeTxt );
    Tet32Value(7, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), epsilon_r( FaceSegMed(7) ), typeTxt );
    Tet32Value(8, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), epsilon_r( FaceSegMed(8) ), typeTxt );

    face10Value(1) = Tet32Value(5, 3) + Tet32Value(6, 4);
    face10Value(2) = Tet32Value(6, 3) + Tet32Value(7, 4);
    face10Value(3) = Tet32Value(7, 3) + Tet32Value(8, 4);
    face10Value(4) = Tet32Value(4, 3) + Tet32Value(5, 4);
    face10Value(5) = sum(Tet32Value(:, 2));
    face10Value(6) = Tet32Value(8, 3) + Tet32Value(1, 4);
    face10Value(7) = Tet32Value(3, 3) + Tet32Value(4, 4);
    face10Value(8) = Tet32Value(2, 3) + Tet32Value(3, 4);
    face10Value(9) = Tet32Value(1, 3) + Tet32Value(2, 4);
    face10Value(10) = sum(Tet32Value(:, 1));

end
