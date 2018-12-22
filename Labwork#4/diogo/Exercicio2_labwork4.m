%Exercicio2

clc; clear; close all;
syms theta1 theta2 theta3 l a


%       theta      d       alpha       a     offset   
   DH=[ theta1     0       -pi/2       0       0        %0->1
        theta2     a        pi/2       0      pi/2      %1->2
        theta3     l          0        0       0   ];   %2->3
    
L1=Link('d'     , 0 , 'a', 0 ,  'alpha', -pi/2  , 'offset', 0    );
L2=Link('d'     , 1 , 'a', 0 ,  'alpha',  pi/2  , 'offset', pi/2 );
L3=Link('d'     , 1 , 'a', 0 ,  'alpha',  0     , 'offset',   0  );

Robot = SerialLink([L1 L2 L3]);
Robot.plot( [0 0 0] );

% Transformações p/cada um dos pontos que definem a trajectória:
P_A=[(1+sqrt(2))/2 (-1+sqrt(2))/2 sqrt(2)/2]';
P_B=[sqrt(2)/2 1 -sqrt(2)/2]';
P_C=[-1 sqrt(2)/2 -sqrt(2)/2]';

%% a) Solução da cinemática inversa:
%% obtenção das variaveis das juntas no ponto A

T_A = cinem_inv_ex2(P_A, 1);
theta11 = T_A(1,1);
theta22 = T_A(1,2);
d33     = 0;


%% obtenção das variaveis das juntas no ponto B

T_B = cinem_inv_ex2(P_B, 1);
theta111 = T_B(1,1); 
dtheta22 = T_B(1,2);     
d333     = 0;  


%% obtenção das variaveis das juntas no ponto C

T_C = cinem_inv_ex2(P_C, 1);
theta1111 = T_C(1,1); 
theta2222 = T_C(1,2);       
d3333     = 0;  

T0A=[eye(3) P_A
    0 0 0 1];
T0B=[eye(3) P_B
    0 0 0 1];
T0C=[eye(3) P_C
    0 0 0 1];
hold on;
trplot(T0A,'frame', 'A','color','r');
trplot(T0B,'frame', 'B','color','b');
trplot(T0C,'frame', 'C','color','k');

%% b)
%% obtenção das velocidades 

tempo_A = 0; 
tempo_B = 4;
tempo_C = 10;

VA = 0;
VC = 0;

for i=1:2

    VA_B = (T_B(i)-T_A(i)) / (tempo_B-tempo_A);
    VB_C = (T_C(i)-T_B(i)) / (tempo_C-tempo_B);

    if sign(VA_B) == sign(VB_C)
        VB(i) = (1/2)*(VA_B + VB_C);
    else
        VB(i) = 0;
    end
end    

VA_B
VB_C
VB
%% Funções polinomiais cúbicas para o troço A -> B

while(1)
    
t0 = 0;
tf = 4;
d = 0.1; %intervalo de tempo entre iterações
i = 1;


for t=t0:d:tf
    
    theta1_A_B = polinomial3(t, t0, tf, T_A(i), T_B(i), VA, VB(i));
    theta2_A_B = polinomial3(t, t0, tf, T_A(i+1), T_B(i+1), VA, VB(i+1));
    
    Robot.plot([ theta1_A_B theta2_A_B 0]);

end
%  Robot.teach([theta1_A_B theta2_A_B 0]);

%% Funções polinomiais cúbicas para o troço B -> C


t0 = 4;
tf = 10;
d = 0.1; %intervalo de tempo entre iterações
i = 1;


for t=t0:d:tf
    
    theta1_C_A = polinomial3(t, t0, tf, T_B(i), T_C(i), VB(i), VC);
    theta2_C_A = polinomial3(t, t0, tf, T_B(i+1), T_C(i+1), VB(i+1), VC);
    
    Robot.plot([ theta1_C_A theta2_C_A 0]);
    
end
%     Robot.teach([ theta1_B_C theta2_B_C 0]);
%% Funções polinomiais cúbicas para o troço C -> A


t0 = 10;
tf = 15;
d = 0.1; %intervalo de tempo entre iterações
i = 1;


for t=t0:d:tf
    
    theta1_C_A = polinomial3(t, t0, tf, T_C(i), T_A(i), VC, VA);
    theta2_C_A = polinomial3(t, t0, tf, T_C(i+1), T_A(i+1), VC, VA);
    
    Robot.plot([ theta1_C_A theta2_C_A 0]);
    
end

end
% %% Funções polinomiais cúbicas para o troço A -> B
% 
% 
% t0 = 0;
% tf = 4;
% d = 0.1; %intervalo de tempo entre iterações
% i = 1;
% 
% 
% for t=t0:d:tf
%     
%     theta1_A_B = polinomial3(t, t0, tf, T_A(i), T_B(i), VA, VB(i));
%     theta2_A_B = polinomial3(t, t0, tf, T_A(i+1), T_B(i+1), VA, VB(i+1));
%     
%     Robot.plot([ theta1_A_B theta2_A_B 0]);
% 
% end
% %  Robot.teach([theta1_A_B theta2_A_B 0]);
% 
% %% Funções polinomiais cúbicas para o troço B -> C
% 
% 
% t0 = 4;
% tf = 10;
% d = 0.1; %intervalo de tempo entre iterações
% i = 1;
% 
% 
% for t=t0:d:tf
%     
%     theta1_C_A = polinomial3(t, t0, tf, T_B(i), T_C(i), VB(i), VC);
%     theta2_C_A = polinomial3(t, t0, tf, T_B(i+1), T_C(i+1), VB(i+1), VC);
%     
%     Robot.plot([ theta1_C_A theta2_C_A 0]);
%     
% end
% %     Robot.teach([ theta1_B_C theta2_B_C 0]);