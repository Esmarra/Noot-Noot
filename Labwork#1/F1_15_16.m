%Freq 1 2015_16
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

%% Enunciado
r=[1 0 0]';
A=[matriz_rot(r,deg2rad(0)) [0 0 0]'
    0 0 0 1];
%Plot A
trplot(A,'color','k');

%% 1- Deslocar B quatro unidades segundo Ar
uni=4;
for i=1:a_inc
    B1=A*[ eye(3) r*(i*uni/a_inc)
        0 0 0 1];
    p1=B1(1:3,4);
    b1(1)=text(p1(1),p1(2),p1(3),'B1','color','b');
    b1(2)=trplot(B1,'color','b');
    pause(a_speed);
    if(i~=a_inc)delete(b1);end
end
disp("Matriz B2")
disp(B1)

%% 2- Rodar B (-pi/2) segundo Ar

% Plot Vector
v=plot3([0;r(1)],[0;r(2)],[0,r(3)],'r');
set(v,'LineWidth',2);

ang=(-pi/2);
for i=1:a_inc
    B2=[matriz_rot(r,i*ang/a_inc) [0 0 0]'
    0 0 0 1]*B1;
    p1=B2(1:3,4);
    b2(1)=text(p1(1),p1(2),p1(3),'B2','color','g');
    b2(2)=trplot(B2,'color','g');
    pause(a_speed);
    if(i~=a_inc)delete(b2);end
end
disp("Matriz B2")
disp(B2)

%% 3- Rodar A (-pi/2) segundo ZB do Ref B2
ang=(-pi/2);
for i=1:a_inc
	% Alfa-Z Beta-Y Gama-X
	A1 = InvTransform(B2)*Transform(i*ang/a_inc,0,0,[0 0 0]','rad')*B2*A;
    %A2 = InvTransform(ATB)*Transform(0,i*ang/a_inc,0,[0 0 0]','rad')*A1;
    p1=A1(1:3,4);
    a2(1)=text(p1(1),p1(2),p1(3),'A1','color','y');
	a2(2)=trplot(A1,'color','y');
	pause(a_speed);
    if(i~=a_inc)delete(a2);end
end
disp(A1)

