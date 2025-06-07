% Parametry
omega = 1;
T1 = 0.1;  % pierwszy czas próbkowania
T2 = 0.5;  % drugi czas próbkowania

% Symboliczne zmienne
syms y(t)

% Równanie różniczkowe
eqn = diff(y,2) + 3*diff(y,1) + y == sin(omega*t);

% Dyskretyzacja przy T = 0.1
disp('--- Dla T = 0.1 ---');
T = T1;
y_k = sym('y_k', [1 3]); % y[k], y[k+1], y[k+2]
syms k

% Przybliżenia numeryczne (Euler do przodu)
y_diff_1 = (y_k(2) - y_k(1)) / T;
y_diff_2 = (y_k(3) - 2*y_k(2) + y_k(1)) / T^2;

% Zastąp wyrażenia w równaniu
lhs = y_diff_2 + 3*y_diff_1 + y_k(1);
rhs = sin(omega * k * T);
eqn_discrete = simplify(lhs == rhs)

% Dyskretyzacja przy T = 0.5
disp('--- Dla T = 0.5 ---');
T = T2;
y_diff_1 = (y_k(2) - y_k(1)) / T;
y_diff_2 = (y_k(3) - 2*y_k(2) + y_k(1)) / T^2;

lhs = y_diff_2 + 3*y_diff_1 + y_k(1);
rhs = sin(omega * k * T);
eqn_discrete = simplify(lhs == rhs)
