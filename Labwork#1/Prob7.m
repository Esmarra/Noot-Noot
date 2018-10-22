% Problema 7 Labwork #1
%clear; 
%clc;
close all;
syms phi a1 a2 a3 a4 a5 a6 a7 a8 a9 p1 p2 p3;

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
%% Alinea a)
r=[-1 1 0]';
p1=[0 0 0]';
ATB=[matriz_rot(r,deg2rad(45)) p1
    0 0 0 1]
trplot(ATB,'color','r'); 
[a,b,g]=matrix_to_RPY(ATB);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);

%% Alinea b)
%i)
p2=[0 0 0]';
WTA=[matriz_rot(r,pi/3) p2
    0 0 0 1]
ATW=InvTransform(WTA)
trplot(WTA,'color','b'); 
%ii) Deslocar B segundo o vector
ATB2=ATB*[eye(3) p1+4
           0 0 0 1]
trplot(ATB2,'color','g');
