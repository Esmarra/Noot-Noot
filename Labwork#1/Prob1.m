% Problema 1 Labwork #1
clear; clc; close all;

R=[ 1/sqrt(2) 0 1/sqrt(2)
    -1/2 1/sqrt(2) 1/2
    -1/2 -1/sqrt(2) 1/2];
% R=[ 2/3 -1/3 2/3
%     2/3 2/3 -1/3
%     -1/3 2/3 2/3];

%% a) Mostre que R é uma matriz Rotação
fprintf("a) Determinante R = %f se fôr = 1 é uma Mat Rot\n",det(R))

%% b)Determine o vector unitário que define o eixo de rotação e o angulo de rotaçao
phi=acos((R(1,1)+R(2,2)+R(3,3)-1)/2); % Ver Slides3 Pag22
fprintf("b) Angulo Rot(phi)= %f(rad) | %f(deg)\n",phi,rad2deg(phi));

v=[ R(3,2)-R(2,3)
    R(1,3)-R(3,1)
    R(2,1)-R(1,2)]';
fprintf("  Vector(v) =[%f %f %f]\n",v(1),v(2),v(3));

r=(1/(2*sin(phi)))*v;
fprintf("  Eixo Rot(r)=[%f %f %f]\n",r(1),r(2),r(3));

%% c) Determine os Parametros de Euler
e0=cos(phi/2); %e1
e1=r(1)*sin(phi/2); %e2
e2=r(2)*sin(phi/2); %e3
e3=r(3)*sin(phi/2); %e4
fprintf("c) Parametros Euler:\n");
fprintf("    [e0 e1 e2 e3] = [%f %f %f %f]\n",e0,e1,e2,e3);
%% Bonus Voltar a Matriz Rot apartir dos Parametros (aka Quaternioes q0 q1 q2 q3)
R1=quat_to_matrix([e0 e1 e2 e3])
if(isequal(round(R,2),round(R1,2))==1)
    fprintf("  Both Matrix are Equal Succecsufly Reconstructed\n");
end
  