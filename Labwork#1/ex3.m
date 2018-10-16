clear; clc; close all;

syms t1 t2 t3 t4 t5; % Tetas

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
a_inc=10; %Animation Increment
a_speed=0.15; %Animation Speed
%%
%    t d a alfa offset   
DH=[t1 0 0  pi/2  pi/2 %0->1
    t2 0 4   0     0   %1->2
    t3 0 2   0     0   %2->3
    t4 0 0 -pi/2 -pi/2 %3->4
    t5 1 0   0     0]; %4->G
[l,~]=size(DH);

%% ==== Pos Home ==== %%
for i=1:a_inc
    T=[0 i*90/a_inc -i*90/a_inc 0 0];
    %T=[0 0 0 0 0];
    
    % Converte Para Rad
    T=deg2rad(T); 
    % ==== Replace Matrix0 Tetas ==== %
    DH=eval(subs(DH,[t1 t2 t3 t4 t5],deg2rad(T)));
    for j=1:l % Corre Todas as Linhas da DH
        DH(j,1)=T(j);
    end
    [A,h,v]=Arroz(DH);
    pause(a_speed);
    if(i~=a_inc)
        set(h,'Visible','off');
        delete(v);
    end
end

%% ==== Calc MDM and Draw ===%
function [A,h,v]=Arroz(DH)
    [c,~]=size(DH);
    cor=['r','b','g','m','y'];
    %A(:,:,c)=zeros(4,4,c); %PreDeclarar a Zeros Multi Dim Matrix
    for i=1:c
        tet=DH(i,1);d=DH(i,2);a=DH(i,3);alf=DH(i,4);of=DH(i,5);
        A(:,:,i)=[cos(tet+of) -sin(tet+of)*cos(alf) sin(tet+of)*sin(alf) a*cos(tet+of)
            sin(tet+of) cos(tet+of)*cos(alf) -cos(tet+of)*sin(alf) a*sin(tet+of)
            0 sin(alf) cos(alf) d
            0 0 0 1];
        
        if(i<2)
            T=A(:,:,i);
        end
        if(i>1)
            T=T*A(:,:,i);
        end
        h(i)=trplot(T,'color',cor(i));
        
        t(:,i)=T(1:3,4);
        if(i>1)
            v(i)=plot3([t(1,i-1);t(1,i)],[t(2,i-1),t(2,i)],[t(3,i-1),t(3,i)],'k');
            set(v(i),'LineWidth',2);
        end
    end
end
%% ==== Animate Arm ==== %%
% function animate(a_inc,L)
%     global Robot;
%     for i=1:a_inc
%         Robot.teach('rpy',[deg2rad(i*L(1)/a_inc) deg2rad(i*L(2)/a_inc) deg2rad(i*L(3)/a_inc) deg2rad(i*L(4)/a_inc) deg2rad(i*L(5)/a_inc)]);
%     end
% end