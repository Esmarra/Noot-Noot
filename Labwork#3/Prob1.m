clear; clc; close all;

syms a1 a2 a3 a4 a5 a6 a7 d1 d2 d3 d4 d5 d6 t1 t2 t3 t4 t5 t6 ;
%% ==== DH Matrix ==== %%
%    theta    d       alpha      a      offset  type
%    DH=[ 0     d1      pi/2       0       pi/2   "P"  %0->1
%         t2    0       pi/2       0       pi/2   "R"  %1->2
%         0     d3     -pi/2       0        0     "P"  %2->3
%         t4    0       pi/2       0        0     "R"  %3->4
%         t5    5         0        0        0     "R"];%4->G

%% Ex Livro
%    theta    d       alpha      a      offset  type
   DH=[ t1     0        0      0        0 "R"     %0->1
        t2     0        0      a1       0 "R"    %1->2
        t3     0        0      a2       0 "R" ];      %2->3

%    theta    d       alpha      a      offset  type
%    DH=[ t1     a1        0      a2       0 "R"    %0->1
%         t2     a3        0      a4       0 "R"];  %1->2

%    theta    d       alpha      a      offset  type
%    DH=[ t1     0         pi/2     a1     pi/2 "R"    %0->1
%         0     d1+a2+a3  -pi/2      0       0  "R"    %1->2
%         t2     0           0      a4    -pi/2 "R"];

%     theta    d       alpha      a      offset  type
%    DH=[ t1     a1       pi/2      0       pi/2  "R"    %0->1
%         t2     0           0     a2       0  "R"    %1->2
%         t3     0           0     a3       0  "R"];

    %    theta    d       alpha      a      offset  type
%    DH=[ 0     d1+a1      0        0        0    "P"  %0->1
%         t2    a2       pi/2       0       pi/2  "R"  %1->2
%         0     d3+a3+a4   0        0        0    "P"  %2->3
%         t4    a5       -pi/2      0       pi/2  "R"  %3->4
%         t5    0         pi/2      0        0    "R"  %4->G
%         t6    a6+a7    -pi/2      0        0    "R"];


%% Gerar Links
% L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', 0  , 'offset', pi/2 );
% L2=Link('d'    ,  0 , 'a', 0 ,  'alpha', 0  , 'offset',   0  ,'qlim' ,[0 50]);
% L3=Link('d'    ,  0 , 'a', 0  , 'alpha', 0  , 'offset',   0  );



%T=simplify(FK_MGD_DH2(DH(3:6,:),3))
%T0_3=(FK_MGD_DH2(DH,3));
A=simplify(FK_MGD_DH2(DH,3))

% T0_EE=[-1 0 0
%     0 -1 0
%     0 0 1];
%T3_EE=inv(T0_3(1:3,1:3))*T0_EE(1:3,1:3)

A=[1 0 0;0 0 1;0 -1 0];
B=[cos(t1) 0 sin(t1);0 1 0;-sin(t1) 0 cos(t1)];

J=Jacobi2(DH)

%x=a1*cos(t1)+a2*cos(t1+t2);
%y=a1*sin(t1)+a2*sin(t1+t2);

%r=simplify(x^2+y^2)
