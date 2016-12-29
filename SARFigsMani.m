% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
% CaseNeme = 'Power300';
% openfig( strcat(fname, '\Power300SARXZ.fig'), 'reuse');

% saveas(figure(1), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');

% openfig( strcat(fname, '\Power300SARXY.fig'), 'reuse');

% saveas(figure(1), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
% saveas(figure(1), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');

% openfig('D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2\Power300SARYZ.fig', 'reuse');
% myRange = [ 9.99e-2, 1e4 ];
% caxis(log10(myRange));
% clc; clear;
load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1226\Case1226TmprtrFigXZ.mat');
squeeze( SARseg(tumor_m, tumor_ell, :, :) )
% [ MaxValue, Idx ] = max(SARseg(:));
% disp('max value is');
% MaxValue
% [I_1, I_2, I_3, I_4] = ind2sub(size(SARseg),Idx)

% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1226\Case1226TmprtrFigXY.mat');
% [ MaxValue, Idx ] = max(SARseg(:));
% disp('max value is');
% MaxValue
% [I_1, I_2, I_3, I_4] = ind2sub(size(SARseg),Idx)

% clc; clear;
% load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case1226\Case1226TmprtrFigYZ.mat');
% [ MaxValue, Idx ] = max(SARseg(:));
% disp('max value is');
% MaxValue
% [I_1, I_2, I_3, I_4] = ind2sub(size(SARseg),Idx)

