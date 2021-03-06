% clc; clear;
% load('TestCase2.mat');
Phi = zeros( x_idx_max, y_idx_max, z_idx_max );
bar_x_my_gmres_mod = zeros(x_idx_max * y_idx_max * z_idx_max, 1);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    p0_v = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
    bar_x_my_gmres_mod(idx) = bar_x_my_gmres(p0_v);
end
Phi = getPhi( bar_x_my_gmres_mod, x_idx_max, y_idx_max, z_idx_max );

% timer: [ 0, dt, ... T_end ];
% dt = 15; % 10s
% timeNum = 4 * 20;
% T_bgn = 0;
T_end = T_bgn + timeNum * dt;
% TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum );
TmprtrTauMinus = zeros(7, 1); 

PennesCoeff = zeros(x_idx_max, y_idx_max, z_idx_max, 7);
RhoCapTerm  = zeros(x_idx_max, y_idx_max, z_idx_max);
XiRhoTerm   = zeros(x_idx_max, y_idx_max, z_idx_max);
QsTerm      = zeros(x_idx_max, y_idx_max, z_idx_max);

disp('pre-calculation of PennesCoeffm, RhoCapTerm, XiRhoTerm and QsTerm');
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    
    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1  && ell >= 2 && ell <= z_idx_max - 1 
        PntSegMed = squeeze( SegMed(m, n, ell, :, :) );
        % % TmprtrTauMinus = get7Tmprtr(m, n, ell, t_idx - 1, TmprtrTau);
        % TmprtrTauMinus = [ p1, p2, p3, p4, p5, p6, p0 ]';

        if mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 7 ...
                  || mediumTable(m, n, ell) == 12 || mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
            if MskMedTab( m, n, ell ) ~= 0 % normal point
                [ PennesCoeff( m, n, ell, : ), RhoCapTerm(m, n, ell), XiRhoTerm(m, n, ell), QsTerm(m, n, ell) ] ...
                                    = calTmprtrNrmlPntCoeff( m, n, ell, shiftedCoordinateXYZ, ...
                                        x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                        T_blood, zeta, sigma, rho, cap, rho_b, cap_b, xi, dt, Phi, LungRatio, BoneMediumTable, MskMedTab );
            elseif MskMedTab( m, n, ell ) == 0 % boundary point
                [ PennesCoeff( m, n, ell, : ), RhoCapTerm(m, n, ell), XiRhoTerm(m, n, ell), QsTerm(m, n, ell) ] ...
                                    = calTmprtrBndrPntCoeff( m, n, ell, shiftedCoordinateXYZ, ...
                                        x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                        T_blood, zeta, sigma, rho, cap, rho_b, cap_b, xi, dt, Phi, LungRatio, BoneMediumTable, MskMedTab );
            end
        elseif mediumTable(m, n, ell) == 13
            sigmaMask = sigma;
            sigmaMask(2) = 0;
            PennesCoeff( m, n, ell, : ) = calTmprtrCnvcPntCoeff( m, n, ell, shiftedCoordinateXYZ, ...
                                        x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                        T_blood, T_bolus, zeta, sigmaMask, rho, cap, rho_b, cap_b, xi, dt, ...
                                        Phi, alpha, BoneMediumTable, MskMedTab );
        else
            % the remaining are the air, the bolus and the air-bolus boundary
            if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2 && mediumTable( m, n, ell ) ~= 11 
                % if mediumTable( m, n, ell ) == 0
                %     XZ9Med = getXZ9Med(m, n, ell, mediumTable);
                %     if ~checkAirAround( XZ9Med )
                        [m, n, ell]
                        error('Check Here');
                %     end
                % end
            end
        end
    end
end
toc;

