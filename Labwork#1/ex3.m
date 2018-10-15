clear; clc; close all;

syms t1 t2 t3 t4 t5;
global Robot;

%       t d alpha  a offset   
PJ_DH=[t1 0  pi/2  0      0     %0->1
       t2 0     0  4   pi/2     %1->2
       t3 0     0  2      0     %2->3
       t4 0 -pi/2  0  -pi/2     %3->4
       t5 1     1  0      0];   %4->G


%% ==== Create Robot Links ==== %%
L1=Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', 0, 'qlim', [-pi/2 pi/2]);
L2=Link('d', 0, 'a', 4, 'alpha', 0, 'offset', pi/2, 'qlim', [-pi/3 pi/4]);
L3=Link('d', 0, 'a', 2, 'alpha', 0, 'offset', 0, 'qlim', [-pi/3 pi/4]);
L4=Link('d', 0, 'a', 0, 'alpha', -pi/2, 'offset', -pi/2, 'qlim', [-pi/2 pi/2]);
L5=Link('d', 1, 'a', 0, 'alpha', 0, 'offset', 0, 'qlim', [-pi pi]);
Robot=SerialLink([L1 L2 L3 L4 L5]);

%% ==== Pos Home ==== %%
Robot.plot([0 0 0 0 0]);


L=[90 90 90 90 90];
animate(5,L);

%% ==== Animate Arm ==== %%
function animate(a_inc,L)
    global Robot;
    for i=1:a_inc
        Robot.teach('rpy',[deg2rad(i*L(1)/a_inc) deg2rad(i*L(2)/a_inc) deg2rad(i*L(3)/a_inc) deg2rad(i*L(4)/a_inc) deg2rad(i*L(5)/a_inc)]);
    end
end