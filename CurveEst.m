load('D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\Case0103\Case0103.mat');

Up = [14, 30 ;
      15, 31; 
      16, 32; 
      17, 32;
      18, 32;
      19, 33;
      20, 33;
      21, 33;
      22, 34;
      23, 34;
      24, 34;
      25, 34;
      26, 34 ];

Dwn = [10, 17 ;
      10, 16; 
      11, 15; 
      12, 14;
      13, 13;
      14, 12;
      15, 11;
      16, 10;
      17, 9;
      18, 8;
      19, 7;
      20, 7;
      21, 7;
      22, 6;
      23, 6;
      24, 6;
      25, 6;
      26, 6;
      27, 6;
      28, 6;
      29, 6;
      30, 6 ];

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

TmpXZ = squeeze( shiftedCoordinateXYZ(:, tumor_n, :, :) );
TmpXZ(:, :, 2) = [];

SumUp = 0;
SumDwn = 0;
LUp = size(Up, 1);
LDn = size(Dwn, 1);
for idx = 1: 1: LUp - 1
    SumUp = SumUp + norm( squeeze(TmpXZ( Up(idx, 1), Up(idx, 2), : ) ) - squeeze( TmpXZ( Up(idx + 1, 1), Up(idx + 1, 2), : ) ) );
end

for idx = 1: 1: LDn - 1
    SumDwn = SumDwn + norm( squeeze(TmpXZ( Dwn(idx, 1), Dwn(idx, 2), : ) ) - squeeze( TmpXZ( Dwn(idx + 1, 1), Dwn(idx + 1, 2), : ) ) );
end

SumUp
SumDwn