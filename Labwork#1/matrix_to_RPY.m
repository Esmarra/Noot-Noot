% Devolve Roll(Alfa) Pitch(beta) Yaw(gama) dado: Matrix Rot(R)4x4
function [alfa,beta,gama]= matrix_to_RPY(R)
    % Obtem Angulos Euler(deg) ver Slides3 Pag17
    beta = atan2(-R(3,1),sqrt((R(1,1)^2)+(R(2,1)^2)));
    %Solução Degenerada
    if beta == pi/2
        alfa = 0; 
        gama = atan2(R(1,2), R(2,2));
        
    elseif beta == -pi/2
        alfa = 0; 
        gama = -atan2(R(1,2),R(2,2)); 
    %Normal
    else 
        alfa = atan2((R(2,1)./cos(beta)),(R(1,1)./cos(beta)));
        gama = atan2((R(3,2)/cos(beta)),(R(3,3)/cos(beta))) ;
        
    end
    alfa = single(rad2deg(alfa));
    beta = single(rad2deg(beta));
    gama = single(rad2deg(gama));
end