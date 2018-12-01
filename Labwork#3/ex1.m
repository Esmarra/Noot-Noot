clear; clc; close all;

%% ==== Variables ==== %%
syms t1 t2 t3;
syms l1 l2 d3;
syms a1 a2;
global Robot Robot_CL;

Kp=1.01 ;
Dt = 0.1 ; %Delta Time
steps = 80 ;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0        0       l1      0  "R"   %0->1
        t2     0        0       l2      0  "R"   %1->2
        t3     d3       0       0       0  "R"];   %2->G

%% ==== Assing Some Variables ==== %%
l1 = 35 ;
l2 = 35 ;
d3 = 10 ;

%% ==== Criar os Links ==== %%
L1=Link('d',0,  'a', l1 , 'alpha', 0  , 'offset', 0 ); %R
L2=Link('d',0,  'a', l2 , 'alpha', 0  , 'offset', 0 ); %R
L3=Link('d',d3, 'a', 0 ,  'alpha', 0  , 'offset', 0 ); %R

Robot = SerialLink([L1 L2 L3], 'name', 'BoT 1');
Robot_CL = SerialLink(Robot, 'name', 'BoT 2');

figure('Name',"Forma Integradora")
Robot.plot([0 0 0],'tilesize',12);

T0_EE=[0 -1 0 20
       1  0 0 50
       0  0 1 10
       0  0 0  1];
%% Alinea a) Soluçâo para as variaveis de junta
q=invkine_RRR(T0_EE)';
disp('Alinea a)')
disp('        RAD           DEG')
fprintf(' q1 = %f  | %f',q(1,1),rad2deg(q(1,1)));
fprintf('\n q2 = %f  | %f',q(2,1),rad2deg(q(2,1)));
fprintf('\n q3 = %f | %f\n\n',q(3,1),rad2deg(q(3,1)));


%% Alinea b) Soluçâo para as variaveis de junta
Jsyms=Jacobi(DH)
T0=simplify(FK_MGD_DH(DH))
%% Abordagem Integradora
for i=1:1:steps
    %Replace q(t1 t2 t3-from invkine) in Jacobian
    J=eval(subs(Jsyms,[t1 t2 t3],q'));
    
    %Velocity vector 6x1 [vx vy vz|wx wy wz]'
    v = [ -3*sqrt(5) -6*sqrt(5) zeros(1,4)]' ;
    
    %Calc new q, mult inv_Jacob * velocity
    q_(:,:,i)=pinv(J)*v;
    
    % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
    q=q+q_(:,:,i)*Dt;
    
    %Plot bot from new q
    Robot.plot(q');
    
    %Calc fk -> Mtype 1x1xSTEPS
    T0_EE(:,:,i)=Robot.fkine(q);
    
    %disp('q_trans')
    %disp(T0_EE(:,:,i))
    
end
%% Display Matrix Transfor & Velocidade rot
disp('T0_EE')
disp(T0_EE(:,:,steps))
disp('Alinea b)')
disp('q_ = [   w1    w2    w3] RAD')
disp(q_(:,:,steps)')
disp('q_ = [   w1    w2    w3] DEG')
disp(rad2deg(q_(:,:,steps)'))

%% Plot Recta
figure('Name',"Relação Pos-Recta Integradora")
x=-40:20;
y=2*x+10;
x_data=reshape(T0_EE(1,4,:),1,steps);
y_data=reshape(T0_EE(2,4,:),1,steps);
plot(x_data,y_data,'o',x,y);
grid on;


%% Abordagem em malha fechada
figure('Name',"Forma Malha Fechada")
% Target pose(kalman?)
p=[20
   50
   zeros(4,1)];

for i=1:1:steps
    J=eval(subs(Jsyms,[t1 t2 t3],q'));
    
    T0_EE_CL=Robot_CL.fkine(q')
    
    %Pose Desejada
    p = p + v * Dt;

    %q*=J(q(k)).^-1 *(p*(k)-f(q(k))) 
    q_=pinv(J)*(p-[T0_EE_CL.t;0;0;sum(q)]);

    % next q = old * deta t * q_ [q(k+1)=q(k)+Dt*q_(k)
    q=q+Kp*q_;
    
    disp('q_ = [   w1    w2    w3] RAD')
    disp(q_)
    
    %Plot bot from new q
    Robot_CL.plot(q');
end
%% Display Matrix Transfor & Velocidade rot
disp('T0_EE')
disp(T0_EE_CL(:,:,steps))


%% Plot Recta
figure('Name',"Relação Pos-Recta Malha Fechada")
x=-40:20;
y=2*x+10;
x_data=reshape(T0_EE(1,4,:),1,steps);
y_data=reshape(T0_EE(2,4,:),1,steps);
plot(x_data,y_data,'o',x,y);
grid on;
