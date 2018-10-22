% Problema 6 Labwork #1
clear; 
clc;
close all;

qx=[sqrt(2)/2 sqrt(2)/2 0 0] %Quaterniao Base
qz=[sqrt(2)/2 0 0 sqrt(2)/2]

Qx=quat_to_matrix(qx)
Qz=quat_to_matrix(qz)

[~,x0,~]=matrix_to_quat(Qx)
[~,z0,~]=matrix_to_quat(Qz)


a1=Qx*Qz*x0'

a2=rot('X',pi/2,'rad')*rot('Z',pi/2,'rad')*x0'

z0'
