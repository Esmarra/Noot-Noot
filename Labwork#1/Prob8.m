% Problema 8 Labwork #1
clear; 
clc;
close all;

world_size=10;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0,0,0, 'O')
w_size=900;
set(gcf, 'Position', [1440-w_size/2, 540-w_size/2, w_size, w_size])
view(135, 50);
grid on
hold on

%%
%Posiçao A segundo B
t=[ -2 3 -1]';
%Parametros de Euler/quarterns
Q=[sqrt(2)/4 (2-sqrt(2))/4 (2+sqrt(2))/4 sqrt(2)/4];
ATB=[quat_to_matrix(Q) t
    0 0 0 1]
trplot(ATB,'color','r');
[a,b,g]=matrix_to_RPY(ATB);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);

%% b) Calc ATB1 depois dos movimentos
% i) Rodar B (pi/2) no eixo Br=[-1 0 1]
r=[-1 0 1]';
BTA=InvTransform(ATB) % é preciso fazer isto?
trplot(BTA,'color','g');
RB=[matriz_rot(r,pi/2) [0 0 0]'
    0 0 0 1]*ATB
s=1; %vector size
v=plot3([r(1)-1;r(1)-1+s],[r(2)-1;r(2)-1-s],[r(3),r(3)+s],'r');
trplot(RB,'color','b');
% ii) Deslocar A 4unidades segundo Br
[matriz_rot(r,0) [0 0 0]'
    0 0 0 1]




