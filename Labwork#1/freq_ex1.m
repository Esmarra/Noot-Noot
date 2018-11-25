clear; 
clc;
close all;

%% ==== Create Window ==== %%
world_size=3;
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
%a_speed=0;

%% Enunciado
t=[1 0 2]';
Q=[ 1/2 -1/2 1/2 1/2];
A=eye(4);
ATB=[quat_to_matrix(Q) t
     0 0 0 1]
a(1)=trplot(A,'color','k');
b(1)=trplot(ATB,'color','r');
%% b)
%i) Deslocar B 2 unidades segundo YA
uni=2;
for i=1:a_inc
    ATB1=[ eye(3) [0 (i*uni/a_inc) 0]'
        0 0 0 1]*ATB;
    p1=ATB1(1:3,4);
    a1(1)=text(p1(1),p1(2),p1(3),'A1','color','g');
    a1(2)=trplot(ATB1,'color','g');
    pause(a_speed);
    if(i~=a_inc)delete(a1);end
end
disp(ATB1)

%ii) Rodar Sobre o Quaterniao qx