clc;
clear;

fprintf("=== Calculadora Matemática para Octave ===\n");
fprintf("Aceita expressões de álgebra, trigonometria e recursos de Cálculo 1, 2 e 3.\n");
fprintf("Digite 'sair' para encerrar.\n\n");
fprintf("Exemplos:\n");
fprintf("  2x(3+4)              -> 14\n");
fprintf("  sin(pi/3)^2 + cos(pi/3)^2\n");
fprintf("  deriv(x.^3 + 2*x, 2) -> derivada numérica em x=2\n");
fprintf("  integ(@(t) t.^2, 0, 3) -> integral numérica definida\n");
fprintf("  lim(@(t) sin(t)./t, 0) -> limite numérico\n\n");

while true
    expr = strtrim(input("Digite a expressão: ", "s"));

    if isempty(expr)
        continue;
    end

    if strcmpi(expr, "sair")
        disp("Encerrando...");
        break;
    end

    try
        expr_preparada = normalizar_expressao(expr);
        resultado = eval(expr_preparada);

        disp("Resultado:");
        disp(resultado);
        disp(" ");
    catch err
        fprintf("Erro ao avaliar expressão: %s\n\n", err.message);
    end
end

% -----------------------------------------------------------------
% Converte entrada do teclado para sintaxe válida do Octave.
% -----------------------------------------------------------------
function expr_out = normalizar_expressao(expr_in)
    expr_out = expr_in;

    % Símbolos matemáticos comuns
    expr_out = strrep(expr_out, '×', '*');
    expr_out = strrep(expr_out, '÷', '/');
    expr_out = strrep(expr_out, '^', '.^');

    % Compatibilidade de nomes frequentes em português
    expr_out = regexprep(expr_out, '\bsen\(', 'sin(');
    expr_out = regexprep(expr_out, '\btg\(', 'tan(');
    expr_out = regexprep(expr_out, '\barcsen\(', 'asin(');
    expr_out = regexprep(expr_out, '\barctg\(', 'atan(');
    expr_out = regexprep(expr_out, '\braiz\(', 'sqrt(');

    % Multiplicação implícita com "x" digitado no teclado:
    % 2x3, 2x(1+1), (a+b)x4, pix2
    expr_out = regexprep(expr_out, '(?<=[0-9a-zA-Z_\)\.])\s*[xX]\s*(?=[0-9a-zA-Z_\(\.])', '*');

    % Multiplicação implícita sem operador: 2(3+4), pi(2), 3sin(pi/2)
    expr_out = regexprep(expr_out, '(?<=[0-9a-zA-Z_\)])\s*(?=\()', '*');
    expr_out = regexprep(expr_out, '(?<=[0-9])\s*(?=[a-zA-Z_])', '*');
end

% -----------------------------------------------------------------
% deriv(f, x0) -> derivada numérica de f no ponto x0
% Uso: deriv(@(x) x.^2, 3)
% -----------------------------------------------------------------
function y = deriv(f, x0)
    h = 1e-6;
    y = (f(x0 + h) - f(x0 - h)) / (2 * h);
end

% -----------------------------------------------------------------
% integ(f, a, b) -> integral numérica definida
% Uso: integ(@(x) x.^2, 0, 2)
% -----------------------------------------------------------------
function y = integ(f, a, b)
    y = integral(f, a, b);
end

% -----------------------------------------------------------------
% lim(f, x0) -> limite numérico bilateral de f quando x -> x0
% Uso: lim(@(x) sin(x)./x, 0)
% -----------------------------------------------------------------
function y = lim(f, x0)
    h = 1e-6;
    y = (f(x0 - h) + f(x0 + h)) / 2;
end
