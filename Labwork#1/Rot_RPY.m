% Cria Matriz Transformação com Roll-Pitch-Yaw e um Vector

function [R] = Rot_RPY(alpha, beta, gama,unit)
	if(unit=='deg')
		% Conv to Rad (can also use deg2rad)
		alpha=(alpha/180)*pi;
		beta=(beta/180)*pi;
		gama=(gama/180)*pi;
	end
	% Matriz Rotação sobre o eixo X Y Z
	Rx = Rot_x(gama);
	Ry = Rot_y(beta);
	Rz = Rot_z(alpha);

	% Matriz Rotação(Euler) RPY
	R=Rz*Ry*Rx;
end