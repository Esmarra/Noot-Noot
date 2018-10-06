function drawSquare(TRA, color)
% Desenha o quadrado com referencial A dado por TRA (em relação ao
% referencial base). Pintado com a cor = color.

sqrPts = [0 0 -1 -1; %X %Pontos de cada quadrado no seu próprio referencial
          0 1  1  0; %Y
          0 0  0  0];%Z
      
Pts_R = transformPts(sqrPts, TRA);
X = Pts_R(1,:);
Y = Pts_R(2,:);
Z = Pts_R(3,:);
fill3(X, Y, Z, color);