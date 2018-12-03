%given a DH matrix spits Jacobian Matrix
function J=Jacobi(DH)
    %get n value
    [n,~]=size(DH);
    T0_EE=simplify(FK_MGD_DH2(DH,n));
    %Primeira Junta
    J(1:3,1)=cross([0 0 1]',T0_EE(1:3,4)-[0 0 0]');
    J(4:6,1)=[0 0 1]';
    for i=1:1:n-1
        T0_i=FK_MGD_DH2(DH,i);
        J(1:3,i+1)=cross(T0_i(1:3,1:3)*[0 0 1]',T0_EE(1:3,4)-T0_i(1:3,4));
        J(4:6,i+1)=T0_i(1:3,1:3)*[0 0 1]';
    end
    J=simplify(J);
end