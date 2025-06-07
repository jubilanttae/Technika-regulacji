% Dwa czasy próbkowania
T_values = [0.1, 0.5];

% Symboliczne zmienne
syms k
y_k = sym('y_k', [1 3]); % y[k], y[k+1], y[k+2]

for T = T_values
    fprintf('\n--- Równanie III dla T = %.2f ---\n', T);
    
    % Aproksymacje różnicowe (Euler do przodu)
    y_diff_1 = (y_k(2) - y_k(1)) / T;
    y_diff_2 = (y_k(3) - 2*y_k(2) + y_k(1)) / T^2;

    % Lewa strona równania różniczkowego
    lhs = y_diff_2 + 3 * y_diff_1 + y_k(1);

    % Prawa strona – t = k*T
    rhs = k * T;

    % Równanie różnicowe (symboliczne)
    eqn_discrete = simplify(lhs == rhs);
    disp(eqn_discrete);
end
