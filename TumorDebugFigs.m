clc; clear;
load( 'Power300.mat' );
tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

% XZ
figure(21); 
clf;
paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
plotMap( paras2dXZ, dx, dz );
plotGridLineXZ( shiftedCoordinateXYZ, tumor_n );

% XY
figure(22); 
clf;
paras2dXY = genParas2dXY( tumor_z, paras, dx, dy, dz );
plotXY( paras2dXY, dx, dy );
plotGridLineXY( shiftedCoordinateXYZ, tumor_ell );

% YZ
figure(23); 
clf;
paras2dYZ = genParas2dYZ( tumor_x, paras, dy, dz );
plotYZ( paras2dYZ, dy, dz );
plotGridLineYZ( shiftedCoordinateXYZ, tumor_m );
