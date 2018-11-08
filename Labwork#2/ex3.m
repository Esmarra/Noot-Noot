clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;        %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5 t6; % Tetas
syms l1 l2 l3 t d l;
global Robot_RT
global Robot_RRR

global l l1 l2 l3;
l=2;
d=2.5*l;
l1=sqrt(2)*l;
l2=l1;
l3=sqrt(7)*l;

%% ==== Create Window ==== %%
figure('Name',"Forward Kinematics")
w_size=900;
set(gcf, 'Position', [1440-w_size/2, 540-w_size/2, w_size, w_size])
view(135, 50);
hold on

%% ==== Denavit Matrix RRR com l1 l2 l3 ==== %%
%       t  d alpha  a  offset   
PJ_DH=[t1  0   0    l1   0     %0->1
       t2  0   0    l2   0     %1->2
       t3  0  pi/2  0   pi/2   %2->3
       0   l3   0   0   pi/2]; %3->G
% Create RRR Robot Links
L1=Link('d', 0, 'a', l1, 'alpha', 0, 'offset', 0 );
L2=Link('d', 0, 'a', l2, 'alpha', 0, 'offset', 0 );
L3=Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', pi/2 );
L4=Link('d', l3, 'a', 0, 'alpha', 0, 'offset', pi/2 );
% Create Robot
Robot_RRR=SerialLink([L1 L2 L3 L4], 'name', 'RRR');

%% ==== Denavit Matrix RT com l1 l2 l3 ==== %%
%         t  d alpha  a  offset
PJ_DH_RT=[t  0  pi/2  1  0   %0->1
          0  d   0    0  0]; %2->EE
% Create RT Robot Links
L1b=Link('d', 0, 'a', l, 'alpha', pi/2, 'offset', 0 );
L2b=Link('d', d, 'a', 0, 'alpha', 0, 'offset', 0,'qlim',[0 5]);
% Create Robot
Robot_RT=SerialLink([L1b L2b], 'name', 'RT');

%%

%Desenhar RRR
q1=[135 0 -135 0];
Robot_RRR.plot(deg2rad(q1),'tilesize',4,'trail',{'r', 'LineWidth', 2});
%Desenhar RT
q2=[0 0];
Robot_RT.plot(deg2rad(q2),'linkcolor','g','jointdiam',2,'jointcolor','y');

%% Fazer Algo?
%Get Cadeia Cinematica(FK) RRR
[oAh_RRR,A_RRR]=FK_MGD_DH(PJ_DH);
%Get Cadeia Cinematica(FK) RT
[oAh_RT,A_RT]=FK_MGD_DH(PJ_DH_RT);

%Calc Inverse Kine RRR
q_rrr=invkine_3(0,d) %t=0 d=5 porque...
Robot_RRR.plot([q_rrr 0],'tilesize',4);
PJ_DH1=double(subs(PJ_DH,[t1 t2 t3],q_rrr))

%% Animations...
disp("Anime")
steps=10;
teta=degtorad(90);
%Initialize Position Array to 0's
Q=zeros(steps,4);
%while(1)
for i = 1:1:steps
	%Populate Position Array
	Q(i,1:3)=invkine_3(i*teta/10,-i*d/steps);
	Robot_RRR.animate(Q(i,:));
	Robot_RT.animate([Q(i,1)+deg2rad(-90) 0]);
end
%end

%% Inverse Kinematics For RRR
function q = invkine_3(t,d)
    global l l1 l2 l3;
    %l1=sqrt(2)*l;
    %l2=l1;
    
    txi = l*cos(t) + (d)*sin(t);
    tyi = l*sin(t) - (d)*cos(t);
    %tz=0;
    
    t2 = -acos((txi^2+tyi^2 - l1^2 -l2^2)/(2*l1*l2));
    t1 = atan2(tyi, txi) - atan2(l2*sin(t2), l1+l2*cos(t2));
    t3 = -pi/2 + t - t1 - t2;

    q = [t1 t2 t3];
end