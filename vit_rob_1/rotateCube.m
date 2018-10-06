function [TBA, TCB, TRC, TCD, TDE, TEF] = rotateCube(TBA, TCB, TRC, TCD, TDE, TEF, N)
%% Levanta o cubo para que se apoie só no vértice em (0, 0, 0) de R
newTRC = [roty(pi/4) [0;0;0]; 0 0 0 1] * [rotx(pi/4) [0;0;0]; 0 0 0 1] * TRC;
Taux = trinterp(TRC, newTRC, 0:0.1:1);
for i = 1:11
    cla
    drawAllSquares(TBA, TCB, Taux(:,:,i), TCD, TDE, TEF);
    pause(0.1);
end
TRC = newTRC;

%% Roda o cubo
for j = 1:100*N %100 rotações de pi/50 por cada volta completa
    TRC = [rotz(pi/50) [0;0;0]; 0 0 0 1] * TRC;
    cla
    drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
    pause(0.1);
end