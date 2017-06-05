% clc; clear;
A_flag = 1;

% Need to modify the 'save' in the PhiDstrbtn.m to make it accord with the 'load' in TmprtrFigs.m
if A_flag == 1
    % clc; clear;
    % load('0503K_0005.mat');
    
    % CaseName = 'Power300';
    % load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0220_1cmFat\', CaseName, '.mat') );
    % load('Case0220_1cmFat.mat');
    % load( strcat('e:\Kevin\CapaReal\Case0220_1cmFat', '\', CaseName, '.mat') );

    flag_XZ = 0;
    flag_XY = 0;
    flag_YZ = 1;
    
    Fname = 'M3_preBC_Case1_TEST';
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0530MQSDirection';
    % CaseName = '0321';
    % fname = 'e:\Kevin\CapaReal\Case0220_1cmFat';
    % CaseDate = 'Case0220_1cmFat';
    % ADstrbtn_Directed;
    ADstrbtn;
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
end

TumorTmptr_flag = 0;

if TumorTmptr_flag == 1
    clc; clear;
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
    % fname = 'e:\Kevin\CapaReal';
    CaseDate = 'Case0220_1cmFat';
    load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );

    TumorTmptrMani;

    fname = strcat( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal', '\', CaseDate );
    % % fname = strcat( 'e:\Kevin\CapaReal', '\', CaseDate );
    saveas(figure(4), fullfile(fname, 'TumorTmprtr'), 'fig');
    saveas(figure(4), fullfile(fname, 'TumorTmprtr'), 'jpg');
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