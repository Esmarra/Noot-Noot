% Cinemática Inversa do Robô RPR
function q = invkine_2(T0EE)
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
    
    % InvKine 0T2: t1 e d2
    t1 = atan2(ty - 10*ay ,tx - 10*ax);
    d2 = cos(t1)*(tx-10*ax)+sin(t1)*(ty-10*ay);
    
    % InvKine 2TEE
    t3=atan2(ay,ax)-t1;
    
    q=[t1,d2,t3];
    
end