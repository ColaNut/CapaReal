function plotDiCurve( f_arr, S, T, ColorTex, FigNum )

Freq_size = length(f_arr);
EPSILON_R = zeros(length(f_arr), 1);
SIGMA = zeros(length(f_arr), 1);

for idx = 1: 1: Freq_size
    f = f_arr(idx);
    [ EPSILON_R(idx), SIGMA(idx) ] = getEpsSig(f, S, T);
end

figure( FigNum );
semilogx( f_arr, EPSILON_R, ColorTex, 'LineWidth', 3 )
hold on
figure( FigNum + 1 );
semilogx( f_arr, SIGMA, ColorTex, 'LineWidth', 3 );
hold on;

end