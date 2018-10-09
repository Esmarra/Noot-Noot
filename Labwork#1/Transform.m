% Cria Matriz Transformação usando roll-pitch-yaw , vector, unit(deg or rad)

function [MT] = Transform(alpha, beta, gama, vector,unit)
	% Get Matriz Rotação(Euler) RPY
	R=Rot_RPY(alpha,beta,gama,unit);
	
	MT=[R vector
			0 0 0 1];
end