clc;
clear all;
close all;
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

A=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    0 0 1 1 2 2 3 3 0 0 1 1 2 2 3 3
    0 1 1 2 2 1 1 0 0 1 1 2 2 1 1 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
B=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    2 2 3 3 4 4 5 5 2 2 3 3 4 4 5 5
    0 2 2 1 1 2 2 0 0 2 2 1 1 2 2 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
C=[ 7 5 5 2 2 0 7 5 5 2 2 0
    0 0 0 0 0 0 -2 -2 -2 -2 -2 -2
    0 4 1 1 4 0 0 4 1 1 4 0
    1 1 1 1 1 1 1 1 1 1 1 1];
d=1;
M=[ 3 3 5 4 4 1 1 0 2 2 3 3 5 4 4 1 1 0 2 2
    -1 0 0 d+1 1 1 d+1 0 0 -1 -1 0 0 d+1 1 1 d+1 0 0 -1
    0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

% M=[0 0 0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
%     2 2 0 1 1 4 4 5 3 3 2 2 0 1 1 4 4 5 3 3
%     0 2 2 4 3 3 4 2 2 0 0 2 2 4 3 3 4 2 2 0
%     1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%hM=create_M(M);
%hA=create_AB(A);
%hB=create_AB(B);
%hC=create_C(C);

WTM=[rot('X',180,'deg') [0 8 1+5]'%rotate this 180?
    0 0 0 1];

WTA=[eye(3,3) [0 2 0]'
    0 0 0 1];

WTB=[rot('Z',-90,'deg') [4 4 0]'
    0 0 0 1];

WTC=[eye(3,3) [0 -d 0]'
    0 0 0 1];

T=[rot('Z',90,'deg') [1 1 0]'
    0 0 0 1];

hM1=create_M(WTM*M);
hA1=create_AB(WTA*A);
hB1=create_AB(WTB*B);
hC1=create_C(WTC*C);
alpha(hC1,.01); %fade

inter=5;
TC=ctraj(WTM, T,inter);
for i=1:inter
    delete(hM1)
    hM1=create_M(TC(:,:,i)*M);
    pause(.5);
end
WTM1=TC(:,:,inter); %Store Current Pos

T=[rot('Z',90,'deg') [0 0 5]'
    0 0 0 1];
TC=ctraj(WTM1, T,inter);
for i=1:inter
    delete(hM1)
    delete(hA1)
    hM1=create_M(TC(:,:,i)*M);
    hA1=create_M(TC(:,:,i)*A);
    pause(.5);
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
    %h(6)
    %h(7)
    %h(8)
    %h(9)
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