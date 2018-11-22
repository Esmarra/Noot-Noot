clear; clc; close all;

syms d3 t1 t2 t3;
syms l1 l2;
syms a1 a2;

%     theta    d      alpha     a    offset   
   DH=[ t1     0        0       l1      0     %0->1
        t2     0        0       l2      0     %1->2
        t3     d3       0       0       0];   %2->G

[n,~]=size(DH);
%%Jacobiano Para Burros
T0_EE=FK_MGD_DH2(DH,n);
i=cross([0 0 1]',T0_EE(1:3,4)-[0 0 0]')

T0_1=FK_MGD_DH2(DH,1);
ii=cross(T0_1(1:3,1:3)*[0 0 1]',T0_EE(1:3,4)-T0_1(1:3,4))

T0_2=FK_MGD_DH2(DH,2);
iii=cross(T0_2(1:3,1:3)*[0 0 1]',T0_EE(1:3,4)-T0_2(1:3,4))

Jacob=[ i ii iii
       [0 0 1]' T0_1(1:3,1:3)*[0 0 1]' T0_2(1:3,1:3)*[0 0 1]']
        



T0_1=FK_MGD_DH2(DH,1)
T0_2=FK_MGD_DH2(DH,2)



%%
%cross([0 0 1]',H0_3(1:3,4)-[0 0 0]')
% cross([0 0 1]',H0_3(1:3,4)-H0_1(1:3,4))
% cross([0 0 1]',H0_3(1:3,4)-H0_2(1:3,4))

l1=35;
l2=35;
d3=10;
% Porpotional Term (PID)
kp = 1.15 ;

% Base to End Efector
bTee=[0 -1 0 20
    1  0 0 50
    0  0 1 d3
    0  0 0 1];

l1=35;
l2=35;
d3=10;

v=[sqrt(5)*3 sqrt(5)*6 0];


