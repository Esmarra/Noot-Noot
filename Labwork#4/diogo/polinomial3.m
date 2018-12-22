%Função polinomial de grau 3

function [ang] = polinomial3(t,ti,tf,thi,thf,vi,vf)

delta_t = tf-ti;

ang = thi + vi*(t-ti) + ( (3/(delta_t^2))*(thf-thi) - (2/delta_t)*vi - (1/delta_t)*vf )*((t-ti)^2) - ( (2/(delta_t^3))*(thf-thi) - (1/(delta_t^2))*(vf+vi) )*((t-ti)^3);

end