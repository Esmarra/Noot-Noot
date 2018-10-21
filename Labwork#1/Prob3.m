% Problema 3 Labwork #1
%clear; 
%clc;
close all;

%% ==== Variables ==== %%
syms t1 phi alf b d; % Tetas


%% ===== Start Position ==== %%
WT0=[rot('X',alf,'rad') [0 0 0]'
    0 0 0 1];
WT1=[eye(3) [b 0 0]'
    0 0 0 1];
WT2=[eye(3) [0 0 d]'
    0 0 0 1];
WT3=[rot('Z',t1,'rad') [0 0 0]'
    0 0 0 1];

WTB2=WT1*WT2*WT0*WT3 %Todas as Translaçoes sao comutativas, só WTM3 é que tem de ser pós-mult

