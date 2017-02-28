clc; clear; 
fname = 'd:\Kevin\CapaReal\Case0301_8MHzSaline';
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0301_8MHzSaline';
S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
for idx = 1: 1: length(S)
    Conc = S(idx);
    CaseName = strcat('Power250_', num2str(Conc));
    V_0 = 81.32;
    Shift2d;
    save( strcat(fname, '\', CaseName, '.mat') );
    CurrentEst;
end

clc; clear;
fname = 'd:\Kevin\CapaReal\Case0301_8MHzSaline';
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0301_8MHzSaline';
S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
for idx = 1: 1: length(S)
    Conc = S(idx);
    CaseName = strcat('Power280_', num2str(Conc));
    V_0 = 86.07;
    Shift2d;
    save( strcat(fname, '\', CaseName, '.mat') );
    CurrentEst;
end

clc; clear;
fname = 'd:\Kevin\CapaReal\Case0301_8MHzSaline';
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0301_8MHzSaline';
S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
for idx = 1: 1: length(S)
    Conc = S(idx);
    CaseName = strcat('Power300_', num2str(Conc));
    V_0 = 89.09;
    Shift2d;
    save( strcat(fname, '\', CaseName, '.mat') );
    CurrentEst;
end

clc; clear;
dt = 15;
timeNum_1   = 4 * 5;
timeNum_2   = 4 * 30;
timeNum_3   = 4 * 15;
timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0301_8MHzSaline';
fname = 'd:\Kevin\CapaReal\Case0301_8MHzSaline';

S = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]';
for idx = 1: 1: length(S)
    Conc = S(idx);
    % Period 1
    CaseName = strcat('Power250_', num2str(Conc));
    load( strcat(fname, '\', CaseName, '.mat') );

    % temperature initialization
    loadThermalParas;
    LungRatio = 1;
    TmprtrTau = T_0 * ones( x_idx_max, y_idx_max, z_idx_max, timeNum_all + 1 );
    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        if mediumTable( m, n, ell ) == 2
            TmprtrTau( m, n, ell, :) = T_bolus;
        end
        if mediumTable( m, n, ell ) == 1
            TmprtrTau( m, n, ell, :) = T_air;
        end
        if mediumTable( m, n, ell ) == 0
            XZ9Med = getXZ9Med(m, n, ell, mediumTable);
            if checkAirAround( XZ9Med )
                % TmprtrTau( m, n, ell, :) = ( T_bolus + T_air ) / 2;
                TmprtrTau( m, n, ell, :) = T_bolus;
            end
        end
    end

    T_bgn = 0;
    timeNum = timeNum_1;
    TmprtrDis;

    % Period 2
    CaseName = strcat('Power280_', num2str(Conc));
    load( strcat(fname, '\', CaseName, '.mat') );
    T_bgn = timeNum_1 * dt;
    timeNum = timeNum_2;
    TmprtrDis;

    % Period 3
    CaseName = strcat('Power300_', num2str(Conc));
    load( strcat(fname, '\', CaseName, '.mat') );
    T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
    timeNum = timeNum_3;
    TmprtrDis;

    % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0301_8MHzSaline';
    fname = 'd:\Kevin\CapaReal\Case0301_8MHzSaline';
    save( strcat(fname, '\Case0301_8MHzSaline_', num2str(Conc), '.mat') );
end
