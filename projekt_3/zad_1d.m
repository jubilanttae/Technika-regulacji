syms z n E

% Zdefiniowanie transformacji Z z poprzedniego podpunktu
G1_z = z/(2*(z - E)) - z/(2*(z - exp(-1))) - (z*E)/(2*(z*E - 1));

% Obliczenie odwrotnej transformaty Z
g1_n_z = iztrans(G1_z, z, n)

% Oryginalna odpowiedź impulsowa (wcześniejsza)
syms s t
A = 1;
B = 1;
C = A + B;

G1_s = C / ((s + A)*(s + B)*(s - 1));
g1_t = ilaplace(G1_s);          % odpowiedź impulsowa w czasie ciągłym
g1_n_original = subs(g1_t, t, n);  % dyskretyzacja: t = n

% Porównanie wyników symbolicznie
simplify(g1_n_z - g1_n_original)
