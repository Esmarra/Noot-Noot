% Problema 4 Labwork #1
clear; 
clc;
close all;

qi=[1 0 0 0];
q=[0 1 0 0];

Qi=quat_to_matrix(qi);
Q=quat_to_matrix(q);

%Visto que a multiplicacao nao é comutativa se Q*Qi != Qi*Q Qi esta errado
A1=Q*Qi
A2=Qi*Q
A3=Q;
if(isequal(A1,A2)==1 && isequal(A2,A3)==1 && isequal(A1,A3)==1)
    fprintf("Yup Qi is the Identity for unitary Quat\n");
end
