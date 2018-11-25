% Devolve Matriz Rotacao(3x3) dado: roll(alfa)-pitch(beta)-yaw(gama)  / unit('deg'ou'rad')
% Alfa-Z Beta-Y Gama-X
function [R] = Rot_RPY(alpha, beta, gama,unit)
	if(unit=='deg')
		% Conv to Rad (can also use deg2rad)
		alpha=(alpha/180)*pi;
		beta=(beta/180)*pi;
		gama=(gama/180)*pi;
		unit='rar'; %Indica q ja estamos em rad a funçao rot
	end
	% Matriz Rotação sobre o eixo X Y Z
	%fprintf('gama %f unit %s \n',gama,unit)
	Rx = rot('X',gama,unit);
	Ry = rot('Y',beta,unit);
	Rz = rot('Z',alpha,unit);
	
	% Matriz Rotação(Euler) RPY
	R=Rz*Ry*Rx;
end