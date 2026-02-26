clc;
clear;

fprintf("==============================================\n");
fprintf(" Calculadora de Matemática para Faculdade\n");
fprintf(" (Básico -> Avançado: Álgebra, Cálculo 1/2/3,\n");
fprintf("  Trigonometria, Geometria Analítica, Matrizes,\n");
fprintf("  Vetores, Séries e Métodos Numéricos)\n");
fprintf("==============================================\n\n");
fprintf("Comandos especiais: ajuda, exemplos, sair\n\n");

mostrar_ajuda();

while true
    expr = strtrim(input("\nDigite expressão/comando: ", "s"));

    if isempty(expr)
        continue;
    end

    if strcmpi(expr, "sair")
        disp("Encerrando calculadora. Bons estudos!");
        break;
    elseif strcmpi(expr, "ajuda")
        mostrar_ajuda();
        continue;
    elseif strcmpi(expr, "exemplos")
        mostrar_exemplos();
        continue;
    end

    try
        expr_preparada = normalizar_expressao(expr);
        resultado = eval(expr_preparada);

        disp("Resultado:");
        disp(resultado);
    catch err
        fprintf("Erro ao avaliar expressão: %s\n", err.message);
        fprintf("Dica: digite 'ajuda' para ver funções prontas e formatos.\n");
    end
end

function mostrar_ajuda()
    fprintf("\n===== GUIA RÁPIDO =====\n");
    fprintf("Operações básicas:\n");
    fprintf("  +  -  *  /  ^   (também aceita x ou × para multiplicar)\n");
    fprintf("\nFunções comuns:\n");
    fprintf("  sin cos tan asin acos atan sqrt log log10 exp abs\n");
    fprintf("  aliases PT: sen, tg, arcsen, arctg, raiz\n");
    fprintf("\nCálculo 1 (derivada e integral):\n");
    fprintf("  deriv(@(x) f(x), x0)                 -> derivada numérica\n");
    fprintf("  deriv_n(@(x) f(x), x0, n)            -> n-ésima derivada\n");
    fprintf("  integ(@(x) f(x), a, b)               -> integral definida\n");
    fprintf("  lim(@(x) f(x), x0)                   -> limite bilateral\n");
    fprintf("  taylor1(@(x) f(x), x0, n, x)         -> polinômio de Taylor\n");
    fprintf("\nCálculo 2 e 3 (várias variáveis):\n");
    fprintf("  grad(@(v) f(v), [x y ...])           -> gradiente numérico\n");
    fprintf("  hess(@(v) f(v), [x y ...])           -> Hessiana numérica\n");
    fprintf("  deriv_parcial(@(v) f(v), [x y], i)   -> parcial na direção i\n");
    fprintf("  dir_deriv(@(v) f(v), p, u)           -> derivada direcional\n");
    fprintf("\nÁlgebra linear:\n");
    fprintf("  det(A), inv(A), rank(A), eig(A), svd(A), trace(A)\n");
    fprintf("  resolver_sistema(A,b)                -> resolve Ax=b\n");
    fprintf("\nMétodos numéricos:\n");
    fprintf("  bissecao(@(x) f(x), a, b, tol)\n");
    fprintf("  newton(@(x) f(x), @(x) f'(x), x0, tol)\n");
    fprintf("\nEstatística e vetores:\n");
    fprintf("  mean(v), median(v), std(v), var(v), sum(v), prod(v)\n");
    fprintf("  dot(a,b), norm(v), cross(a,b)\n");
    fprintf("\nSequências e séries:\n");
    fprintf("  soma_n(@(k) termo(k), n)\n");
    fprintf("  soma_intervalo(@(k) termo(k), a, b)\n");
end

function mostrar_exemplos()
    fprintf("\n===== EXEMPLOS =====\n");
    fprintf("Básico:\n");
    fprintf("  2x(3+4)\n");
    fprintf("  (5^2 - 3*4)/2\n");
    fprintf("\nTrigonometria:\n");
    fprintf("  sen(pi/6)^2 + cos(pi/6)^2\n");
    fprintf("\nCálculo 1:\n");
    fprintf("  deriv(@(x) x.^3 + 2*x, 2)\n");
    fprintf("  deriv_n(@(x) sin(x), 0, 3)\n");
    fprintf("  integ(@(x) x.^2, 0, 3)\n");
    fprintf("  lim(@(x) sin(x)./x, 0)\n");
    fprintf("  taylor1(@(x) exp(x), 0, 4, 0.5)\n");
    fprintf("\nCálculo 2/3:\n");
    fprintf("  grad(@(v) v(1)^2 + v(1)*v(2) + v(2)^2, [1 2])\n");
    fprintf("  hess(@(v) v(1)^3 + v(1)*v(2)^2, [1 1])\n");
    fprintf("  dir_deriv(@(v) v(1)^2+v(2)^2, [1 2], [3 4])\n");
    fprintf("\nÁlgebra linear:\n");
    fprintf("  A=[2 1;1 3]; b=[1;2]; resolver_sistema(A,b)\n");
    fprintf("  eig([2 1;1 2])\n");
    fprintf("\nMétodos numéricos:\n");
    fprintf("  bissecao(@(x) x.^3-x-2, 1, 2, 1e-8)\n");
    fprintf("  newton(@(x) x.^3-x-2, @(x) 3*x.^2-1, 1.5, 1e-8)\n");
