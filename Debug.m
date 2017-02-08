clc;
clear; 
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0208MuscleBone';
% fname = 'e:\Kevin\CapaReal\Case0207BoneDebug';

% Period 1
CaseName = 'Power250';
load( strcat(fname, '\', CaseName, '.mat') );

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0207Bone';
% openfig(strcat(fname, '\', CaseName, 'PhiXZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'SARXZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'PhiXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'SARXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'PhiYZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'SARYZ', '.fig'));
% openfig(strcat(fname, '\', 'TotalQmet42000TumorTmprtr', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrXZ', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrXY', '.fig'));
% openfig(strcat(fname, '\', CaseName, 'TmprtrYZ', '.fig'));

% m = 15;
% n = 14; 
% ell = 28;

% idxmnell = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m

