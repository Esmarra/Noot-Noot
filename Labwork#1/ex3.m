clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;        %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5; % Tetas

%% ==== Create Window ==== %%
world_size=8;
axis([-world_size world_size, -world_size world_size , 0 world_size])
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0,0,0, 'O')
w_size=900;
set(gcf, 'Position', [1440-w_size/2, 540-w_size/2, w_size, w_size])
view(135, 50);
grid on
hold on

%% ==== Denavit-Hartenberg Matrix ==== %%
%    t d a alfa offset   
DH=[t1 0 0  pi/2  pi/2 %0->1
    t2 0 4   0     0   %1->2
    t3 0 2   0     0   %2->3
    t4 0 0 -pi/2 -pi/2 %3->4
    t5 1 0   0     0]; %4->G
% Get number of DH Lines
[l,~]=size(DH);

%% ==== Pos Home ==== %%
T=[0 0 0 0 0]; % Create for that creates T with size(DH)

% Replace DH Matrix Tetas
DH=eval(subs(DH,[t1 t2 t3 t4 t5],deg2rad(T)));
% Calc and Draw
[A,h,li,jo]=Arroz(DH);
% Wait
pause(1);
% Cleanup
delete(h);
delete(li);
delete(jo);

%% ==== Rotate Joint2 90 and Joint3 -90 ==== %%
for i=1:a_inc
    T=[0 i*90/a_inc -i*90/a_inc 0 0];
    % Converte Para Rad
    T=deg2rad(T); 
    % Replace DH Matrix Tetas
    for j=1:l % Corre Todas as Linhas da DH
        DH(j,1)=T(j); % Replace tetas
    end
    [A,h,li,jo]=Arroz(DH);
    pause(a_speed);
    % Dont Delete Final Pos
    if(i~=a_inc)
        set(h,'Visible','off');
        delete(li);
        delete(jo);
    end
end
% Wait
pause(1);
% Cleanup
delete(h);
delete(li);
delete(jo);

%% ==== Rotate 360 Joint1 and -90 Joint4 ====%
for i=1:a_inc
    T(1)=deg2rad(i*360/a_inc);
    T(4)=deg2rad(i*-90/a_inc);
    % Replace DH Matrix Tetas
    for j=1:l % Corre Todas as Linhas da DH
        DH(j,1)=T(j); % Replace tetas
    end
    [A,h,li,jo]=Arroz(DH);
    pause(a_speed);
    % Dont Delete Final Pos
    if(i~=a_inc)
        set(h,'Visible','off');
        delete(li);
        delete(jo);
    end
end



%% ==== Calc MDM and Draw ===%
function [A,h,link,joint]=Arroz(DH)
    % Get number of DH Lines (Use as Global??)
    [l,~]=size(DH);
    cor=['r','b','g','m','y'];
    [x,y,z] = sphere;
    r=.1;
    %A(:,:,c)=zeros(4,4,c); %PreDeclarar a Zeros Multi Dim Matrix
    for i=1:l
        tet=DH(i,1);d=DH(i,2);a=DH(i,3);alf=DH(i,4);of=DH(i,5);
        A(:,:,i)=[cos(tet+of) -sin(tet+of)*cos(alf) sin(tet+of)*sin(alf) a*cos(tet+of)
            sin(tet+of) cos(tet+of)*cos(alf) -cos(tet+of)*sin(alf) a*sin(tet+of)
            0 sin(alf) cos(alf) d
            0 0 0 1];
        % Calc First Inter T
        if(i<2) 
            T=A(:,:,i);
        end
        % Calc T = Recursive A1*A2*A3*A4*A5
        if(i>1)
            T=T*A(:,:,i);
        end
        % Get Matrix Position Vector
        t(:,i)=T(1:3,4);
        % Draw Joints Axis
        h(i)=trplot(T,'color',cor(i)); 
        % Draw Joints
        joint(i)=surf(x*r+t(1,i),y*r+t(2,i),z*r+t(3,i)); % centered at (3,-2,0)
        % Draw Links ( i <-> i-1 )
        if(i>1)
            link(i)=plot3([t(1,i-1);t(1,i)],[t(2,i-1),t(2,i)],[t(3,i-1),t(3,i)],'k'); % Draw Links
            set(link(i),'LineWidth',2);
        end
    end
end