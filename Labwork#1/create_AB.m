function h = create_AB(Pontos)
    X =Pontos(1,:);
	Y =Pontos(2,:);
	Z =Pontos(3,:);
    [~,c]=size(Pontos);
    h(1)=fill3(X(1:c/2),Y(1:c/2),Z(1:c/2),'r'); % Front(x=1)
    h(2)=fill3(X(c/2+1:c),Y(c/2+1:c),Z(c/2+1:c),'w'); % Back(x=0)
    h(3)=fill3([X(1),X(c/2),X(c),X(c/2+1)],[Y(1),Y(c/2),Y(c),Y(c/2+1)],[Z(1),Z(c/2),Z(c),Z(c/2+1)],'y'); % Bottom(z=0)
    h(4)=fill3([X(c/2),X(c/2-1),X(c-1),X(c)],[Y(c/2),Y(c/2-1),Y(c-1),Y(c)],[Z(c/2),Z(c/2-1),Z(c-1),Z(c)],'g'); % Side1(y=1)
    h(5)=fill3([X(c/2-1),X(c/2-2),X(c-2),X(c-1)],[Y(c/2-1),Y(c/2-2),Y(c-2),Y(c-1)],[Z(c/2-1),Z(c/2-2),Z(c-2),Z(c-1)],'b'); % Top(z=1)
    h(6)=fill3([X(c/2-2),X(c/4+1),X(c-3),X(c-2)],[Y(c/2-2),Y(c/4+1),Y(c-3),Y(c-2)],[Z(c/2-2),Z(c/4+1),Z(c-3),Z(c-2)],'g'); % Top(z=1)
    h(7)=fill3([X(c/4+1),X(c/4),X(c-4),X(c-3)],[Y(c/4+1),Y(c/4),Y(c-4),Y(c-3)],[Z(c/4+1),Z(c/4),Z(c-4),Z(c-3)],'b'); % Top(z=1)
    h(8)=fill3([X(c/4),X(3),X(c/2+3),X(c-4)],[Y(c/4),Y(3),Y(c/2+3),Y(c-4)],[Z(c/4),Z(3),Z(c/2+3),Z(c-4)],'m'); % Top(z=1)
    h(9)=fill3([X(2),X(3),X(c/2+3),X(c/2+2)],[Y(2),Y(3),Y(c/2+3),Y(c/2+2)],[Z(2),Z(3),Z(c/2+3),Z(c/2+2)],'b'); % Top(z=1)
    h(10)=fill3([X(1),X(2),X(c/2+2),X(c/2+1)],[Y(1),Y(2),Y(c/2+2),Y(c/2+1)],[Z(1),Z(2),Z(c/2+2),Z(c/2+1)],'m'); % Top(z=1)
end