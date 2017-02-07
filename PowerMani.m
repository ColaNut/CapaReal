% clc; clear; 
% fname = 'e:\Kevin\CapaReal\Case0207Bone';
% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207Bone';
% CaseName = 'Power250';
% V_0 = 76.78;
% Shift2d;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst;

% % ManiScript;

% clc; clear;
% fname = 'e:\Kevin\CapaReal\Case0207Bone';
% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207Bone';
% CaseName = 'Power280';
% V_0 = 81.26;
% Shift2d;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst;

% clc; clear;
% fname = 'e:\Kevin\CapaReal\Case0207Bone';
% % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207Bone';
% CaseName = 'Power300';
% V_0 = 84.11;
% Shift2d;
% save( strcat(fname, '\', CaseName, '.mat') );
% CurrentEst;

clc; clear;
dt = 15;
timeNum_1   = 4 * 5;
timeNum_2   = 4 * 30;
timeNum_3   = 4 * 15;
timeNum_all = timeNum_1 + timeNum_2 + timeNum_3;

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207Bone';
fname = 'e:\Kevin\CapaReal\Case0207Bone';

% Period 1
CaseName = 'Power250';
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
CaseName = 'Power280';
load( strcat(fname, '\', CaseName, '.mat') );
T_bgn = timeNum_1 * dt;
timeNum = timeNum_2;
TmprtrDis;

% Period 3
CaseName = 'Power300';
load( strcat(fname, '\', CaseName, '.mat') );
T_bgn = ( timeNum_1 + timeNum_2 ) * dt;
timeNum = timeNum_3;
TmprtrDis;

fname = 'e:\Kevin\CapaReal\Case0207Bone';
save( strcat(fname, '\Case0207Bone.mat') );

% ManiScript
