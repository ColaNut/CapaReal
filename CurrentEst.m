% clc; clear;
% % load('TestCase2.mat');
% load('Case1124.mat');
% load('First.mat');

% y = tumor_y;
% paras2dXZ = genParas2d( y, paras, dx, dy, dz );
% figure(2);
% plotMap( paras2dXZ, dx, dz );

% reorganize the Phi distribution
bar_x_my_gmres_mod = zeros(x_idx_max * y_idx_max * z_idx_max, 1);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    p0_v = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
    bar_x_my_gmres_mod(idx) = bar_x_my_gmresPhi(p0_v);
end

Phi = zeros( x_idx_max, y_idx_max, z_idx_max );
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    Phi(idx) = bar_x_my_gmres_mod(idx);
end

% UpElecTb = false( x_idx_max, y_idx_max, z_idx_max );
Current = 0;

disp('Estimate the current out of the plate')
tic;
for idx = x_idx_max * y_idx_max * z_idx_max / 2: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m = uint64(m);
    n = uint64(n);
    ell = uint64(ell);

    if UpElecTb( m, n, ell ) == true;
        XZ9Med = getXZ9Med(m, n, ell, MskMedTab);
        if checkBndrNum( XZ9Med, 3 ) || checkBndrNum( XZ9Med, 4 )
            if checkBndrNum( XZ9Med, 4 )
                if length( find(XZ9Med(1: 3) == 0) ) == 1
                    XZ9Med(1: 3) = [2; 2; 2];
                elseif length( find(XZ9Med(1: 3) == 0) ) == 2
                    if XZ9Med(7) ~= 0
                        XZ9Med(3) = 2;
                    elseif XZ9Med(9) ~= 0
                        XZ9Med(1) = 2;
                    else
                        error('check');
                    end
                else
                    error('check');
                end
            end

            PntsIdx       = zeros( 3, 9 );
            PntsCrdnt     = zeros( 3, 9, 3 );
            MidPntsCrdnt  = zeros( 3, 9, 3 );
            MidPhi        = zeros( 3, 9 );
            p2_18MidCrdnt = zeros( 2, 9, 3 );
            p2_18Phi      = zeros( 2, 9 );
            p4_18MidCrdnt = zeros( 2, 9, 3 );
            p4_18Phi      = zeros( 2, 9 );
            
            [ PntsIdx, PntsCrdnt ]  = get27Pnts( m, n, ell, x_idx_max, y_idx_max, shiftedCoordinateXYZ );
            MidPntsCrdnt            = calMid27Pnts( PntsCrdnt );
            MidPhi                  = cal27MidPhi( m, n, ell, Phi );

            p2_18MidCrdnt = p2Face18Crdnt( MidPntsCrdnt );
            p2_18Phi      = p2Face18MidPhi( MidPhi );
            p4_18MidCrdnt = p4Face18Crdnt( MidPntsCrdnt );
            p4_18Phi      = p4Face18MidPhi( MidPhi );

            if XZ9Med(1) == 0
                Current = Current + cal_I_oblique_dwn( p2_18MidCrdnt, p2_18Phi );
            end
            if XZ9Med(2) == 0
                error('check for UpElecTb');
            end
            if XZ9Med(3) == 0
                Current = Current + cal_I_oblique_dwn( p4_18MidCrdnt, p4_18Phi );
            end
            if XZ9Med(4) == 0
                Current = Current + cal_I_ltrl( p2_18MidCrdnt, p2_18Phi );
            end
            if XZ9Med(5) ~= 0
                error('check for UpElecTb');
            end
            if XZ9Med(6) == 0
                Current = Current + cal_I_ltrl( p4_18MidCrdnt, p4_18Phi );
            end
            if XZ9Med(7) == 0
                Current = Current + cal_I_oblique_up( p2_18MidCrdnt, p2_18Phi );
            end
            if XZ9Med(8) == 0
                error('check for UpElecTb');
            end
            if XZ9Med(9) == 0
                Current = Current + cal_I_oblique_up( p4_18MidCrdnt, p4_18Phi );
            end
        else
            % if length( find(XZ9Med(1: 3) == 0) ) ~= 1
                [ m, n, ell ]
                [ XZ9Med(7: 9)'; XZ9Med(4: 6)'; XZ9Med(1: 3)' ]
                warning('check Bndry Point around');
            % end
        end
    end

end
toc;

Current = sigma(2) * Current

W = V_0 * conj(Current) / 2

% save( strcat(fname, '\', CaseName, 'currentEst.mat'), 'Current', 'W' );