function   var = ikineRPR(M)
    
    theta1=atan2(M(2,4)-10*M(2,3),M(1,4)-10*M(1,3));
    theta3=atan2(M(2,3),M(1,3))-theta1;
    d2=cos(theta1)*(M(1,4)-10*M(1,3))+sin(theta1)*(M(2,4)-10*M(2,3));
    var=[theta1, d2, theta3]';
end