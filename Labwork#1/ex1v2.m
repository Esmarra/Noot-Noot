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
%C=Coordenadas Vertices 'a b c d e f g h' (Frente e Costas) + Linha 4=1
C=[ 1 1 1 1 0 0 0 0
    0 1 1 0 0 1 1 0
    0 0 1 1 0 0 1 1
    1 1 1 1 1 1 1 1];

% Desenha Cubo Original
h0=create_cubo(C);
alpha(h0,.2); %fade

% Dada Matriz Transform WTC
T=[0 -1 0 5;
   0 0 -1 -2;
   1 0 0 3;
   0 0 0 1];
% Get Vector Pos
t=T(1:3,4);

% Criar Cubo com Matriz Transformação C
C1=T*C;
h1=create_cubo(C1);
alpha(h1,.4); %fade

%==== Rodar 30º em Realação Ox World ====%
% Alfa-Z Beta-Y Gama-X
C_G = Transform(0,0,30, [0 0 0]','deg')*T ;
C2 = C_G*C;
h2=create_cubo(C2);
alpha(h2,.6); %fade

function h = create_cubo(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    
    h(1)=fill3(X(1:4),Y(1:4),Z(1:4),'r'); % Front(x=1)
    h(2)=fill3(X(5:8),Y(5:8),Z(5:8),'w'); % Back(x=0)
    h(3)=fill3([X(1),X(2),X(6),X(5)],[Y(1),Y(2),Y(6),Y(5)],[Z(1),Z(2),Z(6),Z(5)],'y'); % Bottom(z=0)
    h(4)=fill3([X(2),X(6),X(7),X(3)],[Y(2),Y(6),Y(7),Y(3)],[Z(2),Z(6),Z(7),Z(3)],'g'); % Side1(y=1)
    h(5)=fill3([X(4),X(3),X(7),X(8)],[Y(4),Y(3),Y(7),Y(8)],[Z(4),Z(3),Z(7),Z(8)],'b'); % Top(z=1)
    h(6)=fill3([X(1),X(4),X(8),X(5)],[Y(1),Y(4),Y(8),Y(5)],[Z(1),Z(4),Z(8),Z(5)],'m'); % Side2(y=0)
    
end
% function [h,P] = create_cubo(Pontos)
%     X =Pontos(1,:);
%     Y =Pontos(2,:);
%     Z =Pontos(3,:);
%     
%     CF =[X;Y;Z] % Create Cube Front
%     CB =[X-1;Y;Z]; % Create Cube Back
%     CL1 = [CF(:,1) CF(:,2) CB(:,2) CB(:,1)]; % Side 1
%     CL2 = [CF(:,2) CF(:,3) CB(:,3) CB(:,2)];
%     CL3 = [CF(:,3) CF(:,4) CB(:,4) CB(:,3)];
%     CL4 = [CF(:,1) CF(:,4) CB(:,4) CB(:,1)];
%     
%     fill3(X,Y,Z,'r');
%     hold on
%     fill3(X-1, Y, Z,'w');
%     hold on
%     fill3(CL1(1,:), CL1(2,:), CL1(3,:), 'b');
%     hold on
%     fill3(CL2(1,:), CL2(2,:), CL2(3,:), 'g');
%     hold on
%     fill3(CL3(1,:), CL3(2,:), CL3(3,:), 'y');
%     hold on
%     fill3(CL4(1,:), CL4(2,:), CL4(3,:), 'm');
% end