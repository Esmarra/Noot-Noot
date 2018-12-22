clear; clc; close all;
syms t1 t2 a l;

global Robot;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      -pi/2       0        0  "R"  %0->1
        t2     1       pi/2       0        pi/2    "R"  %1->2
        0      1        0         0        0    "R"];  %2->3
l=1;
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', -pi/2  , 'offset', 0 );
L2=Link('d'    , 1 , 'a', 0 ,  'alpha', pi/2 , 'offset',   pi/2 );
L3=Link('d'    ,  l , 'a', 0  , 'alpha', 0  , 'offset',   0  ,'qlim' ,[0 50]);

Robot=SerialLink([L1 L2 L3], 'name', 'BoT 2');
%Robot.plotopt = {'floorlevel', 2, 'workspace', [-5, 5, -5, 5, -5, 5]};
Robot.teach([0 0 0])

A=FK_MGD_DH(DH)

pa=[(1+sqrt(2))/2,(-1+sqrt(2))/2,(sqrt(2))/2];
pb=[(sqrt(2))/2,1,(-sqrt(2))/2];
pc=[-1,(sqrt(2))/2,(-sqrt(2))/2];

%Fazer invkine T0EE -> teta1,teta2
qa=sloppy_ik(pa,l)
qb=sloppy_ik(pb,l)
qc=sloppy_ik(pc,l)


function q=sloppy_ik(p,L)
    tx=p(1);
    ty=p(2);
    tz=p(3);
    
    teta1 = atan2( ty, tx);
    teta2 = atan2(tz-L, tx*cos(teta1) + ty*sin(teta1));
    
    q=[teta1,teta2];
end