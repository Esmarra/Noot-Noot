
syms L1 L2 L3 t1 t2 t3;

T01=[cos(t1) 0 sin(t1) 0
    sin(t1) 0 -cos(t1) 0
    0 1 0 L1
    0 0 0 1];

T12=[cos(t2) +sin(t2) 0 L2*cos(t2)
    sin(t2) cos(t2) 0 L2*sin(t2)
    0 0 1 0
    0 0 0 1];

T23=[cos(t3) -sin(t3) 0 L3*cos(t3)
    sin(t3) cos(t3) 0 L3*sin(t3)
    0 0 1 0
    0 0 0 1];


T0G=T01*T12*T23

R0G=[0 -sin(t3) cos(t3)
    1 0 0
    0 -cos(t3) sin(t3)];

InvTransform(R0G)


% hold on;
% view(135, 50);
% T01_=eval(subs(T01,[t1 L1],[0 1]));
% T02_=eval(subs(T12,[t2 L2],[0 1]));
% T03_=eval(subs(T23,[t3 L3],[0 1]));
% trplot(T01_,'frame', 'A','color','r');
% trplot(T02_,'frame', 'B','color','b');
% trplot(T03_,'frame', 'C','color','k');

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





function J=Jacob2(T0_EE)
    %get n value
    %[n,~]=size(DH);
    n=3;
    %T0_EE=simplify(FK_MGD_DH2(DH,n));

    % Pre Alocate J
    a=0;
    for i=1:1:n % This Counts LINES(to prealocate)
        tp=DH(i,6);
        if (tp=="R" || tp=="P")
            a=a+1;
        end
    end
    J = sym(zeros(6, a)); %Se der Erro conv 2 double ligar isto(NAO PODE
    %TER jutnas IMG
    
    for i=0:1:n-1
        %Get Joint Type
        tp=DH(i+1,6);
        
        if(i==0)
            T0_i=eye(4);
        else
            T0_i=simplify(FK_MGD_DH2(DH,i));
        end
        
        if(tp=="R")
            J(1:3,i+1)=cross(T0_i(1:3,1:3)*[0 0 1]',T0_EE(1:3,4)-T0_i(1:3,4));
            J(4:6,i+1)=T0_i(1:3,1:3)*[0 0 1]';
        elseif(tp=="P")
            J(1:3,i+1)=T0_i(1:3,1:3)*[0 0 1]';
            J(4:6,i+1)=[0 0 0]';
        end
    end
    J=simplify(J);
end