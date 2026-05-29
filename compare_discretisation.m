%% Compare discretisation methods for G(s) = 1/(s^2 + 0.5*s + 1)
% Methods: Matched, Tustin (bilinear), exact ZOH via matrix exponential.

clear; clc; close all;

%% Continuous-time plant
num = 1;
den = [1, 0.5, 1];
G_c = tf(num, den);

Ts = 2;   % sample time [s]

%% Discretisation methods
G_matched = c2d(G_c, Ts, 'matched');
G_tustin = c2d(G_c, Ts, 'tustin');
G_exact = exact_zoh_discretisation(G_c, Ts);

%% Step response comparison
t_end = 20;
t_cont = linspace(0, t_end, 2000);
t_disc = 0:Ts:t_end;

[y_c, t_c] = step(G_c, t_cont);
[y_matched, ~] = step(G_matched, t_disc);
[y_tustin, ~] = step(G_tustin, t_disc);
[y_exact, ~] = step(G_exact, t_disc);

figure('Name', 'Discretisation comparison');
hold on; grid on;

plot(t_c, y_c, 'k', 'LineWidth', 2, 'DisplayName', 'Continuous');
plot(t_disc, y_matched, 'b.', 'MarkerSize', 30, 'LineStyle', 'none', 'DisplayName', sprintf('Matched (T_s = %.2f s)', Ts));
plot(t_disc, y_tustin, 'g.', 'MarkerSize', 30, 'LineStyle', 'none', 'DisplayName', sprintf('Tustin (T_s = %.2f s)', Ts));
plot(t_disc, y_exact, 'r.', 'MarkerSize', 30, 'LineStyle', 'none', 'DisplayName', sprintf('Exact (matrix exponential, T_s = %.2f s)', Ts));

xlabel('Time [s]');
ylabel('Output');
title('Step response: continuous vs discretised models');
legend('Location', 'best');

%% Local function: exact ZOH discretisation via augmented matrix exponential
function G_d = exact_zoh_discretisation(G_c, Ts)
    sys = ss(G_c);
    [Ac, Bc, Cc, Dc] = ssdata(sys);

    n = size(Ac, 1);
    m = size(Bc, 2);

    M = expm([Ac, Bc; zeros(m, n + m)] * Ts);
    Ad = M(1:n, 1:n);
    Bd = M(1:n, n + (1:m));

    G_d = ss(Ad, Bd, Cc, Dc, Ts);
end
