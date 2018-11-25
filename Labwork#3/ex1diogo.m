%%Exercicio 1

clc; clear; close all;
syms theta1 theta2 theta3 d3 l1 l2
l1=35;
l2=35;

%       theta      d      alpha     a   offset   
   DH=[ theta1     0        0       l1      0     %0->1
        theta2     0        0       l2      0     %1->2
        theta3     d3       0       0       0];   %2->G
      
  
L1=Link('d'    , 0 , 'a', 35 ,  'alpha', 0  , 'offset', 0 );
L2=Link('d'    , 0 , 'a', 35 ,  'alpha', 0  , 'offset', 0 );
L3=Link('d'    , 10, 'a', 0  , 'alpha', 0   , 'offset', 0 );


Robot=SerialLink([L1 L2 L3]);
Robot.plot([0 0 0]);

T_home=[0 -1 0 20;1 0 0 50; 0 0 1 10;0 0 0 1];


%% a)

T = (RRR_inv(T_home))';

 
  %% Abordagem Integradora
  for i=1:1:80
  
  
  theta11=T(1,1); % theta1 pretendido na alinea a)
  theta22=T(2,1); % theta2 pretendido na alinea a)
  theta3=T(3,1);  % theta3 pretendido na alinea a)
  
  
  % matriz de transformação resultante dos novos thetas
  disp('matriz de transformação resultante dos novos thetas:')
  T_trans =  Robot.fkine([(theta11) (theta22) (theta3)])
  
  %b)
  
  Jacobiano = eval(subs([-l1*sin(theta1)-l2*sin(theta1+theta2) -l2*sin(theta1+theta2) 0;l1*cos(theta1)+l2*cos(theta1+theta2) l2*cos(theta1+theta2) 0; 0 0 0; 0 0 0; 0 0 0; 1 1 1],[theta1 theta2],[theta11 theta22])); %Jacobiano 
  
  T_ = pinv(Jacobiano)*[-3*sqrt(5);-6*sqrt(5);0;0;0;0]; %q* = J(q(k)).^-1 * v*
  
  vel_theta1=T_(1,1); % velocidade da junta 1 pretendida na alinea b)
  vel_theta2=T_(2,1); % velocidade da junta 2 pretendida na alinea b) 
  vel_theta3=T_(3,1); % velocidade da junta 3 pretendida na alinea b)
  
  T=T+T_*.1; % q*(k+1)= q(k)+delta_tempo * q*(k)
  
  
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
  
  %Analisar dados
%     figure;
%     x=-40:30;
%     y=2*x+10;
%     plot(PontosXY(:,1),PontosXY(:,2),'.r',x,y); 
%     title('Movimento do robô em relação à reta y=2x+10')
%     grid on;
% 
%     figure;
%     subplot(1,3,1);
%     grid on;
%     plot(1:80, rad2deg(Pontos(:,1)),'.r');
%     title('Vel da junta 1 em graus')
%     
%     subplot(1,3,2);
%     grid on;
%     plot(1:80, rad2deg(Pontos(:,2)),'.r');
%     title('Vel da junta 2 em graus')
% 
%     subplot(1,3,3);
%     grid on;
%     plot(1:80, rad2deg(Pontos(:,3)),'.r');
%     title('Vel da junta 3 em graus')
    
    pause(1);
    figure;
  
%Abordagem em malha fechada

Xt_1 = 20;
Yt_1 = 50;
Kd = 1.001;

Robot1=SerialLink([L1 L2 L3]);

  for i=1:1:80
  
  theta11 = T(1,1); % theta1 pretendido na alinea a)
  theta22 = T(2,1); % theta2 pretendido na alinea a)
  theta33 = T(3,1); % theta3 pretendido na alinea a)
  
  %b)
  
  Jacobiano = eval(subs([-l1*sin(theta1)-l2*sin(theta1+theta2) -l2*sin(theta1+theta2) 0;l1*cos(theta1)+l2*cos(theta1+theta2) l2*cos(theta1+theta2) 0; 0 0 0; 0 0 0; 0 0 0; 1 1 1],[theta1 theta2],[theta11 theta22])); %Jacobiano 
  
  % matriz de transformação resultante dos novos thetas
  disp('matriz de transformação resultante dos novos thetas:')
  T_transf = Robot.fkine(T) % matriz de transformação de resultante dos novos thetas e das novas velocidades de juntas
  
  
  Xt_1 = Xt_1-3*sqrt(5)*0.1;        % Xt_1 = Xt_1 + vx * delta_tempo
  Yt_1 = Yt_1-6*sqrt(5)*0.1;        % Yt_1 = Yt_1 + vy * delta_tempo

  
  vx = (Xt_1 - T_transf.t(1,1));                                                %vx = (Xt_1 - tx)*delta_tempo 
  vy = (Yt_1 - T_transf.t(2,1));                                                %vy = (Yt_1 - ty)*delta_tempo
  wz = (pi/2 - ((theta11) + (theta22) + (theta33)));                            %wz =(90-somatorio dos thetas)*delta_tempo
  
  T_ = (pinv(Jacobiano)*[vx;vy;0;0;0;(wz)]); %q* = J(q(k)).^-1 * (p*(k)-f(q(k)))
  
  
  
  vel_theta1_=T_(1,1); % velocidade da junta 1 pretendida na alinea b)
  vel_theta2_=T_(2,1); % velocidade da junta 2 pretendida na alinea b)
  vel_theta3_=T_(3,1); % velocidade da junta 3 pretendida na alinea b)
  
  T=T+Kd*T_; % q*(k+1)= q(k)+ Kv * delta_tempo * q*(k)
  
  title('Abordagem em malha fechada')
  Robot1.plot(T');
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
    figure;
    x=-40:30;
    y=2*x+10;
    plot(PontosXY_(:,1),PontosXY_(:,2),'.r',x,y); 
    title('Movimento do robô em relação à reta y=2x+10')
    grid on;

    figure;
    subplot(1,3,1);
    grid on;
    plot(1:80, rad2deg(Pontos_(:,1)),'.r');
    title('Vel da junta 1 em graus')
    axis([0 90 -50 100])
    
    subplot(1,3,2);
    grid on;
    plot(1:80, rad2deg(Pontos_(:,2)),'.r');
    title('Vel da junta 2 em graus')
    axis([0 90 -150 100])

    subplot(1,3,3);
    grid on;
    plot(1:80, rad2deg(Pontos_(:,3)),'.r');
    title('Vel da junta 3 em graus')
    axis([0 90 -50 100])
  