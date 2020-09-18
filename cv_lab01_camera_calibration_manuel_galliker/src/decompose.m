%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition
% Compute R, K with QR decomposition such M=K*R 
M = P(1:min(size(P)),1:min(size(P)));
[Q_,R_,E] = qr(inv(M));
R = inv(Q_);
K = inv(R_);

% Compute camera center C=(cx,cy,cz) such P*C=0 
[U,S,V] = svd(P);
C = V(:,end);
C = C/C(end);

% normalize K such K(3,3)=1
K_scale = K(3,3);
K = K/K_scale;
R = R*K_scale;

% Adjust matrices R and Q so that the diagonal elements of K = intrinsic matrix are non-negative values and R = rotation matrix = orthogonal has det(R)=1
R = orth(R);
% Compute translation t=-R*C

t = -R*C(1:end-1);
end