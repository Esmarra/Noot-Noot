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
set(gcf, 'Position', [900-w_size/2, 540-w_size/2, w_size, w_size])
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
pause(2);
delete(hM1);   %Apaga a posição incial do Manipulo

% %==== Rodar 90º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 90º do Manipulo\n')
for i=1:a_inc 
    WTM1=[matriz_rot([0 0 1]',deg2rad(-i*90/a_inc)) [0 yM zM]'
    0 0 0 1];
    h1=create_M(WTM1*M);
    pause(a_speed)
    delete(h1);
    %set(h1,'Visible','off')
end

% %==== Translate yM-yA-4 unidades em Realação Ox e Translate 1 unidades em Realação Oy  Object ====% 
 fprintf(' Deslocação do Manipulo em Y para o objecto A \n')
 for i=1:a_inc
    WTM2 = WTM1*Transform(0,0,0, [i*(yM-yA-4)/a_inc i*1/a_inc 0]','deg') ;
    h2=create_M(WTM2*M);
    pause(a_speed)
    delete(h2);
%   set(h2,'Visible','off')
 end
 
% %==== Translate zM unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo em Z para o objecto A \n')
 for i=1:a_inc
    WTM3 = WTM2*Transform(0,0,0, [0 0 i*-zM/a_inc]','deg') ;
    h3=create_M(WTM3*M);
    pause(a_speed)
    delete(h3);
%   set(h3,'Visible','off')
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
    h4 =create_AB(WTA1*A);
    h5 =create_M(WTA1*WTM4*M); %desloca M com o movimento de A
    pause(a_speed)
    delete(h4);
    delete(h5);
%   set(h4,'Visible','off')
%   set(h5,'Visible','off')
 end

% % %==== Rodar 180º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 180º em z do Manipulo e do objecto A\n')
for i=1:a_inc 
    WTA2=WTA1*Transform(0, 0, i*180/a_inc, [0 0 0]','deg');
    h6=create_AB (WTA2*A);
    h7=create_M (WTA2*WTM4*M);%desloca M com o movimento de A
    pause(a_speed)
    delete(h6);
    delete(h7);
%   set(h6,'Visible','off')
%   set(h7,'Visible','off')
end

% %==== Rodar 90º em Realação a [1,0,0] do Object inicial ====%
fprintf(' Rotação de 90º em x do Manipulo e do objecto A \n')
for i=1:a_inc     
    WTA3=WTA2*Transform(i*90/a_inc, 0, 0, [0 0 0]','deg');
    h8=create_AB (WTA3*A);
    h9=create_M (WTA3*WTM4*M);%desloca M com o movimento de A
    pause(a_speed)
    delete(h8);
    delete(h9);
%   set(h8,'Visible','off')
%   set(h9,'Visible','off')
end

% %==== Translate yB-yA unidades em Realação Ox Object & Translate xB+w unidades em Realação Ox Object ====%
 fprintf(' Deslocação do Manipulo e do objecto A em X e Y\n')
  for i=1:a_inc
    WTA4 =WTA3*Transform(0,0,0, [-i*(yB-yA)/a_inc -i*(xB+w)/a_inc 0]','deg') ;
    h10=create_AB (WTA4*A);
    h11=create_M (WTA4*WTM4*M);
    pause(a_speed)
    delete(h10);
    delete(h11);
%   set(h10,'Visible','off')
%   set(h11,'Visible','off')
  end

 % %==== Translate zM-hB-HB-hA unidades em Realação Oz Object ====% 
fprintf(' Deslocação do Manipulo e do objecto A em Z para encaixar no objecto B\n')
 for i=1:a_inc
    WTA5 =WTA4*Transform(0,0,0, [0 0 i*(zM-hB-HB-hA)/a_inc]','deg') ;
    h12=create_AB (WTA5*A);
    h13=create_M (WTA5*WTM4*M);
    pause(a_speed)
    delete(h13);
    set(h12,'Visible','off')
%   set(h13,'Visible','off')
 end
 
  %% ==== Deslocamento de M ==== %%
 set(h12,'Visible','on')% mantem o objecto A visivel

% %==== Translate hA unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo para cima em Z\n')
 for i=1:a_inc
    WTM5 =WTM4*Transform(0,0, 0, [0 0 -i*(hA)/a_inc]','deg') ;
    h15=create_M (WTA5*WTM5*M);
    pause(a_speed)
    delete(h15);
%   set(h15,'Visible','off')
 end
 
 % %==== Translate 4 unidades em Realação Oy Object ====% 
 fprintf(' Deslocação do Manipulo em Y \n')
 for i=1:a_inc
    WTM6 =WTM5*Transform(0,0, 0, [0 -i*4/a_inc 0]','deg') ;
    h16=create_M (WTA5*WTM6*M);
    pause(a_speed)
    delete(h16);
%   set(h16,'Visible','off')
 end    

% %==== Rodar 180º em Realação a [0,0,1] do Object inicial ====%
fprintf(' Rotação de 180º do Manipulo\n')
for i=1:a_inc 
    WTM7 =WTM6*Transform(0,0, -i*180/a_inc, [0 0 0]','deg') ;
    h17=create_M  (WTA5*WTM7*M);
    pause(a_speed)
    delete(h17);
%   set(h17,'Visible','off')
 end

% %==== Translate 2*hA+HB+hB unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo em Z para alinhar com a Base do obejcto B \n')
 for i=1:a_inc
    WTM8 =WTM7*Transform(0,0, 0, [0 0 -i*(2*hA+HB+hB)/a_inc]','deg') ;
    h18=create_M (WTA5*WTM8*M);
    pause(a_speed)
    delete(h18);
%   set(h18,'Visible','off')
 end    
 %% ==== Deslocamento de M e A e B ==== %%
 fprintf('\n \n 3 Objectos\n\n')
 
% %==== Translate xB-xC-2 unidades em Realação Ox Object & Translate hc unidades em Realação Oz Object ====% 
 fprintf(' Deslocação do Manipulo e dos objectos  A e B em z\n')
 for i=1:a_inc
    delete(h12); %apaga a posição anterior de A
    delete(hB1); %apaga a posição anterior de B
    WTA6 =WTA5*Transform(0,0,0, [0 i*(xB-xC-2)/a_inc -i*(hC)/a_inc]','deg') ;
    WTB1 =WTB*Transform(0,0,0, [0 -i*(xB-xC-2)/a_inc i*(hC)/a_inc]','deg') ;
    h19=create_AB (WTA6*A);
    h20=create_AB (WTB1*B);
    h21=create_M (WTA6*WTM8*M);
    pause(a_speed)
    delete(h19);
    delete(h20); 
    delete(h21);
%   set(h19,'Visible','off')
%   set(h20,'Visible','off')
%   set(h21,'Visible','off')
 end

% %==== Translate yB+2 unidades em Realação Oy Object ====%
fprintf(' Deslocação do Manipulo e dos objectos  A e B em y\n')
 for i=1:a_inc
    WTA7 =WTA6*Transform(0,0,0, [i*(yB+2)/a_inc 0 0]','deg') ;
    WTB2 =WTB1*Transform(0,0,0, [i*(yB+2)/a_inc 0 0]','deg') ;
    h19=create_AB (WTA7*A);
    h20=create_AB (WTB2*B);
    h21=create_M (WTA7*WTM8*M);
    pause(a_speed)
    set(h19,'Visible','off')
    set(h20,'Visible','off')
    set(h21,'Visible','off')
 end
    set(h19,'Visible','on')
    set(h20,'Visible','on')
    set(h21,'Visible','on')

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