end

function expr_out = normalizar_expressao(expr_in)
    expr_out = expr_in;

    expr_out = strrep(expr_out, '×', '*');
    expr_out = strrep(expr_out, '÷', '/');

    expr_out = regexprep(expr_out, '\bsen\(', 'sin(');
    expr_out = regexprep(expr_out, '\btg\(', 'tan(');
    expr_out = regexprep(expr_out, '\barcsen\(', 'asin(');
    expr_out = regexprep(expr_out, '\barctg\(', 'atan(');
    expr_out = regexprep(expr_out, '\braiz\(', 'sqrt(');

    expr_out = regexprep(expr_out, '(?<=[0-9a-zA-Z_\)\.])\s*[xX]\s*(?=[0-9a-zA-Z_\(\.])', '*');

    expr_out = regexprep(expr_out, '(?<=[0-9a-zA-Z_\)])\s*(?=\()', '*');
    expr_out = regexprep(expr_out, '(?<=[0-9])\s*(?=[a-zA-Z_])', '*');
end

function y = deriv(f, x0)
    h = 1e-6;
    y = (f(x0 + h) - f(x0 - h)) / (2 * h);
end

function y = deriv_n(f, x0, n)
    y = deriv_ordem(f, x0, n);
end

function y = deriv_ordem(f, x0, n)
    h = 1e-5;
    if n == 0
        y = f(x0);
    else
        y = (deriv_ordem(f, x0 + h, n - 1) - deriv_ordem(f, x0 - h, n - 1)) / (2*h);
    end
end

function y = integ(f, a, b)
    y = integral(f, a, b);
end

function y = lim(f, x0)
    h = 1e-6;
    y = (f(x0 - h) + f(x0 + h)) / 2;
end

function y = taylor1(f, x0, n, x)
    y = 0;
    for k = 0:n
        y = y + deriv_n(f, x0, k) .* (x - x0).^k ./ factorial(k);
    end
end

function g = grad(f, p)
    h = 1e-6;
    n = numel(p);
    g = zeros(1, n);
    for i = 1:n
        e = zeros(1, n);
        e(i) = 1;
        g(i) = (f(p + h*e) - f(p - h*e)) / (2*h);
    end
end

function hessiana = hess(f, p)
    h = 1e-4;
    n = numel(p);
    hessiana = zeros(n, n);
    for i = 1:n
        for j = 1:n
            ei = zeros(1, n); ei(i) = 1;
            ej = zeros(1, n); ej(j) = 1;
            hessiana(i,j) = (f(p + h*ei + h*ej) - f(p + h*ei - h*ej) - f(p - h*ei + h*ej) + f(p - h*ei - h*ej)) / (4*h*h);
        end
    end
end

function d = deriv_parcial(f, p, i)
    h = 1e-6;
    e = zeros(1, numel(p));
    e(i) = 1;
    d = (f(p + h*e) - f(p - h*e)) / (2*h);
end

function d = dir_deriv(f, p, u)
    u = u / norm(u);
    h = 1e-6;
    d = (f(p + h*u) - f(p - h*u)) / (2*h);
end

function x = resolver_sistema(A, b)
    x = A \ b;
end

function raiz = bissecao(f, a, b, tol)
    if nargin < 4
        tol = 1e-8;
    end

    fa = f(a);
    fb = f(b);
    if fa * fb > 0
        error("Intervalo inválido: f(a) e f(b) precisam ter sinais opostos.");
    end

    while (b - a)/2 > tol
        c = (a + b)/2;
        fc = f(c);
        if fc == 0
            raiz = c;
            return;
        elseif fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
    end
    raiz = (a + b)/2;
end

function raiz = newton(f, df, x0, tol, max_iter)
    if nargin < 4
        tol = 1e-8;
    end
    if nargin < 5
        max_iter = 100;
    end

    x = x0;
    for k = 1:max_iter
        fx = f(x);
        dfx = df(x);
        if abs(dfx) < eps
            error("Derivada muito próxima de zero durante Newton.");
        end

        x_new = x - fx/dfx;
        if abs(x_new - x) < tol
            raiz = x_new;
            return;
        end
        x = x_new;
    end

    error("Newton não convergiu no número máximo de iterações.");
end

function s = soma_n(termo, n)
    s = 0;
    for k = 1:n
        s = s + termo(k);
    end
end

function s = soma_intervalo(termo, a, b)
    s = 0;
    for k = a:b
        s = s + termo(k);
    end
end
