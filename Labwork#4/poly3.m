%% Polynomial^3 Function

function q_now = poly3(t,ti,tf,q_start,q_end,v_start,v_end)
    [l,~]=size(q_start); %get size
    Dt = tf-ti; %delta time
    q_now=zeros(1,l); %prealocate
    for i=1:1:l %all joints
        teta_s=q_start(i);
        teta_f=q_end(i);
        vf=v_end(i);
        vs=v_start(i);
        q_now(i) = teta_s + vs*(t-ti) + ( (3/(Dt^2))*(teta_f-teta_s) - (2/Dt)*vs - (1/Dt)*vf )*((t-ti)^2) - ( (2/(Dt^3))*(teta_f-teta_s) - (1/(Dt^2))*(vf+vs) )*((t-ti)^3);
    end
end