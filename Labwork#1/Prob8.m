% Problema 8 Labwork #1
clear; 
clc;
close all;

%% ==== Create Window ==== %%
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

%% ==== Variables ==== %%
a_inc=10; %Animation Increment
a_speed=0.15; %Animation Speed

%%
A=[eye(3) [0 0 0]';0 0 0 1];
trplot(A,'color','k');
%Posiçao A segundo B
t=[ -2 3 -1]';
%Parametros de Euler/quarterns
Q=[sqrt(2)/4 (2-sqrt(2))/4 (2+sqrt(2))/4 sqrt(2)/4];
ATB=[quat_to_matrix(Q) t
    0 0 0 1]
%Plot ATB
trplot(ATB,'color','r');
p1=ATB(1:3,4);
text(p1(1),p1(2),p1(3),'B','color','r')

%Calcular Alfa Beta Gamma
[a,b,g]=matrix_to_RPY(ATB);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);

%% b) Calcule ATB1 depois dos movimentos i) ii) iii)
% i) Rodar B (pi/2) no eixo Br=[-1 0 1]
r=[-1 0 1]';
%BTA=InvTransform(ATB) % é preciso fazer isto?

% Plot Vector
v=plot3([0;r(1)],[0;r(2)],[0,r(3)],'r');
set(v,'LineWidth',2);

% Animate Rotaçao
ang=(pi/2);
%ang=(1.8*pi);
for i=1:a_inc
    RB=[matriz_rot(r,i*ang/a_inc) [0 0 0]'
    0 0 0 1]*ATB
    p1=RB(1:3,4);
    text(p1(1),p1(2),p1(3),'B1','color','b')
    trplot(RB,'color','b');
    pause(a_speed);
end

% ii) Deslocar A 4unidades segundo Br
%sou burro por isso vou dizer q A esta na origem

for i=1:a_inc
    A1=A*[ eye(3) r*(i*4/a_inc)
        0 0 0 1]
    p1=A1(1:3,4);
    text(p1(1),p1(2),p1(3),'A1','color','g')
    trplot(A1,'color','g');
    pause(a_speed);
end
%% iii) Rodar A (-pi/2) segundo Oyb
ang=(-pi/2);
for i=1:a_inc
	% Alfa-Z Beta-Y Gama-X
	A2 = Transform(0,i*ang/a_inc,0, [0 0 0]','rad')*A1 ;
    p1=A2(1:3,4);
    text(p1(1),p1(2),p1(3),'A1','color','y')
	trplot(A2,'color','y');
	pause(a_speed);
end
fprintf("Matrix ATB?\n");
disp(A1);
%Calc ATB????
