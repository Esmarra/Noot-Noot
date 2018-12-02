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
Robot.plotopt = {'floorlevel', 2, 'workspace', [-10, 60, -10, 30, -5, 5], 'reach', 10,'tilesize',12};
Robot.teach([0 0 0 0])

[n,~]=size(DH);

% Forward Kinematics Base to End.Effector
T0_EE=simplify(FK_MGD_DH2(DH,n));
T0_EE=eval(subs(T0_EE,a3,10))

% Starting Position
Tstart=[ 0 -1 0 40
         0  0 1 20
        -1  0 0  0
         0  0 0  1];
disp(Tstart)
%% Alinea a) Soluçâo para as variaveis de junta

q=invkine_2(Tstart)';
Robot.plot([q' 0])
%q=eval(subs(q,[t1 t3],[0 0]));
disp('Alinea a)')
fprintf(' t1 = %f RAD',q(1,1) );
fprintf('\n d2 = %f',q(2,1) );
fprintf('\n t3 = %f RAD \n\n',q(3,1) );
pause(.5)

% Calcutate Jacobian Matrix With Symbolic's
Jsyms=simplify(Jacobi2(DH));
disp("Jacobiano")
disp(Jsyms)

% Velocity Cap in wz
wz = pi;
% Velocity vector 6x1 [vx vy vz|wx wy wz]'
v = [ zeros(1,5) wz ]' ;


%% Abordagem Integradora
% for i=1:1:steps
%     %Replace q(t1 d2 t3-from invkine) and a3 in Jacobian
%     J=eval(subs(Jsyms,[t1 d2 t3 a3],[q' 10]));
%     
%     %Calc new q, mult inv_Jacob * velocity
%     q_(:,:,i)=pinv(J)*v
%     
%     % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
%     q=q+q_(:,:,i)*Dt;
%     
%     %Plot bot from new q
%     Robot.plot([q' 0]);
%     
%     %Calc fk -> Mtype 1x1xSTEPS
%     T0_E(:,:,i)=Robot.fkine([q' 0])
%     
%     %disp('q_trans')
%     %disp(T0_EE(:,:,i))
%     x_data(i)=T0_E(1).t(1);
%     y_data(i)=T0_E(1).t(2);
% end
% 
% % Data Analysis
% %% Display Matrix Transfor & Velocidade rot
% disp('T0_EE')
% disp(T0_E(:,:,steps))
% disp('Alinea b)')
% disp('q_ = [   w1    w2    w3] RAD')
% disp(q_(:,:,steps)')
% 
% %% Plot Recta
% figure('Name',"Relação Pos-Recta Integradora")
% plot(x_data,y_data,'o');
% grid on;


%% Abordagem em malha fechada

q = invkine_2(Tstart)';
%q=eval(subs(q,[t1 t3],[0 0]));
figure('Name',"Forma Malha Fechada")
Robot_CL.plotopt = {'floorlevel', 2, 'workspace', [-100, 100, -100, 100, -5, 5], 'reach', 10,'tilesize',12};
% Teta pose(desejado)
teta_pose=q(1,1)+q(3,1);

des_teta = -wz*0.01;

for i=1:1:steps
    J=eval(subs(Jsyms,[t1 d2 t3 a3],[q' 10]));
    
    T0_EE_CL=Robot_CL.fkine([q' 0]);
    
    % Curent Teta
    teta_k=acot(tan(q(1,1)+q(3,1)));%+pi*Dt;
    
    teta_pose=teta_pose+des_teta
    
    % New Velocitys(current-targuet)/0.1
    vx = (T0_EE_CL.t(1,1) - 40)/0.1;
    vy = (T0_EE_CL.t(2,1) - 20)/0.1;
    wz = (teta_k - teta_pose)/0.1;
    

    % q*=J(q(k)).^-1 *(p*(k)-f(q(k)))
    q_=pinv(J)*[vx vy 0 0 0 wz]';
    % Print Joint Velocity
    fprintf(' t1 = %f RAD',q_(1,1) );
    fprintf('\n d2 = %f',q_(2,1) );
    fprintf('\n t3 = %f RAD \n\n',q_(3,1) );
    
    % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
    q=q+Kp*q_;
    
    disp('q_ = [   w1    w2    w3] RAD')
    disp(q_')
    if(q(2,1)<0)
    	q(2,1)=0;
    end
    %Plot bot from new q
    Robot_CL.plot([q' 0]);
end
