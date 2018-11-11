clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;      %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5 t6; % Tetas
syms d1 d2;
syms a1 a2 a3 a4;
syms l1;

global Roboti Robotii Robotiii Roboti_pe Robotii_pe Robotiii_pe;

%% ==== ALL ROBOTS MATRIX's ==== %%

%% i) Robot PP
%    theta   d       alpha     a   offset   
DH_i=[ 0   d1+a1     -pi/2    0   -pi/2      %0->1
       0   d2+a2      pi/2    0      0];     %1->2

%% ii) Robot RP
%    theta    d     alpha    a   offset 
DH_ii=[ t1    0      pi/2    a2    pi/2      %0->1
        0  d2+a1+a3   0      0      0 ];     %1->2

%% iii) Robot RPR  
%       theta d       alpha     a   offset 
DH_iii=[ t1   0        pi/2      0    pi/2     %0->1
         0  d2+a1+a2  -pi/2      0      0      %1->2
         t3   0        pi/2      0      0      %2->3
         0    a3         0       0     pi/2];  %3->4
    
%% ==== Com Punho Esferico acopolado ==== %%

%% i) PP-RRR
%        theta d       alpha      a   offset
DH_i_pe=[ 0   d1+a1    -pi/2      0    -pi/2   %0->1
          0   d2+a1      0        0      0     %1->2
          t3   0       -pi/2      0      0     %2->3
          t4   0        pi/2      0      0     %3->4
          t5   a3         0       0    pi/2];  %4->5
disp(" Matriz Simbolica i) PP-RRR 0T5");
oAhi_pe_symb=simplify(FK_MGD_DH(DH_i_pe))

%% ii) RP-RRR
%        theta d       alpha      a   offset
DH_ii_pe=[ t1   0       pi/2      a2    pi/2   %0->1
           0  d2+l1      0        0      0     %1->2
           t3   0      -pi/2      0      0     %2->3
           t4   0       pi/2      0      0     %3->4
           t5  a4        0        0    pi/2];  %4->5
disp(" Matriz Simbolica ii) RP-RRR 0T5");
oAhii_pe_symb=simplify(FK_MGD_DH(DH_ii_pe))

%% iii) RPR-RRR
%          theta d       alpha      a   offset 
DH_iii_pe=[ t1   0        pi/2      0    pi/2    %0->1
            0   d2+l1    -pi/2      0      0     %1->2
            t3   0        pi/2      0      0     %2->3
            t4   a3      -pi/2      0      0    %3->4
            t5   0        pi/2      0      0     %4->5
            t6   a4        0        0   pi/2];  %5->6
disp(" Matriz Simbolica iii) RPR-RRR 0T6");
oAhiii_pe_symb=simplify(FK_MGD_DH(DH_iii_pe))

%% ==== Assing Some Variables ==== %%
a1=2;
a2=2;
a3=2;
a4=3;
l1=a1+a3;

%% ==== Criar os Links Todos os Robos ==== %%
%i)
L1i=Link('theta',-pi/2,'a',0,'alpha', -pi/2  , 'offset',a1 , 'qlim', [0 5]); %Offset(angle) das Prismaticas passa para teta na toolbox (acho eu)
L2i=Link('theta',0,'a',0,'alpha', pi/2   , 'offset', a2, 'qlim', [0 5]);
Roboti=SerialLink([L1i L2i], 'name', 'BoT i)');

%ii)
L1ii=Link('d',0, 'a', a2 , 'alpha', pi/2  , 'offset', pi/2 ); %R
L2ii=Link('theta', 0, 'a', 0 , 'alpha', 0  , 'offset', a1+a3, 'qlim', [0 5]); %Prismatic qlim maxes d-travel  
Robotii=SerialLink([L1ii L2ii], 'name', 'BoT ii)');

