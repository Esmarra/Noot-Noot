clc;
clear all;close all;

a_inc=10; %Animation Increment
a_speed=0.15; %Animation Speed

%==== Create Window ====%
world_size=10;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0,0,0,'O')
w_size=900;
set(gcf, 'Position', [960-w_size/2, 540-w_size/2, w_size, w_size])
view(130, 20);
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
alpha(h0,.1); %fade
pause()
% Dada Matriz Transform WTC
WTC=[0 -1 0 5;
   0 0 -1 -2;
   1 0 0 3;
   0 0 0 1];
% Get Vector Pos
t=WTC(1:3,4);

% Criar Cubo com Matriz Transforma��o WTC
C1=WTC*C;
h1=create_cubo(C1);
pause(.5)
alpha(h1,.2); %fade
%set(h1,'Visible','off')
%==== Rodar 30� em Reala��o Ox World ====% --> WTC1
fprintf(' >Rot 30� Ox-World\n')
for i=1:a_inc
    % Alfa-Z Beta-Y Gama-X
    C_G = Transform(0,0,i*30/a_inc, [0 0 0]','deg')*WTC ;
    C2 = C_G*C;
    h2=create_cubo(C2);
    pause(a_speed)
    set(h2,'Visible','off')
    WTC1=C_G; % GUARDA MAT FINAL WTC1
end
set(h2,'Visible','on')
alpha(h2,.2); %fade
%pause()
%==== Translate 3 unidades em Reala��o Oz Object ====% --> WTC2
fprintf(' >Trans 3 Oz-Object\n')
for i=1:a_inc
    C_G = C_G*Transform(0,0,0, [0 0 3/a_inc]','deg') ;
    C3 = C_G*C;
    h3=create_cubo(C3);
    pause(a_speed)
    set(h3,'Visible','off')
    %delete(h3);
    WTC2=C_G; %  GUARDA MAT FINAL WTC2
end
set(h3,'Visible','on')
alpha(h3,.2); %fade

%==== Rodar -45� em Reala��o a [1,-1,1] do Object inicial ====% --> WTC3
fprintf(' >Rot -45� [1,-1,1] Obj0\n')
s=1; %vector size
v=plot3([t(1)-1;t(1)-1+s],[t(2)-1;t(2)-1-s],[t(3),t(3)+s],'k');
set(v,'LineWidth',2);
for i=1:a_inc %x3 voltas
    C_G=[matriz_rot([1 -1 1]',deg2rad(-i*45/a_inc)) [0 0 0]'
    0 0 0 1];
    C4 = C_G*WTC2*C;
    h4=create_cubo(C4);
    pause(a_speed)
    set(h4,'Visible','off')
    alpha(h4,.01); %fade
    WTC3=C_G*WTC2;
end
set(h4,'Visible','on')
alpha(h4,.2); %fade

%==== Rodar 90� em Reala��o a Oz World ====% --> WTC4
fprintf(' >Rot 90� Oz-World\n')
for i=1:a_inc
    % Alfa-Z Beta-Y Gama-X
    C_G = Transform(i*90/a_inc,0,0, [0 0 0]','deg')*WTC3 ;
    C5 = C_G*C;
    h5=create_cubo(C5);
    pause(a_speed)
    set(h5,'Visible','off')
    alpha(h5,.01); %fade
    WTC1=C_G; % GUARDA MAT FINAL WTC1
end
set(h5,'Visible','on')

function h = create_cubo(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [l c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
    h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
    h(3)=fill3([X(1),X(2),X(6),X(5)],[Y(1),Y(2),Y(6),Y(5)],[Z(1),Z(2),Z(6),Z(5)],'y'); % Bottom(z=0)
    h(4)=fill3([X(2),X(6),X(7),X(3)],[Y(2),Y(6),Y(7),Y(3)],[Z(2),Z(6),Z(7),Z(3)],'g'); % Side1(y=1)
    h(5)=fill3([X(4),X(3),X(7),X(8)],[Y(4),Y(3),Y(7),Y(8)],[Z(4),Z(3),Z(7),Z(8)],'b'); % Top(z=1)
    h(6)=fill3([X(1),X(4),X(8),X(5)],[Y(1),Y(4),Y(8),Y(5)],[Z(1),Z(4),Z(8),Z(5)],'m'); % Side2(y=0)
    
end