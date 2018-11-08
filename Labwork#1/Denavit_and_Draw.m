%% ==== Calc MDM and Draw ===%
function [A,h,link,joint]=Denavit_and_Draw(DH)
    % Get number of DH Lines (Use as Global??)
    [l,~]=size(DH);
    cor=['r','b','g','m','y','k'];
    [x,y,z] = sphere;
    r=.1; % Raio das esferas da Joints
    %A(:,:,c)=zeros(4,4,c); %PreDeclarar a Zeros Multi Dim Matrix
    for i=1:l
        tet=DH(i,1);d=DH(i,2);a=DH(i,3);alf=DH(i,4);of=DH(i,5);
        % A is the Homogenious Denavit-Hartenberg Matrix
        A(:,:,i)=[cos(tet+of) -sin(tet+of)*cos(alf) sin(tet+of)*sin(alf) a*cos(tet+of)
            sin(tet+of) cos(tet+of)*cos(alf) -cos(tet+of)*sin(alf) a*sin(tet+of)
            0 sin(alf) cos(alf) d
            0 0 0 1]
        %% ==== Cadeia Cinematica ==== %%
        % Calc First Inter H=H0_1
        if(i<2) 
            H=A(:,:,i);
        end
        % Calc H0_EE -> Recursive H0_1*H1_2*H2_3*...*Hn-1_n
        if(i>1)
            H=H*A(:,:,i);
        end
        % Get H Position Vector
        t(:,i)=H(1:3,4);
        % Draw Joints Axis
        h(i)=trplot(H,'color',cor(i)); 
        % Draw Joints
        joint(i)=surf(x*r+t(1,i),y*r+t(2,i),z*r+t(3,i)); % centered at (3,-2,0)
        % Draw Links ( i <-> i-1 )
        if(i>1)
            link(i)=plot3([t(1,i-1);t(1,i)],[t(2,i-1),t(2,i)],[t(3,i-1),t(3,i)],'k'); % Draw Links
            set(link(i),'LineWidth',2);
        end
    end
end