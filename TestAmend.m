clc; clear; 
fname = 'D:\Kevin\CapaReal\0715';
CaseName = 'Power250';
load( strcat(fname, '\', CaseName, '.mat') );
rho           = [   1,  1020,   1020, 394,  697,  1790,   900 ]';
save( strcat(fname, '\', CaseName, '.mat') );

fname = 'D:\Kevin\CapaReal\0715';
CaseName = 'Power280';
load( strcat(fname, '\', CaseName, '.mat') );
rho           = [   1,  1020,   1020, 394,  697,  1790,   900 ]';
save( strcat(fname, '\', CaseName, '.mat') );

fname = 'D:\Kevin\CapaReal\0715';
CaseName = 'Power300';
load( strcat(fname, '\', CaseName, '.mat') );
rho           = [   1,  1020,   1020, 394,  697,  1790,   900 ]';
save( strcat(fname, '\', CaseName, '.mat') );
