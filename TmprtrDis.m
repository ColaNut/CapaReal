% clc; clear;
% load('TestCase2.mat');
Phi = zeros( x_idx_max, y_idx_max, z_idx_max );
Phi = getPhi( bar_x_my_gmres, x_idx_max, y_idx_max, z_idx_max );

% timer: [ 0, dt, ... T_end ];
% dt = 15; % 10s
% timeNum = 4 * 20;
% T_bgn = 0;
T_end = T_bgn + timeNum * dt;
% TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum );
TmprtrTauMinus = zeros(7, 1); 

% % temperature initialization
% for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
%     [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
%     if mediumTable( m, n, ell ) == 2
%         TmprtrTau( m, n, ell, :) = T_bolus;
%     end
%     if mediumTable( m, n, ell ) == 1
%         TmprtrTau( m, n, ell, :) = T_air;
%     end
%     if mediumTable( m, n, ell ) == 0
%         XZ9Med = getXZ9Med(m, n, ell, mediumTable);
%         if checkAirAround( XZ9Med )
%             TmprtrTau( m, n, ell, :) = T_bolus;
%         end
%     end
% end

disp('time to cal TmprtrTau')
tic;
for t = T_bgn + dt: dt: T_end
    t_idx = int64(t / dt + 1);
    if mod(t_idx, 40) == 0
        t_idx * dt / 60
    end
    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        
        % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        
        BioValid = false;
        CnvctnFlag = false;
        if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
            if mediumTable( m, n, ell ) == 0
                XZ9Med = getXZ9Med(m, n, ell, mediumTable);
                if ~checkBolusAround( XZ9Med )
                    BioValid = true;
                else
                    if checkMuscleAround( XZ9Med )
                        CnvctnFlag = true;
                    end
                end
            else
                BioValid = true;
            end
        end

        if ( m >= 19 && m <= 20 ) && ( ell == 11 || ell == 31 )
            CnvctnFlag = true;
        end
        if m == 19 && n >= 16 && n <= 20 && ( ell == 12 || ell == 30 )
            BioValid = true;
        end
        % namely, [m, n, ell] = [19, 16, 12], [19, 17, 12], [19, 18, 12], [19, 19, 12], [19, 20, 12], 
        %      or [m, n, ell] = [19, 16, 30], [19, 17, 30], [19, 18, 30], [19, 19, 30], [19, 20, 30].
 

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1  && ell >= 2 && ell <= z_idx_max - 1 
            PntSegMed = squeeze( SegMed(m, n, ell, :, :) );
            TmprtrTauMinus = get7Tmprtr(m, n, ell, t_idx - 1, TmprtrTau);
            % TmprtrTauMinus = [ p1, p2, p3, p4, p5, p6, p0 ]';

            if BioValid
                if mediumTable( m, n, ell ) ~= 0
                    TmprtrTau( m, n, ell, t_idx ) = calTmprtrNrmlPnt( m, n, ell, shiftedCoordinateXYZ, ...
                                            x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                            T_blood, zeta, sigma, rho, cap, rho_b, cap_b, xi, dt, TmprtrTauMinus, Phi, LungRatio );
                else
                    TmprtrTau( m, n, ell, t_idx ) = calTmprtrBndrPnt( m, n, ell, shiftedCoordinateXYZ, ...
                                            x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                            T_blood, zeta, sigma, rho, cap, rho_b, cap_b, xi, dt, TmprtrTauMinus, Phi, LungRatio );
                end
            elseif CnvctnFlag
                sigmaMask = sigma;
                sigmaMask(2) = 0;
                TmprtrTau( m, n, ell, t_idx ) = calTmprtrCnvcPnt( m, n, ell, shiftedCoordinateXYZ, ...
                                            x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                            T_blood, T_bolus, zeta, sigmaMask, rho, cap, rho_b, cap_b, xi, dt, ...
                                            TmprtrTauMinus, Phi, alpha );
            else
                if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
                    if mediumTable( m, n, ell ) == 0
                        XZ9Med = getXZ9Med(m, n, ell, mediumTable);
                        if ~checkAirAround( XZ9Med )
                            [m, n, ell]
                            % error('Check Here');
                        end
                    end
                end
            end
        end
    end
    TmprtrTau( :, 1, :, uint8(t_idx) ) = TmprtrTau( :, 2, :, uint8(t_idx) );
    TmprtrTau( :, y_idx_max, :, uint8(t_idx) ) = TmprtrTau( :, y_idx_max - 1, :, uint8(t_idx) );
end
toc;

% fullfileName = strcat(fname, '\', CaseName, 'Tmprtr', '.mat');
% save( fullfileName );

% extract temperature in the XZ plane
T_XZ = zeros( x_idx_max, z_idx_max );
x_mesh = squeeze(shiftedCoordinateXYZ( :, y_idx, :, 1))';
z_mesh = squeeze(shiftedCoordinateXYZ( :, y_idx, :, 3))';
paras2dXZ = genParas2d( y, paras, dx, dy, dz );
t = T_end;
% for t = 0: dt: T_end
    t_idx = t / dt + 1;
    y = tumor_y;
    y_idx = y / dy + h_torso / ( 2 * dy ) + 1;
    
    T_XZ = squeeze( TmprtrTau( :, y_idx, :, uint8(t_idx) ) );
    
    % figure(uint8(t_idx + 2));
    figure(3);
    clf;
    pcolor(x_mesh * 100, z_mesh * 100, T_XZ');
    shading flat
    % shading interp
    colorbar;
    colormap jet;
    set(gca,'fontsize',20);
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 20);
    view(2);
    hold on;
    plotMap( paras2dXZ, dx, dz );
    saveas(figure(3), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'fig');
    saveas(figure(3), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'jpg');
% end