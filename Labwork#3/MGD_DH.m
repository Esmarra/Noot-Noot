% -------------------------------------------------------------------------
% Fun��o:   [M, Mi] = MGD_DH(PJ_DH)
%
% Fun��o que atrav�s de uma tabela de parametros calcula e devolve a matriz
% de Transforma��o Denavith-Hartenberg que relaciona o griper com a base do
% robot.
% A fun��o devolve tamb�m todas as matrizes de transforma��o de cada junta.
%
% As colunas de PJ_DH s�o [ Theta d Alfa a ], em que os angulos de entrada
% s�o em graus.
% -------------------------------------------------------------------------

function [M, Mi] = MGD_DH(PJ_DH)

[l c] = size(PJ_DH); % Numero de linhas (juntas) da tabela de parametros

M = eye(4,4); % Guarda como identidade para ser possivel multiplicar sem alterar valores

for x = 1:l
    Th = deg2rad(PJ_DH(x,1));   % Obt�m o valor de Th(x)
    d = PJ_DH(x,2);             % Obt�m o valor de d(x)
    Al = deg2rad(PJ_DH(x,3));   % Obt�m o valor de Al(x)
    a = PJ_DH(x,4);             % Obt�m o valor de a(x)
    
    
    % Calcula cada matriz de transforma��o
    MT = [cos(Th) -sin(Th)*cos(Al) sin(Th)*sin(Al) a*cos(Th);
        sin(Th) cos(Th)*cos(Al) -cos(Th)*sin(Al) a*sin(Th);
        0 sin(Al) cos(Al) d;
        0 0 0 1];
    
    M = M * MT;     % Matriz de Transforma��o Denavith-Hartenberg
    
    Mi(:,:,x) = MT; % Guarda cada matriz de transforma��o
end

end
