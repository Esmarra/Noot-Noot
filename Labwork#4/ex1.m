clear; clc; close all;
syms t1 t2 t3 t4 a1 a2 a3 d1 d2 d3;

%% ==== DH Matrix ==== %%
%     theta    d      alpha     a    offset   
   DH=[ t1     0      pi/2       0       pi/2  "R"  %0->1
        0      d2    -pi/2       0        0    "P"  %1->2
        t3     0      pi/2       0        0    "R"  %2->I
        0      a3       0        0     -pi/2   "I"];%I->G

L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta' , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset',   0  ,'qlim' ,[0 50]);
L3=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',   0  );
L4=Link('d'    ,  10, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot=SerialLink([L1 L2 L3 L4], 'name', 'BoT 1');
Robot.plotopt = {'floorlevel', 2, 'workspace', [-10, 35, -20, 35, -5, 5], 'reach', 10,'tilesize',12};
Robot.teach([0 0 0 0])

[n,~]=size(DH);

% Forward Kinematics Base to End.Effector
T0_EE=simplify(FK_MGD_DH2(DH,n));
T0_EE=eval(subs(T0_EE,a3,10))

% Start
T0A=[ 0 -0.2588 .9659 23.8014
      0 -0.9659 -0.2588 11.5539
      1 0 0 0
      0 0 0 1];

% Mid Point
T0I=[0 1 0 0
     0 0 1 0
     1 0 0 0
     0 0 0 1];

% End Point
T0B=[ 0 0.8660 0.5 30.9808
      0 -0.5 0.8660 -6.3397
      1 0 0 0
      0 0 0 1];
qa=invkine_2(T0A)'
qi=invkine_2(T0I)'
qb=invkine_2(T0B)'

Jsyms=Jacobi2(DH)
J=eval(subs(Jsyms,[t1 d2 t3 a3],[qa' 10]));
v=[zeros(1,6)]';
qa_=pinv(J)*v
while 1
    Robot.plot([qa' 0]);
    pause(.2)
    Robot.plot([qi' 0]);
    pause(.2)
    Robot.plot([qb' 0]);
    pause(.2)
end
