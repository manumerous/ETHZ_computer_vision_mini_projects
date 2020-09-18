function [w_x,w_y,E] = tps_model(X,Y,lambda)

K = dist2(X,X).*log(dist2(X,X));
K(isnan(K)) = 0;
N = size(X,1);
P = [ones(N,1), X];

A = [K+lambda*eye(N), P; 
     P', zeros(3,3)];

v_x = Y(:,1);
v_y = Y(:,2);

w_x = A\[v_x;0;0;0];
w_y = A\[v_y;0;0;0];

omega_x = w_x(1:N);
omega_y = w_y(1:N);

E = omega_x'*K*omega_x + omega_y'*K*omega_y;


end


