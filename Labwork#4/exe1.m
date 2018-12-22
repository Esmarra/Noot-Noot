clear; clc; close all;
syms t1 t2 t3 t4 a1 a2 a3 d1 d2 d3;

global Robot;
% Sample Interval
interval = 0.1;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      pi/2       0       pi/2  "R"  %0->1
        0      d2    -pi/2       0        0    "P"  %1->2
        t3     0      pi/2       0        0    "R"  %2->I
        0      a3       0        0     -pi/2   "I"];%I->G

L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta' , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset',   0  ,'qlim' ,[0 50]);
L3=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',   0  );
L4=Link('d'    ,  10, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot=SerialLink([L1 L2 L3 L4], 'name', 'BoT 1');
Robot.plotopt = {'floorlevel', 2, 'workspace', [-10, 35, -20, 35, -5, 5], 'reach', 10,'tilesize',12};
Robot.teach([0 0 0 0])

[n,~]=size(DH);

% Forward Kinematics Base to End.Effector
T0_EE=simplify(FK_MGD_DH2(DH,n));
T0_EE=eval(subs(T0_EE,a3,10))

% Start
T0A=[ 0 -0.2588 .9659 23.8014
      0 -0.9659 -0.2588 11.5539
      1 0 0 0
      0 0 0 1];

% Mid Point
T0I=[0 1 0 0
     0 0 1 0
     1 0 0 0
     0 0 0 1];

% End Point
T0B=[ 0 0.8660 0.5 30.9808
      0 -0.5 0.8660 -6.3397
      1 0 0 0
      0 0 0 1];
 
% Variaveis de Juntas 
qa=invkine_2(T0A)'; % No Ponto A
qi=invkine_2(T0I)'; % No Ponto I
qb=invkine_2(T0B)'; % No Ponto B
fprintf("Joint Var at A:");disp(qa');
fprintf("Joint Var at I:");disp(qi');
fprintf("Joint Var at B:");disp(qb');

% Time Restriction (Passes Point @ t)
time_a = 0;
time_i = 5;
time_b = 8;


[l,~]=size(qa);
%vel_i=zeros(1,l);
for i=1:3
    vel_a_i = (qi(i)-qa(i)) / (time_i-time_a);
    vel_i_b = (qb(i)-qi(i)) / (time_b-time_i);

    if sign(vel_a_i) == sign(vel_i_b)
        vel_i = (1/2)*(vel_a_i + vel_i_b)
    else
        vel_i = 0;
    end
end

%% Path A -> I

vel_a = 0; % Starting Velocity Poin A
for t = time_a : interval : time_i % #### Transformar em FUNCAO! ####
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_a;
    time_end = time_i;
    q_start = qa;
    q_end = qi;
    v_start = vel_a;
    v_end = vel_i;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,vel_i);
	Robot.plot([q_now 0]);
end
fprintf("(CALC) Joint Var at I:");disp(q_now);

%% Path I -> B
vel_b=0;
for t = time_i : interval : time_b
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_i;
    time_end = time_b;
    q_start = qi;
    q_end = qb;
    v_start = vel_i;
    v_end = vel_b;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,vel_i);
	Robot.plot([q_now 0]);
end
fprintf("(CALC) Joint Var at B:");disp(q_now);

%Bonus
%% Path B -> A
time_a=time_b+1;
for t = time_b : interval : time_a
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_b;
    time_end = time_a;
    q_start = qb;
    q_end = qa;
    v_start = vel_b;
    v_end = vel_a;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,vel_i);
	Robot.plot([q_now 0]);
end
fprintf("(CALC) Joint Var at A:");disp(q_now);

%%========= FUNCTIONS ==========%%

%% Polynomial^3 Function
function j_value = poly3(t,ti,tf,q_start,q_end,vs,v_end)
    [l,~]=size(q_start);
    Dt = tf-ti;
    j_value=zeros(1,l);
    for i=1:1:l
        teta_s=q_start(i);
        teta_f=q_end(i);
        vf=v_end;
        j_value(i) = teta_s + vs*(t-ti) + ( (3/(Dt^2))*(teta_f-teta_s) - (2/Dt)*vs - (1/Dt)*vf )*((t-ti)^2) - ( (2/(Dt^3))*(teta_f-teta_s) - (1/(Dt^2))*(vf+vs) )*((t-ti)^3);

    end
end
