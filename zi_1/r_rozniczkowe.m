syms x(t) a A w b s X

% equation
eq = diff(x, t) + a*x == A*sin(w*t);

% condition
cond = x(0) == b;

% symbolic solution
xSol(t) = dsolve(eq, cond);
pretty(xSol);

% graph generating function
function plot_xt(a_val, A_val, w_val, b_val)
    syms x(t) a A w b
    eq = diff(x, t) + a*x == A*sin(w*t);
    cond = x(0) == b;
    xSol(t) = dsolve(eq, cond);
    xNum = subs(xSol, [a, A, w, b], [a_val, A_val, w_val, b_val]);
    xFun = matlabFunction(xNum);
    t_vals = linspace(0, 10, 1000);
    plot(t_vals, xFun(t_vals), 'LineWidth', 2)
    xlabel('t'), ylabel('x(t)')
    title(sprintf('a = %.1f, A = %.1f, w = %.1f, b = %.1f', a_val, A_val, w_val, b_val))
    grid on
end

% function call (with parameters)
plot_xt(1,1,3,0)