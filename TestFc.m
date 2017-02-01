% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0115Bolus1cm';
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

% % % clc; clear; 
% % % V_0 = 76.78;
Shift2d
% loadParas;
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% y = tumor_y + dy;
y = 0;
counter = 0;
% for y = tumor_y - 2 * dy: dy: tumor_y - 2 * dy
    y_idx = y / dy + h_torso / (2 * dy) + 1;
    counter = counter + 1;
    paras2dXZ = genParas2d( y, paras, dx, dy, dz );
    figure(counter);
    clf;
    plotMap( paras2dXZ, dx, dz );
    axis equal;
    plotGridLineXZ( shiftedCoordinateXYZ, y_idx );
    set(gcf, 'Position', get(0,'Screensize'));
% end

% % figure(3);
plotRibXZ(Ribs, SSBone, dx, dz);

% RibValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% SSBoneValid = zeros(size(- h_torso / 2: dy: h_torso / 2));
% for y = - h_torso / 2: dy: h_torso / 2
%     y_idx = int64(y / dy + h_torso / (2 * dy) + 1);
%     if y_idx == 8
%         ;
%     end
%     [ RibValid(y_idx), SSBoneValid(y_idx) ] = Bone2d(y, Ribs, SSBone, dy, h_torso);
% end

% counter = 10;
% for x = tumor_x - 2 * dx: dx: tumor_x + 2 * dx
%     counter = counter + 1;
%     x_idx = x / dx + air_x / (2 * dx) + 1;
%     paras2dYZ = genParas2dYZ( x, paras, dy, dz );
%     figure(counter);
%     clf;
%     plotYZ( paras2dYZ, dy, dz );
%     axis equal;
%     plotGridLineYZ( shiftedCoordinateXYZ, x_idx);
% end


% clc; clear;
% CaseName = 'Power300';
% load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0109\', CaseName, '.mat') );

% flag_XZ = 1;
% flag_XY = 0;
% flag_YZ = 0;
% PhiDstrbtn;

% lala = squeeze(SegMed(16, tumor_n + 2, 29, :, :));
% Need to Rederive the octantCube.m

% AxA = 3;
% if AxA == 3;
%     disp('lala');
% elseif AxA == 4;
%     disp('lala4');
% end