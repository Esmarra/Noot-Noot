% Devolve Posicao(q) dado Matrix Pos
function q = invkine_1(T0G)
    l1 = 4;
    l2 = 3;
    l3 = 2;
    
    t = T0G(1:3, 4);
    a = T0G(1:3, 3);
    %s = T0G(1:3, 2);
    %n = T0G(1:3, 1);
    
    ax = a(1);
    ay = a(2);
    %az = a(3);
    
    % Calc t' = [tx' ty' tz']
    ti = t - l3*a;
    
    txi = ti(1);
    tyi = ti(2);
    
    % Como vimos na Aula teta2 pode ser +/- acos(...)
    t2 = acos((txi^2+tyi^2 - l1^2 -l2^2)/(2*l1*l2));
    t1 = atan2(tyi, txi) - atan2(l2*sin(t2), l1+l2*cos(t2));
    t3 = atan2(ay, ax) - t1 - t2;
    
    q = [t1 t2 t3];
end
