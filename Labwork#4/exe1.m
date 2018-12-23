% Miguel Maranha 2012138309

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

figure('Name',"Forward Kinematics")

Robot=SerialLink([L1 L2 L3 L4], 'name', 'BoT 1');
Robot.plotopt = {'floorlevel', 2, 'workspace', [-10, 35, -20, 35, -5, 5], 'reach', 10,'tilesize',12,'trail',{'b', 'LineWidth', 2}};
Robot.teach([0 0 0 0]);
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
qa=invkine_ex1(T0A)'; % No Ponto A
qi=invkine_ex1(T0I)'; % No Ponto I
qb=invkine_ex1(T0B)'; % No Ponto B
fprintf("Joint Value at A:");disp(qa');
fprintf("Joint Value at I:");disp(qi');
fprintf("Joint Value at B:");disp(qb');
% Merge to Matriz (pointsXjoints)
q_mat=[qa';qi';qb'];


% Time Restriction (Passes Point @ t)
time_a = 0;
time_i = 5;
time_b = 8;
% Merge to Vector 1Xpoints
t_vec = [ time_a time_i time_b];

% Calculate All joint velocitys for at Points
v_qmat = velocidades(q_mat, t_vec);

vel_a=v_qmat(1,:);
vel_i=v_qmat(2,:);
vel_b=v_qmat(3,:);
fprintf("Joint Velocity at A:");disp(vel_a);
fprintf("Joint Velocity at I:");disp(vel_i);
fprintf("Joint Velocity at B:");disp(vel_b);

%% Path A -> I
for t = time_a : interval : time_i % #### Transformar em FUNCAO! ####
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_a;
    time_end = time_i;
    q_start = qa;
    q_end = qi;
    v_start = vel_a;
    v_end = vel_i;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
    hold on;
	if(t==time_a)Robot.plot([q_now 0]);end % Clean trace
	Robot.animate([q_now 0]);
end

fprintf("(CALC) Joint Value at I:");disp(q_now);

%% Path I -> B
for t = time_i : interval : time_b
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_i;
    time_end = time_b;
    q_start = qi;
    q_end = qb;
    v_start = vel_i;
    v_end = vel_b;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
	Robot.animate([q_now 0]);
end
fprintf("(CALC) Joint Value at B:");disp(q_now);

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
	q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
	Robot.animate([q_now 0]);
end
fprintf("(CALC) Joint Value at A:");disp(q_now);

%%========= FUNCTIONS ==========%%

