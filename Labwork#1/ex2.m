clc;
clear;
close all;
%% ==== Variables ==== %%
a_inc=5;        %Animation Increment
a_speed=0.08;  %Animation Speed

%% ==== Create Window ==== %%
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

%% ==== Altura das Peças ==== %%
hA=1;
HB=1;
hC=1;
hB=1;
d=0.5;

%% ==== Object A Points ==== %%
A=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    0 0 1 1 2 2 3 3 0 0 1 1 2 2 3 3
    0 hA hA hA+HB hA+HB hA hA 0 0 hA hA hA+HB hA+HB hA hA 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%% ==== Object B Points ==== %%
B=[0 0 0 0 0 0 0 0 -2 -2 -2 -2 -2 -2 -2 -2
    0 0 1 1 2 2 3 3 0 0 1 1 2 2 3 3
    0 hB+HB hB+HB hB hB hB+HB hB+HB 0 0 hB+HB hB+HB hB hB hB+HB hB+HB 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%% ==== Object C Points ==== %%
C=[ 7 5 5 2 2 0 7 5 5 2 2 0
    0 0 0 0 0 0 -2 -2 -2 -2 -2 -2
    0 hC+hB+HB+hA hC hC hC+hB+HB+hA 0 0 hC+hB+HB+hA hC hC hC+hB+HB+hA 0
    1 1 1 1 1 1 1 1 1 1 1 1];

%% ==== Object M Points ==== %%
M=[ 3 3 5 4 4 1 1 0 2 2 3 3 5 4 4 1 1 0 2 2
    1 0 0 -1-d -1 -1 -1-d 0 0 1 1 0 0 -1-d -1 -1 -1-d 0 0 1
    1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%% ==== Distancia aos Objectos ==== %%
yA=1;
xB=6;
yB=4;
xC=1;
yM=8;
zM=5;% só pode ser >= do que 4
w=3;
%% ==== Matrizes WTM ==== %%

% Alfa-Z Beta-Y Gama-X
WTM=[eye(3) [0 yM zM]'
    0 0 0 1];

WTA=[eye(3) [0 yA 0]'
    0 0 0 1];

WTB=[rot('Z',-90,'deg') [xB yB 0]'
    0 0 0 1];

WTC=[eye(3,3) [xC -d 0]'
    0 0 0 1];

%% ==== Start Positions ==== %%
hM1=create_M(WTM*M); 
hA1=create_AB(WTA*A);
hB1=create_AB(WTB*B);
hC1=create_C(WTC*C);

%% ==== Deslocamento de M ==== %%
pause(1);
delete(hM1);   %Apaga a posição incial do Manipulo

% %==== Rodar 90º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 90º do Manipulo\n')
for i=1:a_inc 
    WTM1=[matriz_rot([0 0 1]',deg2rad(-i*90/a_inc)) [0 yM zM]'
    0 0 0 1];
    hM1=create_M(WTM1*M);
    pause(a_speed)
    delete(hM1);
    %set(hM1,'Visible','off')
end

% %==== Translate yM-yA-4 unidades em Realação Ox e Translate 1 unidades em Realação Oy  Object ====% 
 fprintf(' Deslocação do Manipulo em Y para o objecto A \n')
 for i=1:a_inc
    WTM2 = WTM1*Transform(0,0,0, [i*(yM-yA-4)/a_inc i*1/a_inc 0]','deg') ;
    hM1=create_M(WTM2*M);
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
 end
 
% %==== Translate zM unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo em Z para o objecto A \n')
 for i=1:a_inc
    WTM3 = WTM2*Transform(0,0,0, [0 0 i*-zM/a_inc]','deg') ;
    hM1=create_M(WTM3*M);
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
 end
 %% ==== Deslocamento de M e A ==== %%
 delete(hA1);%apaga a posição inicial do objecto A
%set (hA1,'Visible','off')

WTM4 =WTM3*Transform(0,0,0, [yA 0 0]','deg') ;%define a posição do manipulo antes da rotação

fprintf('\n \n 2 Objectos\n\n')

 % %==== Translate zM unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo e do objecto A para cima\n')
 for i=1:a_inc
    WTA1 =WTA*Transform(0,0,0, [0 0 i*zM/a_inc]','deg') ;
    WTM5=WTA1*WTM4;
    hA1 =create_AB(WTA1*A);
    hM1 =create_M(WTM5*M); %desloca M com o movimento de A
    pause(a_speed)
    delete(hA1);
    delete(hM1);
%   set(hA1,'Visible','off')
%   set(hM1,'Visible','off')
 end

% % %==== Rodar 180º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 180º em z do Manipulo e do objecto A\n')
for i=1:a_inc 
    WTA2=WTA1*Transform(0, 0, i*180/a_inc, [0 0 0]','deg');
    WTM11=WTA2*WTM4;
    hA1=create_AB(WTA2*A);
    hM1=create_M(WTM11*M);%desloca M com o movimento de A
    pause(a_speed)
    delete(hA1);
    delete(hM1);
%   set(hA1,'Visible','off')
%   set(hM1,'Visible','off')
end

% %==== Rodar 90º em Realação a [1,0,0] do Object inicial ====%
fprintf(' Rotação de 90º em x do Manipulo e do objecto A \n')
for i=1:a_inc     
    WTA3=WTA2*Transform(i*90/a_inc, 0, 0, [0 0 0]','deg');
    WTM12=WTA3*WTM4;
    hA1=create_AB(WTA3*A);
    hM1=create_M(WTM12*M);%desloca M com o movimento de A
    pause(a_speed)
    delete(hA1);
    delete(hM1);
%   set(hA1,'Visible','off')
%   set(hM1,'Visible','off')
end

% %==== Translate yB-yA unidades em Realação Ox Object & Translate xB+w unidades em Realação Ox Object ====%
 fprintf(' Deslocação do Manipulo e do objecto A em X e Y\n')
  for i=1:a_inc
    WTA4 =WTA3*Transform(0,0,0, [-i*(yB-yA)/a_inc -i*(xB+w)/a_inc 0]','deg');
    WTM13=WTA4*WTM4;
    hA1=create_AB(WTA4*A);
    hM1=create_M(WTM13*M);
    pause(a_speed)
    delete(hA1);
    delete(hM1);
%   set(hA1,'Visible','off')
%   set(hM1,'Visible','off')
  end

 % %==== Translate zM-hB-HB-hA unidades em Realação Oz Object ====% 
fprintf(' Deslocação do Manipulo e do objecto A em Z para encaixar no objecto B\n')
 for i=1:a_inc
    WTA5 =WTA4*Transform(0,0,0, [0 0 i*(zM-hB-HB-hA)/a_inc]','deg');
    WTM9=WTA5*WTM4;
    hA1=create_AB(WTA5*A);
    hM1=create_M(WTM9*M);
    pause(a_speed)
    delete(hM1);
    set(hA1,'Visible','off')
%   set(hM1,'Visible','off')
 end

  %% ==== Deslocamento de M ==== %%
 set(hA1,'Visible','on')% mantem o objecto A visivel

% %==== Translate hA unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo para cima em Z\n')
 for i=1:a_inc
    WTM10 =WTM9*Transform(0,0, 0, [0 0 -i*(hA)/a_inc]','deg') ;
    hM1=create_M(WTM10*M); %RECHECK
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
 end

 % %==== Translate 4 unidades em Realação Oy Object ====% 
 fprintf(' Deslocação do Manipulo em Y \n')
 for i=1:a_inc
    WTM11 =WTM10*Transform(0,0, 0, [0 -i*4/a_inc 0]','deg') ;
    hM1=create_M(WTM11*M);
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
 end    

% %==== Rodar 180º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 180º do Manipulo\n')
for i=1:a_inc 
    WTM12 =WTM11*Transform(0,0, -i*180/a_inc, [0 0 0]','deg') ;
    hM1=create_M(WTM12*M);
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
end

% %==== Translate 2*hA+HB+hB unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo em Z para alinhar com a Base do obejcto B \n')
 for i=1:a_inc
    WTM13 =WTM12*Transform(0,0, 0, [0 0 -i*(2*hA+HB+hB)/a_inc]','deg') ;
    hM1=create_M (WTM13*M);
    pause(a_speed)
    delete(hM1);
%   set(hM1,'Visible','off')
 end   

 %% ==== Deslocamento de M e A e B ==== %%
 fprintf('\n \n 3 Objectos\n\n')
 
% %==== Translate xB-xC-2 unidades em Realação Ox Object & Translate hc unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo e dos objectos  A e B em z\n')
 for i=1:a_inc
    delete(hA1); %apaga a posição anterior de A
    delete(hB1); %apaga a posição anterior de B
    WTA6 =WTA5*Transform(0,0,0, [0 i*(xB-xC-2)/a_inc -i*(hC)/a_inc]','deg');
    WTB1 =WTB*Transform(0,0,0, [0 -i*(xB-xC-2)/a_inc i*(hC)/a_inc]','deg');
    WTM14 =WTM13*Transform(0,0,0, [-i*(xB-xC-2)/a_inc 0 i*(hC)/a_inc]','deg');
    hA1=create_AB(WTA6*A);
    hB1=create_AB(WTB1*B);
    hM1=create_M(WTM14*M);
    pause(a_speed)
    delete(hA1);
    delete(hB1); 
    delete(hM1);
%   set(hA1,'Visible','off')
%   set(hB1,'Visible','off')
   %set(hM1,'Visible','off')
   %alpha(hM1,.1); %fade
 end

% %==== Translate yB+2 unidades em Realação Oy Object ====%
fprintf(' Deslocação do Manipulo e dos objectos  A e B em y\n')
 for i=1:a_inc
    WTA7 =WTA6*Transform(0,0,0, [i*(yB+2)/a_inc 0 0]','deg');
    WTB2 =WTB1*Transform(0,0,0, [i*(yB+2)/a_inc 0 0]','deg');
    WTM15 =WTM14*Transform(0,0,0, [0 -i*(yB+2)/a_inc 0]','deg');
    hA1=create_AB(WTA7*A);
    hB1=create_AB(WTB2*B);
    hM1=create_M(WTM15*M);
    pause(a_speed)
    set(hA1,'Visible','off')
    set(hB1,'Visible','off')
    set(hM1,'Visible','off')
 end
set(hA1,'Visible','on')
set(hB1,'Visible','on')
set(hM1,'Visible','on')
    
%% ==== Function to Create Figure A e B ==== %%
% function h = create_AB(Pontos)
%     X =Pontos(1,:);
% 	Y =Pontos(2,:);
% 	Z =Pontos(3,:);
%     [~,c]=size(Pontos);
%     h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
%     h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
%     h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
%     h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'g'); % Side1(y=1)
%     h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'b'); % Top(z=1)
%     h(6)=fill3([X(c/2-2),X(c/4+1),X(c-3),X(c-2)],[Y(c/2-2),Y(c/4+1),Y(c-3),Y(c-2)],[Z(c/2-2),Z(c/4+1),Z(c-3),Z(c-2)],'g'); % Top(z=1)
%     h(7)=fill3([X(c/4+1),X(c/4),X(c-4),X(c-3)],[Y(c/4+1),Y(c/4),Y(c-4),Y(c-3)],[Z(c/4+1),Z(c/4),Z(c-4),Z(c-3)],'b'); % Top(z=1)
%     h(8)=fill3([X(c/4),X(3),X(c/2+3),X(c-4)],[Y(c/4),Y(3),Y(c/2+3),Y(c-4)],[Z(c/4),Z(3),Z(c/2+3),Z(c-4)],'m'); % Top(z=1)
%     h(9)=fill3([X(2),X(3),X(c/2+3),X(c/2+2)],[Y(2),Y(3),Y(c/2+3),Y(c/2+2)],[Z(2),Z(3),Z(c/2+3),Z(c/2+2)],'b'); % Top(z=1)
%     h(10)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'m'); % Top(z=1)
% end
%% ==== Function to Create Figure M ==== %%
% function h = create_M(Pontos)
%     X =Pontos(1,:);
% 	Y =Pontos(2,:);
% 	Z =Pontos(3,:);
%     [~,c]=size(Pontos);
%     h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
%     h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
%     h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
%     h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'g'); % Side1(y=1)
%     h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'b'); % Top(z=1)
%     h(6)=fill3([X(c/4),X(c/4-1),X(3*c/4-1), X(3*c/4)],[Y(c/4),Y(c/4-1),Y(3*c/4-1), Y(3*c/4)],[Z(c/4),Z(c/4-1),Z(3*c/4-1), Z(3*c/4)],'m'); 
%     h(7)=fill3([X(c/4),X(c/4+1),X(3*c/4+1), X(3*c/4)],[Y(c/4),Y(c/4+1),Y(3*c/4+1), Y(3*c/4)],[Z(c/4),Z(c/4+1),Z(3*c/4+1), Z(3*c/4)],'y');
%     h(8)=fill3([X(c/4+1),X(c/4+2),X(3*c/4+2), X(3*c/4+1)],[Y(c/4+1),Y(c/4+2),Y(3*c/4+2), Y(3*c/4+1)],[Z(c/4+1),Z(c/4+2),Z(3*c/4+2), Z(3*c/4+1)],'m');
%     h(9)=fill3([X(7),X(8),X(18), X(17)],[Y(7),Y(8),Y(18),Y(17)],[Z(7),Z(8),Z(18),Z(17)],'g');
%     h(10)=fill3([X(c/4-2),X(c/4-1),X(c-(c/4)-1),X(c-(c/4)-2)],[Y(c/4-2),Y(c/4-1),Y(c-(c/4)-1),Y(c-(c/4)-2)],[Z(c/4-2),Z(c/4-1),Z(c-(c/4)-1),Z(c-(c/4)-2)],'g'); % Top(z=1)
%     h(11)=fill3([X(2),X(3),X(c/2+3),X(c/2+2)],[Y(2),Y(3),Y(c/2+3),Y(c/2+2)],[Z(2),Z(3),Z(c/2+3),Z(c/2+2)],'b'); % Top(z=1)
%     h(12)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'m'); % Top(z=1)
% end

%% ==== Function to Create Figure C ==== %%
% function h = create_C(Pontos)
%     X =Pontos(1,:);
% 	Y =Pontos(2,:);
% 	Z =Pontos(3,:);
%     [~,c]=size(Pontos);
%     h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
%     h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
%     h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
%     h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'b'); % Side1(y=1)
%     h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'g'); % Top(z=1)
%     h(6)=fill3([X(c/2-3),X(c/2-2),X(c/2+4),X(c/2+3)],[Y(c/2-3),Y(c/2-2),Y(c/2+4),Y(c/2+3)],[Z(c/2-3),Z(c/2-2),Z(c/2+4),Z(c/2+3)],'b'); % Top(z=1)
%     h(7)=fill3([X(c/2-3),X(2),X(c/2+2),X(c/2+3)],[Y(c/2-3),Y(2),Y(c/2+2),Y(c/2+3)],[Z(c/2-3),Z(2),Z(c/2+2),Z(c/2+3)],'m'); % Top(z=1)
%     h(8)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'b'); % Top(z=1)
% end