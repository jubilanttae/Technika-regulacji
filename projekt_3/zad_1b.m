% zad_1b.m – Symulacja odpowiedzi systemów dyskretnych na skok i impuls
close all; clear;

N = 30; % liczba próbek

% Wejścia
u_impulse = [1 zeros(1, N)];
u_step = ones(1, N+1);

% Dwie kombinacje stanów początkowych
ICs = {
    [0 0],    % IC set 1
    [1 -1]    % IC set 2
};

plot_counter = 1;

%% System I
for ic = 1:length(ICs)
    % Impuls
    u = u_impulse;
    u_ext = [0, 0, u];       % u[-2], u[-1], u[0], ..., u[N]
    y = zeros(1, N+1);
    y_prev = ICs{ic}(2);     % y[-1] (używamy drugiego elementu IC)
    for k_idx = 1:N+1
        % k_idx odpowiada chwili k=0,1,...,N
        u_k = u_ext(k_idx + 2);   % u[k]
        u_k_minus_1 = u_ext(k_idx + 1); % u[k-1]
        u_k_minus_2 = u_ext(k_idx);     % u[k-2]
        
        y(k_idx) = -y_prev + 2*u_k + 5*u_k_minus_1 - 3*u_k_minus_2;
        y_prev = y(k_idx);
    end
    figure('Visible','off'); stem(0:N, y);
    title(['System I - Impuls - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['impuls' num2str(plot_counter) '.jpg']);

    % Skok
    u = u_step;
    u_ext = [0 0 u];
    y = zeros(1, N+1);
    y_prev = ICs{ic}(2);
    for k_idx = 1:N+1
        y(k_idx) = -y_prev + 2*u_ext(k_idx+2) + 5*u_ext(k_idx+1) - 3*u_ext(k_idx);
        y_prev = y(k_idx);
    end
    figure('Visible','off'); stem(0:N, y);
    title(['System I - Skok - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['skok' num2str(plot_counter) '.jpg']);

    plot_counter = plot_counter + 1;
end

%% System II
for ic = 1:length(ICs)
    % Impuls
    u = u_impulse;
    y = zeros(1, N+1);
    y_prev = ICs{ic}(2);  % y[k-1]
    for k_idx = 1:N+1
        y(k_idx) = 0.5 * (u(k_idx) - y_prev);
        y_prev = y(k_idx);
    end
    figure('Visible','off'); stem(0:N, y);
    title(['System II - Impuls - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['impuls' num2str(plot_counter) '.jpg']);

    % Skok
    u = u_step;
    y = zeros(1, N+1);
    y_prev = ICs{ic}(2);
    for k_idx = 1:N+1
        y(k_idx) = 0.5 * (u(k_idx) - y_prev);
        y_prev = y(k_idx);
    end
    figure('Visible','off'); stem(0:N, y);
    title(['System II - Skok - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['skok' num2str(plot_counter) '.jpg']);

    plot_counter = plot_counter + 1;
end

%% System III (poprawiony)
for ic = 1:length(ICs)
    % Impuls
    u = u_impulse;
    u_ext = [0, 0, 0, u];    % u[-3], u[-2], u[-1], u[0], ..., u[N]
    y = zeros(1, N+3);       % y[-2], y[-1], y[0], ..., y[N]
    y(1:2) = ICs{ic};        % y[-2], y[-1]
    for n = 3:N+3
        % n=3: k=0; n=4: k=1; ... n=N+3: k=N
        y(n) = y(n-1) - y(n-2) + ... % POPRAWIONE ZNAKI
               u_ext(n+1) + u_ext(n) - 3*u_ext(n-2);
    end
    y_plot = y(3:3+N); % y[0] do y[N]
    figure('Visible','off'); stem(0:N, y_plot);
    title(['System III - Impuls - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['impuls' num2str(plot_counter) '.jpg']);

    % Skok
    u = u_step;
    u_ext = [zeros(1,3) u];
    y = zeros(1, N+3);
    y(1:2) = ICs{ic};
    for n = 4:N+3
        y(n) = -y(n-1) + y(n-2) + u_ext(n) + u_ext(n-1) - 3*u_ext(n-3);
    end
    y_plot = y(3:end);
    figure('Visible','off'); stem(0:N, y_plot);
    title(['System III - Skok - Kombinacja ', num2str(ic)]); xlabel('k'); ylabel('y[k]');
    saveas(gcf, ['skok' num2str(plot_counter) '.jpg']);

    plot_counter = plot_counter + 1;
end
