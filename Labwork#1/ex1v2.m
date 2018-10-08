clc;
clear all;close all;

%==== Create Window ====%
world_size=10;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0,0,0, 'O')
w_size=900;
set(gcf, 'Position', [960-w_size/2, 540-w_size/2, w_size, w_size])
view(140, 30);
grid on
hold on

%==== Create Objects ====%
C = [0 0 0 0
    0 1 1 0
    0 0 1 1];

create_cubo(C);

% Dada Matriz Transform
T=[0 -1 0 5;
   0 0 -1 -2;
   1 0 0 3;
   0 0 0 1];
% Get Vector Pos
t=T(1:3,4);

%Ti=InvTransform(T);
%WTO = Ti * T;

[l c] = size(C) % Obtemos o n�mero de pontos do Objecto (Cubo)


function [h,P] = create_cubo(Pontos)
    X =Pontos(1,:);
    Y =Pontos(2,:);
    Z =Pontos(3,:);
    
    CF =[X;Y;Z] % Create Cube Front
    CB =[X-1;Y;Z]; % Create Cube Back
    CL1 = [CF(:,1) CF(:,2) CB(:,2) CB(:,1)]; % Side 1
    CL2 = [CF(:,2) CF(:,3) CB(:,3) CB(:,2)];
    CL3 = [CF(:,3) CF(:,4) CB(:,4) CB(:,3)];
    CL4 = [CF(:,1) CF(:,4) CB(:,4) CB(:,1)];
    
    fill3(X,Y,Z,'r');
    hold on
    fill3(X-1, Y, Z,'w');
    hold on
    fill3(CL1(1,:), CL1(2,:), CL1(3,:), 'b');
    hold on
    fill3(CL2(1,:), CL2(2,:), CL2(3,:), 'g');
    hold on
    fill3(CL3(1,:), CL3(2,:), CL3(3,:), 'y');
    hold on
    fill3(CL4(1,:), CL4(2,:), CL4(3,:), 'm');
end