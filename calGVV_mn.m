function face10Value = calGVV_mn( SideCrdnt, CntrlCrdnt, FaceSegMed, epsilon_r, typeTxt, omega )

% the center point is a column vector; while the side point are row vector.

    face10Value = zeros(1, 10);
    Tet32Value = zeros(8, 4);
    Tet32ValueS2 = zeros(8, 4);
    TtrVol = zeros(8, 1);
    TtrVol = cal8TtrVol( SideCrdnt, CntrlCrdnt )';

    switch typeTxt
    case 'Nrml'
        modOnes = [2, 1, 1, 1];
    case { 'z_shift', 'x_shift', 'y_shift' }
        modOnes = [1, 2, 1, 1];
    otherwise
        error('check')
    end

    % S_1: the 1-st to the 8-th tetdrahedron
    Tet32Value = repmat(TtrVol, 1, 4) .* repmat(modOnes, 8, 1) / 20;
    % Tet32Value(1, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(9, :), SideCrdnt(6, :), epsilon_r( FaceSegMed(1) ), typeTxt );
    % Tet32Value(2, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(8, :), SideCrdnt(9, :), epsilon_r( FaceSegMed(2) ), typeTxt );
    % Tet32Value(3, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(7, :), SideCrdnt(8, :), epsilon_r( FaceSegMed(3) ), typeTxt );
    % Tet32Value(4, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(4, :), SideCrdnt(7, :), epsilon_r( FaceSegMed(4) ), typeTxt );
    % Tet32Value(5, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(1, :), SideCrdnt(4, :), epsilon_r( FaceSegMed(5) ), typeTxt );
    % Tet32Value(6, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(2, :), SideCrdnt(1, :), epsilon_r( FaceSegMed(6) ), typeTxt );
    % Tet32Value(7, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(3, :), SideCrdnt(2, :), epsilon_r( FaceSegMed(7) ), typeTxt );
    % Tet32Value(8, :) = get4VrtxValue( CntrlCrdnt', SideCrdnt(5, :), SideCrdnt(6, :), SideCrdnt(3, :), epsilon_r( FaceSegMed(8) ), typeTxt );

    % \int \lambda_m \lambda_n = V / 20;
    % \int \lambda^2_m         = V / 10;
    
    
    % Tet32ValueS2(1, :) = ( epsilon_r( FaceSegMed(1) )^2 * TtrVol(1) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(2, :) = ( epsilon_r( FaceSegMed(2) )^2 * TtrVol(2) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(3, :) = ( epsilon_r( FaceSegMed(3) )^2 * TtrVol(3) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(4, :) = ( epsilon_r( FaceSegMed(4) )^2 * TtrVol(4) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(5, :) = ( epsilon_r( FaceSegMed(5) )^2 * TtrVol(5) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(6, :) = ( epsilon_r( FaceSegMed(6) )^2 * TtrVol(6) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(7, :) = ( epsilon_r( FaceSegMed(7) )^2 * TtrVol(7) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;
    % Tet32ValueS2(8, :) = ( epsilon_r( FaceSegMed(8) )^2 * TtrVol(8) / ( 20 *( 3 * 10^8 )^2) ) * modOnes;

    face10Value(1)  = ( Tet32Value(5, 3) + Tet32Value(6, 4) ); % - omega^2 * ( Tet32ValueS2(5, 3) + Tet32ValueS2(6, 4) );
    face10Value(2)  = ( Tet32Value(6, 3) + Tet32Value(7, 4) ); % - omega^2 * ( Tet32ValueS2(6, 3) + Tet32ValueS2(7, 4) );
    face10Value(3)  = ( Tet32Value(7, 3) + Tet32Value(8, 4) ); % - omega^2 * ( Tet32ValueS2(7, 3) + Tet32ValueS2(8, 4) );
    face10Value(4)  = ( Tet32Value(4, 3) + Tet32Value(5, 4) ); % - omega^2 * ( Tet32ValueS2(4, 3) + Tet32ValueS2(5, 4) );
    face10Value(5)  = sum(Tet32Value(:, 2))                  ; %   - omega^2 * sum(Tet32ValueS2(:, 2));
    face10Value(6)  = ( Tet32Value(8, 3) + Tet32Value(1, 4) ); % - omega^2 * ( Tet32ValueS2(8, 3) + Tet32ValueS2(1, 4) );
    face10Value(7)  = ( Tet32Value(3, 3) + Tet32Value(4, 4) ); % - omega^2 * ( Tet32ValueS2(3, 3) + Tet32ValueS2(4, 4) );
    face10Value(8)  = ( Tet32Value(2, 3) + Tet32Value(3, 4) ); % - omega^2 * ( Tet32ValueS2(2, 3) + Tet32ValueS2(3, 4) );
    face10Value(9)  = ( Tet32Value(1, 3) + Tet32Value(2, 4) ); % - omega^2 * ( Tet32ValueS2(1, 3) + Tet32ValueS2(2, 4) );
    face10Value(10) = sum(Tet32Value(:, 1))                  ; %   - omega^2 * sum(Tet32ValueS2(:, 1));

end
