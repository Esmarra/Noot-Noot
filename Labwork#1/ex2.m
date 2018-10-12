clc;
clear all;
close all;

a_inc=10; %Animation Increment
a_speed=0.05; %Animation Speed

%==== Create Window ====%
world_size=10;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0,0,0, 'O')
w_size=900;
set(gcf, 'Position', [900-w_size/2, 540-w_size/2, w_size, w_size])
view(135, 50);
grid on
hold on

hA=1;
HB=1;
hC=1;
hB=1;
d=1;

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

% hM=create_M(M);
% hA=create_AB(A);
% hB=create_AB(B);
% hC=create_C(C);

yA=1;
xB=6;
yB=4;
xC=1;
yM=8;
zM=5;
w=3;


% Alfa-Z Beta-Y Gama-X
WTM=[eye(3) [0 yM zM]'%Rotate 180x
    0 0 0 1];

WTA=[eye(3) [0 yA 0]'
    0 0 0 1];
WTAe=[[-1 0 0
    0 -1 0
    0 0 1] [0 yA+1.5 0]'
    0 0 0 1];
ATW=InvTransform(WTA);
WTB=[rot('Z',-90,'deg') [xB yB 0]'
    0 0 0 1];
BTW=InvTransform(WTB);
WTC=[eye(3,3) [xC -d 0]'
    0 0 0 1];

T=[rot('Z',90,'deg') [1 1 0]'
    0 0 0 1];
Cu=[ 1 1 1 1 0 0 0 0
    0 1 1 0 0 1 1 0
    0 0 1 1 0 0 1 1
    1 1 1 1 1 1 1 1];
WTCu=[eye(3) [4 4 0]'
    0 0 0 1];
%CuTW=Transformacao_Inversa(WTCu);

%==== Send to Start Positions
%
hM1=create_M(WTM*M); 
hA1=create_AB(WTA*A);
hB1=create_AB(WTB*B);
hC1=create_C(WTC*C);

% Alfa-Z Beta-Y Gama-X
C_G=[eye(3) [0 0 zM]'%Rotate 180x
    0 0 0 1];
pause(2); 
set (hM1, 'Visible','off')

