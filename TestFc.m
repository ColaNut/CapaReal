% function [ AxA ] = TestFc( a, b, c )

% AxA = ones(9, 1);

% end
% AxA = cell(2, 1);
% AxA{1} = 30;
% AxA{2} = 60;

% % CxC = horzcat( cell(2, 1), AxA )

% % BxB = 0;
% x = 1;
% AxA = x;
% BxB = x + 1;

% end

% a = 1;
% try
%     if a == 1
%         a = 9
%         error('testing catch funtion');
%     end
% catch a
%     ;% a = 3
% end
% b = 6
% % xAx = complex(a,0);

% idx = 4320;
%     tmp_m = mod( idx, x_idx_max );
%     if tmp_m == 0
%         m = x_idx_max;
%     else
%         m = tmp_m;
%     end

%     if mod( idx, x_idx_max * y_idx_max ) == 0
%         n = y_idx_max;
%     else
%         n = ( mod( idx, x_idx_max * y_idx_max ) - m ) / x_idx_max + 1;
%     end
    
%     ell = int64( ( idx - m - ( n - 1 ) * x_idx_max ) / ( x_idx_max * y_idx_max ) + 1 );

%     [ m, n, ell ]

% x2 = [2 5; 2 5; 8 8];
% y2 = [4 0; 8 2; 4 0];
% patch(x2,y2,'green')

% v2 = [2 4; 2 8; 8 4; 5 0; 5 2; 8 0];
% f2 = [1 2 3 5;
%       4 5 6 NaN];
% c  = [0; 1];
% patch('Faces', f2,'Vertices', v2, 'FaceColor', c)
% figure(8);
% v = [2 4 1; 2 8 1; 8 4 1; 5 0 1; 5 2 1; 8 0 1];
% f = [1 2 3; 4 5 6];
% col = [0; - Inf];
% patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% colorbar

% figure(4);
% loadParas;

m = tumor_x / dx + air_x / (2 * dx) + 1;
n = tumor_y / dy + h_torso / (2 * dy) + 1;
ell = tumor_z / dz + air_z / (2 * dz) + 1;

[m, n, ell]

% % x = ( m - 1 ) * dx - air_x / 2;
% % y = ( n - 1 ) * dy - h_torso / 2;
% % z = ( ell - 1 ) * dz - air_z / 2;
% paras2dXZ = genParas2d( tumor_y, paras, dx, dy, dz );
% plotMap( paras2dXZ, dx, dz );
% % paras2d = [ air_x, air_z, bolus_a, bolus_b, skin_a, skin_b, muscle_a, muscle_b, ...
% %         l_lung_x, l_lung_z, l_lung_a_prime, l_lung_c_prime, ...
% %         r_lung_x, r_lung_z, r_lung_a_prime, r_lung_c_prime, ...
% %         tumor_x, tumor_z, tumor_r_prime ];
% % [x, z] * 100;

% % x_idx_max = air_x / dx + 1;
% % y_idx_max = h_torso / dy + 1;
% % z_idx_max = air_z / dz + 1;

% x = ( paras2dXZ(13) + paras2dXZ(15) );
% z = ( paras2dXZ(14) + paras2dXZ(16) );
% m = ( x / dx ) + air_x / ( 2 * dx ) + 1;
% ell = ( z / dz ) + air_z / ( 2 * dz ) + 1;
% [m, ell]



figure(1); 
plot(0: dt: T, squeeze(TmprtrTau(12, 9, 11, :)), 'Color', [0, 0, 0], 'LineWidth', 2.5);
set(gca,'fontsize',20);
xlabel('$t$ (s)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);