syms t1 t2 t3 t4 t5 t6 a d3 lg

%  theta    d       alpha      a      offset  type
DH=[ t1     0       -pi/2      0         0 "R"    %0->1
     t2     a       -pi/2      0       -pi/2  "R"    %1->2
     0      d3         0       0        0  "P"
     t4     0        pi/2      0        pi/2 "R"
     t5     0       -pi/2      0        0 "R"
     t6     lg        0        0       -pi/2 "R"];
 
 a=20;
 lg=20;
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', -pi/2  , 'offset', 0 );
L2=Link('d'    ,  a , 'a', 0 ,  'alpha', -pi/2  , 'offset', -pi/2 );
L3=Link('theta' , 0 , 'a', 0 ,  'alpha',  0 , 'offset',   0  ,'qlim' ,[0 50]);
L4=Link('d'    ,  0 , 'a', 0  , 'alpha', pi/2  , 'offset',  pi/2  );
L5=Link('d'    ,  0, 'a', 0  , 'alpha', -pi/2   , 'offset',  0);
L6=Link('d'    ,  lg, 'a', 0  , 'alpha',   0   , 'offset', -pi/2);

Robot=SerialLink([L1 L2 L3 L4 L5 L6], 'name', 'BoT 1');
Robot.teach([0 0 0 0 0 0])

A=simplify(FK_MGD_DH(DH))

Jsyms=simplify(Jacobi2(DH));
disp("Jacobiano")
disp(Jsyms)