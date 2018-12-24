% Miguel Maranha 2012138309

clear; clc; close all;
syms t1 t2 a l;

global Robot;
% Sample Interval
interval = 0.3;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      -pi/2       0        0  "R"  %0->1
        t2     1       pi/2       0        pi/2    "R"  %1->2
        0      1        0         0        0    "R"];  %2->3
l=1;
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', -pi/2  , 'offset', 0 );
L2=Link('d'    , 1 , 'a', 0 ,  'alpha', pi/2 , 'offset',   pi/2 );
L3=Link('d'    ,  l , 'a', 0  , 'alpha', 0  , 'offset',   0  ,'qlim' ,[0 50]);

Robot=SerialLink([L1 L2 L3], 'name', 'BoT 2');
Robot.plotopt = {'floorlevel', 2,'trail',{'m', 'LineWidth', 2}};
Robot.teach(deg2rad([-45 -45 0]))
[n,~]=size(DH);

% Obtain Forward Kinematics
T0_EE=FK_MGD_DH2(DH,n)

% Given positions @ A/B/C
pa=[(1+sqrt(2))/2,(-1+sqrt(2))/2,(sqrt(2))/2];
pb=[(sqrt(2))/2,1,(-sqrt(2))/2];
pc=[-1,(sqrt(2))/2,(-sqrt(2))/2];

% Cacl Joint Variables
qa=sloppy_ik(pa)';
qb=sloppy_ik(pb)';
qc=sloppy_ik(pc)';
disp("======== Alinea a) ========")
fprintf("==== Joint Variables ====\n");
fprintf("Joint Value at A: ");fprintf("%f ",qa');fprintf("| DEG: ");disp(rad2deg(qa'));
fprintf("Joint Value at B: ");fprintf("%f ",qb');fprintf("| DEG: ");disp(rad2deg(qb'));
fprintf("Joint Value at C: ");fprintf("%f ",qc');fprintf("| DEG: ");disp(rad2deg(qc'));

