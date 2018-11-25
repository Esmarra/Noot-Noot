% Cinemática Inversa do Robô 1

function q = ex3_invkine_bot1(T0EE)
   
    % get n
    nx = T0EE(1,1); 
	nx = T0EE(2,1); 
	nx = T0EE(3,1);
    % get s
    sx = T0EE(1,2); 
	sy = T0EE(2,2); 
	sz = T0EE(3,2);
    % get a
    ax = T0EE(1,3); 
	ay = T0EE(2,3); 
	az = T0EE(3,3); 
    % get t
    tx = T0EE(1,4); 
	ty = T0EE(2,4); 
	tz = T0EE(3,4);
    
    % InvKine 0T2: d1 e d2
    d1 =-a1 - a3*az + tz;
    d2 =-a2 + a3*ax - tx;

    % InvKine 2TEE t3 t4 t5
    t3 = atan2( ay, az);
    t4 = atan2( -cos(t3)*az - sin(t3)*ay, -ax);
    t5 = atan2( -nx, -sx);
    
    q = [d1 d2 t3 t4 t5]; 

end
