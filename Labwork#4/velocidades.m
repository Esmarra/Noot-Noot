%% Calcula Vel Juntas dado Matriz q em todos os Pontos e Vector tempo

function vel_q = velocidades(q_mat, t_vec)
    % Pre alocate
    [l,c]=size(q_mat);
    vel_q=zeros(l,c);
    vel_qaux = zeros(1,size(q_mat,2));
    % Pontos
    for i=1:1:size(t_vec,2)-1
        % Juntas
        for k=1:1:l
            % Calc Velocidades Medias (obtemos Sinal)
            vel_qaux(i+1,k) = ( q_mat(i+1, k) - q_mat(i, k) )/( t_vec(i+1) - t_vec(i) );
        end 
    end

    % Todos os Pontos menos o Ultimo
    for i=1:1:size(t_vec,2)-1
        % Juntas
        for k=1:1:l
           % Sinal Diferente (velocidade nula no ponto)
            if sign(vel_qaux(i,k)) ~= sign(vel_qaux(i+1,k))
                vel_q(i,k) = 0;
            else
                vel_q(i,k) = (1/2)*( vel_qaux(i,k) + vel_qaux(i+1,k));
            end 
        end
    end
end