A = 1;
B = 1;
C = A + B;

num = C;                    % licznik: 2
den = conv([1 A], conv([1 B], [1 -1])); % mianownik: (s+1)^2(s-1)

%---------- PODPUNKT A ----------

G_s = tf(num, den)         % transmitancja ciągła

Ts = [0.1, 0.3, 0.5, 1.0];  % czasy próbkowania
G_z = cell(1, length(Ts));

for i = 1:length(Ts)
    disp('czas probkowania: ') 
    Ts(i)
    disp('dyskretyzacja: ')
    G_z{i} = c2d(G_s, Ts(i), 'zoh')  % dyskretyzacja metodą ZOH
end

%---------- PODPUNKT B ----------
N = 50;
u = ones(1, N);          % wejście: skok jednostkowy
y0 = [0, 0, 0];          % początkowe warunki wyjścia y[-1], y[-2], y[-3]
simulate_discrete_response(u, y0, N);

function simulate_discrete_response(u, y0, N)
    % Parametry systemu ciągłego
    A = 1; B = 1; C = A + B;
    num = C;
    den = conv([1 A], conv([1 B], [1 -1]));
    G_s = tf(num, den);

    Ts = [0.1, 0.3, 0.5, 1.0];

    % Pliki tekstowe
    txtFile = fopen('rownania.txt', 'w');
    texFile = fopen('rownania.tex', 'w');

    figure;
    for idx = 1:length(Ts)
        Ts_ = Ts(idx);
        G_z = c2d(G_s, Ts_, 'zoh');
        [b, a] = tfdata(G_z, 'v');

        % --- Równanie różnicowe (tekst) ---
        eq_str = sprintf('y[k] = ');
        for j = 2:length(a)
            eq_str = [eq_str, sprintf('- %.4f*y[k-%d] ', a(j), j-1)];
        end
        for j = 1:length(b)
            eq_str = [eq_str, sprintf('+ %.4f*u[k-%d] ', b(j), j-1)];
        end

        % --- Równanie różnicowe (LaTeX) ---
        eq_latex = '$$y[k] = ';
        for j = 2:length(a)
            eq_latex = [eq_latex, sprintf('- %.4f y[k-%d] ', a(j), j-1)];
        end
        for j = 1:length(b)
            eq_latex = [eq_latex, sprintf('+ %.4f u[k-%d] ', b(j), j-1)];
        end
        eq_latex = [eq_latex, '$$'];

        % --- Zapisz do plików ---
        fprintf(txtFile, 'T_s = %.1f s:\n%s\n\n', Ts_, eq_str);
        fprintf(texFile, '%% T_s = %.1f s\n%s\n\n', Ts_, eq_latex);

        % --- Symulacja ---
        y = zeros(1, N);
        y(1:length(y0)) = y0(1:min(end,length(y)));

        for k = max(length(a), length(b)):N
            for j = 2:length(a)
                y(k) = y(k) - a(j) * y(k - j + 1);
            end
            for j = 1:length(b)
                y(k) = y(k) + b(j) * u(k - j + 1);
            end
        end

        % --- Odpowiedź ciągła ---
        t_cont = 0:Ts_:(N-1)*Ts_;
        [y_cont, ~] = lsim(G_s, u, t_cont);

        % --- Wykres ---
        subplot(2,2,idx);
        stairs(t_cont, y, 'b', 'LineWidth', 1.5); hold on;
        plot(t_cont, y_cont, 'r--', 'LineWidth', 1.2);
        title(['T_s = ' num2str(Ts_) ' s']);
        xlabel('Czas [s]'); ylabel('Wyjście');
        legend('Układ dyskretny', 'Układ ciągły', 'Location', 'best');
        grid on;
    end

    sgtitle('Porównanie: odpowiedź ciągła vs. dyskretna');

    % Zapis wykresu
    saveas(gcf, 'odpowiedz_porownanie.png');

    % Zamknięcie plików
    fclose(txtFile);
    fclose(texFile);
end
