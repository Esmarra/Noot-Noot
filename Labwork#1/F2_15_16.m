%Freq 1 2015_16 EX2
clear; 
clc;
close all;

%% ==== Create Window ==== %%
world_size=5;
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

%% Alinea a)
W=[eye(3) [0 0 0]'
    0 0 0 1];
%Plot A
trplot(W,'color','k');

WT1=[ eye(3) [0 1 1]'
    0 0 0 1];
WT2=[ eye(3) [-.5 1.5 1.1]'
    0 0 0 1];
WT3=[ [0 1 0; 1 0 0; 0 0 -1] [-.5 1.5 3]'
    0 0 0 1];
t1(1)=trplot(WT1,'color','r');
t2(1)=trplot(WT2,'color','b');
t3(1)=trplot(WT3,'color','g');

%% b) Rodar WT3 (30) segundo 2r=[0,1,1]
p2=WT2(1:3,4);
r=p2+[0 1 1]'; %vector r em 2
v=plot3([p2(1);r(1)],[p2(2);r(2)],[p2(3),r(3)],'m');
set(v,'LineWidth',2);
delete(t3)
ang=(deg2rad(30));
for i=1:a_inc
    WT3_=[matriz_rot(r,i*ang/a_inc) [0 0 0]'
    0 0 0 1]*WT3;
    p1=WT3_(1:3,4);
    b2(1)=text(p1(1),p1(2),p1(3),'WT3(1) ','color','g');
    b2(2)=trplot(WT3_,'color','g');
    pause(a_speed);
    if(i~=a_inc)delete(b2);end
end
disp("b) Matriz WT3'")
disp(WT3_)
ASD=inv(WT3_)*WT3;
trplot(ASD,'color','K');
[a,b,g]=matrix_to_RPY(ASD);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);