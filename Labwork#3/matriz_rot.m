% Devolve Matriz Rotação(3x3) dado: vector (r) / angulo (phi)
% Matriz rotacao sobre eixo arbritario ver Slides3 Pag20

function R=matriz_rot(r, phi)
	r_x=r(1,1)/norm(r);
	r_y=r(2,1)/norm(r);
	r_z=r(3,1)/norm(r);

	V_phi=1-cos(phi);

	R=[r_x^2*V_phi+cos(phi) r_x*r_y*V_phi-r_z*sin(phi) r_x*r_z*V_phi+r_y*sin(phi)
		r_x*r_y*V_phi+r_z*sin(phi) r_y^2*V_phi+cos(phi) r_y*r_z*V_phi-r_x*sin(phi)
		r_x*r_z*V_phi-r_y*sin(phi) r_y*r_z*V_phi+r_x*sin(phi) r_z^2*V_phi+cos(phi)];
end