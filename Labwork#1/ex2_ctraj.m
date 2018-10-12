clc;
clear all;
close all;

%% ==== Create Window ==== %%
world_size=20;
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
a_inc=5; %Animation Increment
a_speed=0.1; %Animation Speed
hA=2;
hB=1;
HB=1;
hC=1;
yA=1;
xB=6;
yB=4;
xC=1;
yM=8;%
zM=5;
d=.5;
w=3; %widith peças
%% ==== Figures Points ==== %%
A=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    0 0 1 1 2 2 3 3 0 0 1 1 2 2 3 3
    0 hA hA hA+HB hA+HB hA hA 0 0 hA hA hA+HB hA+HB hA hA 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
B=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    0 0 1 1 2 2 3 3 0 0 1 1 2 2 3 3
    0 hB+HB hB+HB hB hB hB+HB hB+HB 0 0 hB+HB hB+HB hB hB hB+HB hB+HB 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
C=[ 7 5 5 2 2 0 7 5 5 2 2 0
    0 0 0 0 0 0 -2 -2 -2 -2 -2 -2
    0 hC+hB+HB+hA hC hC hC+hB+HB+hA 0 0 hC+hB+HB+hA hC hC hC+hB+HB+hA 0
    1 1 1 1 1 1 1 1 1 1 1 1];
