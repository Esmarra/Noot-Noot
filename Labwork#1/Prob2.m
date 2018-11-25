% Problema 2 Labwork #1
clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;        %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 phi; % Tetas

%% ==== Create Window ==== %%
world_size=8;
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

%% ===== Start Position ==== %%
% Crio A na origem
WTA=[rot('X',0,'deg') [0 0 0]'
    0 0 0 1]
% A é coincidente com B
WTB=WTA;

ATW=InvTransform(WTA)

ha=trplot(WTA,'color','r');
hb=trplot(WTB,'color','b');
pause(1);
%delete(ha);
delete(hb);

%% Rotação phi Segundo YB
fprintf("Rotação phi Segundo YB");
WTB1=[rot('Y',phi,'rad') [0 0 0]'
    0 0 0 1]
ATB1=ATW*WTB1
%% Rotaçao teta Segundo XB
fprintf("Rotação teta Segundo XB'");
WTB2=WTB1*[rot('X',t1,'rad') [0 0 0]'
    0 0 0 1]
ATB2=ATW*WTB2
fprintf("Com phi=30");
WTB1=eval(subs(WTB1,[phi],deg2rad(30)))
ATB1=eval(subs(ATB1,[phi],deg2rad(30)))
hb=trplot(WTB1,'color','b');
pause();
delete(hb);
fprintf("Com teta=60 e phi=30");
WTB2=eval(subs(WTB2,[phi,t1],deg2rad([30 60])))
ATB2=eval(subs(ATB2,[phi,t1],deg2rad([30 60])))

hb1=trplot(WTB2,'color','g');