% Devolve Matriz Transformacao Homogenea(4x4) dado: roll(alfa)-pitch(beta)-yaw(gama) / vector(3x1) / unit(deg or rad)

function [MT] = Transform(alpha, beta, gama, vector,unit)
	% Get Matriz Rotação(Euler) RPY
	R=Rot_RPY(alpha,beta,gama,unit);
	
	MT=[R vector
			0 0 0 1];
end