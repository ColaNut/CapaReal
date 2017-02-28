function [ EPSILON_R, SIGMA ] = getEpsSig(f, S, T)

    EPSILON_R = 0;
    SIGMA = 0;

    epsilon_inf = 4.5;
    % f = 8 * 10^6;
    % f = f_arr(idx);
    epsilon_0_air = 8.854/1e12;
    % S = 4; % parts per thousand: 0.4 %
    N = S * ( 1.707/1e2 + 1.205/1e5 * S + 4.058/1e9 * S^2 );
    % T = 37;

    aN = 1 - 0.2551 * N + 5.151/1e2 * N^2 - 6.889/1e3 * N^3;
    bNT = 0.1463/1e2 * N * T + 1 - 0.04896 * N - 0.02967 * N^2 + 5.644/1e3 * N^3;

    epT0 = 87.74 - 0.40008 * T + 9.398/1e4 * T^2 + 1.410/1e6 * T^3;
    twoPiTauT0 = 1.1109/1e10 - 3.824/1e12 * T + 6.938/1e14 * T^2 - 5.096/1e16 * T^3;

    epsilon_0 = epT0 * aN;
    twoPiTau = twoPiTauT0 * bNT;

    Delta = 25 - T;
    alpha = 2.033/1e2 + 1.266/1e4 * Delta + 2.464/1e6 * Delta^2 ...
        - S * ( 1.849/1e5 - 2.551/1e7 * Delta + 2.551/1e8 * Delta^2 );
    sigma25S = S * ( 0.182521 - 1.46192/1e3 * S + 2.09324/1e5 * S^2 - 1.28205/1e7 * S^3 );
    sigma = sigma25S * exp( - Delta * alpha );

    K = epsilon_inf + ( epsilon_0 - epsilon_inf ) / ( 1 - twoPiTau * j * f ) ...
                + j * sigma / ( 2 * pi * epsilon_0_air * f );
    EPSILON_R = real(K);
    SIGMA = imag(K) * ( 2 * pi * epsilon_0_air * f );
end