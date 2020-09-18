% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

[x1n T1] = normalizePoints2d(x1s);
[x2n T2] = normalizePoints2d(x2s);


 A = [x2n'.*x1n(1,:)',x2n'.*x1n(2,:)',x2n'.*x1n(3,:)'];

[U,S,V] = svd(A);
f = V(:,end); % A * f = 0, also enforce norm(f)=1, but already done when doing svd in matlab, vectors are normalized
F = reshape(f,[3,3]);


[U,S,V] = svd(F);
S(3,3) = 0;
Fh = U*S*V';

Fh = T2'*Fh*T1;
F=T2'*F*T1;
end

