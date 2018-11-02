function Xi = fatXi(TetTmprtr)

    % note that the 36 is the initial temperature 
    TetTmprtr = TetTmprtr + 36;

%     if TetTmprtr < 5 || TetTmprtr > 50
%         error('check the input temperature')
%     end
    Xi = 4 * 1e-7 + 4 * 1e-7 * exp( - (TetTmprtr - 45)^2 / 12 );
end

% 
% figure(41);
% clf;
% TetTmprtrPre = 35: 0.1: 45;
% Xi_pre = 4.41 * 1e-7 + 3.48 * 1e-6 * exp( - (TetTmprtrPre - 45).^2 / 12 );
% plot(TetTmprtrPre, Xi_pre, 'k-', 'LineWidth',2.0);
% hold on;
% 
% TetTmprtrPost = 45: 0.1: 50;
% Xi_post = 3.92 * 1e-6 * ones(size(TetTmprtrPost));
% plot(TetTmprtrPost, Xi_post, 'k-', 'LineWidth',2.0);
% 
% TetTmprtr = 35: 0.1: 50;
% Xi = 2.2549 * 1e-6 * ones(size(TetTmprtr));
% plot(TetTmprtr, Xi, 'k-', 'LineWidth',2.0);
% 
% xlabel('$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$\xi$ (m$^3$/kg/s)','Interpreter','LaTex', 'FontSize', 20);
% saveas(figure(41), 'MuscleXi.jpg', 'jpg');
% 
% figure(42);
% clf;
% TetTmprtrPre = 35: 0.1: 45;
% Xi_pre = 4.00 * 1e-7 + 4.00 * 1e-7 * exp( - (TetTmprtrPre - 45).^2 / 12 );
% plot(TetTmprtrPre, Xi_pre, 'k-', 'LineWidth',2.0);
% hold on;
% 
% TetTmprtrPost = 45: 0.1: 50;
% Xi_post = 8.00 * 1e-7 * ones(size(TetTmprtrPost));
% plot(TetTmprtrPost, Xi_post, 'k-', 'LineWidth',2.0);
% 
% TetTmprtr = 35: 0.1: 50;
% Xi = 6 * 1e-7 * ones(size(TetTmprtr));
% plot(TetTmprtr, Xi, 'k-', 'LineWidth',2.0);
% 
% xlabel('$T$ ($^\circ$C)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$\xi$ (m$^3$/kg/s)','Interpreter','LaTex', 'FontSize', 20);
% saveas(figure(42), 'AdiposeXi.jpg', 'jpg');
% 
% % 