syms theta1 theta2 theta3 d2;


%          t      d     alpha   a  offset   
PJ_DH = [theta1   0     pi/2    0  pi/2;
           0      d2   -pi/2    0    0;
         theta3   0     pi/2    0    0;
           0      10      0     0  -pi/2];

trplot(eye(4));  
L1=Link('d'    ,  0 , 'a', 0 ,  'alpha', pi/2  , 'offset', pi/2 );
L2=Link('theta'    , 0 , 'a', 0 ,  'alpha', -pi/2 , 'offset', 0,'qlim' ,[-50 50]);
L3=Link('d'    ,  0, 'a', 0  , 'alpha', pi/2   , 'offset', 0 );
L4=Link('d'    ,  10, 'a', 0  , 'alpha', 0   , 'offset', -pi/2);
Robot=SerialLink([L1 L2 L3 L4]);
Robot.plotopt = {'floorlevel', 1, 'workspace', [-50, 50, -50, 50, -50, 50], 'reach', 10};
Robot.teach([0 0 0 0])
disp('Robot fkine [0 0 0 0]')
Robot.fkine([0 0 0 0])

disp('fk mgdh')
A=simplify(FK_MGD_DH(PJ_DH))
%disp('FK_MGDH fkine [0 0 0 0]')
%A=simplify(A);
%subs(A,[theta1 theta3 d2],[0 0 0])



