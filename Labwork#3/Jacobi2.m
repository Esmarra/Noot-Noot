%Given a DH matrix(with R P I) spits Jacobian Matrix
function J=Jacobi2(DH)
    %get n value
    [n,~]=size(DH);
    T0_EE=simplify(FK_MGD_DH2(DH,n));

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