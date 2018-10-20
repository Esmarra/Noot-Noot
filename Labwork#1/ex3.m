clear; clc; close all;

%% ==== Variables ==== %%
a_inc=10;        %Animation Increment
a_speed=0.08;  %Animation Speed
syms t1 t2 t3 t4 t5 t6; % Tetas

%% ==== Create Window ==== %%
world_size=8;
axis([-world_size world_size, -world_size world_size , -world_size world_size])
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
DH=[t1 0 0  pi/2  pi/2 %0->1 Base-Shoulder
    t2 0 4   0     0   %1->2 Shoulder-Elbow
    t3 0 2   0     0   %2->3 Elbow-Pitch
    t4 0 0 -pi/2 -pi/2 %3->4 Pitch-Roll
    t5 1 0   0     0]; %4->5 Roll-End_Efector
%% Extra for PUMA Bot in slides
% DH=[t1 0 0  -pi/2  0
%     t2 1 4   0     0
%     t3 0 -.2  pi/2   0
%     t4 4 0 -pi/2   0
%     t5 0 0  pi/2   0 
%     t6 .5 0   0     0];
%% ==== Get number of DH Lines aka (n-1)Frames ==== %%
[l,~]=size(DH);

%% ==== Position Home ==== %%
T=[0 0 0 0 0 0]; % Create a for-loop that creates T with size(DH)
%T=[10 90 -90 -45 0 0]; % Create for that creates T with size(DH)

% Replace DH Matrix Tetas (important to run this)
DH=eval(subs(DH,[t1 t2 t3 t4 t5 t6],deg2rad(T)));
% Calc H0_EE and Draw
[A,h,li,jo]=Denavit_and_Draw(DH);
% Wait
pause(1);
% Cleanup drawings
delete(h);
delete(li);
delete(jo);

%% ==== Rotate Joint2 T(2) and Joint3 T(3) ==== %%
for i=1:a_inc
    T=[0 i*90/a_inc -i*90/a_inc 0 0 0]; % Passar a Funçao q usa current pos
    % Converte Para Rad
    T=deg2rad(T); 
    % Replace DH Matrix Tetas
    for j=1:l % Corre Todas as Linhas da DH (All Frames)
        DH(j,1)=T(j); % Replace tetas
    end
    [A,h,li,jo]=Denavit_and_Draw(DH);
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
    for j=1:l % Corre Todas as Linhas da DH (All Frames)
        DH(j,1)=T(j); % Replace tetas
    end
    [A,h,li,jo]=Denavit_and_Draw(DH);
    pause(a_speed);
    % Dont Delete Final Pos
    if(i~=a_inc)
        set(h,'Visible','off');
        delete(li);
        delete(jo);
    end
end



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