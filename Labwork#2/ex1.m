clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;        %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5 t6; % Tetas
global Robot Robot_02;

%% ==== Create Window ==== %%
figure('Name',"Forward Kinematics")
w_size=900;
%set(gcf, 'Position', [1440-w_size/2, 540-w_size/2, w_size, w_size])
view(135, 50);
hold on

%% ==== Denavit Matrix ==== %%
%       t  d alpha  a  offset   
% PJ_DH=[t1  0   0    4   0     %0->1
%        t2  0   0    3   0     %1->2
%        t3  0  pi/2  0  pi/2   %2->3
%        0   2   0    0  pi/2]; %3->G
syms a1 a2 a3;
PJ_DH=[t1  0   0 a1   0 "R"   %1->2
       t2  0  0  a2  0  "R"];   %2->3
disp(" ==== Pergunta a) Matrix DH ==== ");
disp(PJ_DH);

%% ==== Create Robot Links ==== %%
L1=Link('d', 0, 'a', 4, 'alpha', 0, 'offset', 0 );
L2=Link('d', 0, 'a', 3, 'alpha', 0, 'offset', 0 );
L3=Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', pi/2 );
L4=Link('d', 2, 'a', 0, 'alpha', 0, 'offset', pi/2 );

Robot=SerialLink([L1 L2 L3 L4], 'name', 'i) FK');
Robot_02=SerialLink([L1 L2]);
% Extra Step Calc Symbolic Zero to End Efector Matrix
oAhi_symb=simplify(FK_MGD_DH(PJ_DH))

%% ==== i) ==== %%
disp(" ==== Pergunta b) 0A2 e 0AH ==== ");
disp("  ==== i) q=[0 0 0] ====  ");
q=[0 0 0 0];
% Replace DH Matrix Tetas
PJ_DH1=eval(subs(PJ_DH,[t1 t2 t3 t4],deg2rad(q)));
[oAhi,H]=FK_MGD_DH(PJ_DH1);
subplot(2,2,1)
Robot.plot(deg2rad(q),'tilesize',1 ); %Mudar Conforme os Links :/
oA2i=H(:,:,1)*H(:,:,2);
disp(" OA2=");
disp(double(oA2i))
disp(" OAH=");
disp(double(oAhi))
% Confirmação robotics toolbox
disp(" OA2 tool=");
disp(Robot_02.fkine(q(1:2)));
disp(" OAH tool=");
disp(double(Robot.fkine(q)));

%% ==== ii) ==== %%
disp("  ==== ii) q=[10 20 30] ====  ");
q=[10 20 30 0];
% Replace DH Matrix Tetas
PJ_DH2=eval(subs(PJ_DH,[t1 t2 t3 t4],deg2rad(q)));
[oAhii,H]=FK_MGD_DH(PJ_DH2);
subplot(2,2,2)
bob1 = SerialLink(Robot, 'name', 'ii) FK');
bob1.plot(deg2rad(q),'tilesize',1 ); %Mudar Conforme os Links :/
oA2ii=H(:,:,1)*H(:,:,2);
%oAh=H(:,:,1)*H(:,:,2)*H(:,:,3)*H(:,:,4);
disp(" OA2=");
disp(double(oA2ii))
disp(" OAH=");
disp(double(oAhii))
% Confirmação robotics toolbox
disp(" OA2 tool=");
disp(Robot_02.fkine(deg2rad(q(1:2))));
disp(" OAH tool=");
disp(double(Robot.fkine(deg2rad(q))));
%% ==== iii) ==== %%
disp("  ==== iii) q=[90 90 90] ====  ");
q=[90 90 90 0];
% Replace DH Matrix Tetas
PJ_DH2=eval(subs(PJ_DH,[t1 t2 t3 t4],deg2rad(q)));
[oAhiii,H]=FK_MGD_DH(PJ_DH2);
subplot(2,2,3)
bob2 = SerialLink(Robot, 'name', 'iii) FK');
bob2.plot(deg2rad(q),'tilesize',1 ); %Mudar Conforme os Links :/
oA2iii=H(:,:,1)*H(:,:,2);
%oAh=H(:,:,1)*H(:,:,2)*H(:,:,3)*H(:,:,4);
disp(" OA2=");
disp(double(oA2iii))
disp(" OAH=");
disp(double(oAhiii))


