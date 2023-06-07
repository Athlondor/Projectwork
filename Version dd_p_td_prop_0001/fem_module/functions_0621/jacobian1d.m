function [detJq, invJq] = jacobian1d(xe, gamma, nen, ndm)
Jq = 0.5*sqrt((xe(1,2)-xe(1,1))^2+(xe(2,2)-xe(2,1))^2);

% for 2d truss structures 
%Jq = sqrt(xe(1)^2+xe(2)^2)*gamma(1)+sqrt(xe(3)^2+xe(4)^2)*gamma(2);
%Jq = (xe(3)-xe(1))*gamma(1)+(xe(4)-xe(2))*gamma(2);
detJq = det(Jq);
invJq = inv(Jq);
end 
        