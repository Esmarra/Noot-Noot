%%Exercicio 1

clc; clear; close all;
syms theta1 d2 theta3 theta4


%       theta      d       alpha       a     offset   
   DH=[ theta1     0        pi/2       0       pi/2      %0->1
        0          d2      -pi/2       0       0         %1->2
        theta3     0        pi/2       0       0         %2->3
        theta4     10         0        0     -pi/2];    %3->G
    
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta' , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset',   0  ,'qlim' ,[0 50]);
L3=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',   0  );
L4=Link('d'    ,  10, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot = SerialLink([L1 L2 L3 L4]);
Robot.plot( [0 0 0 0] );


T0_A = [0 -0.2588 0.9659 23.8014; 0 -0.9659 -0.2588 11.5539;1 0 0 0; 0 0 0 1];
T0_i = [0 1 0 0;0 0 1 0;1 0 0 0;0 0 0 1];
T0_B = [0 0.8660 0.5 30.9808; 0 -0.5 0.8660 -6.3397;1 0 0 0;0 0 0 1];

%% obtenção das variaveis das juntas no ponto A

T_A = [ikineRPR(T0_A);0];
theta11 = T_A(1,1); 
d22     = T_A(2,1);     
theta33 = T_A(3,1);  
theta44 = 0;

%% obtenção das variaveis das juntas no ponto i

T_i = [ikineRPR(T0_i);0];
theta111 = T_i(1,1); 
d222     = T_i(2,1);     
theta333 = T_i(3,1);  
theta444 = 0;

%% obtenção das variaveis das juntas no ponto B

T_B = [ikineRPR(T0_B);0];
theta1111 = T_B(1,1); 
d2222     = T_B(2,1);     
theta3333 = T_B(3,1);  
theta4444 = 0;

%% obtenção das velocidades 

tempo_A = 0; 
tempo_i = 5;
tempo_B = 8;

VA = 0;
VB = 0;

for i=1:3

    VA_i = (T_i(i)-T_A(i)) / (tempo_i-tempo_A);
    Vi_B = (T_B(i)-T_i(i)) / (tempo_B-tempo_i);

    if sign(VA_i) == sign(Vi_B)
        Vi(i) = (1/2)*(VA_i + Vi_B);
    else
        Vi(i) = 0;
    end
end    

%% Funções polinomiais cúbicas para o troço A -> i


t0 = 0;
tf = 5;
d = 0.1; %intervalo de tempo entre iterações
i = 1;

for t=t0:d:tf
    
    theta1_A_i = polinomial3(t, t0, tf, T_A(i), T_i(i), VA, Vi(i))
    d2_A_i = polinomial3(t, t0, tf, T_A(i+1), T_i(i+1), VA, Vi(i+1))
    theta3_A_i = polinomial3(t, t0, tf, T_A(i+2), T_i(i+2), VA, Vi(i+2))
    
    Robot.plot([ theta1_A_i d2_A_i theta3_A_i 0]);

end
 

%% Funções polinomiais cúbicas para o troço i -> B


t0 = 5;
tf = 8;
d = 0.1; %intervalo de tempo entre iterações
i = 1;


for t=t0:d:tf
    
    theta1_i_B = polinomial3(t, t0, tf, T_i(i), T_B(i), Vi(i), VB);
    d2_i_B = polinomial3(t, t0, tf, T_i(i+1), T_B(i+1), Vi(i+1), VB);
    theta3_i_B = polinomial3(t, t0, tf, T_i(i+2), T_B(i+2), Vi(i+2), VB);
    
    Robot.plot([ theta1_i_B d2_i_B theta3_i_B 0]);
    
end



