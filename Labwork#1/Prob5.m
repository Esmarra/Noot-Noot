% Problema 5 Labwork #1
clear; 
clc;
close all;

q1=[sqrt(2)/2 sqrt(2)/2 0 0] %Quaterniao Base
q1c=quat_conj(q1) %Quat Conj

Q1=quat_to_matrix(q1) %Matrix Quat Base
Q1c=quat_to_matrix(q1c) %Matrix Quat Conj

A1=Q1c*Q1
A2=Q1*Q1c
A3=matrix_to_quat(A2)

if(isequal(A1,A2)==1)
    fprintf(" Q* é Inverso de Q\n");
end


function Qc=quat_conj(Q)
    Qc(1)=Q(1);  %q0=q0
    Qc(2)=-Q(2); %q1=-q1
    Qc(3)=-Q(3); %q2=-q2
    Qc(4)=-Q(4); %q3=-q3
end