script1 = 0;
% plot the dielectric properties at three frequencies
if script1 == 1
    clc; clear;
    f_arr = [ 10^6, 10^7, 10^8 ];
    epsilon_r_arr = zeros(size(f_arr));
    sigma_arr = zeros(size(f_arr));
    S_arr = [0, 2, 4, 6, 8 ];
    T = 25;
    color_arr = [ 'r', 'g', 'b', 'y', 'k' ];

    figure(1);
    clf;
    figure(2);
    clf;
    S_arrSize = length(S_arr);
    for idx = 1: 1: S_arrSize
        plotDiCurve( f_arr, S_arr(idx), T, color_arr(idx), 1 )
    end

    figure(1);
    plot( f_arr, 78.66 * ones(size(f_arr)), 'r--', 'LineWidth', 3 );
    plot( f_arr, 75.90 * ones(size(f_arr)), 'k--', 'LineWidth', 3 );
    ax = gca;
    set(ax, 'XTick', [ 10^6, 10^7, 10^8 ] );
    set(ax, 'XTickLabel', {'6','7','8'} );
    xlabel('log( frequency )', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$\epsilon_r$','Interpreter','LaTex', 'FontSize', 20);
    set(gca,'fontsize',18);
    set(gca,'LineWidth',2.0);
    axis( [ 10^6, 4 * 10^8, 75, 79 ] );
    legend(strcat(num2str(S_arr(1) / 10), '%', '[1]' ), strcat(num2str(S_arr(2) / 10), '%', '[1]' ), strcat(num2str(S_arr(3) / 10), '%', '[1]' ), ...
            strcat(num2str(S_arr(4) / 10), '%', '[1]' ), strcat(num2str(S_arr(5) / 10), '%', '[1]' ), ...
            strcat(num2str(S_arr(1) / 10), '%', '[2]'), strcat(num2str(S_arr(5) / 10), '%', '[2]') );
    figure(2);
    ax = gca;
    set(ax, 'XTick', [ 10^6, 10^7, 10^8 ] );
    set(ax, 'XTickLabel', {'6','7','8'} );
    set(ax, 'YTick', [0: 0.2: 1.6] );
    set(ax, 'YTickLabel', {'0','0.2','0.4','0.6','0.8','1.0','1.2','1.4','1.6'} );
    xlabel('log( frequency )', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$\sigma$ ($S/m$)','Interpreter','LaTex', 'FontSize', 20);
    set(gca,'fontsize',18);
    set(gca,'LineWidth',2.0);
    axis( [ 10^6, 4 * 10^8, 0, 1.6 ] );
    legend(strcat(num2str(S_arr(1) / 10), '%'), strcat(num2str(S_arr(2) / 10), '%'), strcat(num2str(S_arr(3) / 10), '%'), ...
            strcat(num2str(S_arr(4) / 10), '%'), strcat(num2str(S_arr(5) / 10), '%') );

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
    saveas(figure(1), fullfile(fname, 'EpsilonTest'), 'jpg');
    % saveas(figure(2), fullfile(fname, 'SigmaTest'), 'jpg');
end

script2 = 1;

if script2 == 1
    clc; clear;
    
    f = 10^7;
    S_arr = [ 1.1, 2.9, 6.0, 16.3, 35.0 ];
    T = 25;

    epsilon_r_arr = zeros(size(S_arr));
    sigma_arr = zeros(size(S_arr));

    S_arrSize = length(S_arr);
    for idx = 1: 1: S_arrSize
        [ epsilon_r_arr(idx), sigma_arr(idx) ] = getEpsSig(f, S_arr(idx), T);
    end

    epsilon_r_Lit = [ 79.4, 79.4, 82.33, 88.03, 112.5 ];
    sigma_Lit = [ 0.25, 0.60, 1.17, 2.71, 5.57 ];
    figure(6);
    clf;
    plot( S_arr / 10, epsilon_r_arr, 'ko-', 'MarkerFaceColor', 'k', 'LineWidth', 2 );
    hold on;
    plot( S_arr / 10, epsilon_r_Lit, 'bo-', 'MarkerFaceColor', 'b', 'LineWidth', 2 );
    set(gca,'fontsize',18);
    set(gca,'LineWidth',2.0);
    xlabel('concentration of NaCl ($\%$)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$\epsilon_r$','Interpreter','LaTex', 'FontSize', 20);
    legend( '[1]', '[3]', 'Location','northwest' );
    figure(7);
    clf;
    plot( S_arr / 10, sigma_arr, 'ko-', 'MarkerFaceColor', 'k', 'LineWidth', 2 );
    hold on;
    plot( S_arr / 10, sigma_Lit, 'bo-', 'MarkerFaceColor', 'b', 'LineWidth', 2 );
    set(gca,'fontsize',18);
    set(gca,'LineWidth',2.0);
    xlabel('concentration of NaCl ($\%$)', 'Interpreter','LaTex', 'FontSize', 20);
    ylabel('$\sigma$ (S/m)','Interpreter','LaTex', 'FontSize', 20);
    legend( '[1]', '[3]', 'Location','northwest' );

    fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\TexFile2';
    saveas(figure(6), fullfile(fname, 'EpsilonCmp3'), 'jpg');
    saveas(figure(7), fullfile(fname, 'SigmaCmp3'), 'jpg');

end
