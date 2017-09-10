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

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0908CervixEQStest';
    % fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0816Cervix';
    % % % fname = 'e:\Kevin\CapaReal\Case0220_1cmFat';
    % % CaseDate = 'Case0622_PHI_enhancex';
    CaseName = 'Cervix';
    % load( strcat(fname, '\BasicParameters0717.mat') );
    % load( strcat(fname, '\', CaseName, '.mat'), 'bar_x_my_gmresPhi' );
    % rho           = [   1,  1020,   1020, 242.6,  697,  1790,   900 ]';
    
    E_flag = 1;
    PhiDstrbtn_Cervix;

    % % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'fig');
    % saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
    % % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'fig');
    % saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
    % % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'fig');
    % saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
    % % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'fig');
    % saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
    % % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'fig');
    % saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
    % % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'fig');
    % saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
end

TumorTmptr_flag = 0;

if TumorTmptr_flag == 1
    clc; clear;
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    load( strcat(fname, '\BasicParameters.mat') );
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    load( strcat(fname, '\', 'Tmprtr2cm0717Report.mat'), 'bar_b' );

    % chose the maximum temperature.
    max_flag = 0;

    TumorTmptr_FW;

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    % saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'fig');
    saveas(figure(4), fullfile(fname, 'TotalQmet42000TumorTmprtr'), 'jpg');
end

Tmprtr_flag = 0;

if Tmprtr_flag == 1
    clc; clear;
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    load( strcat(fname, '\BasicParameters.mat') );
    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    load( strcat(fname, '\', 'Tmprtr2cm0717Report.mat'), 'bar_b', 'MedTetTable', 'MedTetTableCell' );
    loadThermalParas;

    T_flagXZ = 1;
    T_flagXY = 1;
    T_flagYZ = 1;

    % TmprtrDstrbtn
    T_plot;

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0717LungEQS';
    % saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'fig');
    saveas(figure(21), fullfile(fname, strcat(CaseName, 'TmprtrXZ')), 'jpg');
    % saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'fig');
    saveas(figure(22), fullfile(fname, strcat(CaseName, 'TmprtrXY')), 'jpg');
    % saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'fig');
    saveas(figure(23), fullfile(fname, strcat(CaseName, 'TmprtrYZ')), 'jpg');
end


% figure(7); 
% clf;
% set(gca,'fontsize',18);
% set(gca,'LineWidth',2.0);
% tmpIdx = ( 11 - 1 ) * x_max_vertex * y_max_vertex + ( ( y_max_vertex + 1 ) / 2 - 1 ) * x_max_vertex + 9;
% plot(0: dt / 60: timeNum_all / 60, bar_b(tmpIdx, :), 'k', 'LineWidth', 2.5);