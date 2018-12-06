% Dada Matrix Denavit-Hartenberg calcula a Cinematic Chain do OTn-Frame
% Devolve tb A(:,:,i) Multimatrix
% Adaptação da funcao entregue no ex 3 da labwork1
function [oTee,A]=FK_MGD_DH2(DH,n)
    % Get number of DH Lines (Use as Global??)
    %[l,~]=size(DH);
    l=n;
    A=sym(zeros(4,4,l)); %PreDeclarar a Zeros Multi Dim Matrix
    
    for i=1:l
        tet=DH(i,1);d=DH(i,2);alf=DH(i,3);a=DH(i,4);of=DH(i,5); % 4 exchange with 3 from Lab1-ex3
        % A is the Homogenious Denavit-Hartenberg Matrix
        A(:,:,i)=[cos(tet+of) -sin(tet+of)*cos(alf) sin(tet+of)*sin(alf) a*cos(tet+of)
            sin(tet+of) cos(tet+of)*cos(alf) -cos(tet+of)*sin(alf) a*sin(tet+of)
            0 sin(alf) cos(alf) d
            0 0 0 1];
        %% ==== Cadeia Cinematica ==== %%
        % Calc First Inter H=H0_1
        if(i<2) 
            oTee=A(:,:,i);
        end
        % Calc H0_EE -> Recursive H0_1*H1_2*H2_3*...*Hn-1_n
        if(i>1)
            oTee=oTee*A(:,:,i);
        end
        
    end
    oTee=simplify(oTee);
end