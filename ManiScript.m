PhiSAR_flag = 0;
TumorTmptr_flag = 0;
Tmprtr_flag = 1;

if PhiSAR_flag == 1
    clc; clear;
    CaseName = 'Power300';
    load( strcat('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108\', CaseName, '.mat') );

    flag_XZ = 1;
    flag_XY = 1;
    flag_YZ = 1;

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0108';
    CaseDate = 'Case0108';
    PhiDstrbtn;
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
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');_
end

if TumorTmptr_flag == 1
    clc; clear;
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
    CaseDate = 'Case0108';
    load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );

    TumorTmptrMani;

    fname = strcat( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal', '\', CaseDate );
    % saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
    % saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
end

if Tmprtr_flag == 1
    clc; clear;
    % load the mat from the end of all simulations
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
    CaseDate = 'Case0103';
    load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );
    fname = strcat( 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal', '\', CaseDate );

    flag_XZ_T = 1;
    flag_XY_T = 0;
    flag_YZ_T = 0;

    TmprtrFigs;
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');
end