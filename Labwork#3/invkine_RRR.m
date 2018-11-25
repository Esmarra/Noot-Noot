% Dada a Matrix Base->EE devolve os angulos das juntas
function  q = invkine_RRR(T0G)
    l1=35;
    l2=35;
    d3=10;

    t = T0G(1:3, 4);
    a = T0G(1:3, 3);
    s = T0G(1:3, 2);
    n = T0G(1:3, 1);

    ax = a(1);
    ay = a(2);
    az = a(3);

    % Calc t' = [tx' ty' tz']
    ti = t - d3*a;
    
    txi = ti(1);
    tyi = ti(2);
    tzi = ti(3);
    
    % Como vimos na Aula teta2 pode ser +/- acos(...)
    t2 = acos((txi^2+tyi^2 - l1^2 -l2^2)/(2*l1*l2));
    t1 = atan2(tyi, txi) - atan2(l2*sin(t2), l1+l2*cos(t2));
    t3 = atan2(ay, ax) - t1 - t2;

    
    q = [t1 t2 t3];
end