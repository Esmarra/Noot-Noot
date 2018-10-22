% Devolve a Matriz Rot(3x3) dado: quaterniao(Q=[e0,e1,e2,e3])
function [R]=quat_to_matrix(Q)
    e0=Q(1);
    e1=Q(2);
    e2=Q(3);
    e3=Q(4);
    % Retruns Matrix created by quaternions
    R =[(1-2*(e2^2)-2*(e3^2)) (2*(e1*e2-e3*e0)) (2*(e1*e3 + e2*e0))
        (2*(e1*e2+e3*e0) ) (1-(2*(e1^2))-(2*(e3^2))) (2*(e2*e3 - e1*e0))
        (2*(e1*e3 - e2*e0)) (2*(e2*e3 + e1*e0)) (1-(2*(e1^2))-(2*(e2^2)))];
end