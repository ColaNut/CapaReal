% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0115Bolus1cm';
% fname = 'e:\Kevin\CapaReal\Case0115Bolus1cm';
% load( strcat(fname, '\Case0115Bolus1cm.mat') );

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% TmprtrEnd = squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :));
% TtrVolTable = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
% TtrVolTable = BuildTtrTable( shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max );
load('TtrVolTable.mat');

TumorVol = 0;

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable(m, n, ell) == 5 || mediumTable(m, n, ell) == 0
        PntTtrVol = squeeze(TtrVolTable(m, n, ell, :, :));
        PntSegMed = squeeze(SegMed(m, n, ell, :, :));

        TumorVol = TumorVol + sum(PntTtrVol( find(PntSegMed == 5) ));
    end
end

TumorVol