%%Exercicio 2

clc; clear; close all;
syms theta1 d2 theta3 theta4


%%a)

%       theta      d       alpha       a     offset   
   DH=[ theta1     0        pi/2       0       pi/2      %0->1
        0          d2      -pi/2       0       0      %1->2
        theta3     0        pi/2       0       0      %2->3
        theta4     10         0         0     -pi/2];    %3->G
        
      
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta' , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset',   0  ,'qlim' ,[0 50]);
L3=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',   0  );
L4=Link('d'    ,  10, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot=SerialLink([L1 L2 L3 L4]);
% Robot.plotopt = {'floorlevel', 1, 'workspace', [-20, 60, -40, 50, -5, 5], 'reach', 10};


T_home=[0 -1 0 40;0 0 1 20; -1 0 0 0;0 0 0 1];

%% b)
 
T = [ikineRPR(T_home);0];

%% Abordagem Integradora
      for i=1:1:40
    
   
    theta11=T(1,1); % theta1 pretendido na alinea b)
    d22=T(2,1);     % d2 pretendido na alinea b)
    theta33=T(3,1);  % theta3 pretendido na alinea b)
    theta44 = 0;
    
    % matriz de transformação resultante dos novos thetas
         T_trans =  Robot.fkine([(theta11) (d22) (theta33) (theta44)]);
 
   %c)
    
     
     Jacobiano = eval(subs([ - 10*sin(theta1 + theta3) - d2*sin(theta1), cos(theta1), -10*sin(theta1 + theta3)
                            10*cos(theta1 + theta3) + d2*cos(theta1), sin(theta1),  10*cos(theta1 + theta3)
                              0,       0,                0
                              0,       0,                0
                              0,       0,                0
                              1,       0,                1],[theta1 d2 theta3],[theta11 d22 theta33])); %Jacobiano 
      
    T_2 = [pinv(Jacobiano)*[0;0;0;0;0;pi];0]; %q* = J(q(k)).^-1 * v*
   
    vel_theta1=T_2(1,1); % velocidade da junta 1 pretendida na alinea c)
    vel_theta2=T_2(2,1); % velocidade da junta 2 pretendida na alinea c) 
    vel_theta3=T_2(3,1); % velocidade da junta 3 pretendida na alinea c)
    
    
    T=T + T_2*.1; % q*(k+1)= q(k)+delta_tempo * q*(k)
  
  
    title('Abordagem Integradora')
    Robot.plot(T');
    drawnow
  
  
    %Pontos das velocidades
     Pontos(i,1)= vel_theta1;
     Pontos(i,2)= vel_theta2;
     Pontos(i,3)= vel_theta3;
     
    
    %PontosXY
     PontosXY(i,1)= T_trans(1).t(1,1);
     PontosXY(i,2)= T_trans(1).t(2,1);
    
     end
     
 %   %Analisar dados
    figure
    plot(PontosXY(:,1),PontosXY(:,2),'.r')
    title('Movimento do robô')
    grid on;

    figure;
    subplot(1,3,1);
    grid on;
    plot(1:40, rad2deg(Pontos(:,1)),'.r');
    title('Vel da junta 1 em graus')
    
    subplot(1,3,2);
    grid on;
    plot(1:40, rad2deg(Pontos(:,2)),'.r');
    title('Vel da junta 2')

    subplot(1,3,3);
    grid on;
    plot(1:40, rad2deg(Pontos(:,3)),'.r');
    title('Vel da junta 3 em graus')
    
    pause(1);
    figure;


  %Abordagem em malha fechada
    T_1 = [ikineRPR(T_home);0];
    theta111=T_1(1,1); % theta1 pretendido na alinea b)
    d222=T_1(2,1);     % d2 pretendido na alinea b)
    theta333=T_1(3,1);  % theta3 pretendido na alinea b)
    theta444 = 0;
    
    theta_des = theta111 + theta333;
    Kd = 1.001;
    
  Robot1=SerialLink([L1 L2 L3 L4]);
  Robot1.plotopt = {'floorlevel', 1, 'workspace', [-20, 60, -20, 40, -5, 5], 'reach', 10};

    for i=1:1:40
  
    theta111=T_1(1,1); % theta1 pretendido na alinea b)
    d222=T_1(2,1);     % d2 pretendido na alinea b)
    theta333=T_1(3,1);  % theta3 pretendido na alinea b)
    theta444 = 0;
    
    
  %b)
  
  Jacobiano = eval(subs([ - 10*sin(theta1 + theta3) - d2*sin(theta1), cos(theta1), -10*sin(theta1 + theta3)
                            10*cos(theta1 + theta3) + d2*cos(theta1), sin(theta1),  10*cos(theta1 + theta3)
                              0,       0,                0
                              0,       0,                0
                              0,       0,                0
                              1,       0,                1],[theta1 d2 theta3],[theta111 d222 theta333])); %Jacobiano  
  
  T_transf = Robot1.fkine(T_1); % matriz de transformação de resultante dos novos thetas e das novas velocidades de juntas
  
  
  
   theta_atual = theta111 + theta333; 
   theta_des = theta_des + pi*0.1;
 
   
   wz = (  theta_des - theta_atual )/0.1; 
   posxatual = 10*cos(theta111 + theta333) + d222*cos(theta111);
   posyatual = 10*sin(theta111 + theta333) + d222*sin(theta111);

  
  vx = ( 40 - posxatual )/0.1;                                                 
  vy = ( 20 - posyatual )/0.1;                                                
                                      
  
  T_ = [pinv(Jacobiano)*[vx;vy;0;0;0;(wz)];0]; %q* = J(q(k)).^-1 * (p*(k)-f(q(k)))
  
  
  
  vel_theta1_=T_(1,1); % velocidade da junta 1 pretendida na alinea b)
  vel_theta2_=T_(2,1); % velocidade da junta 2 pretendida na alinea b)
  vel_theta3_=T_(3,1); % velocidade da junta 3 pretendida na alinea b)
  
  T_1=T_1+Kd*T_*0.1; % q*(k+1)= q(k)+ Kv * delta_tempo * q*(k)
  
   theta111 = T_1(1,1);
   d222 = T_1(2,1);
   theta333 = T_1(3,1);
  title('Abordagem em malha fechada')
%   if(T_1(2,1)<0)
%         T_1(2,1)=0;
%     end
  Robot1.plot(T_1');
  drawnow
  
 %Pontos das velocidades
    Pontos_(i,1)= vel_theta1_;
    Pontos_(i,2)= vel_theta2_;
    Pontos_(i,3)= vel_theta3_;
    
 %PontosXY
    PontosXY_(i,1)= T_transf(1).t(1,1);
    PontosXY_(i,2)= T_transf(1).t(2,1);
end
   
  %Analisar dados
  
  figure
    plot(PontosXY_(:,1),PontosXY_(:,2),'.r')
    title('Movimento do robô')
    grid on;

    figure;
    subplot(1,3,1);
    grid on;
    plot(1:40, rad2deg(Pontos_(:,1)),'.r');
    title('Vel da junta 1 em graus')
    
    subplot(1,3,2);
    grid on;
    plot(1:40, rad2deg(Pontos_(:,2)),'.r');
    title('Vel da junta 2')

    subplot(1,3,3);
    grid on;
    plot(1:40, rad2deg(Pontos_(:,3)),'.r');
    title('Vel da junta 3 em graus')
    