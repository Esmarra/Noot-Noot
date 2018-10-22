% Devolve Matriz Transformada Inversa Homogenea(4x4) dado: ATB
function [BTA] = InvTransform(ATB)
	% Get Matriz Rotação
	ARB=ATB(1:3,1:3);
	% Get Vector de Translação
	tab=ATB(1:3,4);
	
	% Mat Inv = Inversa Inversa*vector
	BTA=[ARB' (-ARB)'*tab
			0 0 0 1];
end