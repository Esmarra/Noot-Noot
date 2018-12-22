function [S] = cinem_inv_ex2(P, L1)
% Transforma��o da Base ao Gripper
% OTG = [nx sx ax tx;
%        ny sy ay ty;
%        nz sz az tz;
%        0  0  0  1]

%Vari�veis da matriz de tranforma��o "OTG" �teis para determinar [theta1, d2, theta2]
tx = P(1,1);
ty = P(2,1);
tz = P(3,1);

%% Solu��o de cinem�tica inversa para theta1 e theta2:
theta1 = atan2( ty, tx);
theta2 = atan2(tz-L1, tx*cos(theta1) + ty*sin(theta1));

S = [theta1, theta2];

end