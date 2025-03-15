getter_A = "Podaj A";
A = input(getter_A);

getter_B = "Podaj B";
B = input(getter_B);

C = A + B;
syms t s;

f_1 = A * t * exp(-B*t);
f_2 = A - exp(-2*t)*(sin(t-B)-cos(t-B)+sin(t-C)*cos(t-C));

F_1 = laplace(f_1);
F_2 = laplace(f_2, t, s);

F_1_simple = simplify(F_1);
F_2_simple = simplify(F_2);

pretty(F_1_simple)
pretty(F_2_simple)