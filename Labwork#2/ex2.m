clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;      %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5 t6; % Tetas
syms d1 d2 d3 d4 d5 d6;
syms a a1 a2 a3 a4;
syms l1;

global Roboti Robotii Robotiii;
%global d1 d2 d3 d4 d5 d6;
global a a1 a2 a3;

%%
%    theta   d     alpha      a   offset   
DH_i=[ 0     d1     -pi/2    0      0      %0->1
       0     d2     pi/2     0      0];    %1->2

% L1i=Link('theta',0,'a',0,'alpha', -pi/2  , 'offset', 0, 'qlim', [0 5]);
% L2i=Link('theta',0,'a',0,'alpha', 0   , 'offset', 0, 'qlim', [0 5]);

% Roboti=SerialLink([L1i L2i], 'name', 'BoT i)');
% Roboti.plot([0 0]);
% Roboti.teach([0 0]);
% 
% a1=2;
% a2=2;
% d2=4;
figure(2);
DH_ii=[ t1   0      pi/2    a2    pi/2      %0->1
        0    d2      0      0      a1 ];     %1->2
% L1ii=Link('d',0, 'a', a2 , 'alpha', pi/2  , 'offset', pi/2 ); %R
% L2ii=Link('theta', 0, 'a', 0 , 'alpha', 0  , 'offset', a1, 'qlim', [0 2]); %Prismatic qlim maxes d-travel
% Robotii=SerialLink([L1ii L2ii], 'name', 'BoT ii)');
% Robotii.plot([0 0]);
% Robotii.teach([0 0]);

figure(3);
world_size=8;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
%       theta d       alpha     a   offset 
DH_iii=[ t1   0       pi/2      a2    pi/2    %0->1
        0    d2      -pi/2      0      a1     %1->2
        t3   0        pi/2      0      0      %2->I
        0    a3         0       0     pi/2];  %I->EE

% L1iii=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', pi/2 ); %R
% L2iii=Link('theta', 0, 'a', 0 , 'alpha', -pi/2  , 'offset', a1, 'qlim', [0 2]); %Prismatic qlim maxes d-travel
% L3iii=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', 0 ); %R
% L4iii=Link('theta', 0, 'a', 0 , 'alpha', 0  , 'offset', pi/2, 'qlim', [0 0]); %Prismatic qlim maxes d-travel
% 
% Robotiii=SerialLink([L1iii L2iii L3iii L4iii], 'name', 'BoT iii)');
% Robotiii.plot([0 0 0 0]);
% Robotiii.teach([0 0 0 0]);

%% ==== Com Punho Esferico acopolado ==== %%

%% i)
%        theta d       alpha      a   offset
DH_i_pe=[ 0   a1+d1    -pi/2      0    pi/2    %0->1
          0   a2+d2      0        0      0     %1->2
          t3   0       -pi/2      0      0     %2->3
          t4   0        pi/2      0      0     %3->4
          t5   0         0        a3   pi/2];  %4->5



%% iii)
%          theta d       alpha      a   offset 
DH_iii_pe=[ t1   0        pi/2      0    pi/2    %0->1
            0   d2+l1    -pi/2      0      0     %1->2
            t3   0        pi/2      0      0     %2->3
            t4   a3      -pi/2      0      0    %3->4
            t5   0        pi/2      0      0     %4->5
            t6   a4        0        0   pi/2];  %5->6
oAhiii_pe_symb=simplify(FK_MGD_DH(DH_iii_pe))