%iii)
L1iii=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', pi/2 ); %R
L2iii=Link('theta', 0, 'a', 0 , 'alpha', -pi/2  , 'offset', a1+a2, 'qlim', [0 5]); %Prismatic qlim maxes d-travel
L3iii=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', 0 ); %R
L4iii=Link('theta', pi/2, 'a', 0 , 'alpha', 0  , 'offset', a3,'qlim',[0 0]); %Prismatic qlim maxes d-travel
Robotiii=SerialLink([L1iii L2iii L3iii L4iii], 'name', 'BoT iii)');

%% ==== Com Punho Esferico acopolado ==== %%
%i)pe
L1i_pe=Link('theta',-pi/2,'a',0,'alpha', -pi/2  , 'offset',a1 , 'qlim', [0 5]); %Offset(angle) das Prismaticas passa para teta na toolbox (acho eu)
L2i_pe=Link('theta',0,'a',0,'alpha', pi/2   , 'offset', a2, 'qlim', [0 5]);
L3i_pe=Link('d',0,'a',0,'alpha', -pi/2   , 'offset', 0);
L4i_pe=Link('d',0,'a',0,'alpha', pi/2   , 'offset', 0);
L5i_pe=Link('d',a3,'a',0,'alpha', 0  , 'offset', pi/2);
Roboti_pe=SerialLink([L1i_pe L2i_pe L3i_pe L4i_pe L5i_pe], 'name', 'BoT i)pe');

%ii)pe
L1ii_pe=Link('d',0, 'a', a2 , 'alpha', pi/2  , 'offset', pi/2 ); %R
L2ii_pe=Link('theta', 0, 'a', 0 , 'alpha', 0  , 'offset', a1+a3, 'qlim', [0 5]); %Prismatic qlim maxes d-travel
L3ii_pe=Link('d',0,'a',0,'alpha', -pi/2   , 'offset', 0);
L4ii_pe=Link('d',0,'a',0,'alpha', pi/2   , 'offset', 0);
L5ii_pe=Link('d',a4,'a',0,'alpha', 0  , 'offset', pi/2);
Robotii_pe=SerialLink([L1ii_pe L2ii_pe L3ii_pe L4ii_pe L5ii_pe], 'name', 'BoT ii)pe');

%iii)pe
L1iii_pe=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', pi/2 ); %R
L2iii_pe=Link('theta', 0, 'a', 0 , 'alpha', -pi/2  , 'offset', l1, 'qlim', [0 5]); %Prismatic qlim maxes d-travel
L3iii_pe=Link('d',0, 'a', 0 , 'alpha', pi/2  , 'offset', 0 ); %R
L4iii_pe=Link('d',a3,'a',0,'alpha', -pi/2   , 'offset', 0);
L5iii_pe=Link('d',0,'a',0,'alpha', pi/2   , 'offset', 0);
L6iii_pe=Link('d',a4,'a',0,'alpha', 0  , 'offset', pi/2);
Robotiii_pe=SerialLink([L1iii_pe L2iii_pe L3iii_pe L4iii_pe L5iii_pe L6iii_pe], 'name', 'BoT iii)pe');
% ==== a) Desenhar Robos Sem punho esferico
figure('Name',"Robot i)PP")
Roboti.plot([0 0],'tilesize',3);
Roboti.teach([0 0]);

figure('Name',"Robot ii)RP")
Robotii.plot([0 0],'tilesize',3);
Robotii.teach([0 0]);

figure('Name',"Robot iii)RPR")
Robotiii.plot([0 0 0 0],'tilesize',3);
Robotiii.teach([0 0 0 0]);

% ==== b) Descrita nas Folhas, Matrizes em Cima e MGD_DH em cima
figure('Name',"Robot i)PP-RRR")
Roboti_pe.plot([0 0 0 0 0],'tilesize',3);
Roboti_pe.teach([0 0 0 0 0]);

figure('Name',"Robot ii)RP-RRR")
Robotii_pe.plot([0 0 0 0 0],'tilesize',3);
Robotii_pe.teach([0 0 0 0 0]);

figure('Name',"Robot iii)RPR-RRR")
Robotiii_pe.plot([0 0 0 0 0 0],'tilesize',3);
Robotiii_pe.teach([0 0 0 0 0 0]);
