clear; clc; close all;

syms d1 d3 t2 t4 t5;
%% ==== DH Matrix ==== %%
%     theta    d      alpha      a      offset  type
   DH=[ 0     d1      pi/2       0       pi/2   "P"  %0->1
        t2    0       pi/2       0       pi/2   "R"  %1->2
        0     d3     -pi/2       0        0     "P"  %2->3
        t4    0       pi/2       0        0     "R"  %3->4
        t5    5         0        0        0     "R"];%4->G
    
simplify(FK_MGD_DH(DH))
 Jacobi2(DH)