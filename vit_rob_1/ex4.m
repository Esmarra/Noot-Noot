%% Matrizes de transforma��o
% Todas as T s�o dada em rela��o a um outro quadrado, excepto uma, que �
% dado em rela��o ao referencial. Quando um quadrado roda, um outro
% quadrado com a matriz de transforma��o definida em rela��o ao primeiro
% roda com ele, sem que T se altere, simplificando os c�lculos.
%
% Assumindo os quadrados alinhado com XR, o quadrado com maior X � o A,
% com menor � o F, os outros est�o por ordem. C come�a com o seu
% referencial coincidente com a base, R, e durante a montagem n�o se move.
% O referencial de cada quadrado situa-se no seu canto de maior X e menor Y
% (na situa��o inicial).

TBA = [1 0 0 1;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];

TCB = [1 0 0 1;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];


TRC = [1 0 0 0;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];

TCD = [1 0 0 -1;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];
   
TDE = [1 0 0 -1;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];
   
TEF = [1 0 0 -1;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];
         
%% Configura��o da figura
figure
plot3(0,0,0, 'r.', 'MarkerSize', 10)
text(0,0,0, 'OR')
xlim([-5 5]);
ylim([-5 5]);
zlim([-5 5]);
view(140, 30);
xlabel('XR')
ylabel('YR')
zlabel('ZR')
grid on
hold on
%% Desenho da situa��o inicial
drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
pause(1)

%% Montagem do cubo
[TBA, TCB, TRC, TCD, TDE, TEF] = mountCube(TBA, TCB, TRC, TCD, TDE, TEF);
%% Rota��o do cubo
[TBA, TCB, TRC, TCD, TDE, TEF] = rotateCube(TBA, TCB, TRC, TCD, TDE, TEF, 2); %2 voltas