% %==== Rodar 90º em Realação a [0,0,1] do Object inicial ====%--> WTM1
fprintf(' >Rot 90º [0,0,1] Obj0\n')
for i=1:a_inc 
    WTM=[matriz_rot([0 0 1]',deg2rad(-i*90/a_inc)) [0 yM zM]'
    0 0 0 1];
    h1=create_M(WTM*M);
    pause(a_speed)
    set(h1,'Visible','off')
    WTM1=WTM;
end


% %==== Translate w unidades em Realação Ox e Translate xC unidades em Realação Oy  Object ====% --> WTM2
 fprintf(' Deslocação de M para A Step 1\n')
 for i=1:a_inc
    WTM = WTM*Transform(0,0,0, [w/a_inc xC/a_inc 0]','deg') ;
    h2=create_M(WTM*M);
    pause(a_speed)
    set(h2,'Visible','off')
    WTM2=WTM; 
end


% %==== Translate zM unidades em Realação Oz Object ====% --> WTM3
 fprintf(' Deslocação de M para A Step 2\n')
 for i=1:a_inc
    WTM = WTM*Transform(0,0,0, [0 0 -zM/a_inc]','deg') ;
    h3=create_M(WTM*M);
    pause(a_speed)
    set(h3,'Visible','off')
    WTM3=WTM; 
end
 set (hA1, 'Visible','off')%objecto A desaparece


% %==== Translate zM unidades em Realação Oz Object ====% --> WTM4 e WTA1
 fprintf(' Deslocação de M e A para cima\n')
 for i=1:a_inc
    WTM =WTM*Transform(0,0,0, [0 0 zM/a_inc]','deg') ;
    WTA =WTA*Transform(0,0,0, [0 0 zM/a_inc]','deg') ;
    
    h4 =create_M(WTM*M);
    h5 =create_AB(WTA*A);
    pause(a_speed)
    set(h4,'Visible','off')
    set(h5,'Visible','off')

    WTM4=WTM; 
    WTA1=WTA;
 end
 set(h4,'Visible','on')
 set(h5,'Visible','on')

% %====IDK WTM5???====% --> WTM5
WTM=WTM*Transform(0, 0, 0, [1 0 -5]','deg');
set(h4,'Visible','off')
set(h5,'Visible','off')
WTM5=WTM;

% % %==== Rodar 180º em Realação a [0,0,1] do Object inicial ====%--> WTA2
fprintf(' >Rot 180º de M e A\n')
for i=1:a_inc 
    WTA=WTA*Transform(0, 0, 180/a_inc, [0 0 0]','deg');
    h6=create_AB (WTA*A);
    h7=create_M (WTA*WTM*M);
    pause(a_speed)
    set(h6,'Visible','off')
    set(h7,'Visible','off')
    WTA2=WTA;
end

  
% %==== Rodar 90º em Realação a [0,0,1] do Object inicial ====%--> WTA3
fprintf(' >Rot 90º de M e A \n')
for i=1:a_inc 
    
    WTA=WTA*Transform(90/a_inc, 0, 0, [0 0 0]','deg');
    h8=create_AB (WTA*A);
    h9=create_M (WTA*WTM*M);
    pause(a_speed)
    set(h8,'Visible','off')
    set(h9,'Visible','off')
    WTA3=WTA;
end

% %==== Translate zM unidades em Realação Oz Object ====% --> WTA4
 fprintf(' Deslocação de M e A em X e Y\n')
  for i=1:a_inc
    WTA =WTA*Transform(0,0,0, [-w/a_inc (-yM-1)/a_inc 0]','deg') ;
    
    h10=create_AB (WTA*A);
    h11=create_M (WTA*WTM*M);
    pause(a_speed)
    set(h10,'Visible','off')
    set(h11,'Visible','off')

    WTA4=WTA;
  end

 % %==== Translate zM unidades em Realação Oz Object ====% -->WTA5
 fprintf(' Deslocação de M e A em Z\n')
 for i=1:a_inc
    WTA =WTA*Transform(0,0,0, [0 0 (zM-3)/a_inc]','deg') ;
    
    h12=create_AB (WTA*A);
    h13=create_M (WTA*WTM*M);
    pause(a_speed)
    set(h12,'Visible','off')
    set(h13,'Visible','off')

    
end
    set(h12,'Visible','on')
    set(h13,'Visible','on')
    


    % %==== Translate zM unidades em Realação Oz Object ====% -->WTA5
 fprintf(' Deslocação de M e A em Z\n')
 for i=1:a_inc
    WTM =WTA*Transform(0,0, 0, [0 0 hB/a_inc]','deg') ;
    
    h14=create_AB (WTA*A);
    h15=create_M (WTA*WTM*M);
    pause(a_speed)
    set(h14,'Visible','off')
    set(h15,'Visible','off')

    WTA5=WTA;
end
    set(h14,'Visible','on')
    set(h15,'Visible','on')
    
 
 

% %alpha(hM1,.01); %fade
% alpha(hA1,.01); %fade
% alpha(hB1,.01); %fade
% alpha(hC1,.01); %fade
 
% h1=create_cubo(WTM*Cu,'b');
% h2=create_cubo(WTAe*Cu,'r');
% h3=create_cubo(WTB*Cu,'g');
% h4=create_cubo(WTC*Cu,'k');
% 
% TC=ctraj(WTM, WTA,a_inc);
% for i=1:a_inc
%     delete(hM1)
%     hM1=create_M(TC(:,:,i)*M);
%     pause(a_speed);
% end
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


function h = create_cubo(Pontos,color)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [l c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),color); % Front(x=1)
    h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),color); % Back(x=0)
    h(3)=fill3([X(1),X(2),X(6),X(5)],[Y(1),Y(2),Y(6),Y(5)],[Z(1),Z(2),Z(6),Z(5)],color); % Bottom(z=0)
    h(4)=fill3([X(2),X(6),X(7),X(3)],[Y(2),Y(6),Y(7),Y(3)],[Z(2),Z(6),Z(7),Z(3)],color); % Side1(y=1)
    h(5)=fill3([X(4),X(3),X(7),X(8)],[Y(4),Y(3),Y(7),Y(8)],[Z(4),Z(3),Z(7),Z(8)],color); % Top(z=1)
    h(6)=fill3([X(1),X(4),X(8),X(5)],[Y(1),Y(4),Y(8),Y(5)],[Z(1),Z(4),Z(8),Z(5)],color); % Side2(y=0)
    alpha(h,.1); %fade
    
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