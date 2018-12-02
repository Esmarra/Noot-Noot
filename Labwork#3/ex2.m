clc;clear all;close all;
syms t1 t2 t3;
syms l1 l2 d2 d3;
syms a1 a2 a3;
global Robot Robot_CL;

Kp=1.01 ;
Dt = 0.1 ; %Delta Time
steps = 40 ;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      pi/2       0       pi/2  "R"  %0->1
        0      d2    -pi/2       0        0    "P"  %1->2
        t3     0      pi/2       0        0    "R"  %2->I
        0      a3       0        0     -pi/2   "I"];%I->G
% %% ==== Assing Some Variables ==== %%
% a1 = 35 ;
% a2 = 35 ;

L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta' , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset',   0  ,'qlim' ,[0 50]);
L3=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',   0  );
L4=Link('d'    ,  10, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot=SerialLink([L1 L2 L3 L4], 'name', 'BoT 1');
Robot_CL = SerialLink(Robot, 'name', 'BoT 2');
figure('Name',"Forma Integradora")
Robot.plotopt = {'floorlevel', 1, 'workspace', [-10, 60, -10, 30, -5, 5], 'reach', 10};
Robot.teach([0 0 0 0])

[n,~]=size(DH);

disp("T0_EE FK_MGD")
T0_EE=simplify(FK_MGD_DH2(DH,n));
T0_EE=eval(subs(T0_EE,a3,10))

Tstart=T0_EE;
Tstart(1:3,4)=[40 20 0]';
disp(Tstart)
%% Alinea a) Soluçâo para as variaveis de junta
q=invkine_2(Tstart)';
q=eval(subs(q,[t1 t3],[0 0]));
disp('Alinea a)')
disp('        RAD           DEG')
fprintf(' q1 = %f  | %f',q(1,1),rad2deg(q(1,1)));
fprintf('\n q2 = %f  | %f',q(2,1),rad2deg(q(2,1)));
fprintf('\n q3 = %f | %f\n\n',q(3,1),rad2deg(q(3,1)));


disp("Jacobiano")
Jsyms=simplify(Jacobi2(DH))


% Velocity Cap in wz
wz = pi;
% Velocity vector 6x1 [vx vy vz|wx wy wz]'
v = [ zeros(1,5) wz ]' ;


%% Abordagem Integradora
for i=1:1:steps
    %Replace q(t1 d2 t3-from invkine) and a3 in Jacobian
    J=eval(subs(Jsyms,[t1 d2 t3 a3],[q' 10]));
    
    %Calc new q, mult inv_Jacob * velocity
    q_(:,:,i)=pinv(J)*v
    
    % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
    q=q+q_(:,:,i)*Dt;
    
    %Plot bot from new q
    Robot.plot([q' 0]);
    
    %Calc fk -> Mtype 1x1xSTEPS
    T0_E(:,:,i)=Robot.fkine([q' 0])
    
    %disp('q_trans')
    %disp(T0_EE(:,:,i))
    
end

% Data Analysis



%% Abordagem em malha fechada
q = invkine_2(Tstart)';
q=eval(subs(q,[t1 t3],[0 0]));
figure('Name',"Forma Malha Fechada")
% Teta pose(desejado)
teta_pose=q(1,1)+q(3,1);

for i=1:1:steps
    J=eval(subs(Jsyms,[t1 t2 t3 a3],[q' 10]));
    
    T0_EE_CL=Robot_CL.fkine([q' 0])
    
    % Curent Teta
    teta_k=q(1,1)+q(3,1)+pi*Dt;
    
    % New Velocitys(current-targuet)/0.1
    vx = (T0_EE_CL.t(1,1) - 40)/0.1;
    vy = (T0_EE_CL.t(2,1) - 20)/0.1;
    wz = (teta_k - teta_pose)/0.1;
    

    % q*=J(q(k)).^-1 *(p*(k)-f(q(k)))
    q_=pinv(J)*[vx vy 0 0 0 wz]';

    % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
    q=q+Kp*q_;
    
    disp('q_ = [   w1    w2    w3] RAD')
    disp(q_)
    
    %Plot bot from new q
    Robot_CL.plot([q' 0]);
end