% Get Transformation Matrix for Given Points A/B/C
T0_A=eval(subs(T0_EE,[t1 t2],qa'));
T0_B=eval(subs(T0_EE,[t1 t2],qb'));
T0_C=eval(subs(T0_EE,[t1 t2],qc'));

% Disp Robot Frame for Given Points A/B/C
hold on;
trplot(T0_A,'frame', 'A','color','r');
trplot(T0_B,'frame', 'B','color','b');
trplot(T0_C,'frame', 'C','color','k');


% Merge to Matriz (pointsXjoints)
q_mat=[qa';qb';qc'];

% Time Restriction (Passes Point @ t)
time_a = 0;
time_b = 4;
time_c = 10;
% Merge to Vector 1Xpoints
t_vec = [ time_a time_b time_c];

% Calculate All joint velocitys for at Points
v_qmat = velocidades(q_mat, t_vec);

vel_a=v_qmat(1,:);
vel_b=v_qmat(2,:);
vel_c=v_qmat(3,:);
disp("======== Alinea b) ========")
fprintf("==== Joint Velocitys ====\n");
fprintf("Joint Velocity at A:");disp(vel_a);
fprintf("Joint Velocity at B:");disp(vel_b);
fprintf("Joint Velocity at C:");disp(vel_c);

%% Path A -> B
for t = time_a : interval : time_b % #### Transformar em FUNCAO! ####
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_a;
    time_end = time_b;
    q_start = qa;
    q_end = qb;
    v_start = vel_a;
    v_end = vel_b;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
	Robot.animate([q_now 0]);
end
%fprintf("(CALC) Joint Value at B:");disp(q_now);

%% Path B -> C
for t = time_b : interval : time_c
    % Poly Inputs (Easy copy paste for more paths)
    time_start = time_b;
    time_end = time_c;
    q_start = qb;
    q_end = qc;
    v_start = vel_b;
    v_end = vel_c;
    % Current Joint Var values
    q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
	Robot.animate([q_now 0]);
end
%fprintf("(CALC) Joint Value at C:");disp(q_now);



pause(1.5)
%% ======== Alinea c) ========
disp("======== Alinea c) ========")
Robot.plot([qa' 0]);
fprintf("End in cycle:")
for count = 1 : 1 : 7
	fprintf(" %d |",7-count)
    % NEW TIME Vector 1Xpoints
    t_vec = [ 0 4 10 12 16 22 24 28 34 ];
    
    % ASSING NEW VALUES
    time_a = t_vec(count);
    time_b = t_vec(count+1);
    time_c = t_vec(count+2);
    time_c_a=time_c+2;
    % Calculate All joint velocitys for at Points
    v_qmat = velocidades([q_mat;q_mat(2:3,:);q_mat(3,:);q_mat], t_vec);
    
    vel_a=v_qmat(1,:);
    vel_b=v_qmat(2,:);
    vel_c=v_qmat(3,:);
%     fprintf("Joint Velocity at A:");disp(vel_a);
%     fprintf("Joint Velocity at B:");disp(vel_b);
%     fprintf("Joint Velocity at C:");disp(vel_c);

    %% Path A -> B
    for t = time_a : interval : time_b % #### Transformar em FUNCAO! ####
        % Poly Inputs (Easy copy paste for more paths)
        time_start = time_a;
        time_end = time_b;
        q_start = qa;
        q_end = qb;
        v_start = vel_a;
        v_end = vel_b;
        % Current Joint Var values
        q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
        Robot.animate([q_now 0]);
    end
%     fprintf("(CALC) Joint Value at B:");disp(q_now);

    %% Path B -> C
    for t = time_b : interval : time_c
        % Poly Inputs (Easy copy paste for more paths)
        time_start = time_b;
        time_end = time_c;
        q_start = qb;
        q_end = qc;
        v_start = vel_b;
        v_end = vel_c;
        % Current Joint Var values
        q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
        Robot.animate([q_now 0]);
    end
%     fprintf("(CALC) Joint Value at C:");disp(q_now);

    %c)
    %% Path C -> A
    for t = time_c : interval : time_c_a
        % Poly Inputs (Easy copy paste for more paths)
        time_start = time_c;
        time_end = time_c_a;
        q_start = qc;
        q_end = qa;
        v_start = vel_c;
        v_end = vel_a;
        % Current Joint Var values
        q_now=poly3(t,time_start,time_end,q_start,q_end,v_start,v_end);
        Robot.animate([q_now 0]);
    end
%     fprintf("(CALC) Joint Value at A:");disp(q_now);
end



pause(1.5)
%% ======== Alinea d) ========
fprintf("\n\n")
disp("======== Alinea d) ========")
% tb1 -> troço acelera(+) A até B-
% tb2 -> troço desacelera(-) até B
% tb3 -> troço acelera(+) até C- 
% tb4 -> troço desacelera(-) até C

% Merge to Matriz (pointsXjoints)
q_mat=[qa';qb';qc'];

% Time Restriction (Passes Point @ t)
time_a = 0;
time_b = 4;
time_c = 10;
% Merge to Vector 1Xpoints
t_vec = [ time_a time_b time_c];

% Calculate All joint velocitys for at Points
acc_max=deg2rad(60);
v_qmat = velocidades_acc(acc_max,q_mat, t_vec);

vel_a=v_qmat(1,:);
vel_b=v_qmat(2,:);
vel_c=v_qmat(3,:);
fprintf("==== Joint Velocitys ====\n");
fprintf("Joint Velocity at A:");disp(vel_a);
fprintf("Joint Velocity at B:");disp(vel_b);
fprintf("Joint Velocity at C:");disp(vel_c);

function q=sloppy_ik(p)
    L=1;

    % get t
    tx = p(1); 
	ty = p(2); 
	tz = p(3);
    
    %Formula quadro teta2
    %t2=atan((-tz)/((tx^2)+(ty^2)-L));
    %t1=atan(ty-tx) - atan2(L,cos(t2));
    
    t2 = atan2( -tz, sqrt(tx^2 + ty^2 - L));
    t1 = atan2(ty, tx) - atan2(L, cos(t2));
    
    %t2=-asin((- tx^2 - ty^2 + 2)^(1/2)) % WRONG -.-
    %t1=atan2(ty,sqrt(L+(cos(t2)^2)-(ty^2)))-atan2(L,cos(t2)); % WRONG -.-
    
    q=[t1,t2];
end