% clc; clear; 
% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% % % fname = 'e:\Kevin\CapaReal\Case0212Qmet8000';
% load( strcat(fname, '\Power300.mat') );

% tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
% tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
% tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% % TmprtrEnd = squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :));
% TtrVolTable = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
% TtrVolTable = BuildTtrTable( shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max );

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0212Qmet8000';
% save( strcat(fname, '\TtrVolTable.mat') );
% load('TtrVolTable.mat');

TumorVol = 0;
PntTtrVol = zeros(6, 8);
PntSegMed = zeros(6, 8);
PntSARSeg = zeros(6, 8);
Phi = zeros(x_idx_max, y_idx_max, z_idx_max);
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    Phi(m, n, ell) = bar_x_my_gmres(idx);
end

disp('time to calculate the tumor volume');
tic;
Num = 0;
TumorSAR = 0;
SAR_vol_arr = [];
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 15
        % PntTtrVol = squeeze(TtrVolTable(m, n, ell, :, :));
        PntSegMed = squeeze(SegMed(m, n, ell, :, :));
        [ PntSARSeg, PntTtrVol ] = calPntSAR( m, n, ell, Phi, shiftedCoordinateXYZ, PntSegMed, x_idx_max, y_idx_max, sigma, rho );
        Num      = Num + length(find(PntSegMed == 5));
        TumorVol = TumorVol + sum(PntTtrVol( find(PntSegMed == 5) ));
        TumorSAR = TumorSAR + sum(PntSARSeg( find(PntSegMed == 5) ));
        SAR_vol_arr = vertcat(SAR_vol_arr, PntSARSeg( find(PntSegMed == 5) ).* PntTtrVol( find(PntSegMed == 5) ) );
    end
end
toc;
TumorVol
% TumorSAR / Num
sum(SAR_vol_arr / TumorVol)
