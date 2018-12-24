%% Calcula Vel Juntas dado max_acc_Juntas , Matriz q em todos os Pontos e Vector tempo

% q_mat =[-0.7854   -0.7854
%          0    0.7854
%     1.5708    0.7854];
% 
% vel_q = velocidades_ac(deg2rad(60),q_mat,[0 4 10])

function vel_q = velocidades_acc(acc_max,q_mat, t_vec)
	% Pre alocate
	[l,c]=size(q_mat);
	vel_q=zeros(l,c);
	vel_qaux = zeros(1,c);
    acc_q = zeros(1,c);
    
     % Todos os Pontos menos o Ultimo
    for i=1:1:size(t_vec,2)-1
        % Juntas
        for k=1:1:c
            acc_q(i,k)=sign( (q_mat(i+1, k) - q_mat(i, k)))*acc_max;
            t1_q(i,k)=t_vec(i)-(sqrt((t_vec(i)^2)-(2*( q_mat(i+1, k) - q_mat(i, k)))/acc_q(i,k)));
            if(isnan(t1_q(i,k))==1)t1_q(i,k)=0;end
            vel_q(i+1,k)=(q_mat(i+1, k) - q_mat(i, k) )/( t_vec(i)-0.5*t1_q(i,k));
        end
    end
    %disp("acc_q");disp(acc_q);
    %disp("t1");disp(t1_q);
end