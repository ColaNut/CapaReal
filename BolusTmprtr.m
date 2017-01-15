clc; clear;
fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
CaseDate = 'Case0109';
load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );

tumor_m = tumor_x / dx + air_x / (2 * dx) + 1;
tumor_n = tumor_y / dy + h_torso / (2 * dy) + 1;
tumor_ell = tumor_z / dz + air_z / (2 * dz) + 1;

figure(4); 
clf;
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'k', 'LineWidth', 2.5);
hold on;
set(gca,'fontsize',18);
set(gca,'LineWidth',2.0);
box on;
xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
axis( [ 0, 50, 35, 50 ] );

fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
CaseDate = 'Case0111Bolus15Degree';
load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );
plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'b--', 'LineWidth', 2.5);
hold on;

% fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal';
% CaseDate = 'Case0111Bolus25Degree';
% load( strcat(fname, '\', CaseDate, '\', CaseDate, '.mat') );
% plot(0: dt / 60: T_end / 60, squeeze(TmprtrTau(tumor_m, tumor_n, tumor_ell, :)), 'b--', 'LineWidth', 2.5);

