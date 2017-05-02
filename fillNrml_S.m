function [ S1_row ] = fillNrml_S( m, n, ell, flag, Vertex_Crdnt, x_max_vertex, y_max_vertex, ...
                                            z_max_vertex, PntSegMed, epsilon_r, omega, varargin )

    % if m ~= 2 && m ~= x_max_vertex - 1 && n ~= 2 && n ~= y_max_vertex - 1 && ell ~= 2 && ell ~= z_max_vertex - 1 && 
    nVarargs = length(varargin);
    if nVarargs == 0
        cal_mn = str2func('calS_mn');
    elseif nVarargs == 1
        if strcmp(varargin{1}, 'GVV')
            cal_mn = str2func('calGVV_mn');
        else
            error('check');
        end
    else
        error('check');
    end

    switch flag
        case { '111', '000' }
            S1_row      = zeros( 1, 54 );
            PntsIdx     = zeros( 3, 9 );
            PntsCrdnt   = zeros( 3, 9, 3 ); 

            [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_max_vertex, y_max_vertex, Vertex_Crdnt );

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
            IndvdlValue(1, :) = cal_mn( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(1, :), epsilon_r, 'Nrml', omega );
            % if ell == z_max_vertex - 1
            %     IndvdlValue(1, :) = IndvdlValue(1, :) - S1_Gamma_p1( squeeze( PntsCrdnt(3, :, :) ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(1, :), epsilon_r, [0, 0, 1], 'Nrml' );
            % end
            % p2
            FaceCrdnt  = zeros( 1, 9, 3 );
            FaceCrdnt = p2Face( PntsCrdnt );
            IndvdlValue(2, :) = cal_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(2, :), epsilon_r, 'Nrml', omega );
            % p3
            FaceCrdnt = p3Face( PntsCrdnt );
            IndvdlValue(3, :) = cal_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(3, :), epsilon_r, 'Nrml', omega );
            % p4
            FaceCrdnt = p4Face( PntsCrdnt );
            IndvdlValue(4, :) = cal_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(4, :), epsilon_r, 'Nrml', omega );
            % p5
            FaceCrdnt = p5Face( PntsCrdnt );
            IndvdlValue(5, :) = cal_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(5, :), epsilon_r, 'Nrml', omega );
            % p6
            FaceCrdnt = p6Face( PntsCrdnt );
            IndvdlValue(6, :) = cal_mn( squeeze( FaceCrdnt ), squeeze( PntsCrdnt(2, 5, :) ), PntSegMed(6, :), epsilon_r, 'Nrml', omega );

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
        case { '110', '001' }
            S1_row      = zeros( 1, 22 );
            PntsIdx     = zeros( 3, 9 );
            PntsCrdnt   = zeros( 3, 9, 3 ); 

            [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_max_vertex, y_max_vertex, Vertex_Crdnt );

            % the order is decided by: look from positive z axis.
            S1_row(1)    = PntsIdx(2, 1);
            S1_row(2)    = PntsIdx(2, 2);
            S1_row(3)    = PntsIdx(2, 3);
            S1_row(4)    = PntsIdx(2, 4);
            S1_row(5)    = PntsIdx(2, 5);
            S1_row(6)    = PntsIdx(2, 6);
            S1_row(7)    = PntsIdx(2, 7);
            S1_row(8)    = PntsIdx(2, 8);
            S1_row(9)    = PntsIdx(2, 9);

            % lower
            S1_row(10)   = PntsIdx(1, 5);
            % upper
            S1_row(11)   = PntsIdx(3, 5);

            tmpMidLyr    = zeros( 9, 3 );
            LidsValue    = zeros( 2, 10 );
            % p1
            LidsValue(1, :) = cal_mn( squeeze( PntsCrdnt(2, :, :) ), squeeze( PntsCrdnt(1, 5, :) ), PntSegMed(1, :), epsilon_r, 'z_shift', omega ); 
            % p3
            tmpMidLyr = p3FaceMidLyr( PntsCrdnt );
            LidsValue(2, :) = cal_mn( tmpMidLyr, squeeze( PntsCrdnt(3, 5, :) ), PntSegMed(2, :), epsilon_r, 'z_shift', omega ); 

            % 9 middle points + lower + upper
            Contribution = zeros(11, 1);

            Contribution(1) = LidsValue(1, 1) + LidsValue(2, 3);
            Contribution(2) = LidsValue(1, 2) + LidsValue(2, 2);
            Contribution(3) = LidsValue(1, 3) + LidsValue(2, 1);
            Contribution(4) = LidsValue(1, 4) + LidsValue(2, 6);
            Contribution(5) = LidsValue(1, 5) + LidsValue(2, 5);
            Contribution(6) = LidsValue(1, 6) + LidsValue(2, 4);
            Contribution(7) = LidsValue(1, 7) + LidsValue(2, 9);
            Contribution(8) = LidsValue(1, 8) + LidsValue(2, 8);
            Contribution(9) = LidsValue(1, 9) + LidsValue(2, 7);
            Contribution(10) = LidsValue(1, 10);
            Contribution(11) = LidsValue(2, 10);

            S1_row(12)    = Contribution(1);
            S1_row(13)    = Contribution(2);
            S1_row(14)    = Contribution(3);
            S1_row(15)    = Contribution(4);
            S1_row(16)    = Contribution(5);
            S1_row(17)    = Contribution(6);
            S1_row(18)    = Contribution(7);
            S1_row(19)    = Contribution(8);
            S1_row(20)    = Contribution(9);
            S1_row(21)    = Contribution(10);
            S1_row(22)    = Contribution(11);

        case { '100', '011' }
            S1_row      = zeros( 1, 22 );
            PntsIdx     = zeros( 3, 9 );
            PntsCrdnt   = zeros( 3, 9, 3 ); 

            [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_max_vertex, y_max_vertex, Vertex_Crdnt );

            % the order is decided by: look from positive x axis.
            S1_row(1)    = PntsIdx(1, 2);
            S1_row(2)    = PntsIdx(1, 5);
            S1_row(3)    = PntsIdx(1, 8);
            S1_row(4)    = PntsIdx(2, 2);
            S1_row(5)    = PntsIdx(2, 5);
            S1_row(6)    = PntsIdx(2, 8);
            S1_row(7)    = PntsIdx(3, 2);
            S1_row(8)    = PntsIdx(3, 5);
            S1_row(9)    = PntsIdx(3, 8);

            % left
            S1_row(10)   = PntsIdx(2, 4);
            % right
            S1_row(11)   = PntsIdx(2, 6);

            tmpMidLyr    = zeros( 9, 3 );
            LidsValue    = zeros( 2, 10 );
            % p4
            tmpMidLyr = p4FaceMidLyr( PntsCrdnt );
            LidsValue(1, :) = cal_mn( tmpMidLyr, squeeze( PntsCrdnt(2, 4, :) ), PntSegMed(1, :), epsilon_r, 'x_shift', omega ); 
            % p2
            tmpMidLyr = p2FaceMidLyr( PntsCrdnt );
            LidsValue(2, :) = cal_mn( tmpMidLyr, squeeze( PntsCrdnt(2, 6, :) ), PntSegMed(2, :), epsilon_r, 'x_shift', omega ); 

            % 9 middle points + left + right
            Contribution = zeros(11, 1);

            Contribution(1) = LidsValue(1, 1) + LidsValue(2, 3);
            Contribution(2) = LidsValue(1, 2) + LidsValue(2, 2);
            Contribution(3) = LidsValue(1, 3) + LidsValue(2, 1);
            Contribution(4) = LidsValue(1, 4) + LidsValue(2, 6);
            Contribution(5) = LidsValue(1, 5) + LidsValue(2, 5);
            Contribution(6) = LidsValue(1, 6) + LidsValue(2, 4);
            Contribution(7) = LidsValue(1, 7) + LidsValue(2, 9);
            Contribution(8) = LidsValue(1, 8) + LidsValue(2, 8);
            Contribution(9) = LidsValue(1, 9) + LidsValue(2, 7);
            Contribution(10) = LidsValue(1, 10);
            Contribution(11) = LidsValue(2, 10);

            S1_row(12)    = Contribution(1);
            S1_row(13)    = Contribution(2);
            S1_row(14)    = Contribution(3);
            S1_row(15)    = Contribution(4);
            S1_row(16)    = Contribution(5);
            S1_row(17)    = Contribution(6);
            S1_row(18)    = Contribution(7);
            S1_row(19)    = Contribution(8);
            S1_row(20)    = Contribution(9);
            S1_row(21)    = Contribution(10);
            S1_row(22)    = Contribution(11);

        case { '101', '010' }
            S1_row      = zeros( 1, 22 );
            PntsIdx     = zeros( 3, 9 );
            PntsCrdnt   = zeros( 3, 9, 3 ); 

            [ PntsIdx, PntsCrdnt ] = get27Pnts( m, n, ell, x_max_vertex, y_max_vertex, Vertex_Crdnt );

            % the order is decided by: look from positive y axis.
            S1_row(1)    = PntsIdx(1, 6);
            S1_row(2)    = PntsIdx(1, 5);
            S1_row(3)    = PntsIdx(1, 4);
            S1_row(4)    = PntsIdx(2, 6);
            S1_row(5)    = PntsIdx(2, 5);
            S1_row(6)    = PntsIdx(2, 4);
            S1_row(7)    = PntsIdx(3, 6);
            S1_row(8)    = PntsIdx(3, 5);
            S1_row(9)    = PntsIdx(3, 4);

            % close
            S1_row(10)   = PntsIdx(2, 2);
            % far
            S1_row(11)   = PntsIdx(2, 8);

            tmpMidLyr    = zeros( 9, 3 );
            LidsValue    = zeros( 2, 10 );
            % p4
            tmpMidLyr = p5FaceMidLyr( PntsCrdnt );
            LidsValue(1, :) = cal_mn( tmpMidLyr, squeeze( PntsCrdnt(2, 2, :) ), PntSegMed(1, :), epsilon_r, 'x_shift', omega ); 
            % p2
            tmpMidLyr = p6FaceMidLyr( PntsCrdnt );
            LidsValue(2, :) = cal_mn( tmpMidLyr, squeeze( PntsCrdnt(2, 8, :) ), PntSegMed(2, :), epsilon_r, 'x_shift', omega ); 

            % 9 middle points + left + right
            Contribution = zeros(11, 1);

            Contribution(1) = LidsValue(1, 1) + LidsValue(2, 3);
            Contribution(2) = LidsValue(1, 2) + LidsValue(2, 2);
            Contribution(3) = LidsValue(1, 3) + LidsValue(2, 1);
            Contribution(4) = LidsValue(1, 4) + LidsValue(2, 6);
            Contribution(5) = LidsValue(1, 5) + LidsValue(2, 5);
            Contribution(6) = LidsValue(1, 6) + LidsValue(2, 4);
            Contribution(7) = LidsValue(1, 7) + LidsValue(2, 9);
            Contribution(8) = LidsValue(1, 8) + LidsValue(2, 8);
            Contribution(9) = LidsValue(1, 9) + LidsValue(2, 7);
            Contribution(10) = LidsValue(1, 10);
            Contribution(11) = LidsValue(2, 10);

            S1_row(12)    = Contribution(1);
            S1_row(13)    = Contribution(2);
            S1_row(14)    = Contribution(3);
            S1_row(15)    = Contribution(4);
            S1_row(16)    = Contribution(5);
            S1_row(17)    = Contribution(6);
            S1_row(18)    = Contribution(7);
            S1_row(19)    = Contribution(8);
            S1_row(20)    = Contribution(9);
            S1_row(21)    = Contribution(10);
            S1_row(22)    = Contribution(11);
        otherwise
            error('check');
    end

    if nVarargs == 1 && strcmp(varargin{1}, 'GVV')
      cal_mn = str2func('calGVV_mn');
      S1_row = S1_row';
    end
end