M=[ 3 3 5 4 4 1 1 0 2 2 3 3 5 4 4 1 1 0 2 2
    1 0 0 -1-d -1 -1 -1-d 0 0 1 1 0 0 -1-d -1 -1 -1-d 0 0 1
    1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% Cubo ex1 (HELP EIXOS) can be removed
Cu=[ 1 1 1 1 0 0 0 0
    0 1 1 0 0 1 1 0
    0 0 1 1 0 0 1 1
    1 1 1 1 1 1 1 1];
% hM=create_M(M);
% hA=create_AB(A);
% hB=create_AB(B);
%hC=create_C(C);
%% ==== Matriz Pos Inicial ==== %%
WTM=[eye(3) [0 yM zM]'%Pos Inicial M
    0 0 0 1];
WTA=[eye(3) [0 yA 0]'%Pos Inicial A
    0 0 0 1];
WTB=[rot('Z',-90,'deg') [xB yB 0]' %Pos Inicial B
    0 0 0 1];
WTC=[eye(3) [xC -d 0]' %Pos Inicial C
    0 0 0 1];

%% ==== Eixos ==== %%
% WTMe=[rot('Z',-90,'deg') [2 yM-d zM]'%Rotate x90
%     0 0 0 1];
% 
% WTAe=[rot('Z',270,'deg') [0 yA+w/2 0]'
%     0 0 0 1];
%% ==== Cadeia Cinematica M->A->B->C ==== %%
MTA=InvTransform(WTM)*WTA;
ATB=InvTransform(WTA)*WTB;
BTC=InvTransform(WTB)*WTC; %*

RTC=WTM*MTA*ATB*BTC; %Target world to C
%% ==== Send to Start Positions ==== %%
hM=create_M(WTM*M); 
hA=create_AB(WTA*A);
hB=create_AB(WTB*B);
hC=create_C(WTC*C);

%alpha(hM1,.6); %fade
alpha(hA,.01); %fade
alpha(hB,.01); %fade
alpha(hC,.01); %fade
%% ==== Cria Cubo no origem do Ref Obj(Eixos) ==== %%
%create_cubo(Cu);
h1=create_cubo(WTM*Cu);
h2=create_cubo(WTA*Cu);
h3=create_cubo(WTB*Cu);
h4=create_cubo(WTC*Cu);
%% ==== Transforms ==== %%
%% Gripper --> A %%
% Move M -a units Oy (a=-((yM-1)-(yA+w/2)))
WTM1=WTM*Transform(0, 0, 0, [0,-((yM-1)-(yA+w/2)),0]','deg');
delete(hM);
hM=create_M(WTM1*M);

pause(.5)
% Rotate and Move ObM Ox Oy Oz Position to Match ObjA
WTM2=WTM1*Transform(-90, 0, 0, [+1,w/2,-zM]','deg');
delete(hM);
hM=create_M(WTM2*M);

pause(0.5)
%% Gripper And A --> B%%
% Move M and A Oz
WTM3=WTM2;
WTA1=WTA;
for i=1:a_inc
    WTM3=WTM3*Transform(0, 0, 0, [0,0,zM/a_inc]','deg');
    WTA1=WTA1*Transform(0, 0, 0, [0,0,zM/a_inc]','deg');
    delete(hM);
    delete(hA);
    hM=create_M(WTM3*M);
    hA=create_AB(WTA1*A);
    pause(a_speed)
end

% Rotate and Move M and A
WTM4=WTM3;
WTA2=WTA1;
for i=1:a_inc
    WTM4=Transform(-90, 0, 0, [1,w+1,0]','deg'); %+1?
    WTA2=WTA1*Transform(90, 0, 0, [0,0,0]','deg');
    delete(hM);
    delete(hA);
    hM=create_M(WTA2*WTM4*M);
    hA=create_AB(WTA2*A);
    pause(a_speed)
end
pause
% Move M and A
WTM5=WTM4;
WTA3=WTA2;
for i=1:a_inc
    WTM5=WTM5*Transform(0, 0, 0, [0,0,zM/5]','deg');
    delete(hM);
    hM=create_M(WTM5*M);
    pause(a_speed)
end
%% ==== CTRAJ ==== %%

% TC=ctraj(WTMe,WTAe,a_inc);
%  for i=1:a_inc
%      delete(hM1)
%      hM1=create_M(TC(:,:,i)*M);
%      create_cubo(TC(:,:,i)*Cu);
%      pause(a_speed);
%  end
% WTM1=TC(:,:,a_inc); %Store Current Pos

% T=[rot('Z',90,'deg') [0 0 5]'
%     0 0 0 1];
% TC=ctraj(WTM1, T,a_inc);
% for i=1:a_inc
%     delete(hM1)
%     delete(hA1)
%     hM1=create_M(TC(:,:,i)*M);
%     hA1=create_AB(TC(:,:,i)*A);
%     pause(a_speed);
% end
%% ==== Functions ==== %%
function h = create_cubo(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [~,c]=size(Pontos);
    %h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),color); % Front(x=1)
    h(1)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'G'); % Back(x=0)
    h(2)=fill3([X(1),X(2),X(6),X(5)],[Y(1),Y(2),Y(6),Y(5)],[Z(1),Z(2),Z(6),Z(5)],'B'); % Bottom(z=0)
    %h(4)=fill3([X(2),X(6),X(7),X(3)],[Y(2),Y(6),Y(7),Y(3)],[Z(2),Z(6),Z(7),Z(3)],color); % Side1(y=1)
    %h(5)=fill3([X(4),X(3),X(7),X(8)],[Y(4),Y(3),Y(7),Y(8)],[Z(4),Z(3),Z(7),Z(8)],color); % Top(z=1)
    h(3)=fill3([X(1),X(4),X(8),X(5)],[Y(1),Y(4),Y(8),Y(5)],[Z(1),Z(4),Z(8),Z(5)],'R'); % Side2(y=0)
    alpha(h,.1); %fade
    
end
function v = create_eixo(P,size)
    v(1)=plot3([P(1);P(1)+size],[0,0],[0,0],'r');
    v(2)=plot3([0,0],[P(2);P(2)+size],[0,0],'b');
    v(3)=plot3([0,0],[0,0],[P(3),P(3)+size],'g');
    set(v,'LineWidth',1.5);
end
function h = create_AB(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [l c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
     h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
     h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
     h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'g'); % Side1(y=1)
     h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'b'); % Top(z=1)
    h(6)=fill3([X(c/2-2),X(c/4+1),X(c-3),X(c-2)],[Y(c/2-2),Y(c/4+1),Y(c-3),Y(c-2)],[Z(c/2-2),Z(c/4+1),Z(c-3),Z(c-2)],'g'); % Top(z=1)
    h(7)=fill3([X(c/4+1),X(c/4),X(c-4),X(c-3)],[Y(c/4+1),Y(c/4),Y(c-4),Y(c-3)],[Z(c/4+1),Z(c/4),Z(c-4),Z(c-3)],'b'); % Top(z=1)
    h(8)=fill3([X(c/4),X(3),X(c/2+3),X(c-4)],[Y(c/4),Y(3),Y(c/2+3),Y(c-4)],[Z(c/4),Z(3),Z(c/2+3),Z(c-4)],'m'); % Top(z=1)
    h(9)=fill3([X(2),X(3),X(c/2+3),X(c/2+2)],[Y(2),Y(3),Y(c/2+3),Y(c/2+2)],[Z(2),Z(3),Z(c/2+3),Z(c/2+2)],'b'); % Top(z=1)
    h(10)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'m'); % Top(z=1)
end
function h = create_M(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [l c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
    h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
    h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
    h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'g'); % Side1(y=1)
    h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'b'); % Top(z=1)
    h(6)=fill3([X(c/4),X(c/4-1),X(3*c/4-1), X(3*c/4)],[Y(c/4),Y(c/4-1),Y(3*c/4-1), Y(3*c/4)],[Z(c/4),Z(c/4-1),Z(3*c/4-1), Z(3*c/4)],'m'); 
    h(7)=fill3([X(c/4),X(c/4+1),X(3*c/4+1), X(3*c/4)],[Y(c/4),Y(c/4+1),Y(3*c/4+1), Y(3*c/4)],[Z(c/4),Z(c/4+1),Z(3*c/4+1), Z(3*c/4)],'y');
    h(8)=fill3([X(c/4+1),X(c/4+2),X(3*c/4+2), X(3*c/4+1)],[Y(c/4+1),Y(c/4+2),Y(3*c/4+2), Y(3*c/4+1)],[Z(c/4+1),Z(c/4+2),Z(3*c/4+2), Z(3*c/4+1)],'m');
    h(9)=fill3([X(7),X(8),X(18), X(17)],[Y(7),Y(8),Y(18),Y(17)],[Z(7),Z(8),Z(18),Z(17)],'g');
    h(10)=fill3([X(c/4-2),X(c/4-1),X(c-(c/4)-1),X(c-(c/4)-2)],[Y(c/4-2),Y(c/4-1),Y(c-(c/4)-1),Y(c-(c/4)-2)],[Z(c/4-2),Z(c/4-1),Z(c-(c/4)-1),Z(c-(c/4)-2)],'g'); % Top(z=1)
    h(11)=fill3([X(2),X(3),X(c/2+3),X(c/2+2)],[Y(2),Y(3),Y(c/2+3),Y(c/2+2)],[Z(2),Z(3),Z(c/2+3),Z(c/2+2)],'b'); % Top(z=1)
    h(12)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'m'); % Top(z=1)
end
function h = create_C(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [l c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
    h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
    h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
    h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'b'); % Side1(y=1)
    h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'g'); % Top(z=1)
    h(6)=fill3([X(c/2-3),X(c/2-2),X(c/2+4),X(c/2+3)],[Y(c/2-3),Y(c/2-2),Y(c/2+4),Y(c/2+3)],[Z(c/2-3),Z(c/2-2),Z(c/2+4),Z(c/2+3)],'b'); % Top(z=1)
    h(7)=fill3([X(c/2-3),X(2),X(c/2+2),X(c/2+3)],[Y(c/2-3),Y(2),Y(c/2+2),Y(c/2+3)],[Z(c/2-3),Z(2),Z(c/2+2),Z(c/2+3)],'m'); % Top(z=1)
    h(8)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'b'); % Top(z=1)
end