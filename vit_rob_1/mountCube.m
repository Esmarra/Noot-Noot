function [TBA, TCB, TRC, TCD, TDE, TEF] = mountCube(TBA, TCB, TRC, TCD, TDE, TEF)

    Ry = [roty((-pi/2)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TCB = Ry * TCB; %Rodar B no eixo de C -> pr� multiplica
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end

    %%
    Ry = [roty((pi/2)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TCD = TCD * Ry; % Rodar D no seu eixo -> p�s multiplica
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end

    %%
    Rx = [rotx((pi/2)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TBA = Rx * TBA; %Rodar A no eixo de B -> pr�-multiplica
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end
    %%
    Rz = [rotz((-pi)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TEF = TEF * transl(0,1,0) * Rz * transl(0,-1,0); %Rodar F num outro eixo -> transforma��o de similaridade
        cla 
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end
    %%
    Ry = [roty((pi/2)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TDE = TDE * Ry; % P�s multiplica
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end
    %%
    Rz = [rotz((-pi)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TBA = Rz * TBA;
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end
    %%
    Rx = [rotx((-pi/2)/5) [0;0;0]; 0 0 0 1]; %Cada rota��o � 1/5 da rota��o total
    for i = 1:5
        TEF = TEF * transl(0,1,0) * Rx * transl(0,-1,0);
        cla
        drawAllSquares(TBA, TCB, TRC, TCD, TDE, TEF);
        pause(0.1)
    end
