clc;
clear;

% EXPRESSÃO DIGITADA PELO USUÁRIO
expr = input("Digite a expressão lógica (ex: (P & Q) | ~R): ", "s");

% Substituir símbolos matemáticos comuns
expr = strrep(expr, '∧', '&');
expr = strrep(expr, '∨', '|');
expr = strrep(expr, '¬', '~');

% Descobrir variáveis automaticamente (P, Q, R...)
vars = unique(regexp(expr, '[A-Z]', 'match'));
n = length(vars);

% Gerar todas combinações possíveis
comb = dec2bin(0:2^n-1) - '0';

% Criar variáveis dinamicamente
for i = 1:n
    eval([vars{i} ' = comb(:, i);']);
end

% Avaliar expressão automaticamente
resultado = eval(expr);

% Mostrar tabela
disp("Tabela Verdade:");
header = [vars, {"Resultado"}];
disp(header);

tabela = [comb resultado];
disp(tabela);
