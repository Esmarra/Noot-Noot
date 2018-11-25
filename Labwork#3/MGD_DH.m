% -------------------------------------------------------------------------
% Função:   [M, Mi] = MGD_DH(PJ_DH)
%
% Função que através de uma tabela de parametros calcula e devolve a matriz
% de Transformação Denavith-Hartenberg que relaciona o griper com a base do
% robot.
% A função devolve também todas as matrizes de transformação de cada junta.
%
% As colunas de PJ_DH são [ Theta d Alfa a ], em que os angulos de entrada
% são em graus.
% -------------------------------------------------------------------------

function [M, Mi] = MGD_DH(PJ_DH)

[l c] = size(PJ_DH); % Numero de linhas (juntas) da tabela de parametros

M = eye(4,4); % Guarda como identidade para ser possivel multiplicar sem alterar valores

for x = 1:l
    Th = deg2rad(PJ_DH(x,1));   % Obtêm o valor de Th(x)
    d = PJ_DH(x,2);             % Obtêm o valor de d(x)
    Al = deg2rad(PJ_DH(x,3));   % Obtêm o valor de Al(x)
    a = PJ_DH(x,4);             % Obtêm o valor de a(x)
    
    
    % Calcula cada matriz de transformação
    MT = [cos(Th) -sin(Th)*cos(Al) sin(Th)*sin(Al) a*cos(Th);
        sin(Th) cos(Th)*cos(Al) -cos(Th)*sin(Al) a*sin(Th);
        0 sin(Al) cos(Al) d;
        0 0 0 1];
    
    M = M * MT;     % Matriz de Transformação Denavith-Hartenberg
    
    Mi(:,:,x) = MT; % Guarda cada matriz de transformação
end

end