%% ==== e) ==== %%
disp(" ==== Pergunta e) usando invkine desenhe os robots ==== ");
figure('Name','Inverse Kinematics');
w_size=900;
%set(gcf, 'Position', [990-w_size, 540-w_size/2, w_size, w_size])
view(135, 50);
%i)
qi=rad2deg(double(invkine_1(oAhi)))
% Confirmação robotics toolbox
disp("pela toolbox");
qi_tool=Robot.ikine(double(oAhi), 'mask', [1 1 0 1 0 1])
subplot(2,2,1)
bob3 = SerialLink(Robot, 'name', 'i) invK');
bob3.plot([deg2rad(qi) 0],'tilesize',1 );
%ii)
qii=rad2deg(double(invkine_1(oAhii)))
% Confirmação robotics toolbox
disp("pela toolbox");
qii_tool=rad2deg(Robot.ikine(double(oAhii), 'mask', [1 1 0 1 0 1]))
subplot(2,2,2)
bob4 = SerialLink(Robot, 'name', 'ii) invK');
bob4.plot([deg2rad(qii) 0],'tilesize',1 );
%iii)
qiii=rad2deg(double(invkine_1(oAhiii)))
% Confirmação robotics toolbox
disp("pela toolbox");
qiii_tool=rad2deg(Robot.ikine(double(oAhiii), 'mask', [1 1 0 1 0 1]))
subplot(2,2,3)
bob5 = SerialLink(Robot, 'name', 'iii) invK');
bob5.plot([deg2rad(qiii) 0],'tilesize',1 );

%% Homogenious DH & Forward Kinematics
% function [oTee,A]=FK_MGD_DH(DH)
%     % Get number of DH Lines (Use as Global??)
%     [l,~]=size(DH);
%     A=sym(zeros(4,4,l)); %PreDeclarar a Zeros Multi Dim Matrix
%     
%     for i=1:l
%         tet=DH(i,1);d=DH(i,2);alf=DH(i,3);a=DH(i,4);of=DH(i,5); % 4 exchange with 3 from Lab1-ex3
%         % A is the Homogenious Denavit-Hartenberg Matrix
%         A(:,:,i)=[cos(tet+of) -sin(tet+of)*cos(alf) sin(tet+of)*sin(alf) a*cos(tet+of)
%             sin(tet+of) cos(tet+of)*cos(alf) -cos(tet+of)*sin(alf) a*sin(tet+of)
%             0 sin(alf) cos(alf) d
%             0 0 0 1];
%         %% ==== Cadeia Cinematica ==== %%
%         % Calc First Inter H=H0_1
%         if(i<2) 
%             oTee=A(:,:,i);
%         end
%         % Calc H0_EE -> Recursive H0_1*H1_2*H2_3*...*Hn-1_n
%         if(i>1)
%             oTee=oTee*A(:,:,i);
%         end
%         
%     end
% end

%% Inverse Kinematics For RRRP
% function q = invkine_1(T0G)
%     l1 = 4;
%     l2 = 3;
%     l3 = 2;
%     
%     t = T0G(1:3, 4);
%     a = T0G(1:3, 3);
%     %s = T0G(1:3, 2);
%     %n = T0G(1:3, 1);
%     
%     ax = a(1);
%     ay = a(2);
%     %az = a(3);
%     
%     % Calc t' = [tx' ty' tz']
%     ti = t - l3*a;
%     
%     txi = ti(1);
%     tyi = ti(2);
%     
%     % Como vimos na Aula teta2 pode ser +/- acos(...)
%     t2 = acos((txi^2+tyi^2 - l1^2 -l2^2)/(2*l1*l2));
%     t1 = atan2(tyi, txi) - atan2(l2*sin(t2), l1+l2*cos(t2));
%     t3 = atan2(ay, ax) - t1 - t2;
%     
%     q = [t1 t2 t3];
% end