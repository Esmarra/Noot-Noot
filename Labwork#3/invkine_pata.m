syms t1 t2 t3 t4 t5 t6 a1 a2 a3 a4 a5 a6 d1 d2 d3 d4 d5 d6;
%T0_2=(FK_MGD_DH2(DH,2));

%x=a1*cos(t1)+a2*cos(t1+t2);
%y=a1*sin(t1)+a2*sin(t1+t2);

x=a2*cos(t1+t2)+a1*cos(t1);
y=a2*sin(t1+t2)+a1*sin(t1);
r=simplify(x^2+y^2)