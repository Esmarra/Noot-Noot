%Freq 1 2015_16 EX1
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
ATB=[[0 -1 0
    0 0 -1
    1 0 0] [0 0 0]'
    0 0 0 1];

A= [rot('X',0,'deg') [0 0 0]'
    0 0 0 1];
%Plot A
a(1)=trplot(A,'color','k');
b(1)=trplot(ATB,'color','r');
pause(.1);
delete(b);

%% a) Obtenha Sequência de Mobimentos q Traduz a Matriz ATB
[a,b,g]=matrix_to_RPY(ATB);
fprintf("Alfa %f | Beta %f | Gamma %f\n",a,b,g);
% Sequencia da Rotação -- >R=Rz,alfa * Ry,Beta * Rx,Gama
R=rot('Z',a,'deg')*rot('Y',b,'deg')*rot('X',g,'deg');

%% b) Obtenha ATB apos os Movimentos Realizados
%i) Rodar B (alfa) segundo YA
ang=(pi/2);
%while true
for i=1:a_inc
	% Alfa-Z Beta-Y Gama-X
	ATB1 = inv(A)*Transform(0,i*ang/a_inc,0,[0 0 0]','rad')*A*ATB;
    %A2 = InvTransform(ATB)*Transform(0,i*ang/a_inc,0,[0 0 0]','rad')*A1;
    p1=ATB1(1:3,4);
    b1(1)=text(p1(1),p1(2),p1(3),'ATB1','color','b');
	b1(2)=trplot(ATB1,'color','b');
	pause(a_speed);
    if(i~=a_inc)delete(b1);end
    %delete(a2);
end
%end
disp(ATB1)

%ii) Deslocar A d unidades segundo ZBinicial
uni=2;
for i=1:a_inc
    A1=ATB*[ eye(3) [0 0 (i*uni/a_inc)]'
        0 0 0 1];
    p1=A1(1:3,4);
    a1(1)=text(p1(1),p1(2),p1(3),'A1','color','g');
    a1(2)=trplot(A1,'color','g');
    pause(a_speed);
    if(i~=a_inc)delete(a1);end
end
disp(A1)

%iii) Rodar B beta segundo XAactual
ang=(pi/2);
%while true
for i=1:a_inc
	% Alfa-Z Beta-Y Gama-X
	ATB2 = inv(A1)*Transform(i*ang/a_inc,0,0,[0 0 0]','rad')*A1*ATB1;
    %A2 = InvTransform(ATB)*Transform(0,i*ang/a_inc,0,[0 0 0]','rad')*A1;
    p1=ATB2(1:3,4);
    b1(1)=text(p1(1),p1(2),p1(3),'ATB2','color','b');
	b1(2)=trplot(ATB2,'color','b');
	pause(a_speed);
    if(i~=a_inc)delete(b1);end
    %delete(a2);
end
%end
disp(ATB2)