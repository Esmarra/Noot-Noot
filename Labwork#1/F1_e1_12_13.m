%Freq 1 2012_13 EX1
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
a_speed=0.08; %Animation Speed

%% Dados
t=[5 -3 1]';
ATB=[ [sqrt(2)/2 0 sqrt(2)/2 
    0 1 0
    -sqrt(2)/2 0 sqrt(2)/2] t
    0 0 0 1]
%% a) alfa beta gamma
[a,b,g]=matrix_to_RPY(ATB);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);
%Plot ATB
trplot(ATB,'color','r');
T=Transform(0,45,0,t,'deg')

%% b) 
[Q,r,phi]=matrix_to_quat(ATB);
disp("e1 e2 e3 e3");
disp(Q)

%% c) Rodar B (pi/3) segundo Ar
r=r';
% Plot Vector
v=plot3([0;r(1)],[0;r(2)],[0,r(3)],'r');
set(v,'LineWidth',2);

ang=(pi/3);
for i=1:a_inc
    ATB2=[matriz_rot(r,i*ang/a_inc) [0 0 0]'
    0 0 0 1]*ATB;
    p1=ATB2(1:3,4);
    b2(1)=text(p1(1),p1(2),p1(3),'ATB','color','b');
    b2(2)=trplot(ATB2,'color','b');
    pause(a_speed);
    if(i~=a_inc)delete(b2);end
end
disp("Matriz ATB")
disp(ATB2)

%% d)
v1=[-3 4 1]';

p2=ATB2(1:3,4);
r=p2+v1; %vector r em 2
v=plot3([p2(1);r(1)],[p2(2);r(2)],[p2(3),r(3)],'m');
set(v,'LineWidth',2);
