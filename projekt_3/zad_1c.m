syms s z n
A = 1;
B = 1;
C = A + B;
%%
% 
% $$e^{\pi i} + 1 = 0$$
% 

G1_s = C / ((s + A)*(s + B)*(s - 1));

% Obliczenie odwrotnej transformaty Laplace’a (odpowiedź impulsowa)
g1_t = ilaplace(G1_s);

% Obliczenie transformaty Z z odpowiedzi impulsowej
g1_n = subs(g1_t, 't', n);  % zamiana t -> n, dyskretyzacja
G1_z = ztrans(g1_n, n, z);

pretty(G1_z)
