syms x y t1 t2 t3 t4 t5 t6 a1 a2 a3 a4 a5 a6 d1 d2 d3 d4 d5 d6 a b;
%T0_2=(FK_MGD_DH2(DH,2));

%x=a1*cos(t1)+a2*cos(t1+t2);
%y=a1*sin(t1)+a2*sin(t1+t2);

% Valores de p da matriz DH
x=cos(t1)*cos(t2) - sin(t1);
y=cos(t1) + cos(t2)*sin(t1);

% 1- Square and ADD
r=simplify(x^2+y^2)

eqn=sin(t2)^2==-a^2-b^2+2
solve(eqn,t2)