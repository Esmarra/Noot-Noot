% Miguel Maranha Tiago 
% 2012138309

clear; clc; close all;
syms t1 t2 a l;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      -pi/2       0        0  "R"  %0->1
        t2     1       pi/2       0        pi/2    "R"  %1->2
        0      1        0         0        0    "R"];  %2->3
    
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', -pi/2  , 'offset', 0 );
L2=Link('d'    , a , 'a', 0 ,  'alpha', pi/2 , 'offset',   pi/2 );
L3=Link('d'    ,  l , 'a', 0  , 'alpha', 0  , 'offset',   0  ,'qlim' ,[0 50]);

A=FK_MGD_DH(DH)

pa=[(1+sqrt(2))/2,(-1+sqrt(2))/2,(sqrt(2))/2];
pb=[(sqrt(2))/2,1,(-sqrt(2))/2];
pc=[-1,(sqrt(2))/2,(-sqrt(2))/2];

%Fazer invkine T0EE -> teta1,teta2
qa=sloppy_ik(pa)
qb=sloppy_ik(pb);
qc=sloppy_ik(pc);

%Calc t1 -> velocidade linear 1-2
td12=4; % 4 segundos
td23=6; % 6 segundos


teta1=qa(1);
teta2=qa(2);
acc1=4*(teta1-0)/td12^2; % right?

t1=td12 - sqrt((td12^2)-(2*(teta2-teta1))/(acc1))
teta12=(teta2-teta1)/(td12-.5*t1)
t12=td12-t1-.5*t2


function q=sloppy_ik(p)
    tx=p(1);
    ty=p(2);
    tz=p(3);
    
    %Formula quadro teta2
    teta2=atan((-p(3))/((p(1)^2)+(p(2)^2)-1));
    teta1=atan(ty-tx) - atan2(1,cos(teta2));
    
    q=[teta1,teta2];
end