% load( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0216_1cmFat\PreCalVariable.mat');

% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207BoneTest\Case0207BoneTest.mat');
disp('time to cal TmprtrTau');
tic;
for t = T_bgn + dt: dt: T_end
    t_idx = int64(t / dt + 1);
    if mod(t_idx, 40) == 0
        t_idx * dt / 60
    end

    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        
        % BioValid = false;
        % CnvctnFlag = false;
        % if mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 5 
        %     BioValid = true;
        % end
        % if mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
        %     BioValid = true;
        % end
        % if mediumTable(m, n, ell) == 13
        %     CnvctnFlag = true;
        % end
        % if mediumTable( m, n, ell ) ~= 1 && mediumTable( m, n, ell ) ~= 2
        %     if mediumTable( m, n, ell ) == 0
        %         XZ9Med = getXZ9Med(m, n, ell, mediumTable);
        %         if ~checkBolusAround( XZ9Med )
        %             BioValid = true;
        %         else
        %             if checkMuscleAround( XZ9Med )
        %                 CnvctnFlag = true;
        %             end
        %         end
        %     else
        %         BioValid = true;
        %     end
        % end

        % if ( m >= 19 && m <= 20 ) && ( ell == 11 || ell == 31 )
        %     CnvctnFlag = true;
        % end
        % if m == 19 && n >= 16 && n <= 20 && ( ell == 12 || ell == 30 )
        %     BioValid = true;
        % end
        % namely, [m, n, ell] = [19, 16, 12], [19, 17, 12], [19, 18, 12], [19, 19, 12], [19, 20, 12], 
        %      or [m, n, ell] = [19, 16, 30], [19, 17, 30], [19, 18, 30], [19, 19, 30], [19, 20, 30].

        if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1  && ell >= 2 && ell <= z_idx_max - 1 
            PntSegMed = squeeze( SegMed(m, n, ell, :, :) );
            TmprtrTauMinus = get7Tmprtr(m, n, ell, t_idx - 1, TmprtrTau);
            % TmprtrTauMinus = [ p1, p2, p3, p4, p5, p6, p0 ]';

            if mediumTable(m, n, ell) == 3 || mediumTable(m, n, ell) == 4 || mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 7 ...
                  || mediumTable(m, n, ell) == 12 || mediumTable(m, n, ell) == 14 || mediumTable(m, n, ell) == 15 
                if MskMedTab( m, n, ell ) ~= 0 % normal point
                    TmprtrTau( m, n, ell, t_idx ) = calTmprtrNrmlPnt( T_blood, TmprtrTauMinus, ...
                                squeeze(PennesCoeff(m, n, ell, :)), squeeze(RhoCapTerm(m, n, ell)), ...
                                squeeze(XiRhoTerm(m, n, ell)), squeeze(QsTerm(m, n, ell)) );
                elseif MskMedTab( m, n, ell ) == 0 % boundary point
                    TmprtrTau( m, n, ell, t_idx ) = calTmprtrBndrPnt( T_blood, TmprtrTauMinus, ...
                                squeeze(PennesCoeff(m, n, ell, :)), squeeze(RhoCapTerm(m, n, ell)), ...
                                squeeze(XiRhoTerm(m, n, ell)), squeeze(QsTerm(m, n, ell)) );
                end
            elseif mediumTable(m, n, ell) == 13
                sigmaMask = sigma;
                sigmaMask(2) = 0;
                TmprtrTau( m, n, ell, t_idx ) = calTmprtrCnvcPnt( m, n, ell, shiftedCoordinateXYZ, ...
                                            x_idx_max, y_idx_max, z_idx_max, PntSegMed, mediumTable, ...
                                            T_blood, T_bolus, zeta, sigmaMask, rho, cap, rho_b, cap_b, xi, dt, ...
                                            TmprtrTauMinus, Phi, alpha, BoneMediumTable, MskMedTab, squeeze(PennesCoeff(m, n, ell, :)) );
            else
                % the remaining are the air, the bolus and the air-bolus boundary
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
    % saveas(figure(3), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'fig');
    % saveas(figure(3), fullfile(fname, strcat(CaseName, 'TumorTmprtr')), 'jpg');
% end