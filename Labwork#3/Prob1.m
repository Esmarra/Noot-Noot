clear; clc; close all;

syms d1 d3 a1 a2 t1 t2 t3 t4 t5 x y;
%% ==== DH Matrix ==== %%
%     theta    d      alpha      a      offset  type
%    DH=[ 0     d1      pi/2       0       pi/2   "P"  %0->1
%         t2    0       pi/2       0       pi/2   "R"  %1->2
%         0     d3     -pi/2       0        0     "P"  %2->3
%         t4    0       pi/2       0        0     "R"  %3->4
%         t5    5         0        0        0     "R"];%4->G
   DH=[ t1     0        0      0        0      %0->1
        t2     0        0      a1       0      %1->2
        t3     0        0      a2       0];      %2->3
        
FK_MGD_DH2(DH,3)
%Jacobi2(DH)

x=a1*cos(t1)+a2*cos(t1+t2);
y=a1*sin(t1)+a2*sin(t1+t2);

r=simplify(x^2+y^2)

S = solve(x^2+y^2==r,cos(t2))