function SegMed27Pnt_B = InhereSegMed( PntSegMed, SegMed27Pnt_B, air_x, h_torso, air_z, dx, dy, dz )

    % SegMed27Pnt_B = zeros(3, 3, 3, 6, 8, 'uint8');
    % PntSegMed = zeros(6, 8, 'uint8');
    PntsIdx     = zeros( 3, 9 );
    PntsCrdnt   = zeros( 3, 9, 3 ); 

    ImagCoord = zeros(3, 3, 3, 3);
    [ X_grid, Y_grid, Z_grid ] = meshgrid( [-1: 1], [-1: 1], [-1: 1] );
    ImagCoord(:, :, :, 1) = Y_grid;
    ImagCoord(:, :, :, 2) = X_grid;
    ImagCoord(:, :, :, 3) = Z_grid;

    % PntsIdx is a dummy variable
    [ PntsIdx, PntsCrdnt ] = get27Pnts( 2, 2, 2, 3, 3, ImagCoord );

    S1_row(1)    = PntsIdx(1, 1);
    S1_row(2)    = PntsIdx(1, 2);
    S1_row(3)    = PntsIdx(1, 3);
    S1_row(4)    = PntsIdx(1, 4);
    S1_row(5)    = PntsIdx(1, 5);
    S1_row(6)    = PntsIdx(1, 6);
    S1_row(7)    = PntsIdx(1, 7);
    S1_row(8)    = PntsIdx(1, 8);
    S1_row(9)    = PntsIdx(1, 9);

    S1_row(10)   = PntsIdx(2, 1);
    S1_row(11)   = PntsIdx(2, 2);
    S1_row(12)   = PntsIdx(2, 3);
    S1_row(13)   = PntsIdx(2, 4);
    S1_row(14)   = PntsIdx(2, 5);
    S1_row(15)   = PntsIdx(2, 6);
    S1_row(16)   = PntsIdx(2, 7);
    S1_row(17)   = PntsIdx(2, 8);
    S1_row(18)   = PntsIdx(2, 9);

    S1_row(19)   = PntsIdx(3, 1);
    S1_row(20)   = PntsIdx(3, 2);
    S1_row(21)   = PntsIdx(3, 3);
    S1_row(22)   = PntsIdx(3, 4);
    S1_row(23)   = PntsIdx(3, 5);
    S1_row(24)   = PntsIdx(3, 6);
    S1_row(25)   = PntsIdx(3, 7);
    S1_row(26)   = PntsIdx(3, 8);
    S1_row(27)   = PntsIdx(3, 9);

    % p1
    % tmpMidLyr = p1FaceMidLyr( PntsCrdnt );
    % each face have ten contribution: 9 on each face and 1 in the center.
    IndvdlValue = zeros(6, 10);
    % p1
    IndvdlValue(1, :) = calS1_mn( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(1, :), epsilon_r, 'Nrml' ); 
    % if ell == z_max_vertex - 1
    %     IndvdlValue(1, :) = IndvdlValue(1, :) - S1_Gamma_p1( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(1, :), epsilon_r, [0, 0, 1], 'Nrml' );
    % end
    % p2
    FaceCrdnt  = zeros( 1, 9, 3 );
    FaceCrdnt = p2Face( PntsCrdnt );
    IndvdlValue(2, :) = calS1_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(2, :), epsilon_r, 'Nrml' ); 
    % p3
    FaceCrdnt = p3Face( PntsCrdnt );
    IndvdlValue(3, :) = calS1_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(3, :), epsilon_r, 'Nrml' ); 
    % p4
    FaceCrdnt = p4Face( PntsCrdnt );
    IndvdlValue(4, :) = calS1_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(4, :), epsilon_r, 'Nrml' ); 
    % p5
    FaceCrdnt = p5Face( PntsCrdnt );
    IndvdlValue(5, :) = calS1_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(5, :), epsilon_r, 'Nrml' ); 
    % p6
    FaceCrdnt = p6Face( PntsCrdnt );
    IndvdlValue(6, :) = calS1_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(6, :), epsilon_r, 'Nrml' ); 

    Contribution = zeros(3, 9);

    % start from here.
    Contribution(1, 1) = IndvdlValue(3, 3) + IndvdlValue(2, 3) + IndvdlValue(6, 1);
    Contribution(1, 2) = IndvdlValue(3, 2) + IndvdlValue(6, 2);
    Contribution(1, 3) = IndvdlValue(3, 1) + IndvdlValue(4, 1) + IndvdlValue(6, 3);
    Contribution(1, 4) = IndvdlValue(3, 6) + IndvdlValue(2, 2);
    Contribution(1, 5) = IndvdlValue(3, 5);
    Contribution(1, 6) = IndvdlValue(3, 4) + IndvdlValue(4, 2);
    Contribution(1, 7) = IndvdlValue(3, 9) + IndvdlValue(2, 1) + IndvdlValue(5, 3);
    Contribution(1, 8) = IndvdlValue(3, 8) + IndvdlValue(5, 2);
    Contribution(1, 9) = IndvdlValue(3, 7) + IndvdlValue(4, 3) + IndvdlValue(5, 1);

    Contribution(2, 1) = IndvdlValue(2, 6) + IndvdlValue(6, 4);
    Contribution(2, 2) = IndvdlValue(6, 5);
    Contribution(2, 3) = IndvdlValue(4, 4) + IndvdlValue(6, 6);
    Contribution(2, 4) = IndvdlValue(2, 5);
    Contribution(2, 5) = sum(IndvdlValue(:, 10));
    Contribution(2, 6) = IndvdlValue(4, 5);
    Contribution(2, 7) = IndvdlValue(2, 4) + IndvdlValue(5, 6);
    Contribution(2, 8) = IndvdlValue(5, 5);
    Contribution(2, 9) = IndvdlValue(4, 6) + IndvdlValue(5, 4);

    Contribution(3, 1) = IndvdlValue(1, 1) + IndvdlValue(2, 9) + IndvdlValue(6, 7);
    Contribution(3, 2) = IndvdlValue(1, 2) + IndvdlValue(6, 8);
    Contribution(3, 3) = IndvdlValue(1, 3) + IndvdlValue(4, 7) + IndvdlValue(6, 9);
    Contribution(3, 4) = IndvdlValue(1, 4) + IndvdlValue(2, 8);
    Contribution(3, 5) = IndvdlValue(1, 5);
    Contribution(3, 6) = IndvdlValue(1, 6) + IndvdlValue(4, 8);
    Contribution(3, 7) = IndvdlValue(1, 7) + IndvdlValue(2, 7) + IndvdlValue(5, 9);
    Contribution(3, 8) = IndvdlValue(1, 8) + IndvdlValue(5, 8);
    Contribution(3, 9) = IndvdlValue(1, 9) + IndvdlValue(4, 9) + IndvdlValue(5, 7);

    S1_row(28:36) = Contribution(1, :);
    S1_row(37:45) = Contribution(2, :);
    S1_row(46:54) = Contribution(3, :);

end