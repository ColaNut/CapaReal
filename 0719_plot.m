saveas(figure(1), fullfile(fname, strcat(CaseName, 'PhiXZ')), 'jpg');
saveas(figure(2), fullfile(fname, strcat(CaseName, 'SARXZ')), 'jpg');
saveas(figure(6), fullfile(fname, strcat(CaseName, 'PhiXY')), 'jpg');
saveas(figure(7), fullfile(fname, strcat(CaseName, 'SARXY')), 'jpg');
saveas(figure(11), fullfile(fname, strcat(CaseName, 'PhiYZ')), 'jpg');
saveas(figure(12), fullfile(fname, strcat(CaseName, 'SARYZ')), 'jpg');
saveas(figure(21), strcat(CaseName, 'T_XZ','.jpg'));
saveas(figure(22), strcat(CaseName, 'T_XY','.jpg'));
saveas(figure(23), strcat(CaseName, 'T_YZ','.jpg'));