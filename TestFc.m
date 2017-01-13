% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109';
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
% saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
% saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
% saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
% saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
% saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
% saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
% saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
% saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
% saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');

% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\Power250currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\Power280currentEst.mat');
% W
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\Power300currentEst.mat');
% W

% clc; clear; 
V_0 = 76.78;
Shift2d
y = tumor_y + 2 * dy;
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

paras2dXZ = genParas2d( y, paras, dx, dy, dz );
figure(1);
plotMap( paras2dXZ, dx, dz );
plotGridLineXZ( shiftedCoordinateXYZ, tumor_n + 2 );



% lala = squeeze(SegMed(16, tumor_n + 2, 29, :, :));
% Need to Rederive the octantCube.m

% AxA = 3;
% if AxA == 3;
%     disp('lala');
% elseif AxA == 4;
%     disp('lala4');
% end