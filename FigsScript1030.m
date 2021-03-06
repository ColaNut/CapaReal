% clc; clear;
PhiSAR_flag = 1;

% Need to modify the 'save' in the PhiDstrbtn.m to make it accord with the 'load' in TmprtrFigs.m
if PhiSAR_flag == 1
    % clc; clear;
    % CaseName = 'Case0503_PHI_enhance';
    % load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0220_1cmFat\', CaseName, '.mat') );
    % load('Case0220_1cmFat.mat');
    % load( strcat('e:\Kevin\CapaReal\Case0220_1cmFat', '\', CaseName, '.mat') );
    % load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0503_PHI_enhance\0502_PHI.mat');
    flag_XZ = 1;
    flag_XY = 1;
    flag_YZ = 1;

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\1031LungEQS';
    % % fname = 'e:\Kevin\CapaReal\Case0220_1cmFat';
    % CaseDate = 'Case0622_PHI_enhancex';
    CaseName = 'Power300';
    PhiDstrbtn;
    % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
    saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'epsc');
    saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
    % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
    saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'epsc');
    saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
    saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'epsc');
    saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
    saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'epsc');
    saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
    saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'epsc');
    saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
    saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'epsc');
    saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
end

TumorTmptr_flag = 0;

if TumorTmptr_flag == 1
    % clc; clear;
    % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
    % fname = 'e:\Kevin\CapaReal';
    % CaseDate = 'Case0220_1cmFat';
    % load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );

    TumorTmptrMani;

    % fname = strcat( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal', '\', CaseDate );
    % % fname = strcat( 'e:\Kevin\CapaReal', '\', CaseDate );
    % saveas(figure(4), fullfile(fname, 'TumorTmprtr'), 'fig');
    % saveas(figure(4), fullfile(fname, 'TumorTmprtr'), 'jpg');
end

Tmprtr_flag = 0;

if Tmprtr_flag == 1
    clc; clear;
    % load the mat from the end of all simulations
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
    % fname = 'e:\Kevin\CapaReal';
    CaseDate = 'Case0220_1cmFat';
    load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );
    fname = strcat( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal', '\', CaseDate );
    % fname = strcat( 'e:\Kevin\CapaReal', '\', CaseDate );

    flag_XZ_T = 1;
    flag_XY_T = 0;
    flag_YZ_T = 0;

    TmprtrFigs;
    % % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');
end


% figure(7); 
% clf;
% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
% tmpIdx = ( 11 - 1 ) * x_max_vertex * y_max_vertex + ( ( y_max_vertex + 1 ) / 2 - 1 ) * x_max_vertex + 9;
% plot(0: dt / 60: timeNum_all / 60, bar_b(tmpIdx, :), 'k', 'LineWidth', 2.5);