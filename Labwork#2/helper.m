syms t1 t2 t3 t4 t5 t6; % Tetas
syms d1 d2 d3 d4 d5 d6;
syms a a1 a2 a3 a4;
syms nx ny nz ax ay az sx sy sz tx ty tz;
syms l1;


% %        theta d       alpha      a   offset
% DH_i_pe=[ 0   a1+d1    -pi/2      0    pi/2    %0->1
%           0   a2+d2      0        0   -pi/2     %1->2
%           t3   0       -pi/2      0      0     %2->3
%           t4   0        pi/2      0      0     %3->4
%           t5   a3         0        0   pi/2];  %4->5
% disp(" 0TEE ");
% T0EE=simplify(FK_MGD_DH(DH_i_pe))
% 
% %    theta     d       alpha    a   offset
% DH=[ 0     a1+d1     -pi/2    0      -pi/2      %0->1
%        0     a2+d2      0       0      -pi/2];    %1->2
% disp(" 0T2 ");
% T02=simplify(FK_MGD_DH(DH))

%        theta d       alpha      a   offset
DH_ii_pe=[ t1   0       pi/2      a2    pi/2    %0->1
          0 l1+d2     0        0   0     %1->2
          t3   0       -pi/2      0      0     %2->3
          t4   0        pi/2      0      0     %3->4
          t5  a4         0        0   pi/2];  %4->5
disp(" 0TEE ");
T0EE=simplify(FK_MGD_DH(DH_ii_pe))

%    theta     d       alpha    a   offset
DH=[ t1   0       pi/2      a2    pi/2    %0->1
          0 a1+a3+d2     0        0   0];     %1->2
disp(" 0T2 ");
T02=simplify(FK_MGD_DH(DH))

Aux=[ nx sx ax tx
      ny sy ay ty
      nz sz az tz
      0   0  0  1];
disp(" 2TEE SYMB = 2T0*0TEE ");
T2EE_s=inv(T02)*Aux
disp(" 2TEE = 2T0*0TEE ");
T2EE=inv(T02)*T0EE