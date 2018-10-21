% Devolve Q=[e0,e1,e2,e3] / vector unit (r) / angulo rot (phi) dado: Matrix Rot(R)
function [Q,r,phi]=matrix_to_quat(R)
    %Get Anglo de Rotação phi
    phi=acos((R(1,1)+R(2,2)+R(3,3)-1)/2); % Ver Slides3 Pag22
    
    %Get vector unitário que define o eixo de rotação
    v=[ R(3,2)-R(2,3)
    R(1,3)-R(3,1)
    R(2,1)-R(1,2)]';

    %Get vector unit eixo rot
    r=(1/(2*sin(phi)))*v;
    
    e0=cos(phi/2); %e1
    e1=r(1)*sin(phi/2); %e2
    e2=r(2)*sin(phi/2); %e3
    e3=r(3)*sin(phi/2); %e4
    
    Q=[e0 e1 e2 e3];

end