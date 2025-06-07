clc;
clear;

% --- Lepsze parametry PID dla stabilności ---
k_p = 1.5;
k_i = 1.0;
k_d = 2.0;

% --- Czas symulacji ---
dt = 0.0005;        % mniejszy krok czasowy
T = 1;
t = 0:dt:T;
N = length(t);

% --- Inicjalizacja ---
y = zeros(1, N);
u = zeros(1, N);
e = zeros(1, N);
int_e = 0;
prev_e = 0;

y1 = 0; y2 = 0; y3 = 0;

r = ones(1, N); % skok jednostkowy

for k = 2:N
    % --- PID regulator ---
    e(k) = r(k) - y(k-1);
    int_e = int_e + e(k)*dt;
    der_e = (e(k) - prev_e) / dt;
    prev_e = e(k);

    u(k) = k_p * e(k) + k_i * int_e + k_d * der_e;

    % --- Saturacja sterowania (opcjonalna ochrona) ---
    u(k) = max(min(u(k), 100), -100);  % ograniczamy sygnał sterujący

    % --- Symulacja obiektu: y''' - 6y'' + 11y' - 6y = u ---
    y3_next = 6*y2 - 11*y1 + 6*y(k-1) + u(k);
    y2 = y2 + y3_next * dt;
    y1 = y1 + y2 * dt;
    y(k) = y(k-1) + y1 * dt;
end

% --- Wykres ---
plot(t, y, 'b', 'LineWidth', 1.3);
xlabel('Czas [s]'); ylabel('Wyjście y(t)');
title('Poprawiona odpowiedź skokowa (PID, stabilna)');
grid on;

% --- Parametry odpowiedzi ---
y_ss = y(end);
overshoot = (max(y) - 1) * 100;
rise_time_idx = find(y > 0.9, 1);
settling_idx = find(abs(y - 1) < 0.02, 1);

fprintf('\n📈 Parametry odpowiedzi skokowej:\n');
fprintf('Uchyb w stanie ustalonym: %.5f\n', abs(1 - y_ss));
fprintf('Wartość końcowa: %.5f\n', y_ss);
fprintf('Maksymalne przeregulowanie: %.2f%%\n', overshoot);
fprintf('Czas narastania (do 90%%): %.2f s\n', t(rise_time_idx));
fprintf('Czas ustalania (±2%%): %.2f s\n', t(settling_idx));
