function  ik2 = RRR_inv(T)

l1=35;
l2=35;
d3=10;

t = T(1:3, 4);
a = T(1:3, 3);
s = T(1:3, 2);
n = T(1:3, 1);
    
ax = a(1);
ay = a(2);
az = a(3);
tx=t-a*d3;
    
txl = tx(1);
tyl = tx(2);
tzl = tx(3);

theta2 = acos((txl^2+tyl^2 - l1^2 -l2^2)/(2*l1*l2));
theta1 = atan2(tyl, txl) - atan2(l2*sin(theta2), l1+l2*cos(theta2));
theta3 = pi/2 - theta1 - theta2;

ik2 = [theta1 theta2 theta3];
end